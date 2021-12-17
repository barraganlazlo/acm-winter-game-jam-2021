extends HBoxContainer

class_name HealthBar

func update_health_bar(health_left:int,full_health:int):
	var full_hearts= health_left/4
	var left_heart = health_left%4
	var empty_hearts = full_health/4 - (full_hearts)
	if left_heart!=0 :
		empty_hearts-=1
	for heart in get_children() :
		if heart.is_in_group("heart_full") :
			heart.visible=full_hearts>0
			full_hearts-=1
		elif heart.is_in_group("heart_empty") :
			heart.visible=empty_hearts>0
			empty_hearts-=1
		elif heart.is_in_group("heart_quarter"):
			heart.visible=left_heart==1
		elif heart.is_in_group("heart_half"):
			heart.visible=left_heart==2
		elif heart.is_in_group("heart_3quarter"):
			heart.visible=left_heart==3
