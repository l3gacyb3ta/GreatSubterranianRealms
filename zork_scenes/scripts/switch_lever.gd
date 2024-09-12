extends MeshInstance3D

var on = false

@onready var Animations = $"../AnimationPlayer" as AnimationPlayer

var on_rotation: Vector3 = Vector3(0,0,140)
var off_rotation: Vector3 = Vector3(0,0,-140)

func story_event(_thing):
	on = not on
	if on:
		Animations.play("off_to_on")
		#rotation = on_rotation
	else: Animations.play("on_to_off")
