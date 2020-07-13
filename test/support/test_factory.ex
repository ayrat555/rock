defmodule Rock.Test.TestFactory do
  @moduledoc false

  alias Rock.Struct.Point
  alias Rock.Struct.Cluster
  alias Rock.Struct.Heap

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

  def create(:heap, items) do
    %Heap{cluster: %Cluster{uuid: UUID.uuid4}, items: items}
  end
end
