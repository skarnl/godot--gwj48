extends Node2D


onready var kid := $Kid
onready var mom := $Mother


enum {
	IDLE,
	MOONING,
	STOP_MOONING,
	BUSTED,
	GAME_OVER
}

var state = IDLE


func _ready() -> void:
	kid.connect("mooning_stopped", self, "_on_Kid_mooning_stopped")
	mom.connect("looking_started", self, "_on_Mother_looking")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and state == IDLE:
		_update_state(MOONING)
	elif event.is_action_released("ui_accept") and state == MOONING:
		_update_state(STOP_MOONING)
		

func _on_Kid_mooning_stopped() -> void:
	print("stopped mooning, we are safe")
	_update_state(IDLE)


func _on_Mother_looking() -> void:
	if state == MOONING:
		print("BUSTED")
		_update_state(BUSTED)
	elif state == STOP_MOONING:
		print("increase paranoia")
		# PARA increase
		mom.show_para()
	
	var para_level = 0;	
	if para_level > 0:
		mom.show_para()
	else:
		mom.show_smile()
	


func _update_state(new_state: int) -> void:
	if state != GAME_OVER:
		state = new_state
		
		match state:
			IDLE:
				kid.idle()
			
			STOP_MOONING:
				kid.stop_mooning()
				
			MOONING:
				kid.start_mooning()
				
			BUSTED:
				kid.busted()
				
			GAME_OVER:
				print("GAME OVER")
				pass
				
