extends Node2D

func _ready():
	print("game")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("spatie")
