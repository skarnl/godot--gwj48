extends Node2D

enum STATES {
	IDLE,
	MOONING,
	BUSTED
}

var state = STATES.IDLE

onready var idle = $"Kid--idle"
onready var mooning = $"Kid--mooning"
onready var busted = $"Kid--busted"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_state()
	
	
func _hide_all() -> void:
	idle.hide()
	mooning.hide()
	busted.hide()

	
func update_state() -> void:
	_hide_all()
	
	match state:
		STATES.IDLE:
			idle.show()
			
		STATES.MOONING:
			mooning.show()
			
		STATES.BUSTED:
			busted.show()
