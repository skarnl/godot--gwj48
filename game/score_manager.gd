extends Node2D

var ScoreIndicatorPrefab = preload("res://entities/score_animation.tscn")

onready var anchor := $ScoreIndicationAnchor

const TICK_RATE := 0.35
var current_tick := 0.0

const INCREASE_WITH_START_VALUE := 1.0
const INCREASE_RATIO_START_VALUE := 1.473
	

export var increase_with := INCREASE_WITH_START_VALUE
export var increase_ratio := INCREASE_RATIO_START_VALUE

var total_score := 0

func _ready() -> void:
	reset()
	
	
func _process(delta: float) -> void:
	current_tick = current_tick + delta
	
	if current_tick > TICK_RATE:
		current_tick = 0
		_update_score(delta)


func _update_score(delta: float) -> void:
	increase_with = increase_with * increase_ratio
	
	var rounded_increase_value = round(increase_with)
	
	add_score(rounded_increase_value)
	
	total_score = total_score + rounded_increase_value
	

# start mooning
func start_counting() -> void:
	current_tick = 0
	increase_with = INCREASE_WITH_START_VALUE
	increase_ratio = INCREASE_RATIO_START_VALUE
	
	set_process(true)
	
	
# stop mooning
func stop_counting() -> void:
	if is_processing():
		# we need to make the last mooning-action also count for points ^^
#		_update_score()
		pass
		
	set_process(false)


func add_score(val: int) -> void:
	var sc = ScoreIndicatorPrefab.instance()
	sc.show_value(val)
	sc.connect("update_score", self, "_on_update_score")

	anchor.add_child(sc)


func _on_update_score() -> void:
	EventBus.emit_signal("score_updated", total_score)


func reset() -> void:
	set_process(false)
	current_tick = 0
	increase_with = INCREASE_WITH_START_VALUE
	increase_ratio = INCREASE_RATIO_START_VALUE
	total_score = 0
	
	for c in anchor.get_children():
		c.queue_free()
