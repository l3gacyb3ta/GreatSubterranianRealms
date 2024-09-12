## A StoryCollider allows for complex interactions with in-game story objects. Allows for triggering of signals, display of text, etc.
class_name StoryCollider extends StaticBody3D

## The in-game description of an object
@export_multiline var description: String

## Follow up secondary messages
@export_multiline var SecondaryMessages: Array[String]

## A list of signals to fire when the object is interacted with (will attempt to call "story_event")
@export var signals: Array[Node3D]

@export_group("Indications")
@export var Indicate: bool = false
@export var Marker: Node3D

var finished = false
var marked = false
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_mask = 2
	collision_layer = 2
	SaveManager.register(self)

func get_description() -> Dictionary:
	var out = self.description
	var more = false
	
	if index != 0:
		out = SecondaryMessages[self.index - 1]
	if index < len(SecondaryMessages):
		more = true
	index += 1
	if index > len(SecondaryMessages):
		index = 0
		if Indicate: finished = true
		
	for object in self.signals:
		if object.has_method("story_event"):
			object.story_event(self)
	
	return {'text': out, 'more': more}

func _on_timer_timeout() -> void:
	if not marked and Indicate and not finished:
		var marker = Marker
		marker.visible = true
		signals.append(marker)
		
		marked = true
