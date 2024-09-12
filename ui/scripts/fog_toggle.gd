extends CheckButton

func _on_toggled(toggled_on: bool) -> void:
	Settings.world_environment.environment.volumetric_fog_enabled = toggled_on
