extends CanvasLayer

onready var game_over := $HUD/GameOver

func _ready() -> void:
	reset()


func show_game_over() -> void:
	game_over.show()
	
	
func reset() -> void:
	game_over.hide()
	# reset the points
