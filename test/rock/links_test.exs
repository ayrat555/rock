defmodule Rock.LinksTest do
  use ExUnit.Case
  alias Rock.Links
  alias Rock.Struct.Point

  @points [
    Point.new(["1", "2", "3", "4", "5"]),
    Point.new(["1"]),
    Point.new(["5", "6", "7"])
  ]

  test "calculates link matrix" do
    link_matrix =
      @points
      |> Links.matrix(0)

    ^link_matrix =
      [
        [0, 2, 2],
        [0, 0, 1],
        [0, 0, 0]
      ]
  end
end
