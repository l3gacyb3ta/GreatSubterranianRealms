extends Node

signal progress_changed(progress: float)
signal load_finished

var _load_screen_path: String = "res://ui/loading.tscn" 
var _load_screen: PackedScene = load(_load_screen_path)
var _loaded_resource: PackedScene
var _scene_path: String
var _progress: Array = []
var _use_subthreads: bool = true

## array of [path, return_with_loading_screen]
var _previous_stack = []

func pop_and_return():
	var result = _previous_stack.pop_back()
	if result:
		var path = result[0]
		var rwls = result[1]
		load_scene(path, rwls)

func load_scene(scene: String, loading_screen: bool = true, return_with_loading_screen: bool = true):
	var previous_scene = get_tree().current_scene.scene_file_path
	_previous_stack.push_back([previous_scene, return_with_loading_screen])
	_scene_path = scene
	
	if loading_screen:
		var new_loading_screen = _load_screen.instantiate()
		
		get_tree().get_root().add_child(new_loading_screen)
	
		progress_changed.connect(new_loading_screen._update_progress_bar)
		load_finished.connect(new_loading_screen._start_outro_animation)
		await Signal(new_loading_screen, "loading_screen_has_full_coverage")
	
	start_load()

func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(_scene_path, "", _use_subthreads)
	
	if state == OK:
		set_process(true)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		0, 2: #? THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: #? in progress
			progress_changed.emit(_progress[0])
		3: #? done
			_loaded_resource = ResourceLoader.load_threaded_get(_scene_path)
			progress_changed.emit(1.0)
			load_finished.emit()
			get_tree().change_scene_to_packed(_loaded_resource)
			
			await Signal(get_tree(), "process_frame")
