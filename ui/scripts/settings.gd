extends Control

@onready var MouseSensitivitySlider = %MouseSensitivitySlider
@onready var focus_point = MouseSensitivitySlider

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_property_list_changed() -> void: # in case the settings change during the game
	_ready()

func _on_game_pause(status: bool) -> void:
	if status:
		focus_point.grab_focus()

func _on_back_pressed() -> void:
	LoadManager.pop_and_return()
