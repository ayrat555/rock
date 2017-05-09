defmodule Rock.Neighbours do
  def list(points, theta, similarity_function) when is_list(points) do
    points
    |> matrix(theta, similarity_function)
    |> index_list
  end

  def matrix(points, theta, similarity_function) when is_list(points) do
    similarity_function = fn(point1, point2) ->
      neighbors?(point1, point2, similarity_function, theta)
    end

    points
    |> lower_triangle_matrix(similarity_function)
    |> copy_to_upper_triangle
  end

  defp index_list(matrix) do
    matrix
    |> Enum.map(fn(row) ->
      row
      |> Enum.with_index
      |> Enum.filter(fn({el, _index}) ->
        el != 0
      end)
      |> Enum.map(fn({_el, index}) ->
        index
      end)
    end)
  end

  defp lower_triangle_matrix(points, similarity_function) do
    points
    |> Enum.with_index
    |> Enum.map(fn({point1, row_index}) ->
      lower_triangle_row(point1, row_index, points, similarity_function)
    end)
  end

  defp lower_triangle_row(point1, row_index, points, similarity_function) do
    points
    |> Enum.with_index
    |> Enum.map(fn({point2, column_index}) ->
      if row_index >= column_index do
        similarity_function.(point1, point2)
      else
        0
      end
    end)
  end

  defp neighbors?(point1, point2, similarity_function, theta) do
    if similarity_function.(point1, point2) > theta, do: 1, else: 0
  end

  defp copy_to_upper_triangle(lower_neighbor_matrix) do
    lower_neighbor_matrix
    |> Enum.with_index
    |> Enum.map(fn({row, row_index}) ->
      row
      |> Enum.with_index
      |> Enum.map(fn({element, column_index}) ->
        lower_neighbor_matrix
        |> lower_triangle_element(row_index, column_index, element)
      end)
    end)
  end

  defp lower_triangle_element(matrix, row_index, column_index, _element)
      when row_index < column_index do
    matrix
    |> Enum.at(column_index)
    |> Enum.at(row_index)
  end

  defp lower_triangle_element(_matrix, _row_index, _column_index, element) do
    element
  end
end
