extends KinematicBody2D

class_name Player

onready var roll_snowball_pos : Node2D = $Sprite/roll_snowball_pos
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite
onready var snowball_starting_pos : Node2D= $Sprite/snowball_starting_pos

const roll_snowball_scene=preload("res://scenes/projectiles/roll_snowball_player.tscn")

export var start_health:=24

export var move_speed:=10.0

export var shoot_speed:=32.0
export var shoot_damages:=1
export var shoot_cooldown:=0.4

export var dodge_cooldown:=1.0
export var dodge_invincible_time:=0.6
export var dodge_speed:=15.0

export var roll_max_time:=3.0

var roll_min_speed:=move_speed * 0.7

var invincible:=false
var moving:=false
var shooting:=false
var dodging:=false
var rolling:=false
var dodge_invincible:=false
var last_move_direction:=Vector2.RIGHT
var roll_direction:=Vector2.RIGHT
var shoot_direction:=Vector2.RIGHT
var dodge_direction:=Vector2.RIGHT
var shoot_timer:=0.0
var dodge_timer:=0.0
var roll_max_timer:=0.0
var dodge_invincible_timer:=0.0
var start_collision_layer:int
var face_direction:Vector2
var current_health:int

var dead:=false
var roll_snowball:RollSnowballPlayer
var roll_snowball_min_damage:=1
var roll_snowball_max_damage:=5
var roll_snowball_min_speed:=8.0
var roll_snowball_max_speed:=32.0
var roll_snowball_min_time:=0.5
var roll_snowball_max_time:=5.0
var roll_snowball_max_size:=1.0
var roll_snowball_min_size:=0.2
#Input
var move_direction:=Vector2.ZERO

func _ready()->void:
	add_to_group("Player")
	global.player_node=self
	start_collision_layer=collision_layer
	current_health=start_health
	global.health_bar_node.update_health_bar(current_health,start_health)

func _physics_process(delta:float)->void:
	if dead :
		return
	if Input.is_action_just_pressed("invincible_cheat_code"):
		invincible= !invincible
	#timer
	if shoot_timer > 0 :
		shoot_timer-=delta
	if dodge_timer > 0 :
		dodge_timer-=delta
	if roll_timer >0 :
		roll_timer-=delta
	if roll_max_timer >0 :
		roll_max_timer-=delta
		if roll_max_timer<0 :
			roll_max_timer=0
	if dodge_invincible_timer >0 :
		dodge_invincible_timer-=delta
		
	if dodge_invincible and dodge_invincible_timer <= 0 :
		collision_layer=start_collision_layer
		dodge_invincible=false
	
	if dodging :
		var dodge_velocity:=dodge_direction.normalized() * dodge_speed * 10
		move_and_slide(dodge_velocity)
		face_direction=dodge_direction
	elif rolling:
		var move_direction := Vector2.ZERO
		if Input.get_connected_joypads().size()>0 :
			move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			move_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		else :
			move_direction = (get_global_mouse_position() - global_position)
			if move_direction.length()<10:
				move_direction=roll_direction
		if move_direction!=Vector2.ZERO :
			roll_direction=move_direction
		face_direction=roll_direction
		var roll_speed :float= move_speed
		var roll_velocity:=roll_direction.normalized() * roll_speed * 10.0
		move_and_slide(roll_velocity)
		var current_size= lerp(roll_snowball_min_size,roll_snowball_max_size,1-(roll_max_timer/roll_max_time))
		roll_snowball.scale=Vector2(current_size,current_size)
		var roll_stop_input:= !Input.is_action_pressed("roll")
		if roll_stop_input or roll_max_timer <=0:
			rolling=false
			var roll_damages:int=lerp(roll_snowball_min_damage,roll_snowball_max_damage,1-(roll_max_timer/roll_max_time))
			var snowball_transform=roll_snowball.global_transform
			roll_snowball_pos.remove_child(roll_snowball)
			var roll_snowball_speed=lerp(roll_snowball_min_speed,roll_snowball_max_speed,1-(roll_max_timer/roll_max_time))
			var roll_snowball_time=lerp(roll_snowball_min_time,roll_snowball_max_time,1-(roll_max_timer/roll_max_time))
			roll_snowball.launch(snowball_transform,roll_direction,roll_snowball_time,roll_snowball_speed,roll_damages)
			
	else :
		regular_update(delta)
	
	#Animations
	sprite.scale.x= -1 if face_direction.x<0 else 1
	if rolling :
		if face_direction.y < 0 :
			animation_player.play("roll_back")
		else :
			animation_player.play("roll")
	elif dodging :
		if face_direction.y < 0 :
			animation_player.play("dodge_back")
		else :
			animation_player.play("dodge")
	elif shooting :
		if face_direction.y < 0 :
			animation_player.play("shoot_back")
		else :
			animation_player.play("shoot")
	elif moving :
		if face_direction.y < 0 :
			animation_player.play("move_back")
		else :
			animation_player.play("move")
	else :
		if face_direction.y < 0 :
			animation_player.play("idle_back")
		else :
			animation_player.play("idle")
	#end Animations

