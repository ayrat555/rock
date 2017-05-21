defmodule Rock.Struct.Heap do
  defstruct cluster_uuid: nil, items: []

  alias Rock.Struct.Cluster
  alias Rock.Struct.Heap
  alias Rock.ClusterMergeCriterion

  def new(%Cluster{uuid: uuid} = cluster,
      other_clusters,
      link_matrix,
      theta) do

    if other_clusters |> Enum.member?(cluster),
      do: raise ArgumentError, message: "cluster can not be member of heap items clusters"

    items = cluster |> prepare_items(other_clusters, link_matrix, theta)

    %Heap{cluster_uuid: uuid, items: items}
  end

  def remove_item(%Heap{items: items, cluster_uuid: cluster_uuid}, uuid) do
    new_items = items |> _remove_item(items, uuid)

    %Heap{cluster_uuid: cluster_uuid, items: new_items}
  end

  defp _remove_item(items, [{_, _, cluster_uuid} = item | _], uuid) when cluster_uuid == uuid do
    items |> List.delete(item)
  end

  defp _remove_item(_, [_, []], uuid) do
    raise ArgumentError, message: "heap does not have the item with uuid #{uuid}"
  end

  defp _remove_item(items, [_item | tail], uuid) do
    items |> _remove_item(tail, uuid)
  end

  defp prepare_items(cluster, clusters, link_matrix, theta) do
    clusters
    |> calculate_items(cluster, link_matrix, theta)
    |> remove_empty_links
    |> sort
  end

  defp calculate_items(clusters, cluster, link_matrix, theta) do
    clusters
    |> Enum.map(&calculate_item(cluster, &1, link_matrix, theta) )
  end

  defp calculate_item(cluster,
      other_cluster = %Cluster{uuid: uuid},
      link_matrix,
      theta) do

    {measure, cross_link_count} =
      link_matrix
      |> ClusterMergeCriterion.measure(cluster, other_cluster, theta)

    {measure, cross_link_count, uuid}
  end

  defp remove_empty_links(items) do
    items
    |> Enum.filter(fn({_, cross_link_count, _}) ->
      cross_link_count != 0
    end)
  end

  defp sort(items) do
    items
    |> Enum.sort_by(fn({measure, _, _}) ->
      - measure
    end)
  end
end
