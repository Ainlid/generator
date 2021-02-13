extends Node

func _usable_action():
	print("interacted!")
	queue_free()
