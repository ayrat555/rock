defmodule Rock.HeapsTest do
  use ExUnit.Case

  alias Rock.Heaps
  alias Rock.Links
  alias Rock.NeighbourCriterion
  alias Rock.Struct.Point
  alias Rock.Struct.Cluster
  alias Rock.Struct.Heap

  setup do
    theta = 0.5
    criterion = NeighbourCriterion.new(theta)
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
    link_matrix =
      points
      |> Links.matrix(criterion)
    point_clusters =
      points
      |> Enum.chunk_by(fn(%Point{attributes: attrs}) ->
      attrs |> Enum.at(0) == "1"
    end)
    clusters =
      point_clusters
      |> Enum.map(&Cluster.new(&1))

    {
      :ok,
      [
        clusters: clusters,
        link_matrix: link_matrix,
        theta: theta
      ]
    }
  end

  test "initializes heap list", %{clusters: clusters,
                                  link_matrix: link_matrix, theta: theta} do
    heaps = clusters |> Heaps.initialize(link_matrix, theta)

    clusters
    |> Enum.each(fn(%Cluster{uuid: uuid}) ->
      exists =
        heaps
        |> Enum.map(fn(%Heap{cluster: %Cluster{uuid: cluster_uuid}}) ->
          cluster_uuid == uuid
        end)

      assert exists
    end)
  end

  test "updates heap list", %{clusters: clusters,
                              link_matrix: link_matrix, theta: theta} do
    heaps = clusters |> Heaps.initialize(link_matrix, theta)
    cluster1 = %Cluster{uuid: uuid1} = clusters |> Enum.at(0)
    cluster2 = %Cluster{uuid: uuid2} = clusters |> Enum.at(1)

    {new_heaps, _cluster3} = heaps |> Heaps.update(cluster1, cluster2, theta)

    assert Enum.count(heaps) == (Enum.count(new_heaps) + 1)
    refute new_heaps |> Enum.any?(fn(%Heap{cluster: %Cluster{uuid: uuid}}) ->
      (uuid == uuid1) || (uuid == uuid2)
    end)
  end
end
