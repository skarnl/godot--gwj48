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
	vis.show_state("stop-mooning1")
	
	yield(get_tree().create_timer(STOP_MOONING_TIMEOUT1), "timeout")
	
	vis.show_state("stop-mooning2")
	
	yield(get_tree().create_timer(STOP_MOONING_TIMEOUT2), "timeout")

	vis.show_state("idle")
	
	emit_signal("mooning_stopped")
