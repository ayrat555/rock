defmodule Rock.JaccardCoefficientTest do
  use ExUnit.Case
  alias Rock.Struct.Point
  alias Rock.JaccardCoefficient

  test "calculates jaccard coefficient" do
    point1 = Point.new(["1", "2", "3", "5", "6"])
    point2 = Point.new(["1", "2", "7", "8"])

    coefficient = JaccardCoefficient.measure(point1, point2)

    ^coefficient = 2 / 7
  end
end
