extends Control

func _on_game_pause(_status: bool) -> void:
	self.visible = not self.visible
