extends Node

signal save()
signal reset()

@onready var resource = SaveResource.new()

var stories = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ResourceLoader.exists("user://save.tres"):
		resource = ResourceLoader.load("user://save.tres", "Resource", ResourceLoader.CACHE_MODE_REPLACE)
		stories = resource.SaveData
	else:
		resource.SaveData = stories

	save.connect(_on_save)
	reset.connect(_on_reset)
	
func _on_reset():
	if ResourceLoader.exists("user://save.tres"):
		DirAccess.remove_absolute("user://save.tres")
		LoadManager.load_scene("res://main.tscn")
	else:
		LoadManager.load_scene("res://main.tscn")

func register(story: StoryCollider):
	var key = str(story.get_path())
	if stories.has(key):
		var data = stories[key]
		var exists = data["extant"]
		if exists == false:
			story.queue_free()
			return
		story.marked = data["marked"]
		story.index = data["index"]
		story.finished = data["finished"]
		data["story"] = story
	else:
		stories[key] = {
			"marked": story.marked,
			"index": story.index,
			"finished": story.finished,
			"extant": true,
			"story": story
		}

func _on_save() -> void:
	print_debug("Saving...")
	for key in stories.keys():
		if stories[key] != null:
			var item = stories[key]
			if not item.has("story") or not item["story"]:
				resource.SaveData[key] = {
					"extant": false
				}
				continue
			
			var story: StoryCollider = item["story"]
			resource.SaveData[key] = {
				"marked": story.Indicate,
				"index": story.index,
				"finished": story.finished,
				"extant": true
			}

	ResourceSaver.save(resource, "user://save.tres")
