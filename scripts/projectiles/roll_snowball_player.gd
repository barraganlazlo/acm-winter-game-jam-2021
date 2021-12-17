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
		if collision.collider.has_method("take_damage"):
			collision.collider.take_damage(damage)
		for body in area2d.get_overlapping_bodies() :
			if body.has_method("take_damage") and body!=collision.collider:
				body.take_damage(damage)
		global.create_fx(global.fx_big_snow_hit,global_transform)
		queue_free()

func launch(global_tr:Transform,launch_direction:Vector2, launch_time:float, launch_speed:float,launch_damage:float):
	direction=launch_direction
	speed=launch_speed
	launched=true
	global.ysort_node.add_child(self)
	global_transform=global_tr
	damage=launch_damage
