defmodule Rock.Struct.PointTest do
  use ExUnit.Case
  alias Rock.Struct.Point

  test "calculates intersection of two points" do
    point1 = Point.new(["1", "2", "5", "6", "9", "10"])
    point2 = Point.new(["3", "4", "5", "6", "7", "8"])

    intersection = Point.intersection(point1, point2)

    ^intersection = ["5", "6"]
  end

  test "calculates union of two points" do
    point1 = Point.new(["1", "2"])
    point2 = Point.new(["3", "4", "5"])

    intersection = Point.union(point1, point2)

    ^intersection = ["1", "2", "3", "4", "5"]
  end

  test "calculates attribute size of a point" do
    point = Point.new(["1", "2", "3", "4"])

    attribute_size = point |> Point.attribute_size

    ^attribute_size = 4
  end
end
