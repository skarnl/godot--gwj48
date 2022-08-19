extends Label


func _ready() -> void:
	reset()


func update_amount(new_value) -> void:
	text = str(new_value)
	


func reset() -> void:
	update_amount(0)
