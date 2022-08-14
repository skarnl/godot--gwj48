extends Node2D

enum STATES {
	IDLE,
	LOOKING,
	SHOCKED,
	ANGRY
}

var state = STATES.IDLE

onready var idle = $"Mother--idle"
onready var looking = $"Mother--looking"
onready var shocked = $"Mother--shocked"
onready var angry = $"Mother--angry"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_state()
	
	
func _hide_all() -> void:
	idle.hide()
	looking.hide()
	shocked.hide()
	angry.hide()

	
func update_state() -> void:
	_hide_all()
	
	match state:
		STATES.IDLE:
			idle.show()
			
		STATES.LOOKING:
			looking.show()
			
		STATES.SHOCKED:
			shocked.show()
			
		STATES.ANGRY:
			angry.show()
