extends MeshInstance

func _body_entered(var body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
