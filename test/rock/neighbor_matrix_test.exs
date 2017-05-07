defmodule Rock.NeighborMatrixTest do
  use ExUnit.Case
  alias Rock.Struct.Point
  @points [
    Point.new(["1", "2", "3", "4", "5"]),
    Point.new(["1"]),
    Point.new(["5", "6", "7"])
  ]

  test "calculates neighbor matrix with jaccard coefficient" do
    neighbor_matrix = @points |> Rock.NeighborMatrix.matrix(0.1)

    ^neighbor_matrix = [
      [1, 1, 1],
      [1, 1, 0],
      [1, 0, 1]
    ]
  end

  test "calculates neighbor matrix with custom similarity function" do
    similarity_function = fn(
        %Point{attributes: attributes1},
        %Point{attributes: attributes2}) ->
      Enum.count(attributes1) * Enum.count(attributes2)
    end
    neighbor_matrix =
      @points
      |> Rock.NeighborMatrix.matrix(10, similarity_function)

    ^neighbor_matrix = [
      [1, 0, 1],
      [0, 0, 0],
      [1, 0, 0]
    ]
  end
end
