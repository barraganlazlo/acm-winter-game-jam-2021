extends AudioStreamPlayer2D

func _on_AudioStreamPlayer2D_finished():
	global.snowball_sound_per_5seconds-=1
	queue_free()
