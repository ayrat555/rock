defmodule Rock.Test.TestFactory do
  alias Rock.Struct.Point
  alias Rock.Struct.Cluster

  def from_string(:cluster, string_points) do
    string_points
    |> Enum.map(fn(string_point) ->
      from_string(:point, string_point)
    end)
    |> Cluster.new
  end

  def from_string(:point, string_attributes) do
    string_attributes |> Point.new
  end
end
