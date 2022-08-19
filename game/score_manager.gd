extends Node2D

var ScoreIndicatorPrefab = preload("res://entities/score_animation.tscn")


func _ready() -> void:
	print("SM started")


# start mooning
func start() -> void:
	pass
	
	
# stop mooning
func stop() -> void:
	pass



func add_score(val: int) -> void:
	var sc = ScoreIndicatorPrefab.instance()
	sc.show_value(val)
