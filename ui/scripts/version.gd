@tool
extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = ("CC-BY-NC-SA Arcade Wise 2024 v%s" % ProjectSettings.get_setting("application/config/version"))
