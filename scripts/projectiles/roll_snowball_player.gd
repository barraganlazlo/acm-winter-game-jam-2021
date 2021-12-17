extends KinematicBody2D

class_name RollSnowballPlayer

onready var area2d:Area2D =$Area2D
var launched:=false
var speed:float
var direction:Vector2
var damage:int

func _process(delta:float)->void:
	if not launched :
		return
	var velocity:= speed * direction.normalized() * 10 
	var collision=move_and_collide(velocity*delta)
	if collision!=null :
		position+=collision.remainder
		for body in area2d.get_overlapping_bodies() :
			if body.has_method("take_damage") :
				body.take_damage(damage)
		global.create_fx(global.fx_big_snow_hit,global_transform)
		queue_free()

func launch(global_pos:Vector2,global_sc:Vector2,global_rot:float,launch_direction:Vector2, launch_speed:float,launch_damage:float):
	direction=launch_direction
	speed=launch_speed
	launched=true
	global.ysort_node.add_child(self)
	global_position=global_pos
	global_scale=global_sc
	global_rotation=global_rot
	damage=launch_damage
