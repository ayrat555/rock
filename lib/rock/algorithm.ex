defmodule Rock.Algorithm do
  alias Rock.Struct.Cluster
  alias Rock.NeighbourCriterion
  alias Rock.Links
  alias Rock.ClusterMergeCriterion

  def clusterize(points, number_of_clusters, theta) when is_list(points) do
    neighbour_criterion = theta |> NeighbourCriterion.new
    link_matrix = points |> Links.matrix(neighbour_criterion)
    initial_clusters = points |> initialize_clusters
    local_heaps = initial_clusters |> initialize_local_heaps(link_matrix, theta)

    local_heaps
    |> update_global_heap
    |> optimize_clusters(local_heaps, initial_clusters, number_of_clusters, theta)
  end

  defp initialize_clusters(points) do
    points
    |> Enum.map(fn(point) ->
      point
      |> List.wrap
      |> Cluster.new
    end)
  end

  defp initialize_local_heaps(clusters, link_matrix, theta) do
    clusters
    |> Enum.map(fn(%Cluster{uuid: uuid1} = cluster) ->
      clusters
      |> List.delete(cluster)
      |> Enum.map(fn(%Cluster{uuid: uuid2} = other_cluster) ->
        {measure, cross_link_count} =
          link_matrix
          |> ClusterMergeCriterion.measure(cluster, other_cluster, theta)
        {measure, cross_link_count, {uuid1, uuid2}}
      end)
      |> Enum.filter(fn({_, cross_link_count, _}) ->
        cross_link_count != 0
      end)
      |> Enum.sort_by(fn({measure, _, _}) ->
        -measure
      end)
    end)
  end

  defp update_global_heap(local_heaps) do
    local_heaps
    |> Enum.map(fn(local_heap) ->
      local_heap |> Enum.at(0)
    end)
    |> Enum.sort_by(fn({measure, _, _}) ->
      -measure
    end)
  end


  defp optimize_clusters([best_clusters |  _] = global_heap,
      local_heaps,
      clusters,
      number_of_clusters,
      theta) when length(global_heap) > number_of_clusters do

    {_uv_measure, _uv_cross_link_count, {u_uuid, v_uuid}} = best_clusters

    u_cluster = clusters |> find_cluster(u_uuid) 
    v_cluster = clusters |> find_cluster(v_uuid)
    IO.inspect best_clusters
    new_cluster = Cluster.merge(u_cluster, v_cluster) |> IO.inspect
    new_local_heaps =  update_local_heaps(u_uuid, v_uuid, new_cluster, local_heaps, clusters, theta)
    new_global_heap = new_local_heaps |> update_global_heap
    new_clusters =
      clusters
      |> List.delete(u_cluster)
      |> List.delete(v_cluster)

    new_clusters = [new_cluster | new_clusters]

    optimize_clusters(new_global_heap, new_local_heaps, new_clusters, number_of_clusters, theta)
  end

  defp optimize_clusters(_global_heap, _local_heaps, clusters, _number_of_clusters, _theta) do
    clusters
  end

  defp merge_clusters(clusters, uuid1, uuid2) do
    cluster1 = clusters |> find_cluster(uuid1)
    cluster2 = clusters |> find_cluster(uuid2)

    Cluster.merge(cluster1, cluster2)
  end

  defp find_cluster(clusters, uuid) do
    clusters
    |> Enum.find(fn(%Cluster{uuid: cluster_uuid}) ->
      cluster_uuid == uuid
    end)
  end

  def update_local_heaps(u_uuid, v_uuid, w_cluster, local_heaps, clusters, theta) do
    u_heap = local_heaps |> find_heap(u_uuid)
    v_heap = local_heaps |> find_heap(v_uuid)

    heaps_to_update_from_v =
      v_heap
      |> Enum.map(fn({_, _, {_, uuid}}) ->
        uuid
      end)

    heaps_to_update_from_u =
      u_heap
      |> Enum.map(fn({_, _, {_, uuid}}) ->
        uuid
      end)
    heaps_to_update = heaps_to_update_from_u ++ heaps_to_update_from_v
    heaps_to_update = heaps_to_update |> Enum.uniq

    local_heaps
    |> Enum.map(fn(heap) ->
      {_, _, {heap_cluster_uuid, _}} = heap |> Enum.at(0)

      if Enum.any?(heaps_to_update, fn(uuid) -> uuid == heap_cluster_uuid end) do
        cluster = find_cluster(clusters, heap_cluster_uuid)
        update_local_heap(heap, cluster, u_uuid, v_uuid, w_cluster, theta)
      else
        heap
      end
    end)
    |> List.delete(u_heap)
    |> List.delete(v_heap)
  end

  defp update_local_heap(
      local_heap,
      %Cluster{uuid: x_uuid} = cluster,
      u_uuid,
      v_uuid,
      %Cluster{uuid: w_uuid} = w_cluster,
      theta) do

    u_heap_value =
      local_heap
      |> Enum.find(fn({_, _, {_, cluster_uuid}}) ->
        cluster_uuid == u_uuid
      end)
    u_cross_link_count = if is_nil(u_heap_value) do
        0
      else
        {_, u_cross_link_count, _} = u_heap_value
        u_cross_link_count
      end


    v_heap_value =
      local_heap
      |> Enum.find(fn({_, _, {_, cluster_uuid}}) ->
        cluster_uuid == v_uuid
      end)
    v_cross_link_count = if is_nil(v_heap_value) do
        0
      else
        {_, v_cross_link_count, _} = v_heap_value
        v_cross_link_count
      end

    w_cross_link_count = u_cross_link_count + v_cross_link_count
    w_measure = ClusterMergeCriterion.measure(cluster, w_cluster, theta, w_cross_link_count)

    updated_heap =
      local_heap
      |> List.delete(u_heap_value)
      |> List.delete(v_heap_value)

    [{w_measure, w_cross_link_count, {x_uuid, w_uuid}} | updated_heap]
    |> Enum.sort_by(fn({measure, _, _}) ->
       -measure
     end)
  end

  defp find_heap(heaps, uuid) do
    heaps
    |> Enum.find(fn(heap) ->
      {_, _, {cluster_uuid, _}} = Enum.at(heap, 0)
      cluster_uuid == uuid
    end)
  end
end
