extends Node2D

signal sequence_ended

export var prefix := ""

var abort_sequence := false


func _ready() -> void:
	show_state("idle")


func hide_all() -> void:
	for c in get_children():
		c.hide()
		

func show_state(state_name: String) -> void:
	abort_sequence = true
	_show_state(state_name)
	
	
func _show_state(state_name: String) -> void:
	var node_name = prefix + "--" + state_name
	
	assert(has_node(node_name), "no node found with name: " + node_name) 
	
	print("show_state [%s]" % node_name)
	
	hide_all()
	
	get_node(node_name).show()


func show_sequence(states: Array) -> void:
	abort_sequence = false
	
	for state in states:
		if abort_sequence:
			break
		
		_show_state(state[0])
		
		if state.size() > 1:
			yield(get_tree().create_timer(state[1]), "timeout")
			
		if state.size() > 2:
			emit_signal(state[2])

	emit_signal("sequence_ended")
