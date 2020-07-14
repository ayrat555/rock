defmodule Rock.Struct.Point do
  defstruct attributes: [], name: nil, index: nil

  alias Rock.Struct.Point
  @moduledoc false

  def new(name, attributes, index) when is_list(attributes) do
    attributes = MapSet.new(attributes)

    %Point{attributes: attributes, name: name, index: index}
  end

  def new(attributes) when is_list(attributes) do
    attributes = MapSet.new(attributes)

    %Point{attributes: attributes}
  end

  def intersection(
        %Point{attributes: attributes1},
        %Point{attributes: attributes2}
      ) do
    attributes1
    |> MapSet.intersection(attributes2)
    |> MapSet.to_list()
  end

  def union(
        %Point{attributes: attributes1},
        %Point{attributes: attributes2}
      ) do
    attributes1
    |> MapSet.union(attributes2)
    |> MapSet.to_list()
  end

  def attribute_size(%Point{attributes: attributes}) do
    attributes |> Enum.count()
  end

  def to_list(%Point{attributes: attributes, name: name}) do
    attr_list = attributes |> MapSet.to_list()

    {name, attr_list}
  end
end
