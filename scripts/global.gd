extends Node

var small_snowball_player= preload("res://scenes/projectiles/small_snowball_player.tscn")
var small_snowball_enemy= preload("res://scenes/projectiles/small_snowball_enemy.tscn")
var fx_snow_hit= preload("res://scenes/fx/snow_hit.tscn")

onready var navigationNode : Pathfinding2D= get_node("/root/level/navigation")
onready var ysortNode : YSort= get_node("/root/level/navigation/ysort")
onready var playerNode : Player= get_node("/root/level/navigation/ysort/player")

