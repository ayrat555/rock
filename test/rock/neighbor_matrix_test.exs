defmodule Rock.NeighborMatrixTest do
  use ExUnit.Case
  alias Rock.Struct.Point
  @points [
    Point.new(["1", "2", "3", "4", "5"]),
    Point.new(["1"]),
    Point.new(["5", "6", "7"])
  ]

  test "calculates neighbor matrix with jaccard coefficient" do
    neighbor_matrix = @points |> Rock.NeighborMatrix.matrix

    ^neighbor_matrix = [
      [1.0, 0.2, 0.14285714285714285],
      [0.2, 1.0, 0.0],
      [0.14285714285714285, 0.0, 1.0]
    ]
  end

  test "calculates neighbor matrix with custom similarity function" do
    similarity_function = fn(
        %Point{attributes: attributes1},
        %Point{attributes: attributes2}) ->
      Enum.count(attributes1) / Enum.count(attributes2)
    end
    neighbor_matrix = @points |> Rock.NeighborMatrix.matrix(similarity_function)

    ^neighbor_matrix = [
      [1.0, 5.0, 1.6666666666666667],
      [0.2, 1.0, 0.3333333333333333],
      [0.6, 3.0, 1.0]
    ]
  end
end
