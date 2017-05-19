defmodule Rock.Struct.HeapTest do
  use ExUnit.Case

  alias Rock.Struct.Point
  alias Rock.Struct.Heap
  alias Rock.Struct.Cluster

  test "initializs heap" do
    points = [
      Point.new(["1", "2", "3"]),
      Point.new(["1", "2", "4"]),
      Point.new(["1", "2", "5"]),
      Point.new(["1", "3", "4"]),
      Point.new(["1", "3", "5"]),
      Point.new(["1", "4", "5"]),
      Point.new(["2", "3", "4"]),
      Point.new(["2", "3", "5"]),
      Point.new(["2", "4", "5"]),
      Point.new(["3", "4", "5"]),
      Point.new(["1", "2", "6"]),
      Point.new(["1", "2", "7"]),
      Point.new(["1", "6", "7"]),
      Point.new(["2", "6", "7"])
    ]
    link_matrix = [
      [0, 7, 7, 5, 5, 4, 5, 5, 4, 4, 5, 5, 2, 2],
      [0, 0, 7, 5, 4, 5, 5, 4, 5, 4, 5, 5, 2, 2],
      [0, 0, 0, 4, 5, 5, 4, 5, 5, 4, 5, 5, 2, 2],
      [0, 0, 0, 0, 5, 5, 5, 4, 4, 5, 2, 2, 0, 0],
      [0, 0, 0, 0, 0, 5, 4, 5, 4, 5, 2, 2, 0, 0],
      [0, 0, 0, 0, 0, 0, 4, 4, 5, 5, 2, 2, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 2, 2, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 2, 2, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 2, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 4, 4],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
    theta = 0.5
    point_clusters =
      points
      |> Enum.chunk_by(fn(%Point{attributes: attrs}) ->
        attrs |> Enum.at(0) == "1"
      end)
    clusters =
      point_clusters
      |> Enum.map(&Cluster.new(&1))
    cluster = clusters |>  Enum.at(0)
    clusters = clusters |> List.delete_at(0)
  end
end
 
