extends NavigationPolygonInstance

func update_nav(level_width,level_height):
	var navigationPolygon := NavigationPolygon.new()
	var vec2_array:=PoolVector2Array()
	vec2_array.append(Vector2(0,0))
	vec2_array.append(Vector2(0,level_height))
	vec2_array.append(Vector2(level_width,level_height))
	vec2_array.append(Vector2(level_width,0))
	navigationPolygon.add_outline(vec2_array)
	for polygon in get_tree().get_nodes_in_group("ObstaclesPolygons"):
		var new_shape:=PoolVector2Array()
		var polygon_transform=polygon.get_global_transform()
		var shape=polygon.get_polygon()
		for vertex in shape :
			new_shape.append(polygon_transform.xform(vertex))
		navigationPolygon.add_outline(new_shape)
	navigationPolygon.make_polygons_from_outlines()
	set_navigation_polygon(navigationPolygon)
