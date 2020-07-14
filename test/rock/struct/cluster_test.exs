defmodule Rock.Struct.ClusterTest do
  use ExUnit.Case
  alias Rock.Struct.Cluster
  alias Rock.Test.TestFactory

  test "adds a point to a cluster" do
    point = TestFactory.from_string(:point, ["6"])

    cluster =
      TestFactory.from_string(
        :cluster,
        [
          ["1", "2", "3"],
          ["5"]
        ]
      )

    %Cluster{points: points, size: size} =
      cluster
      |> Cluster.add_point(point)

    ^size = 3

    assert Enum.any?(points, fn p ->
             p == point
           end)
  end

  test "merges two clusters" do
    cluster1 =
      %Cluster{uuid: uuid1, points: points1} =
      TestFactory.from_string(
        :cluster,
        [
          ["1", "2", "3"],
          ["5", "7"]
        ]
      )

    cluster2 =
      %Cluster{uuid: uuid2, points: points2} =
      TestFactory.from_string(
        :cluster,
        [
          ["1", "2"],
          ["5"]
        ]
      )

    %Cluster{uuid: uuid3, points: new_points} = Cluster.merge(cluster1, cluster2)

    assert uuid3 != uuid1
    assert uuid3 != uuid2
    assert new_points == points1 ++ points2
  end
end
