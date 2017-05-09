defmodule Rock.Utils do
  alias Rock.Struct.Point

  def internalize_points(points) when is_list(points) do
    points
    |> Enum.with_index
    |> Enum.map(fn({{name, attributes}, index}) ->
      Point.new(name, attributes, index)
    end)
  end
end
