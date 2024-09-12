extends Control

@export_group("Settings connections")
@export var character: CharController
@export var worldEnvironment: WorldEnvironment

@onready var focus_point = $"Above Blur/VBoxContainer/Reset"
@onready var root = get_tree().current_scene

signal pause(status: bool)

var mouse_mode = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Settings.root = root

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var currently = get_tree().paused
		get_tree().paused = not currently
		self.visible = not currently
		
		mouse_mode = not mouse_mode
		if mouse_mode:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			root.process_mode = Node.PROCESS_MODE_ALWAYS
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			root.process_mode = Node.PROCESS_MODE_DISABLED

		pause.emit(not currently)
		if not currently:
			focus_point.grab_focus()

func _on_property_list_changed() -> void: # in case the settings change during the game
	_ready()

func _on_reset_pressed() -> void:
	character.position = character.reset_point.position

func _on_fog_toggle_toggled(toggled_on: bool) -> void:
	Settings.world_environment.environment.volumetric_fog_enabled = toggled_on

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().paused = false
	SaveManager.save.emit()
	LoadManager.load_scene("res://ui/settings.tscn", false, true)

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	SaveManager.save.emit()
	LoadManager.load_scene("res://ui/main_menu.tscn", false)


func _on_save_pressed() -> void:
	SaveManager.save.emit()


func _on_reset_save_pressed() -> void:
	SaveManager.reset.emit()
