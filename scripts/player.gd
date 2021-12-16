extends KinematicBody2D

class_name Player

#onready var animation_tree : AnimationTree = $AnimationTree
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite
onready var snowball_starting_pos : Node2D= $snowball_starting_pos



export var move_speed:int=10
export var shoot_speed:int=32
export var shoot_damages:int=1

var moving:=false
var dodging:=false
var rolling:=false
var last_move_direction:=Vector2.RIGHT

#Input
var move_direction:=Vector2.ZERO

func _ready():
	add_to_group("Player")

func _physics_process(_delta:float)->void:
	var move_direction := Vector2.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	moving=move_direction!=Vector2.ZERO
	var move_velocity:=move_direction.normalized() * move_speed * 10
	move_and_slide(move_velocity)
	if moving:
		animation_player.play("move")
	else:
		animation_player.play("idle")
	var shoot_input := Input.is_action_just_pressed("shoot")
	var shoot_direction = Vector2.ZERO
	if Input.get_connected_joypads().size()>0 :
		shoot_direction.x = Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left")
		shoot_direction.y = Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
	else :
		shoot_direction=get_global_mouse_position() - global_position
	if shoot_direction==Vector2.ZERO:
		if move_direction!=Vector2.ZERO:
			shoot_direction=move_direction
		else:
			shoot_direction=last_move_direction
	sprite.flip_h=shoot_direction.x<0
	
	if shoot_input:
		var small_snowball:SmallSnowball=global.small_snowball_player.instance()
		global.ysortNode.add_child(small_snowball)
		small_snowball.global_position=snowball_starting_pos.global_position
		small_snowball.launch(shoot_direction.normalized() * shoot_speed, shoot_damages)
	
	var dodge_input:=Input.is_action_just_pressed("dodge")
	if dodge_input :
		dodging=true


func take_damage(damages:int)->void:
	pass
