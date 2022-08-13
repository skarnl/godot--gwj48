extends Node2D

var TilePrefab = preload("res://entities/tile.tscn")

var TILE_WIDTH := 16
var TILE_HEIGHT := 40
var SCREEN_WIDTH_IN_TILES := 8

var current_tile_index := 0

var tileConfig = {
	
}

onready var tile_container = $TileContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initial_generation()


func _initial_generation() -> void:
	for i in range(SCREEN_WIDTH_IN_TILES + 4):
		generate_next()
		
		
# Generate the next part
func generate_next() -> void:
	var next_tile_index = _determine_tile_index()
	
	var t = TilePrefab.instance()
	t.set_frame(next_tile_index)
	t.position.x = tile_container.get_child_count() * TILE_WIDTH
	
	tile_container.add_child(t)
	
	# hide the gap-tile
	t.visible = next_tile_index != -1
	# TODO mark as "gap", for the height?
	
	current_tile_index += 1
	

func _determine_tile_index() -> int:
	var TEMP_fixed_tile_order = [
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 2, 0, 0
	]
	
	# TODO eventually make this a random selection based on the current_tile_index
	return TEMP_fixed_tile_order[current_tile_index]
