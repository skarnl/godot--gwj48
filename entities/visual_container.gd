extends Node2D


export var prefix := ""


func _ready() -> void:
	show_state("idle")


func hide_all() -> void:
	for c in get_children():
		c.hide()
		

func show_state(state_name: String) -> void:
	var node_name = prefix + "--" + state_name
	
	assert(has_node(node_name), "no node found with name: " + node_name) 
		
	hide_all()
	
	get_node(node_name).show()
