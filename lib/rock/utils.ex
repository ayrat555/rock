defmodule Rock.Utils do
  alias Rock.Struct.Point
  alias Rock.Struct.Cluster
  @moduledoc false

  def internalize_points(points) when is_list(points) do
    points
    |> Enum.with_index
    |> Enum.map(fn({{name, attributes}, index}) ->
      Point.new(name, attributes, index)
    end)
  end

  def externalize_clusters(clusters) when is_list(clusters) do
    clusters
    |> Enum.map(fn(%Cluster{points: points}) ->
      points |> Enum.map(&Point.to_list/1)
    end)
  end
end
