extends Node2D

signal update_looking_time
signal looking_started


var STATE_TRANSLATIONS = ['idle', 'looking', 'shocked', 'angry', 'turning', 'smile', 'para']


enum {
	IDLE,
	LOOKING,
	SHOCKED,
	ANGRY,
	TURNING,
	SMILE,
	PARA
}

onready var vis := $VisualContainer

var state = IDLE

onready var timer = $Timer

var paranoia := 0.0

var rdm := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rdm.randomize()
	
	update_state(IDLE)
	
	timer.connect("timeout", self, "_on_timer_timeout")
	
	
	
func update_state(new_state: int) -> void:
	if state == ANGRY:
		return
		
	vis.show_state(STATE_TRANSLATIONS[state])


func idle() -> void:
	update_state(IDLE)
	
	# dit moet gebaseerd zijn op hoe paranoid ze is
	timer.wait_time = rdm.randi_range(10, 20)


func busted() -> void:
	update_state(SHOCKED)
	
	# wait 1 sec
	yield(get_tree().create_timer(1.0), "timeout")
	
	update_state(ANGRY)
	
	
func start_looking() -> void:
	pass


func _on_timer_timeout() -> void:
	timer.stop()
	
	start_looking()


func show_smile() -> void:
	vis.show_state("smile")


func show_para() -> void:
	vis.show_state("para1")
