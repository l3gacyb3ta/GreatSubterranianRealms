extends Node3D

@export var removable: bool = false
@export var collider: bool = true

@onready var story = $Story
@onready var collider_obj = $StaticCollider

func _ready() -> void:
	if removable:
		story.description = "Clank!"
		story.signals.append(self)
	else:
		story.description = "The board won't be budged"
	if not collider:
		collider_obj.queue_free()

func delete_self():
	
	queue_free()

func story_event(_thing):
	if not removable:
		return

	if collider_obj != null:
		collider_obj.queue_free()

	var rigidbody = RigidBody3D.new()
	add_child(rigidbody)
	rigidbody.owner = self
	
	for child in story.get_children():
		child.reparent(rigidbody)
	
	story.queue_free()
	await get_tree().create_timer(5).timeout
	queue_free()
