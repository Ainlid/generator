extends Spatial

var rng
var grid_size = 4
var grid_step = 0.5

var seed_tile

var tiles = []
var selection = 0

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	seed_tile = preload("res://files/nodes/seed_tile.tscn")
	_generate()

func _generate():
	var offset = grid_size / 2.0 * grid_step
	for n_x in range(grid_size):
		for n_y in range(grid_size):
			var new_tile = seed_tile.instance()
			var number = rng.randi_range(0, 9)
			new_tile.frame = number
			add_child(new_tile)
			tiles.append(new_tile)
			new_tile.translation.x = n_x * grid_step - offset
			new_tile.translation.y = n_y * grid_step - offset

func _process(delta):
	if Input.is_action_just_pressed("left"):
		selection -= 1
	if Input.is_action_just_pressed("right"):
		selection += 1
	selection = clamp(selection, 0, tiles.size())
	var select_tile = tiles[selection]
	select_tile.scale *= 0.7
