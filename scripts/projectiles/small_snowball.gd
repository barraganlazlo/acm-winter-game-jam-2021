extends KinematicBody2D

var velocity := Vector2(0,0)
var damage: int = 1

func _ready()->void:
	set_physics_process(false)

func _physics_process(delta:float)->void:
	var collision=move_and_collide(velocity * 10 * delta)
	if collision!=null :
		var body = collision.collider
		if body.is_in_group("Player"):
			body.take_damage(damage)
		elif body.is_in_group("Enemy"):
			body.take_damage(damage)
		#play explode animation
		

func launch(init_velocity : Vector2, impact_damage : int)->void:
	damage = impact_damage
	velocity=init_velocity
	set_physics_process(true)
