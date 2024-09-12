extends Node3D

func story_event(who: StoryCollider):
	var id = who.signals.rfind(self)
	who.signals.remove_at(id)
	self.queue_free()
