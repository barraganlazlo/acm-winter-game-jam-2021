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
		var fx=global.fx_snow_hit.instance()
		global.ysortNode.add_child(fx)
		fx.global_position=global_position
		queue_free()


func launch(init_velocity : Vector2, impact_damage : int)->void:
	damage = impact_damage
	velocity=init_velocity
	set_physics_process(true)
