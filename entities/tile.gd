extends Sprite

signal tile_removed

onready var visibility_node = $VisibilityNotifier2D

func _ready() -> void:
	visibility_node.connect("screen_exited", self, "_on_screen_exited")
	visibility_node.connect("viewport_exited", self, "_on_screen_exited")
	

func _on_screen_exited() -> void:
	queue_free()
	
	emit_signal("tile_removed")
