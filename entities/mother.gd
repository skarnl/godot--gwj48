extends Node2D

signal update_looking_time
signal looking_started
signal looking_stopped
signal busted_sequence_ended
signal show_hand
signal hide_hand


const TURNING_TIMEOUT1 := 0.2
const TURNING_TIMEOUT2 := 0.1
const TURNING_BACK_TIMEOUT1 := 0.1
const TURNING_BACK_TIMEOUT2 := 0.07
const SHOCKED_TIMEOUT := 1.3

const STATE_TRANSLATIONS = ['idle', 'looking', 'shocked', 'angry', 'turning', 'smile', 'para']
const LOOK_CHANCE_INITIAL_PERCENTAGE = 100
const LOOK_CHANCE_BASE_PERCENTAGE = 48
const LOOK_CHANCE_INCREASE_PERCENTAGE = 9

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

onready var timer := $Timer

var look_chance_percentage := LOOK_CHANCE_INITIAL_PERCENTAGE

var paranoia := 0.0

var rdm := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rdm.randomize()
	
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_on_timer_timeout")
	
	idle()
	
	
func update_state(new_state: int) -> void:
	if state == ANGRY:
		return
		
	state = new_state
		
	vis.show_state(STATE_TRANSLATIONS[state])


func idle() -> void:
	update_state(IDLE)
	
	var wait_time = rdm.randf_range(2.7, 5.5)
	
	print("wait time = %f" % wait_time)
	
	# TODO dit moet gebaseerd zijn op hoe paranoid ze is
	timer.start(wait_time)


func busted() -> void:
	timer.stop()
	
	vis.show_sequence([
		["shocked", SHOCKED_TIMEOUT],
		["angry"]
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("busted_sequence_ended")


func start_looking() -> void:
	#reset looking_chance
	look_chance_percentage = LOOK_CHANCE_BASE_PERCENTAGE
	
	vis.show_sequence([
		["turning1", TURNING_TIMEOUT1]
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("show_hand")
	
	vis.show_sequence([
		["turning1", TURNING_TIMEOUT2],
		["looking", 0.3]
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("looking_started")
	
func stop_looking() -> void:
	vis.show_sequence([
		["turning1", TURNING_BACK_TIMEOUT1],
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("hide_hand")
	emit_signal("looking_stopped")
	
	vis.show_sequence([
		["turning1", TURNING_BACK_TIMEOUT2],
		["idle"]
	])
	
	yield(vis, "sequence_ended")
	
	idle()


func _on_timer_timeout() -> void:
	match state:
		IDLE:
			_wiggle_or_look()
			
		SMILE:
			stop_looking()


func _wiggle_or_look() -> void:
	var chance = rdm.randi_range(0, 100)
	
	print("CHANGE = %s" % chance)
	print("LOOK CHANGE = %s" % look_chance_percentage)
	
	if not chance <= look_chance_percentage:
		# increase look-chance
		look_chance_percentage = look_chance_percentage + LOOK_CHANCE_INCREASE_PERCENTAGE
		
		_play_random_wiggle_anim()
	else:
		start_looking()


func show_smile() -> void:
	update_state(SMILE)
	
	timer.start(rdm.randf_range(1.7, 2.3))
	

func show_para() -> void:
	vis.show_state("para1")


func _play_random_wiggle_anim() -> void:
	# TODO add more animations
	vis.show_sequence([
		["turning1", TURNING_TIMEOUT1]
	])
	
	yield(vis, "sequence_ended")

	idle()


func reset() -> void:
	look_chance_percentage = LOOK_CHANCE_INITIAL_PERCENTAGE
	timer.stop()
	rdm.randomize()
	
	idle()
