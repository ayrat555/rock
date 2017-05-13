defmodule Rock.NeighboursTest do
  use ExUnit.Case
  alias Rock.Struct.Point
  alias Rock.Neighbours
  alias Rock.NeighbourCriterion

  @points [
    Point.new(["1", "2", "3", "4", "5"]),
    Point.new(["1"]),
    Point.new(["5", "6", "7"])
  ]

  test "calculates neighbor matrix with jaccard coefficient (example 1)" do
    criterion = NeighbourCriterion.new(0.1)

    neighbor_matrix =
      @points
      |> Neighbours.matrix(criterion)

    ^neighbor_matrix = [
      [1, 1, 1],
      [1, 1, 0],
      [1, 0, 1]
    ]
  end

  test "calculates neighbor matrix with jaccard coefficient (example 2)" do
    criterion = NeighbourCriterion.new(0.5)
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
    neighbor_matrix =
      points
      |> Neighbours.matrix(criterion)

    [
      [1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0],
      [1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0],
      [1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0],
      [1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0],
      [1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0],
      [1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
      [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
      [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1]
    ] = neighbor_matrix
  end

  test "calculates neighbor matrix with custom similarity function" do
    similarity_function = fn(
        %Point{attributes: attributes1},
        %Point{attributes: attributes2}) ->
      Enum.count(attributes1) * Enum.count(attributes2)
    end
    criterion = NeighbourCriterion.new(10, similarity_function)
    neighbor_matrix =
      @points
      |> Neighbours.matrix(criterion)

    ^neighbor_matrix = [
      [1, 0, 1],
      [0, 0, 0],
      [1, 0, 0]
    ]
  end

  test "returns neighbor indices list" do
    criterion = NeighbourCriterion.new(0.1)
    neighbor_list =
      @points
      |> Neighbours.list(criterion)

    ^neighbor_list = [
      [0, 1, 2],
      [0, 1],
      [0, 2]
    ]
  end
end
