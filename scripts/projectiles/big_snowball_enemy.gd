extends KinematicBody2D

class_name BigSnowballEnemy

var velocity := Vector2(0,0)
var damage:int= 1
var shoot_damages:int= 1

var collided:=false
var snowballs_launched_on_explode:=9


func _ready()->void:
	set_physics_process(false)

func _physics_process(delta:float)->void:
	var collision=move_and_collide(velocity * 10 * delta)
	if collision!=null :
		collided=true
		position+=collision.remainder
		var body = collision.collider
		if body.is_in_group("Player"):
			body.take_damage(damage)
		explode()

func take_damage(damages:int)->void:
	explode()

func launch(init_velocity : Vector2, impact_damage : int)->void:
	damage = impact_damage
	velocity=init_velocity
	set_physics_process(true)

func explode():
	global.create_fx(global.fx_snow_hit,global_transform)
	var start_direction =Vector2.RIGHT
	var angle:=0.0
	for i in range(snowballs_launched_on_explode):
		var snowball:SmallSnowball=global.small_snowball_enemy.instance()
		global.ysort_node.add_child(snowball)
		snowball.global_position=global_position
		var shoot_direction=start_direction.rotated(angle)
		snowball.launch(shoot_direction.normalized() * global.shoot_speed, shoot_damages)
		angle+=360.0/snowballs_launched_on_explode	
	queue_free()
