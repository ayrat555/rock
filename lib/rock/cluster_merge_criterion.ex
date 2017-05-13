defmodule Rock.ClusterMergeCriterion do
  alias Rock.Struct.Point
  alias Rock.Struct.Cluster

  def measure(link_matrix,
      %Cluster{points: points1, size: size1} = cluster1,
      %Cluster{points: points2, size: size2} = cluster2,
      theta) do
    cross_link = count_cross_links(link_matrix, cluster1, cluster2)
    power = 1 + 2 * f_theta(theta)
    summand1 = :math.pow(size1 + size2, power)
    summand2 = :math.pow(size1, power)
    summand3 = :math.pow(size2, power)

    cross_link / (summand1 - summand2 - summand3)
  end

  def count_cross_links(link_matrix,
      %Cluster{points: points1},
      %Cluster{points: points2}) do
    count_cross_links(link_matrix, points1, points2, 0)
  end

  defp count_cross_links(link_matrix,
      [point1 | []],
      second_cluster_points,
      count) do

    count_cross_links(link_matrix, point1, second_cluster_points, count)
  end

  defp count_cross_links(link_matrix,
      [point1 | tail],
      second_cluster_points,
      count) do
    new_count =
      count +
        count_cross_links(link_matrix, point1, second_cluster_points, count)

    count_cross_links(link_matrix, tail, second_cluster_points, new_count)
  end

  defp count_cross_links(link_matrix,
      %Point{index: index1},
      [%Point{index: index2} | []],
      count) do
    count + number_of_links(link_matrix, index1, index2)
  end

  defp count_cross_links(link_matrix,
      %Point{index: index1} = point1,
      [%Point{index: index2} | tail],
      count) do
    new_count = count + number_of_links(link_matrix, index1, index2)

    count_cross_links(link_matrix, point1, tail, new_count)
  end

  defp number_of_links(link_matrix, index1, index2) do
    # because our link matrix is symmetric and we have zeros under main diagonal
    {index1, index2} =  if index1 > index2,
      do: {index2, index1},
      else: {index1, index2}

    link_matrix
    |> Enum.at(index1)
    |> Enum.at(index2)
  end

  def f_theta(theta) do
    (1 - theta) / (1 + theta)
  end
end
