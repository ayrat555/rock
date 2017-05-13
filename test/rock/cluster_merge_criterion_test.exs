defmodule Rock.ClusterMergeCriterionTest do
  use ExUnit.Case

  alias Rock.Utils
  alias Rock.ClusterMergeCriterion
  alias Rock.Links
  alias Rock.Struct.Cluster
  alias Rock.NeighbourCriterion

  test "counts number of cross links (example 1)" do
    points = [
      {"point1", ["1", "2", "3", "4", "5"]},
      {"point2", ["1", "2", "7", "9"]},
      {"point3", ["1", "9"]}
    ] |> Utils.internalize_points
    cluster1 =
      points
      |> Enum.at(0)
      |> List.wrap
      |> Cluster.new
    cluster2 =
      points
      |> List.delete_at(0)
      |> Cluster.new
    neighbour_criterion = NeighbourCriterion.new(0.2)
    link_matrix = Links.matrix(points, neighbour_criterion)

    count = ClusterMergeCriterion.count_cross_links(link_matrix, cluster1, cluster2)

    ^count = Enum.at(link_matrix, 0) |> Enum.reduce(0, fn(x, acc) -> x + acc end)
  end


  test "counts number of cross links (example 2)" do
    points = [
      {"point1", ["1", "2", "3"]},
      {"point2", ["1", "2", "4"]},
      {"point3", ["1", "2", "5"]},
      {"point4", ["1", "3", "4"]},
      {"point5", ["1", "3", "5"]},
      {"point6", ["1", "4", "5"]},
      {"point7", ["2", "3", "4"]},
      {"point8", ["2", "3", "5"]},
      {"point9", ["2", "4", "5"]},
      {"point10", ["3", "4", "5"]},
      {"point11", ["1", "2", "6"]},
      {"point12", ["1", "2", "7"]},
      {"point13", ["1", "6", "7"]},
      {"point14", ["2", "6", "7"]}
    ]
    |> Utils.internalize_points
    cluster1 =
      points
      |> Enum.at(0)
      |> List.wrap
      |> Cluster.new
      |> Cluster.add_point(points |> Enum.at(2))
    cluster2 =
      points
      |> List.delete_at(0)
      |> List.delete_at(1)
      |> Cluster.new
    neighbour_criterion = NeighbourCriterion.new(0.5)
    link_matrix = Links.matrix(points, neighbour_criterion)
    count = ClusterMergeCriterion.count_cross_links(link_matrix, cluster1, cluster2)

    first_row =
      link_matrix
      |> Enum.at(0)
      |> Enum.reduce(0, fn(x, acc) -> x + acc end)
    expected_count =
      link_matrix
      |> Enum.at(2)
      |> Enum.reduce(first_row, fn(x, acc) -> x + acc end)
    ^count = expected_count
  end

  test "calculates cluster merge critertion" do
    points = [
      {"point1", ["1", "2", "3"]},
      {"point2", ["1", "2", "4"]},
      {"point3", ["1", "2", "5"]},
      {"point4", ["1", "3", "4"]},
      {"point5", ["1", "3", "5"]},
      {"point6", ["1", "4", "5"]},
      {"point7", ["2", "3", "4"]},
      {"point8", ["2", "3", "5"]},
      {"point9", ["2", "4", "5"]},
      {"point10", ["3", "4", "5"]},
      {"point11", ["1", "2", "6"]},
      {"point12", ["1", "2", "7"]},
      {"point13", ["1", "6", "7"]},
      {"point14", ["2", "6", "7"]}
    ]
    |> Utils.internalize_points
    cluster1 =
      points
      |> Enum.at(0)
      |> List.wrap
      |> Cluster.new
      |> Cluster.add_point(points |> Enum.at(2))
    cluster2 =
      points
      |> List.delete_at(0)
      |> List.delete_at(1)
      |> Cluster.new
    neighbour_criterion = NeighbourCriterion.new(0.5)
    link_matrix = Links.matrix(points, neighbour_criterion)

    result =  ClusterMergeCriterion.measure(link_matrix, cluster1, cluster2, 0.5)

    ^result = 6.9506352159723646
  end
 end
