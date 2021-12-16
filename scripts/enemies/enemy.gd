extends KinematicBody2D

export var start_hitpoints := 10
export var move_speed := 13
export var target_player_distance := 100.0
export var move_distance := 30.0
export var move_cooldown := 0.8


onready var move_timer:Timer=$move_timer
onready var animation_player:AnimationPlayer=$AnimationPlayer
onready var animation_tree:AnimationTree=$AnimationTree
var animation_statemachine:AnimationNodeStateMachinePlayback

var hitpoints:int

var desired_velocity:=Vector2.ZERO
var is_moving:=false
var moved_distance:=0.0
var can_move:=true

func _ready():
	add_to_group("Enemies")
	hitpoints=start_hitpoints
	animation_statemachine=animation_tree["parameters/playback"]
	move_timer.connect("timeout", self, "on_end_move_cd")

func _physics_process(delta:float)->void:
	if is_moving :
		move_and_slide(desired_velocity)
		moved_distance+=desired_velocity.length()*delta
		if moved_distance >= move_distance :
			animation_player.play("idle")
			move_timer.set_wait_time(move_cooldown)
			move_timer.start()
			is_moving=false
	else :
		if can_move :
			var desired_direction:=get_desired_direction()
			if desired_direction!=Vector2.ZERO :
				desired_velocity = desired_direction.normalized() * 10 * move_speed
				is_moving=true
				can_move=false
				animation_player.play("move")
				moved_distance=0.0
	

func on_end_move_cd():
	can_move=true

func get_desired_direction()->Vector2 :
	var desired_direction:=Vector2.ZERO
	var player_direction:=global_position.direction_to(global.playerNode.global_position)
	var player_distance:=global_position.distance_to(global.playerNode.global_position)
	var player_spring_strength:=player_distance-target_player_distance
	if(player_spring_strength<0):
		player_spring_strength=player_spring_strength*-player_spring_strength
	desired_direction+=player_direction * player_spring_strength
	
	for obstacle in get_tree().get_nodes_in_group("ObstaclesPolygons"):
		var obstacle_direction:=global_position.direction_to(obstacle.global_position)
		var obstacle_distance:=global_position.distance_to(obstacle.global_position)
		var obstacle_spring_strength:=1.0/(1.0 + obstacle_distance * obstacle_distance * obstacle_distance)
		desired_direction-=obstacle_direction * obstacle_spring_strength
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy==self:
			continue
		var enemy_direction:=global_position.direction_to(enemy.global_position)
		var enemy_distance:=global_position.distance_to(enemy.global_position)
		var enemy_spring_strength:=1.0/(1.0 + enemy_distance * enemy_distance * enemy_distance)
		desired_direction-=enemy_direction * enemy_spring_strength
		
	if desired_direction.length() <50 :
		desired_direction=Vector2.ZERO
	return desired_direction

func take_damage(damage:int)->void:
	hitpoints-=damage
	if hitpoints<0 :
		queue_free()
