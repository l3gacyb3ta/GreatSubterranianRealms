extends Node

@export var root: Node
@export var PauseMenu: Control

# signal pause(status: bool)

@onready var Topdown = %TopdownCam
@onready var character = %Character

var mouse_mode = true
var map = preload("res://zork_scenes/map.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Settings.root = root
	
	
func _overview_window():
	get_viewport().set_embedding_subwindows(false)
	
	var window = map.instantiate()
	Topdown.reparent(window)
	window.gui_release_focus()
	
	add_child(window)
	window.move_to_center()
	window.position = Vector2(500, 500)
	
	get_viewport().get_window().grab_focus()

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		#var currently = get_tree().paused
		#get_tree().paused = not currently
		#PauseMenu.visible = not currently
		#
		#mouse_mode = not mouse_mode
		#if mouse_mode:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#root.process_mode = Node.PROCESS_MODE_ALWAYS
		#else:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#root.process_mode = Node.PROCESS_MODE_DISABLED
			#
		#pause.emit(not currently)
