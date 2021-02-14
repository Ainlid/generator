extends Spatial

var active = false

var sound
var pitch = 1.0

var speed = 5.0
var basis

var mesh
var mat_on

signal activated

func _ready():
	sound = $sound
	basis = transform.basis
	mesh = $cube
	mat_on = preload("res://files/materials/note_on.tres")

func _set_note(var rand_pitch):
	var new_note = pow(2.0, rand_pitch / 12.0)
	sound.pitch_scale = new_note

func _process(delta):
	translate(basis.z * speed * delta)

func _collided(body):
	if body.get_parent().is_in_group("solid"):
		speed *= -1.0
		if active:
			sound.play()
	if body.is_in_group("player") and !active:
		active = true
		mesh.set_surface_material(0, mat_on)
		emit_signal("activated")
