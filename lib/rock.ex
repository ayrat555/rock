defmodule Rock do
  alias Rock.Utils
  alias Rock.Algorithm

  @moduledoc """
  ROCK: A Robust Clustering Algorithm for Categorical Attributes
  """

  @doc """
  Clusterizes points using the Rock algorithm with the provided arguments:

  * `points`, points that will be clusterized
  * `number_of_clusters`, the number of desired clusters.
  * `theta`, neighborhood parameter in the range [0,1). Default value is 0.5.
  * `similarity_function`, distance function to use. Jaccard Coefficient is used by default.

  ## Examples

      points =
      [
        {"point1", ["1", "2", "3"]},
        {"point2", ["1", "2", "4"]},
        {"point3", ["1", "2", "5"]},
        {"point4", ["1", "3", "4"]},
        {"point5", ["1", "3", "5"]},
        {"point6", ["1", "4", "5"]},
        {"point7", ["2", "3", "4"]},
        {"point8", ["2", "3", "5"]},
        {"point9", ["2", "4", "5"]},
        {"point10", ["3", "4", "5"]},
        {"point11", ["1", "2", "6"]},
        {"point12", ["1", "2", "7"]},
        {"point13", ["1", "6", "7"]},
        {"point14", ["2", "6", "7"]}
      ]

      # Example 1

      Rock.clusterize(points, 5, 0.4)
      [
        [
          {"point4", ["1", "3", "4"]},
          {"point5", ["1", "3", "5"]},
          {"point6", ["1", "4", "5"]},
          {"point10", ["3", "4", "5"]},
          {"point7", ["2", "3", "4"]},
          {"point8", ["2", "3", "5"]}
        ],
        [
          {"point11", ["1", "2", "6"]},
          {"point12", ["1", "2", "7"]},
          {"point1", ["1", "2", "3"]},
          {"point2", ["1", "2", "4"]},
          {"point3", ["1", "2", "5"]}
        ],
        [
          {"point9", ["2", "4", "5"]}
        ],
        [
          {"point13", ["1", "6", "7"]}
        ],
        [
          {"point14", ["2", "6", "7"]}
        ]
      ]

      # Example 2 (with custom similarity function)

      similarity_function = fn(
          %Rock.Struct.Point{attributes: attributes1},
          %Rock.Struct.Point{attributes: attributes2}) ->

        count1 = Enum.count(attributes1)
        count2 = Enum.count(attributes2)

        if count1 >= count2, do: (count2 - 1) / count1, else: (count1 - 1) / count2
      end

      Rock.clusterize(points, 4, 0.5, similarity_function)
      [
        [
          {"point1", ["1", "2", "3"]},
          {"point2", ["1", "2", "4"]},
          {"point3", ["1", "2", "5"]},
          {"point4", ["1", "3", "4"]},
          {"point5", ["1", "3", "5"]},
          {"point6", ["1", "4", "5"]},
          {"point7", ["2", "3", "4"]},
          {"point8", ["2", "3", "5"]},
          {"point9", ["2", "4", "5"]},
          {"point10", ["3", "4", "5"]},
          {"point11", ["1", "2", "6"]}
        ],
        [
          {"point12", ["1", "2", "7"]}
        ],
        [
          {"point13", ["1", "6", "7"]}
        ],
        [
          {"point14", ["2", "6", "7"]}
        ]
      ]

  """

  def clusterize(points, number_of_clusters, theta \\ 0.5, similarity_function \\ nil)
      when is_list(points)
      when is_number(number_of_clusters)
      when is_number(theta)
      when is_function(similarity_function) do
    points
    |> Utils.internalize_points()
    |> Algorithm.clusterize(number_of_clusters, theta, similarity_function)
    |> Utils.externalize_clusters()
  end
end
