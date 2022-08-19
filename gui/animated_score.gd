extends Label


var score_amount = 0

func _ready() -> void:
	reset()


func update_amount(new_value) -> void:
	score_amount = score_amount + new_value
	
	text = str(score_amount)
	


func reset() -> void:
	score_amount = 0
	update_amount(0)
