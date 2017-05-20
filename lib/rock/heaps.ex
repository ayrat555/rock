defmodule Rock.Heaps do
  alias Rock.Struct.Heap

  def initialize(clusters, link_matrix, theta) do
    clusters
    |> Enum.map(fn(cluster) ->
      remaining_clusters =
        clusters
        |> List.delete(cluster)

      cluster |> Heap.new(remaining_clusters, link_matrix, theta)
    end)
  end
end
