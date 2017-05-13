defmodule Rock.Algorithm do
  alias Rock.Struct.Cluster
  alias Rock.NeighbourCriterion
  alias Rock.Links
  alias Rock.ClusterMergeCriterion

  def clusterize(points, number_of_clusters, theta) when is_list(points) do
    neighbour_criterion = theta |> NeighbourCriterion.new
    link_matrix = points |> Links.matrix(neighbour_criterion)

    local_heaps =
      points
      |> initialize_clusters
      |> initialize_local_heaps(link_matrix, theta)

    global_heap = local_heaps |> initialize_global_heap
  end

  defp initialize_clusters(points) do
    points
    |> Enum.map(fn(point) ->
      point
      |> List.wrap
      |> Cluster.new
    end)
  end

  defp initialize_local_heaps(clusters, link_matrix, theta) do
    clusters
    |> Enum.map(fn(%Cluster{uuid: uuid1} = cluster) ->
      clusters
      |> List.delete(cluster)
      |> Enum.map(fn(%Cluster{uuid: uuid2} = other_cluster) ->
        {measure, cross_link_count} =
          link_matrix
          |> ClusterMergeCriterion.measure(cluster, other_cluster, theta)
        {measure, cross_link_count, {uuid1, uuid2}}
      end)
      |> Enum.filter(fn({_, cross_link_count, _}) ->
        cross_link_count != 0
      end)
      |> Enum.sort_by(fn({measure, _, _}) ->
        -measure
      end)
    end)
  end

  defp initialize_global_heap(local_heaps) do
    local_heaps
    |> Enum.map(fn(local_heap) ->
      local_heap |> Enum.at(0)
    end)
    |> Enum.sort_by(fn({measure, _, _}) ->
      -measure
    end)
  end
end
