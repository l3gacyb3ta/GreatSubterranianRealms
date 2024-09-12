extends Node3D

@onready var world = $WorldEnvironment
@onready var character = $Character
func _update_world(new_world: WorldEnvironment) -> void:
	world = new_world.duplicate()

func _update_sensitivity(value: float):
	character.mouse_acceleration = value

func _ready() -> void:
	if Settings.world_environment == null:
		Settings.world_environment = world.duplicate()
	else:
		world = Settings.world_environment.duplicate()
	
	Settings.update_world.connect(_update_world)
	Settings.update_sensitivity.connect(_update_sensitivity)
