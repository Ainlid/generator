extends MeshInstance

var sfx
var timer

func _ready():
	sfx = $sfx
	timer = $delay

func _body_entered(var body):
	if body.is_in_group("player"):
		body.active = false
		sfx.play()
		timer.start()

func _timeout():
	get_tree().reload_current_scene()
