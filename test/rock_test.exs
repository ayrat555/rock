defmodule RockTest do
  use ExUnit.Case

  alias Rock.Struct.Point

  @points [
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

  test "clusterizes points" do
    theta = 0.15
    number_of_clusters = 2

    result = @points |> Rock.clusterize(number_of_clusters, theta)

    [
      [
        {"point11", ["1", "2", "6"]},
        {"point12", ["1", "2", "7"]},
        {"point5", ["1", "3", "5"]},
        {"point6", ["1", "4", "5"]},
        {"point3", ["1", "2", "5"]},
        {"point4", ["1", "3", "4"]},
        {"point1", ["1", "2", "3"]},
        {"point2", ["1", "2", "4"]},
        {"point7", ["2", "3", "4"]},
        {"point8", ["2", "3", "5"]},
        {"point9", ["2", "4", "5"]},
        {"point10", ["3", "4", "5"]}
      ],
      [
        {"point13", ["1", "6", "7"]},
        {"point14", ["2", "6", "7"]}
      ]
    ] = result
  end

  test "clusterizes points with custom similarity function" do
    theta = 0.5
    number_of_clusters = 2

    similarity_function = fn %Point{attributes: attributes1}, %Point{attributes: attributes2} ->
      count1 = Enum.count(attributes1)
      count2 = Enum.count(attributes2)

      if count1 >= count2, do: count2 / count1, else: count1 / count2
    end

    result = @points |> Rock.clusterize(number_of_clusters, theta, similarity_function)

    ^number_of_clusters = result |> Enum.count()
  end
end
