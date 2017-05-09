defmodule Rock.Struct.Cluster do
  defstruct points: [], size: 0

  alias Rock.Struct.Cluster
  alias Rock.Struct.Point

  def new(points) when is_list(points) do
    size = points |> Enum.count

    %Cluster{points: points, size: size}
  end

  def add_point(%Cluster{points: points, size: size}, %Point{} = point) do
    new_points = points ++ [point]

    %Cluster{points: new_points, size: size + 1}
  end
end
