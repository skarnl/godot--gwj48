extends Node2D

signal mooning_stopped

onready var vis := $VisualContainer

const STOP_MOONING_TIMEOUT1 := 0.15
const STOP_MOONING_TIMEOUT2 := 0.1


func idle() -> void:
	vis.show_state("idle")


func start_mooning() -> void:
	vis.show_state("mooning")


func stop_mooning() -> void:
	vis.show_sequence([
		["stop-mooning1", STOP_MOONING_TIMEOUT1],
		["stop-mooning2", STOP_MOONING_TIMEOUT2],
		["idle"]
	])
	
	yield(vis, "sequence_ended")
	
	emit_signal("mooning_stopped")


func busted() -> void:
	vis.show_state("busted")
