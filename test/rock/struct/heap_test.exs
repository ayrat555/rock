defmodule Rock.Struct.HeapTest do
  use ExUnit.Case

  alias Rock.Struct.Point
  alias Rock.Struct.Heap
  alias Rock.Struct.Cluster

  test "initializs heap" do
    points = [
      Point.new("1", ["1", "2", "3"], 0),
      Point.new("2", ["1", "2", "4"], 1),
      Point.new("3", ["1", "2", "5"], 2),
      Point.new("4", ["1", "3", "4"], 3),
      Point.new("5", ["1", "3", "5"], 4),
      Point.new("6", ["1", "4", "5"], 5),
      Point.new("7", ["2", "3", "4"], 6),
      Point.new("8", ["2", "3", "5"], 7),
      Point.new("9", ["2", "4", "5"], 8),
      Point.new("10", ["3", "4", "5"], 9),
      Point.new("11", ["1", "2", "6"], 10),
      Point.new("12", ["1", "2", "7"], 11),
      Point.new("13", ["1", "6", "7"], 12),
      Point.new("14", ["2", "6", "7"], 13)
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
    cluster = %Cluster{uuid: cluster_uuid} =  clusters |>  Enum.at(0)
    clusters = clusters |> List.delete_at(0)

    heap = cluster |> Heap.new(clusters, link_matrix, theta)

    %Heap{cluster_uuid: ^cluster_uuid, items: items} = heap
    clusters
    |> Enum.each(fn(%Cluster{uuid: uuid}) ->
      items
      |> Enum.any?(fn({_, _, item_uuid}) ->
        item_uuid == uuid
      end)
    end)
  end
end
 
