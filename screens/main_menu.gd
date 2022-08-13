extends Control

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.grab_focus()
	show()



func _on_Button_pressed():
	Game.start_game()
	
	hide()
