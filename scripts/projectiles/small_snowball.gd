extends KinematicBody2D

class_name SmallSnowball

var velocity := Vector2(0,0)
var damage:int= 1
var collided:=false

func _ready()->void:
	set_physics_process(false)

func _physics_process(delta:float)->void:
	var collision=move_and_collide(velocity * 10 * delta)
	if collision!=null :
		collided=true
		position+=collision.remainder
		var body = collision.collider
		if body.is_in_group("Player") or body.is_in_group("Enemies"):
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
	queue_free()
