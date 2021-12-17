extends KinematicBody2D

export var start_healthpoints := 15
export var shoot_damages := 1
export var big_snowball_damages := 4
export var action_cooldown:=1.0

export var move_speed := 13
export var target_player_distance := 1.0
export var obstacle_avoidance := 5.0
export var move_distance := 30.0
export var move_cooldown := 0.8

export var snowballs_launched_by_move :int= 3
export var snowball_angle_diff_move := 15.0

export var min_player_distance_to_attack := 200.0
export var attack_cooldown := 5.0
export var snowballs_launched_by_attack_wave :int= 1
export var waves := 3
export var time_between_waves := 0.4
onready var move_timer:Timer=$move_timer
onready var wave_timer:Timer=$wave_timer
onready var attack_timer:Timer=$attack_timer
onready var action_timer:Timer=$action_timer
onready var animation_player:AnimationPlayer=$AnimationPlayer
onready var big_snowball_sprite:Sprite=$big_snowball_sprite
onready var health_bar:TextureProgress=$health_bar

var healthpoints:int

var desired_velocity:=Vector2.ZERO
var desired_direction:=Vector2.ZERO
var is_moving:=false
var moved_distance:=0.0
var can_move:=true
var can_attack:=true
var can_do_action:=false
var waves_to_launch:=0
var static_body_snowball_collision_layer:int

func _ready()->void:
	add_to_group("Enemies")
	healthpoints=start_healthpoints
	move_timer.connect("timeout", self, "on_end_move_cd")
	move_timer.set_wait_time(move_cooldown)
	attack_timer.connect("timeout", self, "on_end_attack_cd")
	attack_timer.set_wait_time(attack_cooldown)
	action_timer.connect("timeout", self, "on_end_action_cd")
	action_timer.set_wait_time(action_cooldown)
	wave_timer.connect("timeout", self, "launch_snowball_wave")
	wave_timer.set_wait_time(time_between_waves)
	health_bar.max_value=start_healthpoints
	health_bar.value=start_healthpoints
	health_bar.visible=false

func _physics_process(delta:float)->void:
	if is_moving :
		moved_distance+=desired_velocity.length()*delta
		move_and_slide(desired_velocity)		
		if moved_distance >= move_distance :
			end_move()

func _process(delta:float)->void:
	if can_do_action :
		if can_attack :
			var player_distance:=global_position.distance_to(global.player_node.global_position)
			if player_distance <= min_player_distance_to_attack :
				begin_attack()
				return
		if can_move :
			desired_direction=get_desired_direction()
			if desired_direction!=Vector2.ZERO :
				begin_move()
				return

func begin_attack()->void:
	animation_player.play("attack")
	can_do_action=false
	can_attack=false	
	waves_to_launch=waves

func launch_attack()->void:
	wave_timer.start()

func launch_snowball_wave()->void:
	var player_direction =big_snowball_sprite.global_position.direction_to(global.player_node.global_position)
	var angle:=0.0
	for i in range(snowballs_launched_by_attack_wave):
		var snowball:BigSnowballEnemy=global.big_snowball_enemy.instance()
		global.ysort_node.add_child(snowball)
		snowball.global_position=big_snowball_sprite.global_position
		var shoot_direction=player_direction.rotated(angle)
		snowball.launch(shoot_direction.normalized() * global.shoot_speed, big_snowball_damages)
		angle+=360.0/snowballs_launched_by_attack_wave
	waves_to_launch-=1
	if(waves_to_launch>0):
		wave_timer.start()
	else :
		end_attack()

func end_attack()->void:
	action_timer.start()
	attack_timer.start()

func on_end_attack_cd()->void:
	can_attack=true

func begin_move()->void:
	can_do_action=false
	desired_velocity = desired_direction.normalized() * 10 * move_speed
	is_moving=true
	can_move=false
	animation_player.play("move")
	moved_distance=0.0

func end_move()->void:
	animation_player.play("idle")
	action_timer.start()	
	move_timer.start()
	is_moving=false
	var angle=snowball_angle_diff_move * (snowballs_launched_by_move / 2)
	for i in range(0,snowballs_launched_by_move) :
		var snowball:SmallSnowball=global.small_snowball_enemy.instance()
		global.ysort_node.add_child(snowball)
		snowball.global_position=global_position
		var shoot_direction=desired_direction.rotated(deg2rad(angle))
		snowball.launch(shoot_direction.normalized() * global.shoot_speed, shoot_damages)
		angle-=snowball_angle_diff_move

func on_end_move_cd()->void:
	can_move=true

func on_end_action_cd()->void:
	can_do_action=true

func get_desired_direction()->Vector2 :
	var new_desired_direction:=Vector2.ZERO	
	var player_direction:=global_position.direction_to(global.player_node.global_position)
	var player_distance:=global_position.distance_to(global.player_node.global_position)
	var player_spring_strength:=player_distance-target_player_distance
	new_desired_direction+=player_direction * player_spring_strength
	
	for obstacle in get_tree().get_nodes_in_group("ObstaclesPolygons"):
		var obstacle_direction:=global_position.direction_to(obstacle.global_position)
		var obstacle_distance:=global_position.distance_to(obstacle.global_position)
		var obstacle_spring_strength:=2*player_spring_strength/(obstacle_distance/obstacle_avoidance)
		new_desired_direction-=obstacle_direction * obstacle_spring_strength 
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy==self:
			continue
		var enemy_direction:=global_position.direction_to(enemy.global_position)
		var enemy_distance:=global_position.distance_to(enemy.global_position)
		var enemy_spring_strength:=2*player_spring_strength/(enemy_distance/obstacle_avoidance)
		new_desired_direction-=enemy_direction * enemy_spring_strength
		
		
	if new_desired_direction.length() <10 :
		new_desired_direction=Vector2.ZERO
	return new_desired_direction

func take_damage(damage:int)->void:
	healthpoints-=damage
	health_bar.value=healthpoints
	health_bar.visible=true
	if healthpoints<=0 :
		var dead_fx=global.fx_big_snowman_dead.instance()
		global.ysort_node.add_child(dead_fx)
		dead_fx.global_position=global_position
		queue_free()
