extends CanvasLayer


func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton) and event.pressed:
		global.retry()
		queue_free()
	
