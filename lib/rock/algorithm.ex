defmodule Rock.Algorithm do
  alias Rock.Struct.Cluster
  alias Rock.NeighbourCriterion
  alias Rock.Links
  alias Rock.Heaps
  @moduledoc false

  def clusterize(points, number_of_clusters, theta, similarity_function \\ nil)
      when is_list(points) do
    neighbour_criterion =
      if is_nil(similarity_function) do
        theta |> NeighbourCriterion.new()
      else
        theta |> NeighbourCriterion.new(similarity_function)
      end

    link_matrix = points |> Links.matrix(neighbour_criterion)
    initial_clusters = points |> initialize_clusters
    current_number_of_clusters = points |> Enum.count()
    local_heaps = initial_clusters |> Heaps.initialize(link_matrix, theta)

    local_heaps
    |> optimize_clusters(
      initial_clusters,
      theta,
      number_of_clusters,
      current_number_of_clusters
    )
  end

  defp initialize_clusters(points) do
    points
    |> Enum.map(fn point ->
      point
      |> List.wrap()
      |> Cluster.new()
    end)
  end

  defp optimize_clusters(_, _, _, necessary_number, current_number)
       when necessary_number > current_number do
    raise ArgumentError,
      message: "Needed number of clusters must be smaller than the number of points"
  end

  defp optimize_clusters(_, clusters, _, necessary_number, current_number)
       when necessary_number == current_number do
    clusters
  end

  defp optimize_clusters(local_heaps, clusters, theta, necessary_number, current_number) do
    global_heap = local_heaps |> Heaps.global_heap()
    {_, _, v_uuid, u_uuid} = global_heap |> Enum.at(0)
    v_cluster = clusters |> find_cluster(v_uuid)
    u_cluster = clusters |> find_cluster(u_uuid)

    {new_local_heap, new_cluster} =
      local_heaps
      |> Heaps.update(v_cluster, u_cluster, theta)

    new_clusters =
      clusters
      |> List.delete(v_cluster)
      |> List.delete(u_cluster)

    new_clusters = [new_cluster | new_clusters]

    optimize_clusters(
      new_local_heap,
      new_clusters,
      theta,
      necessary_number,
      current_number - 1
    )
  end

  defp find_cluster(clusters, uuid) do
    clusters
    |> Enum.find(fn %Cluster{uuid: cluster_uuid} ->
      uuid == cluster_uuid
    end)
  end
end
