defmodule Rock.Struct.Cluster do
  defstruct points: [], size: 0, uuid: nil

  alias Rock.Struct.Cluster
  alias Rock.Struct.Point

  def new(points) when is_list(points) do
    size = points |> Enum.count

    %Cluster{points: points, size: size, uuid: UUID.uuid4()}
  end

  def add_point(%Cluster{points: points, size: size}, %Point{} = point) do
    new_points = points ++ [point]

    %Cluster{points: new_points, size: size + 1}
  end
end
