extends Node2D

signal mooning_start_anim_started
signal mooning_started
signal mooning_stopped
signal mooning_stop__anim_finished

onready var vis := $VisualContainer

const START_MOONING_TIMEOUT1 := 0.2

const STOP_MOONING_TIMEOUT1 := 0.15
const STOP_MOONING_TIMEOUT2 := 0.1

var mooning_anim_finished := false
var stop_mooning_after_anim := false

var is_busted := false


func _ready() -> void:
	reset()


func idle() -> void:
	if is_busted:
		return
		
	vis.show_state("idle")


func start_mooning() -> void:
	if is_busted:
		return
	
	emit_signal("mooning_start_anim_started")
		
	vis.show_sequence([
		["stop-mooning2", START_MOONING_TIMEOUT1],
		["mooning"]
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("mooning_started")
	
	mooning_anim_finished = true

	if stop_mooning_after_anim:
		stop_mooning()


func stop_mooning() -> void:
	if is_busted:
		return
	
	if not mooning_anim_finished:
		stop_mooning_after_anim = true
		return
	
	stop_mooning_after_anim = false
	
	emit_signal("mooning_stopped")
	
	vis.show_sequence([
		["stop-mooning1", STOP_MOONING_TIMEOUT1],
		["stop-mooning2", STOP_MOONING_TIMEOUT2],
		["idle"]
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("mooning_stop__anim_finished")


func busted() -> void:
	is_busted = true
	vis.show_state("busted")
	


func reset() -> void:
	print("Kid::reset")
	mooning_anim_finished = false
	stop_mooning_after_anim = false
	is_busted = false
