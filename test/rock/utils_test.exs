defmodule Rock.UtilsTest do
  use ExUnit.Case

  alias Rock.Utils
  alias Rock.Struct.Point

  test "internalizes points" do
    external_input = [
      {"point1", ["1", "2", "3", "4", "5"]},
      {"point2", ["1", "6", "7"]},
      {"point3", ["5", "8", "8"]}
    ]

    points = external_input |> Utils.internalize_points

    points
    |> Enum.reduce(0, fn(
      %Point{
        attributes: attributes,
        index: index,
        name: name},
      count) ->

      assert external_input |> Enum.any?(fn({n, attrs}) ->
        (name == n) && (MapSet.new(attrs) == attributes)
      end)
      ^index = count

      count + 1
    end)
  end
end
