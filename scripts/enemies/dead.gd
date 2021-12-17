extends Sprite

var time_to_disapear:=3.0

func _process(delta):
	if time_to_disapear<=0 :
		queue_free()
	else :
		time_to_disapear-=delta
