extends Node

var level_width:=1280.0
var level_height:=720.0

onready var left_limit=$map_limits/map_limit_left
onready var right_limit=$map_limits/map_limit_right
onready var top_limit=$map_limits/map_limit_top
onready var bot_limit=$map_limits/map_limit_bot
onready var nav=$navigation

onready var player_spawn_point=$player_spawn_point
onready var enemies_spawn_points=$enemies_spawn_points

var timer_to_spawn_player:=0.1
var spawned_player:=false
var enemy_max_count:=12
var time_to_next_spawn:=4.0
var timer_to_next_spawn:=4.0
var rng = RandomNumberGenerator.new()

var num_obstacles_to_spawn:=32
var spawn_margin:=50

var player_spawn_distance=400
var enemy_spawn_distance=30

var distance_between_obstacles=120

func _ready():
	left_limit.get_node("CollisionShape2D").shape.extents=Vector2(10.0,level_height+10.0)
	left_limit.global_position=Vector2(-5,level_height/2.0)
	right_limit.get_node("CollisionShape2D").shape.extents=Vector2(10.0,level_height+10.0)
	right_limit.global_position=Vector2(level_width+5,level_height/2.0)
	top_limit.get_node("CollisionShape2D").shape.extents=Vector2(level_width+10.0,10.0)
	top_limit.global_position=Vector2(level_width/2.0,-5)
	bot_limit.get_node("CollisionShape2D").shape.extents=Vector2(level_width+10.0,10.0)
	bot_limit.global_position=Vector2(level_width/2.0,level_height+5)
	timer_to_next_spawn=0.0
	rng.randomize()
	spawn_obstacles()
	spawn_decors()
	nav.get_node("NavigationPolygonInstance").update_nav(level_width,level_height)
	
func _process(delta):
	if not spawned_player :
		if timer_to_spawn_player <=0 :
			spawned_player=true
			global.spawn_player(player_spawn_point.global_position)
		else:
			timer_to_spawn_player-=delta
	else :
		if timer_to_next_spawn <=0 and enemy_max_count>get_tree().get_nodes_in_group("Enemies").size() :
			timer_to_next_spawn=time_to_next_spawn
			time_to_next_spawn*=0.92
			spawn_enemy(get_random_pos())
		else :
			timer_to_next_spawn-=delta

func get_random_pos() ->Vector2: 
	var pos := Vector2(rng.randf_range(spawn_margin,level_width-spawn_margin), rng.randf_range(spawn_margin,level_height-spawn_margin))
	pos=nav.get_closest_point(pos)
	if(pos.distance_to(global.player_node.global_position)<player_spawn_distance):
		return get_random_pos()
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if(pos.distance_to(enemy.global_position)< enemy_spawn_distance):
			return get_random_pos()
	return pos

func spawn_enemy(pos:Vector2):
	var r=rng.randf_range(0.0,1.0)
	var enemy
	if r<0.1:
		enemy=global.big_snowman.instance()
	else :
		enemy=global.small_snowman.instance()
	global.ysort_node.add_child(enemy)
	enemy.global_position=pos

func spawn_obstacles():
	var array=PoolVector2Array()
	var i:=0
	while(i<num_obstacles_to_spawn):
		var valid:=true
		var pos=Vector2(rng.randf_range(spawn_margin,level_width-spawn_margin), rng.randf_range(spawn_margin,level_height-spawn_margin))
		for v in array :
			if(pos.distance_to(v)<distance_between_obstacles):
				valid=false
				break
		if valid:
			i+=1
			array.append(pos)
			var r =rng.randf_range(0.0,1.0)
			var obstacle
			if r<0.1 :
				obstacle=global.sugar.instance()
			elif r<0.4 :
				obstacle=global.tree.instance()
			elif r <0.8 :
				obstacle=global.snow_tree.instance()
			else :
				obstacle=global.rock.instance()
			global.ysort_node.add_child(obstacle)
			obstacle.global_position=pos


func spawn_decors():
	var tilemap:TileMap=get_node("navigation/ground_tilemap")
	tilemap.clear()
	for d in range(30):
			var i=rng.randi_range(0,level_width/16) 
			var j=rng.randi_range(0,level_height/16) 
			while(tilemap.get_cell(i,j)!=-1) :
				i=rng.randi_range(0,level_width/16) 
				j=rng.randi_range(0,level_height/16)
			var r=rng.randf_range(0.0,1.0)
			var id:int
			if r <0.15 :
				id=7
			elif r <0.3 :
				id=2
			elif r <0.45 :
				id=3
			elif r <0.6 :
				id=4
			elif r <0.75 :
				id=5
			else :
				id=6
			tilemap.set_cellv(Vector2(i,j),id)
			tilemap.update_dirty_quadrants()
