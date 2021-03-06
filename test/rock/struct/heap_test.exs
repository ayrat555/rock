defmodule Rock.Struct.HeapTest do
  use ExUnit.Case

  alias Rock.Struct.Point
  alias Rock.Struct.Heap
  alias Rock.Struct.Cluster
  alias Rock.Test.TestFactory

  setup do
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
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]

    theta = 0.5

    point_clusters =
      points
      |> Enum.chunk_by(fn %Point{attributes: attrs} ->
        attrs |> Enum.at(0) == "1"
      end)

    clusters =
      point_clusters
      |> Enum.map(&Cluster.new(&1))

    cluster = clusters |> Enum.at(0)
    clusters = clusters |> List.delete_at(0)

    {
      :ok,
      [
        cluster: cluster,
        clusters: clusters,
        link_matrix: link_matrix,
        theta: theta
      ]
    }
  end

  test "initializes heap",
       %{
         cluster: cluster = %Cluster{uuid: cluster_uuid},
         clusters: clusters,
         link_matrix: link_matrix,
         theta: theta
       } do
    heap = cluster |> Heap.new(clusters, link_matrix, theta)

    %Heap{cluster: %Cluster{uuid: ^cluster_uuid}, items: items} = heap

    clusters
    |> Enum.each(fn %Cluster{uuid: uuid} ->
      assert items
             |> Enum.any?(fn {_, _, item_uuid} ->
               item_uuid == uuid
             end)
    end)
  end

  test "deletes item from heap" do
    items = [
      {10, 15, UUID.uuid4()},
      item = {9, 14, uuid = UUID.uuid4()},
      {6, 12, UUID.uuid4()},
      {5, 10, UUID.uuid4()}
    ]

    heap = TestFactory.create(:heap, items)

    %Heap{items: new_items} = heap |> Heap.remove_item(uuid)

    refute new_items |> Enum.member?(item)
  end

  test "adds new item to heap",
       %{cluster: cluster, clusters: clusters, link_matrix: link_matrix, theta: theta} do
    new_cluster = %Cluster{uuid: uuid} = clusters |> Enum.at(0)
    clusters = clusters |> List.delete_at(0)
    heap = cluster |> Heap.new(clusters, link_matrix, theta)
    cross_link_count = 10

    %Heap{items: items} =
      heap
      |> Heap.add_item(new_cluster, cross_link_count, theta)

    assert items
           |> Enum.any?(fn {_, _, cluster_uuid} ->
             cluster_uuid == uuid
           end)
  end

  test "finds item in heap",
       %{cluster: cluster, clusters: clusters, link_matrix: link_matrix, theta: theta} do
    %Cluster{uuid: uuid} = clusters |> Enum.at(0)
    heap = cluster |> Heap.new(clusters, link_matrix, theta)

    item = heap |> Heap.find_item(uuid)

    assert item
  end
end
