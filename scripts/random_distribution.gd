class_name RandomDistribution extends Node3D

@export var object: Node3D
@export_range(1, 30, 2) var count = 2
@export var radius_square = 15

@export var distribute: bool:
	set(val):
		distribute = false
		_ready()

var _rand = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if !Engine.is_editor_hint():
		#return
	
	var count = get_parent_node_3d().get_meta("Count", 20)
	_rand.randomize()
	for i in range(0, count):
		var new_position = self.position
		new_position.x += _rand.randi_range((-1 * radius_square), radius_square)
		new_position.z += _rand.randi_range((-1 * radius_square), radius_square)
		
		var clone = object.duplicate()
		clone.position = new_position
		clone.visible = true
		add_child(clone)
		clone.owner = self
