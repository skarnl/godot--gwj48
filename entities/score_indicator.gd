extends Node2D

onready var label: Label = $Label
onready var player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hide()


func show_value(val: int) -> void:
	label.text = str(val)
	
	show()
	
	player.play('fade')
	
	yield(player, "animation_finished")
	
	queue_free()
