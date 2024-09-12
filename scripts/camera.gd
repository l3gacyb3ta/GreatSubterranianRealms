class_name CharController extends CharacterBody3D

@export_category("Player")
## Speed in m/s
@export_range(1, 35, 1) var speed: float = 10 # m/s
## Acceleration in m/s^2
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2
## Jump Height in Meters
@export_range(0.1, 3.0, 0.1) var jump_height: float = 1
## Mouse acceleration, arbitrary units
@export_range(0.001, 0.1, 0.001) var mouse_acceleration: float = 0.001 # m
## Camera sensistivity for controllers
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1
## the distance forward, in meters
@export var interaction_distance: int = 5
## The popup controller
@export var popup_controller: PopupController
## A 3d position in the world to reset to when you fall off the map.
@export var reset_point: Node3D

var jumping: bool = false
var mouse_captured: bool = true
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim
var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

signal interact

@onready var camera: Camera3D = $Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * mouse_acceleration
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("jump"): jumping = true
	elif Input.is_action_just_pressed("interact"): _interact()
	#if Input.is_action_just_pressed("exit"): get_tree().quit()

func _interact() -> void:
	interact.emit()
	if popup_controller.displaying_text: return

	var space = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position,
			$Camera3D.global_position - $Camera3D.global_transform.basis.z * interaction_distance, 2)
	var collision = space.intersect_ray(query)
	if collision:
		var result = collision.collider.get_description()
		if result["text"] != "": popup_controller.display_text(result["text"], result["more"])

func _physics_process(delta: float) -> void:	
	if self.position.y < -100:
		self.position = reset_point.position
	
	if mouse_captured: _handle_joypad_camera_rotation(delta, mouse_acceleration * 1000)
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("left", "right", "forward", "backward")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel

#class_name FreeLookCamera extends CharacterBody3D
#
## Modifier keys' speed multiplier
#const SHIFT_MULTIPLIER = 2.5
#const ALT_MULTIPLIER = 1.0 / SHIFT_MULTIPLIER
#
#
#@export_range(0.0, 1.0) var sensitivity: float = 0.25
#@export var root: Node3D
#@export var free_look: bool = false
#@onready var camera: Camera3D = $"Camera3D"
#@onready var me: CharacterBody3D = $"."
#
#@export var SPEED = 5.0
#@export var JUMP_VELOCITY = 4.5
#
## Mouse state
#var _mouse_position = Vector2(0.0, 0.0)
#var _total_pitch = 0.0
#
## Movement state
#var _direction = Vector3(0.0, 0.0, 0.0)
#var _velocity = Vector3(0.0, 0.0, 0.0)
#var _acceleration = 30
#var _deceleration = -10
#var _vel_multiplier = 4
#
## Keyboard state
#var _w = false
#var _s = false
#var _a = false
#var _d = false
#var _q = false
#var _e = false
#var _shift = false
#var _alt = false
#
#var mouse_mode = true;
#
#func _input(event):
	## Receives mouse motion
	#if event is InputEventMouseMotion:
		#_mouse_position = event.relative
	#
	## Receives mouse button input
	#if event is InputEventMouseButton:
		#match event.button_index:
			#MOUSE_BUTTON_RIGHT: # Only allows rotation if right click down
				#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			#MOUSE_BUTTON_WHEEL_UP: # Increases max velocity
				#_vel_multiplier = clamp(_vel_multiplier * 1.1, 0.2, 20)
			#MOUSE_BUTTON_WHEEL_DOWN: # Decereases max velocity
				#_vel_multiplier = clamp(_vel_multiplier / 1.1, 0.2, 20)
	#
	#
	## Receives key input
	#if event is InputEventKey and free_look:
		#match event.keycode:
			#KEY_W:
				#_w = event.pressed
			#KEY_S:
				#_s = event.pressed
			#KEY_A:
				#_a = event.pressed
			#KEY_D:
				#_d = event.pressed
			#KEY_Q:
				#_q = event.pressed
			#KEY_E:
				#_e = event.pressed
			#KEY_SHIFT:
				#_shift = event.pressed
			#KEY_ALT:
				#_alt = event.pressed
#
#
## Updates mouselook and movement every frame
#func _process(delta):
	#_update_mouselook()
	#if free_look:
		#_update_movement(delta)
#
## Updates camera movement
#func _update_movement(delta):
	## Computes desired direction from key states
	#_direction = Vector3(
		#(_d as float) - (_a as float), 
		#(_e as float) - (_q as float),
		#(_s as float) - (_w as float)
	#)
	#
	## Computes the change in velocity due to desired direction and "drag"
	## The "drag" is a constant acceleration on the camera to bring it's velocity to 0
	#var offset = _direction.normalized() * _acceleration * _vel_multiplier * delta \
		#+ _velocity.normalized() * _deceleration * _vel_multiplier * delta
	#
	## Compute modifiers' speed multiplier
	#var speed_multi = 1
	#if _shift: speed_multi *= SHIFT_MULTIPLIER
	#if _alt: speed_multi *= ALT_MULTIPLIER
	#
	## Checks if we should bother translating the camera
	#if _direction == Vector3.ZERO and offset.length_squared() > _velocity.length_squared():
		## Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		#_velocity = Vector3.ZERO
	#else:
		## Clamps speed to stay within maximum value (_vel_multiplier)
		#_velocity.x = clamp(_velocity.x + offset.x, -_vel_multiplier, _vel_multiplier)
		#_velocity.y = clamp(_velocity.y + offset.y, -_vel_multiplier, _vel_multiplier)
		#_velocity.z = clamp(_velocity.z + offset.z, -_vel_multiplier, _vel_multiplier)
	#
		#translate(_velocity * delta * speed_multi)
#
## Updates mouse look 
#func _update_mouselook():
	## Only rotates mouse if the mouse is captured
	#if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#_mouse_position *= sensitivity
		#var yaw = _mouse_position.x
		#var pitch = _mouse_position.y
		#_mouse_position = Vector2(0, 0)
		#
		## Prevents looking up/down too far
		#pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
		#_total_pitch += pitch
	#
		#camera.rotate_y(deg_to_rad(-yaw))
		#me.rotation.y = camera.rotation.y
		#camera.rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("left", "right", "forward", "backward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
