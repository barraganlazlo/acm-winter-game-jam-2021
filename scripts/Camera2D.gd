extends Camera2D

onready var tween=$Tween

var max_zoom= Vector2(0.7, 0.7)
var zoom_duration=1.2
func _ready():
	global.camera_node=self

func zoom_on_player()->void :
	tween.interpolate_property(self,"zoom",Vector2(1, 1), max_zoom,zoom_duration)
	tween.interpolate_property(self,"global_position",global_position, global.player_node.global_position,zoom_duration)
	tween.start()

func _on_Tween_tween_all_completed():
	global.show_death_menu()
