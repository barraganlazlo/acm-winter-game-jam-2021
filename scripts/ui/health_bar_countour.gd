extends TextureRect

func _ready():
	rect_min_size=get_node("..").rect_min_size + Vector2(4,4)
	rect_size=get_node("..").rect_size + Vector2(4,4)
