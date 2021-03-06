extends KinematicBody

onready var camera = $Pivot/Camera

var active = true

export var gravity = -30.0
export var walk_speed = 8.0
export var jump_speed = 15.0
export var turn_speed = 2.0

var pivot
var raycast
var crosshair

var dir = Vector3()
var velocity = Vector3()

func _ready():
	pivot = $pivot
	raycast = $pivot/raycast
	crosshair = $crosshair

func _physics_process(delta):
	dir = Vector3()
	var basis = global_transform.basis
	if Input.is_action_pressed("up"):
		dir -= basis.z
	if Input.is_action_pressed("down"):
		dir += basis.z
	if Input.is_action_pressed("left"):
		dir -= basis.x
	if Input.is_action_pressed("right"):
		dir += basis.x
	dir = dir.normalized()

	if Input.is_action_pressed("look_up"):
		pivot.rotate_x(turn_speed * delta)
	if Input.is_action_pressed("look_down"):
		pivot.rotate_x(-turn_speed * delta)
	pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
	if Input.is_action_pressed("look_left"):
		rotate_y(turn_speed * delta)
	if Input.is_action_pressed("look_right"):
		rotate_y(-turn_speed * delta)

	velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	#if Input.is_action_pressed("jump"):
		#velocity.y = jump_speed

	var final_velocity = dir * walk_speed
	if !is_on_wall():
		velocity.x = final_velocity.x
		velocity.z = final_velocity.z
	if active:
		velocity = move_and_slide(velocity, Vector3.UP, true)

	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	var npc
	if raycast.is_colliding():
		npc = raycast.get_collider().get_parent()
	
	if npc != null:
		if npc.is_in_group("npc"):
			crosshair.show()
			if Input.is_action_just_pressed("use"):
				npc._speak()
	else:
		crosshair.hide()
