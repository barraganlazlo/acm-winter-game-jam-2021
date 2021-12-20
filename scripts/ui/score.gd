extends Label

export var propertie_name:String

func _process(delta):
	if global.level_node!=null and global.player_node!=null and not global.player_node.dead :
		text=String(global.level_node.get(propertie_name))
