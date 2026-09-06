class_name Movement3D extends Node3D

@export var player : Player3D
@export var head : Node3D

@export var move_speed : float = 24.0

@export var acceleration : float = 50.0
@export var deceleration : float = 100

@export var jump_force : float = 12.0

@export var camera_sensitivity : float = 4
# max up/down
@export var camera_max_degrees : float = 99

func _physics_process(delta: float) -> void:
	var input : Vector2 = Input.get_vector("mv_left", "mv_right", "mv_foreward", "mv_backward")
	var move_direction : Vector3 = (player.transform.basis * Vector3(input.x, 0.0, input.y)).normalized()
	
	# Accelerate if input is pressed, otherwise decelerate
	var rate : float = acceleration if input.length() > 0 else deceleration
	
	# Seperate x/z movement is horrible so make it into a vec3, move that and split that back into x/z ;-;
	var horizontal : Vector3 = Vector3(player.velocity.x, 0.0, player.velocity.z).move_toward(move_direction * move_speed, rate * delta)
	player.velocity.x = horizontal.x
	player.velocity.z = horizontal.z
	
	if player.is_on_floor():
		if Input.is_action_pressed("mv_jump"):
			player.velocity.y = jump_force
	else:
		player.velocity.y -= Constants.gravity * delta
	
	player.move_and_slide()

# Camera movement from Bramwell on yt
# https://youtu.be/v4IEPi1c0eE?si=v0cpUg0muRM57SSs
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			player.rotate_y(-event.relative.x * (camera_sensitivity / 1000))
			head.rotate_x(-event.relative.y * (camera_sensitivity / 1000))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-camera_max_degrees), deg_to_rad(camera_max_degrees))
