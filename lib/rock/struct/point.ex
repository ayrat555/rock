defmodule Rock.Struct.Point do
  defstruct attributes: []

  alias Rock.Struct.Point

  def new(attributes) when is_list(attributes) do
    attributes = MapSet.new(attributes)

    %Point{attributes: attributes}
  end

  def intersection(%Point{attributes: attributes1},
      %Point{attributes: attributes2}) do
    attributes1
    |> MapSet.intersection(attributes2)
    |> MapSet.to_list
  end

  def union(%Point{attributes: attributes1},
      %Point{attributes: attributes2}) do
    attributes1
    |> MapSet.union(attributes2)
    |> MapSet.to_list
  end

  def attribute_size(%Point{attributes: attributes}) do
    attributes |> Enum.count
  end
end
