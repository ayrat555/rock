defmodule Rock.Heaps do
  alias Rock.Struct.Heap
  alias Rock.Struct.Cluster
  @moduledoc false

  def initialize(clusters, link_matrix, theta) do
    clusters
    |> Enum.map(fn cluster ->
      remaining_clusters =
        clusters
        |> List.delete(cluster)

      cluster |> Heap.new(remaining_clusters, link_matrix, theta)
    end)
  end

  def update(
        heaps,
        %Cluster{uuid: v_uuid} = v_cluster,
        %Cluster{uuid: u_uuid} = u_cluster,
        theta
      ) do
    w_cluster = v_cluster |> Cluster.merge(u_cluster)

    new_heaps =
      heaps
      |> Enum.map(fn heap ->
        v_item = heap |> Heap.find_item(v_uuid)
        u_item = heap |> Heap.find_item(u_uuid)

        cross_link_count =
          case {v_item, u_item} do
            {nil, {_, cross_link_count, _}} ->
              cross_link_count

            {{_, cross_link_count, _}, nil} ->
              cross_link_count

            {{_, v_cross_link_count, _}, {_, u_cross_link_count, _}} ->
              v_cross_link_count + u_cross_link_count

            {nil, nil} ->
              0
          end

        heap =
          heap
          |> Heap.remove_item(v_uuid)
          |> Heap.remove_item(u_uuid)

        if cross_link_count == 0 do
          heap
        else
          heap
          |> Heap.add_item(w_cluster, cross_link_count, theta)
          |> Heap.sort_items()
        end
      end)

    new_heaps =
      new_heaps
      |> remove_heap(v_uuid)
      |> remove_heap(u_uuid)

    # need optimization, move  to heaps update ^
    w_heap = new_heaps |> construct_w_heap(w_cluster)

    {[w_heap | new_heaps], w_cluster}
  end

  def global_heap(heaps) do
    heaps
    |> Enum.map(fn %Heap{items: items, cluster: %Cluster{uuid: uuid}} ->
      {measure, cross_link_count, cluster_uuid} = items |> Enum.at(0)

      {measure, cross_link_count, uuid, cluster_uuid}
    end)
    |> Enum.sort_by(fn {measure, _, _, _} ->
      -measure
    end)
  end

  defp remove_heap(heaps, uuid) do
    heaps
    |> Enum.filter(fn %Heap{cluster: %Cluster{uuid: cluster_uuid}} ->
      uuid != cluster_uuid
    end)
  end

  defp construct_w_heap(heaps, %Cluster{uuid: w_uuid} = w_cluster) do
    items =
      heaps
      |> Enum.map(fn %Heap{cluster: %Cluster{uuid: uuid}} = heap ->
        item = heap |> Heap.find_item(w_uuid)
        {uuid, item}
      end)
      |> Enum.filter(fn {_, item} ->
        item != nil
      end)
      |> Enum.map(fn {uuid, {measure, cross_link_count, _}} ->
        {measure, cross_link_count, uuid}
      end)

    %Heap{cluster: w_cluster, items: items} |> Heap.sort_items()
  end
end
