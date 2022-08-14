extends Node2D

onready var floor_manager = $Floor
onready var runner = $Runner

func _ready():
	print("game")
	
	floor_manager.start()
	floor_manager.connect("update_player_height", self, "_on_floor_moved")



func _on_floor_moved(offset: float) -> void:
	print("floor_offset %s" % offset)
	
	runner.position.y = 104 - offset