func regular_update(delta:float)->void:
	#MOVEMENT INPUT
	var move_direction := Vector2.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	moving=move_direction!=Vector2.ZERO
	var move_velocity:=move_direction.normalized() * move_speed * 10
	#END MOVEMENT
	
	#SHOOT INPUT
	
	if Input.get_connected_joypads().size()>0 :
		shoot_direction.x = Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left")
		shoot_direction.y = Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
	else :
		shoot_direction=(get_global_mouse_position() - global_position).normalized()
	#END_SHOOT_INPUT
	
	if shoot_direction==Vector2.ZERO:
		if move_direction!=Vector2.ZERO:
			shoot_direction=move_direction
			last_move_direction=move_direction
		else:
			shoot_direction=last_move_direction
	face_direction=shoot_direction
	
	#DODGE
	var dodge_input:=Input.is_action_just_pressed("dodge")
	if dodge_input and dodge_timer<=0 :
		dodging=true
		dodge_invincible=true
		dodge_invincible_timer=dodge_invincible_time
		dodge_direction = shoot_direction
		collision_layer=0
		return
	#END_DODGE
	
	
	#ROLL
	var roll_input:=Input.is_action_just_pressed("roll")
	if roll_input :
		rolling=true
		roll_max_timer=roll_max_time
		roll_direction=face_direction
		roll_snowball=roll_snowball_scene.instance()
		roll_snowball.scale=Vector2(roll_snowball_min_size,roll_snowball_min_size)
		roll_snowball_pos.add_child(roll_snowball)
		return
	#END ROLL
	
	#apply move
	move_and_slide(move_velocity)
	#apply shoot
	var shoot_input := Input.is_action_pressed("shoot")
	if shoot_input and shoot_timer <=0:
		shooting=true
	#END SHOOT


func launch_snowball()->void:
	shooting=false
	var small_snowball:SmallSnowball=global.small_snowball_player.instance()
	global.ysort_node.add_child(small_snowball)
	small_snowball.global_position=snowball_starting_pos.global_position
	small_snowball.launch(shoot_direction.normalized() * shoot_speed, shoot_damages)
	shoot_timer=shoot_cooldown


func take_damage(damages:int)->void:
	if invincible or dodge_invincible or dead:
		return
	current_health-=damages
	if current_health<0 :
		current_health=0
	global.health_bar_node.update_health_bar(current_health,start_health)
	if current_health==0 :
		death()
		
func death()->void:
	animation_player.play("dead")
	dead=true
	global.on_player_death()

func shoot_frame_1()->void:
	sprite.frame+=1

func _on_AnimationPlayer_animation_finished(anim_name:String)->void:
	if anim_name=="dodge"or  anim_name=="dodge_back" :
		dodging=false
		dodge_timer=dodge_cooldown
	elif anim_name=="shoot" or  anim_name=="shoot_back" :
		launch_snowball()

func _on_AnimationPlayer_animation_changed(old_name:String, new_name:String)->void:
	if (new_name=="shoot" or  new_name=="shoot_back") :
		if (old_name=="move" or  old_name=="move_back") :
			sprite.frame=(sprite.frame*3)+2
		else :
			if moving :
				sprite.frame=2
			else :
				sprite.frame=0
