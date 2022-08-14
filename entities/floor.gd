extends Node2D

signal update_player_height

var TilePrefab = preload("res://entities/tile.tscn")

var TILE_WIDTH := 16
var TILE_HEIGHT := 40
var SCREEN_WIDTH_IN_TILES := 8

export var speed := 20.0
export var increase_rate := 1.0

var last_update_time := 0.0

var current_tile_index := 0

var center_tile;

var tileConfig = {
	
}

onready var tile_container = $TileContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initial_generation()

	set_process(false)
	

func start() -> void:
	set_process(true)


func _process(delta: float) -> void:
	tile_container.position.x -= delta * speed
	
	#speed += increase_rate / 100.0
	
	last_update_time += delta
	
	if last_update_time > 0.5:
		last_update_time = 0
		emit_signal("update_player_height")


func _initial_generation() -> void:
	for _i in range(SCREEN_WIDTH_IN_TILES * 2):
		_generate_next()
		
		
# Generate the next part
func _generate_next() -> void:
	var next_tile_index = _determine_tile_index()
	
	var t = TilePrefab.instance()
	t.set_frame(next_tile_index) if next_tile_index != -1 else null
	t.position.x = current_tile_index * TILE_WIDTH
	t.connect("tile_removed", self, "_on_tile_removed")
	
	tile_container.add_child(t)
	
	# hide the gap-tile
	t.visible = next_tile_index != -1
	# TODO mark as "gap", for the height?
	
	current_tile_index += 1
	
	
func _on_tile_removed() -> void:
	_generate_next()


func _determine_tile_index() -> int:
	var TEMP_fixed_tile_order = [
		0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0
	]
	
	# TODO eventually make this a random selection based on the current_tile_index
	return TEMP_fixed_tile_order[current_tile_index % TEMP_fixed_tile_order.size()]


func get_offset(xpos: float) -> float:
	var center_tile = tile_container.get_child(5)
	
	print(center_tile)
	
	print(center_tile.frame)
	
	match center_tile.frame:
		[0, 1, 2]:
			return 10.0
		
		[4, 6, 7]:
			return 8.0
			
		[3, 5, 8, 9]:
			# TODO fix slope
			return 4.0

	return 20.0
