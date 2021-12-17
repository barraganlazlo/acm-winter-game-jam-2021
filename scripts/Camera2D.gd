extends Camera2D

onready var tween=$Tween

var max_zoom

func _ready():
	global.camera_node=self

func zoom_on_player()->void :
	tween.interpolate_property(self,"zoom",Vector2(1, 1), Vector2(100, 100))


func _on_Tween_tween_all_completed():
	global.show_death_menu()
