extends NavigationPolygonInstance

func update_nav():
	var navigationPolygon := get_navigation_polygon()
	for polygon in get_tree().get_nodes_in_group("ObstaclesPolygons"):
		var new_shape:=PoolVector2Array()
		var polygon_transform=polygon.get_global_transform()
		var shape=polygon.get_polygon()
		for vertex in shape :
			new_shape.append(polygon_transform.xform(vertex))
		navigationPolygon.add_outline(new_shape)
	navigationPolygon.make_polygons_from_outlines()
	set_navigation_polygon(navigationPolygon)
