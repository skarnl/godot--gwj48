extends Node2D

export var speed := 20

onready var tile_manager = $TileManager;

var TILE_WIDTH := 160;
var START_X_POS := 80;

func _process(delta: float) -> void:
	tile_manager.position.x -= delta * speed;
