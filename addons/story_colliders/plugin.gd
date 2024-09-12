@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("StoryCollider", "StaticBody3D", preload("storyCollider.gd"), preload("res://addons/story_colliders/assets/book.svg"))

func get_description() -> String:
	for object in self.signals:
		if object.has_method("story_event"):
			object.story_event(self)
	var description = self.description
	return description

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("StoryCollider")
