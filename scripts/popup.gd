class_name PopupController extends Control

@onready var text_container = $VBoxContainer/Label
@onready var more_icon = $MoreIcon
var actually_visible = false

@export var displaying_text = false

func display_text(text: String, more: bool = false) -> void:
	self.visible = true
	self.displaying_text = true
	text_container.text = text
	actually_visible = true
	
	var visible_lines = text_container.get_visible_line_count()
	var lines = text_container.get_line_count()
	
	more_icon.visible = (lines > visible_lines) or more

func _remove_first_line(text: String) -> String:
	var lines = text.split("\n")
	lines.remove_at(0)
	while lines[0] == "":
		lines.remove_at(0)
	return "\n".join(lines)

func _on_game_pause(status: bool) -> void:
	if actually_visible and status: self.visible = false
	elif actually_visible and not status: self.visible = true

func _on_character_interact() -> void:
	if not visible:
		return
	var visible_lines = text_container.get_visible_line_count()
	var lines = text_container.get_line_count()
	if visible_lines < lines:
		text_container.text = _remove_first_line(text_container.text)
		
		visible_lines = text_container.get_visible_line_count()
		lines = text_container.get_line_count()
		more_icon.visible = visible_lines < lines
		return
	
	more_icon.visible = false
	self.displaying_text = false
	if actually_visible: actually_visible = false
	self.visible = false
