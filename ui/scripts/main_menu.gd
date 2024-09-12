extends Control

@onready var Loading = $Loading
@onready var Buttons = $Buttons


func _on_play_pressed() -> void:
	switch_to_gameplay()

func switch_to_gameplay() -> void:
	LoadManager.load_scene("res://main.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	LoadManager.load_scene("res://ui/settings.tscn", false, false)
