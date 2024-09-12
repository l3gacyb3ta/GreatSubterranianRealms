extends Node

var mouse_sensitivity: float = 0.002:
	set(value):
		mouse_sensitivity = value
		update_sensitivity.emit(value)

var world_environment: WorldEnvironment:
	set(value):
		world_environment = value
		update_world.emit(value)

var root: Node

signal update_world(world: WorldEnvironment)
signal update_sensitivity(sensitivity: float)
