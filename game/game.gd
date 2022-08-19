extends Node2D


onready var kid := $Kid
onready var mom := $Mother
onready var hand := $Hand
onready var hud := $HUD
onready var score := $ScoreManager


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
	kid.connect("mooning_started", self, "_on_Kid_mooning_started")
	kid.connect("mooning_stopped", self, "_on_Kid_mooning_stopped")
	kid.connect("mooning_stop__anim_finished", self, "_on_Kid_mooning_stop__anim_finished")
	
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
					_update_state(BUSTED)
					
		MOONING:
			if event.is_action_released("ui_accept") or (event is InputEventScreenTouch and not event.is_pressed()):
				_update_state(STOP_MOONING)
		
		GAME_OVER:
			if event.is_pressed():
				_restart()

func _on_Kid_mooning_started() -> void:
	if state == MOONING:
		score.start_counting()


func _on_Kid_mooning_stopped() -> void:
	score.stop_counting()
	

# animation is finished, so now we can be idle
func _on_Kid_mooning_stop__anim_finished() -> void:
	_update_state(IDLE)
	


func _on_Mother_looking_started() -> void:
	mom_is_looking = true
	
	if state == MOONING:
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
	# guard
	if state == GAME_OVER and new_state != IDLE:
		return
		
	state = new_state
	
	match state:
		IDLE:
			kid.idle()
		
		STOP_MOONING:
			kid.stop_mooning()
			
		MOONING:
			kid.start_mooning()
			
		BUSTED:
			score.stop_counting()
			kid.busted()
			mom.busted()
			
			yield(mom, "busted_sequence_ended")
			
			yield(get_tree().create_timer(2.0), "timeout")
			
			_update_state(GAME_OVER)
			
		GAME_OVER:
			hud.show_game_over()
			# show points
			
			# timeout before we can proceed?
			

func _restart() -> void:
#	reset points
#   reset paranoia
	kid.reset()
	mom.reset()
	hud.reset()
	hand.hide()
	score.reset()
	
	mom_is_looking = false
	
	_update_state(IDLE)
