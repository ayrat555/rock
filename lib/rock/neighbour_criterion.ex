defmodule Rock.NeighbourCriterion do
  alias Rock.Struct.Point
  alias Rock.JaccardCoefficient

  def new(theta,
      similarity_function \\ &JaccardCoefficient.measure/2) do
    fn(%Point{} = point1, %Point{} = point2) ->
      if similarity_function.(point1, point2) >= theta, do: 1, else: 0
    end
  end
end
