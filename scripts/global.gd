extends Node

var small_snowball_player= preload("res://scenes/projectiles/small_snowball_player.tscn")
var small_snowball_enemy= preload("res://scenes/projectiles/small_snowball_enemy.tscn")
var fx_snow_hit= preload("res://scenes/fx/snow_hit.tscn")
var fx_big_snow_hit= preload("res://scenes/fx/big_snow_hit.tscn")

onready var navigation_node : Pathfinding2D= get_node("/root/level/navigation")
onready var ysort_node : YSort= get_node("/root/level/navigation/ysort")
onready var player_node : Player= get_node("/root/level/navigation/ysort/player")
onready var health_bar_node : HealthBar= get_node("/root/level/CanvasLayer/health_bar")

func create_fx(fx_to_instance,transform_to_instacne):
	var fx=fx_to_instance.instance()
	ysort_node.add_child(fx)
	fx.global_transform=transform_to_instacne
