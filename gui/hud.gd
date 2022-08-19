extends CanvasLayer

onready var game_over := $HUD/GameOver
onready var game_over_score := $HUD/GameOver/Score
onready var score := $HUD/AnimatedScore

var total_score_copy := 0

func _ready() -> void:
	EventBus.connect("score_updated", self, "_on_score_updated")
	
	reset()


func _on_score_updated(total_value: int) -> void:
	total_score_copy = total_value
	score.update_amount(total_value)
	

func show_game_over() -> void:
	game_over_score.set_text(str(total_score_copy))
	game_over.show()
	
	
func reset() -> void:
	game_over.hide()
	game_over_score.set_text("")
	score.reset()
