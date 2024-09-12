extends CanvasLayer
signal loading_screen_has_full_coverage

@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var indicator: Button = $ColorRect/Loading/Indicator

func _update_progress_bar(value: float) -> void:
	indicator.text = "Loading... %s%%" % str(round(value * 100))

func _start_outro_animation() -> void:
	animation_player.play("end_load")
	await Signal(animation_player, "animation_finished")
	self.queue_free()

func _ready():
	animation_player.play("start_load")
	await Signal(animation_player, "animation_finished")
	loading_screen_has_full_coverage.emit()
