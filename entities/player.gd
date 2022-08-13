
extends Sprite

func _ready():
	pass
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_left"):
			position.x -= 10
		elif event.is_action_pressed("ui_right"):
			position.x += 10
		elif event.is_action_pressed("ui_down"):
			position.y += 10
		elif event.is_action_pressed("ui_up"):
			position.y -= 10
