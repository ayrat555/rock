defmodule Rock.Struct.ClusterTest do
  use ExUnit.Case
  alias Rock.Struct.Cluster
  alias Rock.Test.TestFactory

  test "adds a point to a cluster" do
    point = TestFactory.from_string(:point, ["6"])
    cluster = TestFactory.from_string(:cluster,
      [
        ["1", "2", "3"],
        ["5"]
      ])

    %Cluster{points: points, size: size} =
      cluster
      |> Cluster.add_point(point)

    ^size = 3
    assert Enum.any?(points, fn(p) ->
      p == point
    end)
  end
end
