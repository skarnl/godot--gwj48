extends Node2D

var ScoreIndicatorPrefab = preload("res://entities/score_animation.tscn")

onready var anchor := $ScoreIndicationAnchor

const TICK_RATE := 0.35
var current_tick := 0.0

export var current_score := 0.0
export var increase_with := 1.0
export var increase_ratio := 1.5

func _ready() -> void:
	print("SM started")
	
	reset()
	
	
func _process(delta: float) -> void:
	current_tick = current_tick + delta
	
	if current_tick > TICK_RATE:
		current_tick = 0
		_update_score(delta)


func _update_score(delta: float = 0) -> void:
	var increase_value = floor(increase_with * increase_ratio)
	current_score = current_score + increase_value
	increase_ratio = increase_ratio + delta
	
	print("increase_ratio %d" % increase_ratio)
	
	print("increase_value %d" % increase_value)
	
	add_score(increase_value)
	
	EventBus.emit_signal("score_updated", increase_value)


# start mooning
func start_counting() -> void:
	current_tick = 0
	set_process(true)
	
	
# stop mooning
func stop_counting() -> void:
	if is_processing():
		# we need to make the last mooning-action also count for points ^^
		_update_score()
		
	set_process(false)


func add_score(val: int) -> void:
	var sc = ScoreIndicatorPrefab.instance()
	sc.show_value(val)

	anchor.add_child(sc)


func reset() -> void:
	set_process(false)
	current_score = 0
	increase_with = 1.0
	increase_ratio = 1.1
	
	for c in anchor.get_children():
		c.queue_free()
