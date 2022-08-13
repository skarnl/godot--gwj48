extends Node2D

onready var floor_manager = $Floor

func _ready():
	print("game")
	
	floor_manager.start()
