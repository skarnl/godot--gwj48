extends Node2D


onready var kid := $Kid
onready var mom := $Mother
onready var hand := $Hand

enum {
	IDLE,
	MOONING,
	STOP_MOONING,
	BUSTED,
	GAME_OVER
}

var mom_is_looking := false

var state = IDLE

func _ready() -> void:
	kid.connect("mooning_stopped", self, "_on_Kid_mooning_stopped")
	mom.connect("show_hand", self, "_on_show_hand")
	mom.connect("hide_hand", self, "_on_hide_hand")
	mom.connect("looking_started", self, "_on_Mother_looking_started")
	mom.connect("looking_stopped", self, "_on_Mother_looking_stopped")
	
	hand.hide()


func _on_show_hand() -> void:
	hand.show()
	
	
func _on_hide_hand() -> void:
	hand.hide()


func _input(event: InputEvent) -> void:
	match state:
		IDLE:
			if event.is_action_pressed("ui_accept") or (event is InputEventScreenTouch and event.is_pressed()):
				_update_state(MOONING)
				
				if mom_is_looking:
					yield(get_tree().create_timer(1.0), "timeout")
					
					_update_state(BUSTED)
		MOONING:
			if event.is_action_released("ui_accept") or (event is InputEventScreenTouch and not event.is_pressed()):
				
				
				_update_state(STOP_MOONING)
		

func _on_Kid_mooning_stopped() -> void:
	_update_state(IDLE)


func _on_Mother_looking_started() -> void:
	mom_is_looking = true
	
	if state == MOONING:
		print("BUSTED")
		_update_state(BUSTED)
		return
	elif state == STOP_MOONING:
		print("increase paranoia")
		# PARA increase
		mom.show_para()
	
	var para_level = 0;	
	if para_level > 0:
		mom.show_para()
	else:
		mom.show_smile()
	

func _on_Mother_looking_stopped() -> void:
	mom_is_looking = false
	

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
				mom.busted()
				
				yield(mom, "busted_sequence_ended")
				
				_update_state(GAME_OVER)
								
				
			GAME_OVER:
				print("GAME OVER")
				pass
				
