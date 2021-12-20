extends Sprite

func on_end_anim()->void:
	queue_free()

func _ready():
	if(global_position.distance_to(global.player_node.global_position)<2000):
		 $AudioStreamPlayer2D.play()
