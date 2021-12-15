extends KinematicBody2D

export var start_hitpoints := 10
export var target_player_distance := 100.0
onready var line2d:Line2D=$Line2D

var hitpoints:int

func _ready():
	add_to_group("Enemies")
	hitpoints=start_hitpoints

func _physics_process(delta:float)->void:
	var desired_direction:=Vector2.ZERO
#	var path:=global.navigationNode.get_nav_path(global_position,global.playerNode.global_position)
	var player_direction:=global_position.direction_to(global.playerNode.global_position)
	var player_distance:=global_position.distance_to(global.playerNode.global_position)

	var player_spring_strength:=player_distance-target_player_distance
	desired_direction+=player_direction * player_spring_strength
	
	for obstacle in Obstacles
	
func take_damage(damage:int)->void:
	hitpoints-=damage
	if hitpoints<0 :
		queue_free()
