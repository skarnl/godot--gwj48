extends Node2D

signal update_score

onready var label: Label = $LabelContainer/Label
onready var player: AnimationPlayer = $LabelContainer/AnimationPlayer

var value: int

func _ready() -> void:
	hide()


func show_value(val: int) -> void:
	yield(self, "ready")
	
	value = val
	
	label.set_text("+%d" % val)
	
	show()
	
	player.play('fade')
	
	yield(player, "animation_finished")
	
	queue_free()


func t_on_update_score() -> void:
	emit_signal("update_score")	
