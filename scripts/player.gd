extends KinematicBody2D

class_name Player

#onready var animation_tree : AnimationTree = $AnimationTree
onready var levelNode : Node= get_parent()
export var move_speed:int=12
export var shoot_speed:int=24
export var shoot_damages:int=1

var moving:=false
var dodging:=false
var rolling:=false

#Input
var move_direction:=Vector2.ZERO
var dodge_input:=false
var roll_input:=false
var shoot_input:=false


func _physics_process(delta:float)->void:
	var move_direction := Vector2.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var move_velocity:=move_direction.normalized() * move_speed * 10
	move_and_slide(move_velocity)
	
	
	var shoot_input := Input.is_action_just_pressed("shoot")
	if shoot_input:
		var shoot_direction = Vector2.ZERO
		if Input.get_connected_joypads().size()>0 :
			shoot_direction.x = Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left")
			shoot_direction.y = Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
		else :
			shoot_direction=get_global_mouse_position() - global_position
		if shoot_direction==Vector2.ZERO:
			shoot_direction=move_direction
		var small_snowball=global.small_snowball_player.instance()
		levelNode.add_child(small_snowball)
		small_snowball.global_position=global_position
		print("shoot_speed :", shoot_speed)
		small_snowball.launch(shoot_direction.normalized() * shoot_speed, shoot_damages)
	
	var dodge_input:=Input.is_action_just_pressed("dodge")
	if dodge_input :
		dodging=true
