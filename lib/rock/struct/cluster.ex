defmodule Rock.Struct.Cluster do
  defstruct points: [], size: 0, uuid: nil

  alias Rock.Struct.Cluster
  alias Rock.Struct.Point
  @moduledoc false

  def new(points) when is_list(points) do
    size = points |> Enum.count

    %Cluster{points: points, size: size, uuid: UUID.uuid4()}
  end

  def add_point(%Cluster{points: points, size: size}, %Point{} = point) do
    new_points = points ++ [point]

    %Cluster{points: new_points, size: size + 1}
  end

  def merge(%Cluster{points: points1, size: size1},
      %Cluster{points: points2, size: size2}) do
    new_points = points1 ++ points2
    new_size = size1 + size2

    %Cluster{
      points: new_points,
      size: new_size,
      uuid: UUID.uuid4
    }
  end
end
