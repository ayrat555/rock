defmodule Rock.NeighbourCriterionTest do
  use ExUnit.Case
  alias Rock.Struct.Point
  alias Rock.NeighbourCriterion

  test "check if points are neighbours with Jaccard Coefficient" do
    point1 = Point.new(["1", "2", "5"])
    point2 = Point.new(["1", "5", "6"])

    criterion = NeighbourCriterion.new(0.1)
    assert criterion.(point1, point2) == 1
  end

  test "check if points are neighbours with custom similarity function" do
    similarity_function = fn %Point{attributes: attributes1}, %Point{attributes: attributes2} ->
      Enum.count(attributes1) * Enum.count(attributes2)
    end

    point1 = Point.new(["1", "2", "5"])
    point2 = Point.new(["1", "5", "6"])

    criterion = NeighbourCriterion.new(100, similarity_function)
    assert criterion.(point1, point2) == 0
  end
end
