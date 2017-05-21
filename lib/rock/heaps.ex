defmodule Rock.Heaps do
  alias Rock.Struct.Heap
  alias Rock.Struct.Cluster

  def initialize(clusters, link_matrix, theta) do
    clusters
    |> Enum.map(fn(cluster) ->
      remaining_clusters =
        clusters
        |> List.delete(cluster)

      cluster |> Heap.new(remaining_clusters, link_matrix, theta)
    end)
  end

  def update(heaps,
      %Cluster{uuid: v_uuid} = v_cluster,
      %Cluster{uuid: u_uuid} = u_cluster,
      theta) do

    merged_cluster = v_cluster |> Cluster.merge(u_cluster)

    new_heaps =
      heaps
      |> Enum.map(fn(heap) ->
        v_item = heap |> Heap.find_item(v_uuid)
        u_item = heap |> Heap.find_item(u_uuid)

        cross_link_count = case {v_item, u_item} do
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
          |> Heap.remove_item(u_item)

        if cross_link_count == 0 do
          heap
        else
          heap |> Heap.add_item(merged_cluster, cross_link_count, theta)
        end
      end)

    new_heaps =
      new_heaps
      |> remove_heap(v_uuid)
      |> remove_heap(u_uuid)
  end

  def remove_heap(heaps, uuid) do
    heaps
    |> Enum.filter(fn(%Heap{cluster: %Cluster{uuid: cluster_uuid}}) ->
      uuid != cluster_uuid
    end)
  end
end
