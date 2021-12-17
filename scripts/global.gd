extends Node

var small_snowball_player= preload("res://scenes/projectiles/small_snowball_player.tscn")
var small_snowball_enemy= preload("res://scenes/projectiles/small_snowball_enemy.tscn")
var big_snowball_enemy= preload("res://scenes/projectiles/big_snowball_enemy.tscn")
var fx_snow_hit= preload("res://scenes/fx/snow_hit.tscn")
var fx_big_snow_hit= preload("res://scenes/fx/big_snow_hit.tscn")
var death_menu_scene= preload("res://scenes/ui/death_menu.tscn")
var level_scene=preload("res://scenes/level.tscn")
var settings_menu_scene=preload("res://scenes/ui/settings_menu.tscn")
var fx_big_snowman_dead=preload("res://scenes/enemies/big_snowman_dead.tscn")
var fx_small_snowman_dead=preload("res://scenes/enemies/small_snowman_dead.tscn")
var player_scene=preload("res://scenes/player.tscn")
var small_snowman=preload("res://scenes/enemies/small_snowman.tscn")
var big_snowman=preload("res://scenes/enemies/big_snowman.tscn")

var navigation_node : Pathfinding2D
var ysort_node : YSort
var player_node : Player
var health_bar_node : HealthBar
var camera_node : Camera2D
var level_node : Node
var shoot_speed:=12.0

var death_menu_node
var settings_menu_node

func create_fx(fx_to_instance,transform_to_instacne):
	var fx=fx_to_instance.instance()
	ysort_node.add_child(fx)
	fx.global_transform=transform_to_instacne

func _ready():
	self.pause_mode=Node.PAUSE_MODE_PROCESS
	
	death_menu_node=death_menu_scene.instance()
	self.add_child(death_menu_node)
	death_menu_node.get_child(0).visible=false
	death_menu_node.pause_mode=Node.PAUSE_MODE_PROCESS
	
	settings_menu_node=settings_menu_scene.instance()
	self.add_child(settings_menu_node)
	settings_menu_node.get_child(0).visible=false
	settings_menu_node.pause_mode=Node.PAUSE_MODE_PROCESS
	
	

func _process(_delta:float)->void:
	if Input.is_action_just_pressed("ui_menu") :
		show_hide_settings()

func retry():
	if level_node!=null :
		level_node.queue_free()
	Engine.time_scale=1.0
	level_node=level_scene.instance()
	add_child(level_node)
	settings_menu_node.get_child(0).visible=false
	death_menu_node.get_child(0).visible=false
	get_tree().paused=false

func show_hide_settings() :
	level_node.pause_mode=Node.PAUSE_MODE_STOP
	settings_menu_node.get_child(0).visible=!settings_menu_node.get_child(0).visible
	get_tree().paused=!get_tree().paused
	
func on_player_death():
	Engine.time_scale=0.5
	camera_node.zoom_on_player()

func show_death_menu():
	death_menu_node.get_child(0).visible=true
	
func spawn_player(pos):
	player_node=player_scene.instance()
	ysort_node.add_child(player_node)
	player_node.global_position=pos
	

