extends Spatial

var rng
var grid_size = 8
var grid_step = 4.0
var inset = 2
var offset

var player_scene
var player

var env

var tile
var tile_mat

var wall
var wall_mat

var npc
var npc_mat

var portal
var portal_mat

var bg_color
var tile_colors = []
var light_color
var npc_color

func _ready():
	offset = grid_size / 2.0 * grid_step
	rng = RandomNumberGenerator.new()
	rng.randomize()
	player_scene = preload("res://files/nodes/player.tscn")
	env = $worldenv.environment
	tile = preload("res://files/nodes/tile_solid.tscn")
	tile_mat = preload("res://files/materials/tile.tres")
	wall = preload("res://files/nodes/wall.tscn")
	wall_mat = preload("res://files/materials/wall.tres")
	npc = preload("res://files/nodes/npc.tscn")
	npc_mat = preload("res://files/materials/npc.tres")
	portal = preload("res://files/nodes/portal.tscn")
	portal_mat = preload("res://files/materials/portal.tres")
	_generate()

func _generate():
	player = player_scene.instance()
	add_child(player)
	player.translation.x = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
	player.translation.y = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
	player.translation.z = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
	player.rotation.y = float(rng.randi_range(0, 3)) * PI / 2.0
	bg_color = Color.from_hsv(rng.randf(), 0.6, 0.5)
	var tile_color_base = Color.from_hsv(rng.randf(), 0.8, 0.8)
	for n_col in range(4):
		var new_tile_col = Color.white
		var color_range = 0.3
		new_tile_col.r = clamp(tile_color_base.r + rng.randf_range(-color_range, color_range), 0.0, 1.0)
		new_tile_col.g = clamp(tile_color_base.g + rng.randf_range(-color_range, color_range), 0.0, 1.0)
		new_tile_col.b = clamp(tile_color_base.b + rng.randf_range(-color_range, color_range), 0.0, 1.0)
		tile_colors.append(new_tile_col)
	light_color = Color.from_hsv(rng.randf(), 0.8, 1.0)
	npc_color = Color.from_hsv(rng.randf(), 0.8, 1.0)
	var wall_seed = Vector2(rng.randf(), rng.randf())
	wall_mat.set_shader_param("seed", wall_seed)
	wall_mat.set_shader_param("col", tile_colors[0])
	portal_mat.set_shader_param("col", npc_color)
	env.fog_depth_end = rng.randf_range(20.0, 100.0)
	env.background_color = bg_color
	env.ambient_light_color = bg_color
	env.fog_color = bg_color

	for n_x in range(grid_size):
		for n_y in range(grid_size):
			for n_z in range(grid_size):
				_spawn_tiles(n_x, n_y, n_z)
	_spawn_lights()
	_spawn_npc()
	_spawn_portals()

func _spawn_tiles(var x, var y, var z):
	if x == 0 or x == grid_size - 1 or y == 0 or y == grid_size - 1 or z == 0 or z == grid_size - 1:
		var new_wall = wall.instance()
		add_child(new_wall)
		new_wall.translation.x = x * grid_step - offset
		new_wall.translation.y = y * grid_step - offset
		new_wall.translation.z = z * grid_step - offset
	else:
		var new_tile = tile.instance()
		add_child(new_tile)
		tile_colors.shuffle()
		var new_tile_mat = tile_mat.duplicate()
		var tile_seed = Vector2(rng.randf(), rng.randf())
		new_tile_mat.set_shader_param("seed", tile_seed)
		new_tile_mat.set_shader_param("col", tile_colors[0])
		new_tile.get_node("tile_mesh/cube").set_surface_material(0, new_tile_mat)
		new_tile.translation.x = x * grid_step - offset
		new_tile.translation.y = y * grid_step - offset
		new_tile.translation.z = z * grid_step - offset
		new_tile.rotation.x = float(rng.randi_range(0, 3)) * PI / 2.0
		new_tile.rotation.y = float(rng.randi_range(0, 3)) * PI / 2.0
		new_tile.rotation.z = float(rng.randi_range(0, 3)) * PI / 2.0

func _spawn_lights():
	var amount = rng.randi_range(8, 16)
	for n_light in range(amount):
		var new_light = OmniLight.new()
		new_light.omni_range = rng.randf_range(2.0, 10.0)
		new_light.light_energy = rng.randf_range(1.0, 2.0)
		new_light.light_color = light_color
		add_child(new_light)
		new_light.translation.x = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
		new_light.translation.y = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
		new_light.translation.z = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset

func _spawn_npc():
	var amount = rng.randi_range(2, 8)
	for n_npc in range(amount):
		var new_npc = npc.instance()
		add_child(new_npc)
		var new_npc_mat = npc_mat.duplicate()
		var npc_seed = Vector2(rng.randf(), rng.randf())
		new_npc_mat.set_shader_param("seed", npc_seed)
		new_npc_mat.set_shader_param("col", npc_color)
		new_npc.set_surface_material(0, new_npc_mat)
		new_npc.translation.x = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
		new_npc.translation.y = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
		new_npc.translation.z = float(rng.randi_range(inset, grid_size - inset)) * grid_step - offset
		new_npc.target = player

func _spawn_portals():
	var amount = rng.randi_range(3, 6)
	for n_portal in range(amount):
		var new_portal = portal.instance()
		add_child(new_portal)
		new_portal.translation.x = float(rng.randi_range(1, grid_size - 1)) * grid_step - offset
		new_portal.translation.y = float(rng.randi_range(1, grid_size - 1)) * grid_step - offset
		new_portal.translation.z = float(rng.randi_range(1, grid_size - 1)) * grid_step - offset
		new_portal.rotation.y = float(rng.randi_range(0, 3)) * PI / 2.0
