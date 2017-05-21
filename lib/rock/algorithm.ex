defmodule Rock.Algorithm do
  alias Rock.Struct.Cluster
  alias Rock.NeighbourCriterion
  alias Rock.Links
  alias Rock.ClusterMergeCriterion
  alias Rock.Heaps

  def clusterize(points, number_of_clusters, theta) when is_list(points) do
    neighbour_criterion = theta |> NeighbourCriterion.new
    link_matrix = points |> Links.matrix(neighbour_criterion)
    initial_clusters = points |> initialize_clusters
    local_heaps = initial_clusters |> Heaps.initialize(link_matrix, theta)

    local_heaps
    |> optimize_clusters(initial_clusters, number_of_clusters, theta)
  end

  defp initialize_clusters(points) do
    points
    |> Enum.map(fn(point) ->
      point
      |> List.wrap
      |> Cluster.new
    end)
  end

  defp optimize_clusters(local_heaps, clusters, number_of_clusters, theta) do
  end
end
