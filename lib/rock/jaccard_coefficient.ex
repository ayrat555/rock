defmodule Rock.JaccardCoefficient do
  alias Rock.Struct.Point
  @moduledoc false

  def measure(%Point{} = point1, %Point{} = point2) do
    intersection_count(point1, point2) / union_count(point1, point2)
  end

  defp union_count(point1, point2) do
    point1
    |> Point.union(point2)
    |> Enum.count
  end

  defp intersection_count(point1, point2) do
    point1
    |> Point.intersection(point2)
    |> Enum.count
  end
end
