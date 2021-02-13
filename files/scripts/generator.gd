extends Spatial

var rng
var grid_size = 8
var grid_step = 4.0

var env

var tile
var tile_mat

var npc
var npc_mat

var bg_color
var tile_color
var light_color
var npc_color

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	env = $worldenv.environment
	tile = preload("res://files/nodes/tile_solid.tscn")
	tile_mat = preload("res://files/materials/tile.tres")
	npc = preload("res://files/nodes/npc.tscn")
	npc_mat = preload("res://files/materials/npc.tres")
	_generate()

func _generate():
	bg_color = Color.from_hsv(rng.randf(), 0.6, 0.5)
	tile_color = Color.from_hsv(rng.randf(), 0.8, 0.8)
	light_color = Color.from_hsv(rng.randf(), 0.8, 1.0)
	npc_color = Color.from_hsv(rng.randf(), 0.8, 1.0)
	tile_mat.set_shader_param("col", tile_color)
	var tile_seed = Vector2(rng.randf(), rng.randf())
	tile_mat.set_shader_param("seed", tile_seed)
	env.fog_depth_end = rng.randf_range(20.0, 100.0)
	env.background_color = bg_color
	env.ambient_light_color = bg_color
	env.fog_color = bg_color

	var offset = grid_size / 2.0 * grid_step
	for n_x in range(grid_size):
		for n_y in range(grid_size):
			for n_z in range(grid_size):
				var new_tile = tile.instance()
				add_child(new_tile)
				new_tile.translation.x = n_x * grid_step - offset
				new_tile.translation.y = n_y * grid_step - offset
				new_tile.translation.z = n_z * grid_step - offset
				new_tile.rotation.x = float(rng.randi_range(0, 3)) * PI / 2.0
				new_tile.rotation.y = float(rng.randi_range(0, 3)) * PI / 2.0
				new_tile.rotation.z = float(rng.randi_range(0, 3)) * PI / 2.0
				var light_chance = rng.randf()
				if light_chance * 100.0 < 30.0:
					var new_light = OmniLight.new()
					new_light.omni_range = rng.randf_range(2.0, 10.0)
					new_light.light_energy = rng.randf_range(1.0, 2.0)
					new_light.light_color = light_color
					add_child(new_light)
					new_light.translation = new_tile.translation
				var npc_chance = rng.randf()
				if npc_chance * 100.0 < 5.0:
					var new_npc = npc.instance()
					add_child(new_npc)
					var new_npc_mat = npc_mat.duplicate()
					var npc_seed = Vector2(rng.randf(), rng.randf())
					new_npc_mat.set_shader_param("seed", npc_seed)
					new_npc_mat.set_shader_param("col", npc_color)
					new_npc.set_surface_material(0, new_npc_mat)
					new_npc.translation = new_tile.translation
					new_npc.rotation.y = float(rng.randi_range(0, 3)) * PI / 2.0
