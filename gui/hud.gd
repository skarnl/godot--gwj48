extends CanvasLayer

onready var game_over := $HUD/GameOver
onready var score := $HUD/AnimatedScore

func _ready() -> void:
	EventBus.connect("score_updated", self, "_on_score_updated")
	
	reset()


func _on_score_updated(increase_value: int) -> void:
	score.update_amount(increase_value)
	

func show_game_over() -> void:
	game_over.show()
	
	
func reset() -> void:
	game_over.hide()
	score.reset()
