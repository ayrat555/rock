defmodule Rock do
  alias Rock.Utils
  alias Rock.Algorithm
  @moduledoc """
  ROCK: A Robust Clustering Algorithm for Categorical Attributes
  """

  @doc """
  Hello world.

  ## Examples

      iex> Rock.hello
      :world

  """

  def clusterize(points, number_of_clusters, theta, similarity_function \\ nil)
      when is_list(points)
      when is_number(number_of_clusters)
      when is_number(theta) do
    points
    |> Utils.internalize_points
    |> Algorithm.clusterize(number_of_clusters, theta, similarity_function)
    |> Utils.externalize_clusters
  end
end
