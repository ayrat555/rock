defmodule Rock.NeighborMatrix do
  alias Rock.JaccardCoefficient

  def matrix(points,
      similarity_function \\ &JaccardCoefficient.measure/2)
      when is_list(points) do
    points
    |> Enum.map(fn(point1) ->
      points
      |> Enum.map(fn(point2) ->
        similarity_function.(point1, point2)
      end)
    end)
  end
end
