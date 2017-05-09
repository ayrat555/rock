defmodule Rock.LinksTest do
  use ExUnit.Case
  alias Rock.Links
  alias Rock.Struct.Point
  alias Rock.NeighbourCriterion

  test "calculates link matrix (example 1)" do
    criterion = NeighbourCriterion.new(0.1)
    points = [
      Point.new(["1", "2", "3", "4", "5"]),
      Point.new(["1"]),
      Point.new(["5", "6", "7"])
    ]
    link_matrix =
      points
      |> Links.matrix(criterion)

    ^link_matrix =
      [
        [0, 2, 2],
        [0, 0, 1],
        [0, 0, 0]
      ]
  end

  test "calculates link matrix (example 2)" do
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

    link_matrix =
      points
      |> Links.matrix(criterion)

    ^link_matrix = [
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
  end

  test "calculates link matrix (example 3)" do
    criterion = NeighbourCriterion.new(0.2)
    points = [
      Point.new(["1"]),
      Point.new(["2", "3", "4", "5"]),
      Point.new(["2", "3", "4", "6"]),
      Point.new(["4", "6"])
    ]

    link_matrix =
      points
      |> Links.matrix(criterion)

    ^link_matrix = [
      [0, 0, 0, 0],
      [0, 0, 3, 3],
      [0, 0, 0, 3],
      [0, 0, 0, 0]
    ]
  end
end
