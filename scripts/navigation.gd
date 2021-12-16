extends Navigation2D

class_name Pathfinding2D

func get_nav_path(global_start: Vector2, global_end: Vector2)->PoolVector2Array:
	var local_start=to_local(global_start)
	var local_end=to_local(global_end)
	return get_simple_path(local_start,local_end)
