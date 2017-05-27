defmodule Rock.AlgorithmTest do
  use ExUnit.Case

  alias Rock.Algorithm
  alias Rock.Utils

  @points  [
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
  ] |> Utils.internalize_points
  @number_of_clusters 5


  test "clusterizes points with theta = 0.1" do
    theta = 0.1

    result = @points
      |> Algorithm.clusterize(@number_of_clusters, theta)
      |> Utils.externalize_clusters

    [
      [
        {"point5", ["1", "3", "5"]},
        {"point6", ["1", "4", "5"]},
        {"point10", ["3", "4", "5"]}
      ],
      [
        {"point11", ["1", "2", "6"]},
        {"point12", ["1", "2", "7"]},
        {"point13", ["1", "6", "7"]}
      ],
      [
        {"point3", ["1", "2", "5"]},
        {"point4", ["1", "3", "4"]},
        {"point1", ["1", "2", "3"]},
        {"point2", ["1", "2", "4"]}
      ],
      [
        {"point7", ["2", "3", "4"]},
        {"point8", ["2", "3", "5"]},
        {"point9", ["2", "4", "5"]}
      ],
      [
        {"point14", ["2", "6", "7"]}
      ]
    ] = result
  end

  test "clusterizes points with theta = 0.2" do
    theta = 0.2

    result = @points
    |> Algorithm.clusterize(@number_of_clusters, theta)
    |> Utils.externalize_clusters

    [
      [
        {"point3", ["1", "2", "5"]},
        {"point4", ["1", "3", "4"]},
        {"point1", ["1", "2", "3"]},
        {"point2", ["1", "2", "4"]},
        {"point7", ["2", "3", "4"]},
        {"point8", ["2", "3", "5"]},
        {"point9", ["2", "4", "5"]}
      ],
      [
        {"point11", ["1", "2", "6"]},
        {"point12", ["1", "2", "7"]},
        {"point5", ["1", "3", "5"]},
        {"point6", ["1", "4", "5"]}
      ],
      [
        {"point10", ["3", "4", "5"]}
      ],
      [
        {"point13", ["1", "6", "7"]}
      ],
      [
        {"point14", ["2", "6", "7"]}
      ]
    ] = result
  end

  test "clusterizes points with theta = 0.3" do
    theta = 0.3

    result = @points
    |> Algorithm.clusterize(@number_of_clusters, theta)
    |> Utils.externalize_clusters

    [
      [
        {"point7", ["2", "3", "4"]},
        {"point8", ["2", "3", "5"]},
        {"point10", ["3", "4", "5"]},
        {"point6", ["1", "4", "5"]},
        {"point9", ["2", "4", "5"]}
      ],
      [
        {"point1", ["1", "2", "3"]},
        {"point2", ["1", "2", "4"]},
        {"point3", ["1", "2", "5"]},
        {"point11", ["1", "2", "6"]},
        {"point12", ["1", "2", "7"]}
      ],
      [
        {"point4", ["1", "3", "4"]},
        {"point5", ["1", "3", "5"]}
      ],
      [
        {"point13", ["1", "6", "7"]}
      ],
      [
        {"point14", ["2", "6", "7"]}
      ]
    ] = result
  end
end
