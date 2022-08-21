extends Node2D

signal update_looking_time
signal looking_started
signal looking_stopped
signal busted_sequence_ended
signal show_hand
signal hide_hand


const TURNING_TIMEOUT1 := 0.28
const TURNING_TIMEOUT2 := 0.38
const PARA_LOOK_TIMEOUT := 0.2
const TURNING_BACK_TIMEOUT1 := 0.1
const TURNING_BACK_TIMEOUT2 := 0.07
const SHOCKED_TIMEOUT := 1.2
const PARA_SEQUENCE_TIMEOUT := 1.15
const PARA_DECREASE_RATIO := 0.56

const STATE_TRANSLATIONS = ['idle', 'looking', 'shocked', 'angry', 'turning', 'smile', 'para']
const LOOK_CHANCE_INITIAL_PERCENTAGE = 100
const LOOK_CHANCE_BASE_PERCENTAGE = 53
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

var para_level := 0.0

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
		
	if state != PARA:
		vis.show_state(STATE_TRANSLATIONS[state])


func idle(after_wiggle: bool = false) -> void:
	update_state(IDLE)
	
	var wait_time = rdm.randf_range(2.7, 5.5) - para_level * 0.5
	
	if after_wiggle:
		wait_time = wait_time - 1.5
	
	print("wait time = %f" % wait_time)
	
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
		["turning1", TURNING_TIMEOUT1 - para_level * 0.05]
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("show_hand")
	
	vis.show_sequence([
		["turning1", TURNING_TIMEOUT2 - para_level * 0.05]
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
	print("CURRENT PARA: %f" % para_level)
	
	match state:
		IDLE:
			_wiggle_or_look()
			
		SMILE, PARA:
			stop_looking()


func _wiggle_or_look() -> void:
	var chance = rdm.randi_range(0, 100)
	var para_adjustment = (para_level * 25)
	
	if not look_chance_percentage + para_adjustment >= chance:
		# increase look-chance
		look_chance_percentage = look_chance_percentage + (LOOK_CHANCE_INCREASE_PERCENTAGE * (para_level + 1))
		
		_play_random_wiggle_anim()
	else:
		start_looking()


func show_smile() -> void:
	print("show_smile - para_level %f" % para_level)
	
	var previous_frame = "looking"
	
	if round(para_level) > 0:
		previous_frame = "para" + str(clamp(round(para_level), 1, 3))
	
	vis.show_sequence([
		[previous_frame, PARA_LOOK_TIMEOUT],
	])
	
	yield(vis, "sequence_ended")
	
	if para_level > 1:
		para_level = para_level * PARA_DECREASE_RATIO
		vis.show_state("para" + str(clamp(round(para_level), 1, 3)))
		
		update_state(PARA)
	else:
		para_level = 0
		
		update_state(SMILE)
	
	timer.start(rdm.randf_range(1.7, 2.3) + para_level * 0.3)
	

func show_para() -> void:
	var first_anim = "looking"
	
	if para_level > 0:
		first_anim = "para" + str(clamp(ceil(para_level), 1, 3))
		
	if para_level < 3:
		para_level = para_level + 1
	
	vis.show_sequence([
		[first_anim, PARA_LOOK_TIMEOUT],
		["para" + str(floor(para_level)), PARA_SEQUENCE_TIMEOUT]
	])
	
	yield(vis, "sequence_ended")
	
	update_state(PARA)
	
	timer.start(rdm.randf_range(1.7, 2.3) + para_level * 0.3)


func _play_random_wiggle_anim() -> void:
	randomize()
	
	var animation = [
		["turning1", rdm.randf_range(1.7, 2.6)],
		["look-outside", rdm.randf_range(1.7, 2.6)]
	]
	animation.shuffle()
	
	vis.show_sequence([
		animation[0]
	])
	
	yield(vis, "sequence_ended")

	idle(true)


func reset() -> void:
	look_chance_percentage = LOOK_CHANCE_INITIAL_PERCENTAGE
	timer.stop()
	rdm.randomize()
	para_level = 0
	
	idle()
