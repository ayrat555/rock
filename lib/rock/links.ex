defmodule Rock.Links do
  alias Rock.Neighbours

  def matrix(points, neighbour_criterion)
      when is_list(points) do
    neighbour_lists =
      points
      |> Neighbours.list(neighbour_criterion)

    points
    |> Enum.count
    |> initialize_links
    |> link_matrix(neighbour_lists)
  end

  defp initialize_links(size) do
    1..size
    |> Enum.map(fn(_) ->
      1..size
      |> Enum.map(fn(_) ->
        0
      end)
    end)
  end

  defp link_matrix(link_matrix, [neighbour_list | []]) do
    link_matrix
    |> links_from_neighbours(neighbour_list)
  end

  defp link_matrix(link_matrix, [neighbour_list | tail]) do
    link_matrix
    |> links_from_neighbours(neighbour_list)
    |> link_matrix(tail)
  end

  defp links_from_neighbours(link_matrix, [_neighbour | []]) do
    link_matrix
  end

  defp links_from_neighbours(link_matrix, [neighbour | neighbour_tail]) do
    link_matrix
    |> add_links(neighbour_tail, neighbour)
    |> links_from_neighbours(neighbour_tail)
  end

  defp add_links(link_matrix, [neighbour | []], row_index) do
    link_matrix
    |> add_link(row_index, neighbour)
  end

  defp add_links(link_matrix, [neighbour | neighbour_tail], row_index) do
    link_matrix
    |> add_link(row_index, neighbour)
    |> add_links(neighbour_tail, row_index)
  end

  defp add_link(link_matrix, row_index, column_index) do
    link_matrix
    |> List.update_at(row_index, fn(row) ->
      row
      |> List.update_at(column_index,  &(&1 + 1))
    end)
  end
end
