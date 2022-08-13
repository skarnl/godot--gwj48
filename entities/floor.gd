extends Node2D

export var speed := 10

onready var tile1 = $Tile1;
onready var tile2 = $Tile2;

var TILE_WIDTH := 160;
var START_X_POS := 80;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if (tile1.position.x < START_X_POS - TILE_WIDTH / 2):
		tile1.position.x = tile2.position.x + TILE_WIDTH / 2;
	if (tile2.position.x < START_X_POS - TILE_WIDTH / 2):
		tile2.position.x = tile1.position.x + TILE_WIDTH / 2;
		
	tile1.position.x -= delta * speed;
	tile2.position.x -= delta * speed;
