extends Node2D

## Preloaded scenes
const Chunk: PackedScene = preload("res://Scenes/chunk.tscn")
const Player: PackedScene = preload("res://Scenes/player.tscn")
const Dungeon_Entrance: PackedScene = preload("res://Scenes/dungeon_entrance.tscn")
const Balloon: PackedScene = preload("res://Dialogue/balloon.tscn")
var dialogue = preload("res://Dialogue/player_dialogue.dialogue")

## Noise variables
@onready var moisture: OpenSimplexNoise4D = OpenSimplexNoise4D.new()
@onready var temperature: OpenSimplexNoise4D = OpenSimplexNoise4D.new()
@onready var altitude: OpenSimplexNoise4D = OpenSimplexNoise4D.new()
@onready var plants: OpenSimplexNoise4D = OpenSimplexNoise4D.new()

## Onready variables
@onready var Map: TileMap = %TileMap
@onready var health_bar: TextureProgressBar = %PlayerHealthBar
@onready var music: AudioStreamPlayer = %WorldMapMusic
@onready var grass: AudioStreamPlayer = %Grass
@onready var dry_grass: AudioStreamPlayer = %DryGrass
@onready var dirt: AudioStreamPlayer = %Dirt
@onready var sand: AudioStreamPlayer = %Sand
@onready var water: AudioStreamPlayer = %Water
@onready var snow: AudioStreamPlayer = %Snow
@onready var stone: AudioStreamPlayer = %Stone
@onready var leaves: AudioStreamPlayer = %Leaves

## Player variables
var player: Player
var player_pos: Vector2 = Vector2.ZERO

## Chunk variables
const chunk_size: int = 8
const tilesize: int = 16
const chunk_radius: int = 3
var chunks: Dictionary = {}
var all_chunks: Dictionary = {}
var chunk_pool: Array[Chunk] = []
var max_pool_size: int = 50

## World variables
const WORLD_SIZE: int = 10000

## Terrain generation variables
const noise_norm_factor: float = 20 * sqrt(2)
const sea_level: int = -4
const sea_tiles: int = 5
const num_sea_tiles: int = 5
const sea_tiles_index: int = 4
const plant_level: int = 3
const snow_level: int = 4
const num_y_tiles: int = 7
const y_tiles_index: int = 6
const num_grassland_tiles: int = 3
const grassland_tiles_index: int = 2
const num_plains_tiles: int = 6
const plains_tiles_index: int = 5
const swamp_index: int = 6
const jungle_index: int = 7
const snow_min: int = 3
const snow_max: int = 5
const snow_y_index: int = 6
const max_value: float = -1 * noise_norm_factor
const min_value: float = 1 * noise_norm_factor
var noise_values: Dictionary = {}

## Noise variables
const moisture_octaves: int = 3
const moisture_persistence: float = 0.6
const moisture_lacunarity: float = 2.2
const moisture_period: int = 25
const temperature_octaves: int = 2
const temperature_persistence: float = 0.3
const temperature_lacunarity: float = 2.0
const temperature_period: int = 30
const altitude_octaves: int = 4
const altitude_persistence: float = 0.6
const altitude_lacunarity: float = 2.5
const altitude_period: int = 5
const plants_octaves: int = 2
const plants_persistence: float = 0.6
const plants_lacunarity: float = 2.0
const plants_period: int = 1

## Dungeon variables
const max_dungeons: int = 5
var dungeons: Dictionary = {}

## Avoiding water
const water_tiles: Array[Vector2i] = [
	Vector2i(0,4), 
	Vector2i(2,5), 
	Vector2i(3,5), 
	Vector2i(4,5), 
	Vector2i(0,6), 
	Vector2i(1,6), 
	Vector2i(2,6), 
	Vector2i(3,6)
	]

## Tile types
const tile_types: Dictionary = {
	Vector2i(0,0): "grass",
	Vector2i(1,0): "grass",
	Vector2i(2,0): "grass",
	Vector2i(0,1): "grass",
	Vector2i(1,1): "grass",
	Vector2i(2,1): "grass",
	Vector2i(0,2): "dry_grass",
	Vector2i(1,2): "dry_grass",
	Vector2i(2,2): "dry_grass",
	Vector2i(0,3): "dry_grass",
	Vector2i(1,3): "dry_grass",
	Vector2i(2,3): "dry_grass",
	Vector2i(1,4): "grass",
	Vector2i(2,4): "grass",
	Vector2i(3,4): "dirt",
	Vector2i(4,4): "dirt",
	Vector2i(0,5): "sand",
	Vector2i(1,5): "water",
	Vector2i(4,6): "snow",
	Vector2i(5,6): "stone",
	Vector2i(6,6): "leaves",
	Vector2i(7,6): "leaves"
}
const empty_grass: Vector2i = Vector2i(0,0)
const empty_dark_grass: Vector2i = Vector2i(0,1)
const empty_dark_dirt: Vector2i = Vector2i(0,2)
const empty_dirt: Vector2i = Vector2i(0,3)
const empty_grass_light: Vector2i = Vector2i(1,4)
const empty_grass_dark: Vector2i = Vector2i(2,4)
const empty_desert1: Vector2i = Vector2i(3,4)
const empty_desert2: Vector2i = Vector2i(4,4)
const empty_sand: Vector2i = Vector2i(0,5)
const empty_snow: Vector2i = Vector2i(4,6)
const empty_stone: Vector2i = Vector2i(5,6)
const empty_jungle: Vector2i = Vector2i(6,6)
const empty_forest: Vector2i = Vector2i(7,6)

##
# World.gd is a global script that loads/unloads chunks of tiles
# depending on the player's position
##

# Ready function to start everything off
func _ready() -> void:
	# Make sure that the same seed is being used each time
	SaveLoad.rng.seed = SaveLoad.seed
	# Initialize the noise
	noise_init()
	# Get saved data if it exists from the save file
	if SaveLoad.all_chunks:
		all_chunks = SaveLoad.all_chunks
	# Initialize the chunk pool
	for i in range(max_pool_size):
		chunk_pool.append(Chunk.instantiate())
	# Create dungeon entrances
	spawn_dungeons()
	# Connect signals
	connect_signals()
	# Spawn the player
	spawn_player()
	# Make sure the start screen is rendered
	on_player_move(player.position)
	# Move the player if it's on water
	get_off_water(player)
	# Start the music
	music.play()
	#If this is the player's first time in the world...
	if PlayerStats.first_time:
		PlayerStats.first_time = false
		# Play the dialogue
		start_dialogue()

# A function to start dialogue
func start_dialogue() -> void:
	var balloon = Balloon.instantiate()
	add_child(balloon)
	balloon.start(dialogue, "start")

# A function for spawning the player
func spawn_player() -> void:
	player = Player.instantiate()
	player.position = SaveLoad.current_position
	add_child(player)

# A function to connect signals
func connect_signals() -> void:
	Events.player_move.connect(on_player_move)
	Events.dungeon_entered.connect(enter_the_dungeon)

# A function for spawning dungeons
func spawn_dungeons() -> void:
	if SaveLoad.dungeons:
		dungeons = SaveLoad.dungeons
		for i in range(1, max_dungeons+1):
			var dungeon: Dungeon_Entrance = Dungeon_Entrance.instantiate()
			dungeon.position = dungeons[i].dungeon_position
			add_child(dungeon)
			get_off_water(dungeon)
	else:
		for i in range(1, max_dungeons+1):
			var x: int
			var y: int
			if i == 1:
				x = i * 500
				y = i * 500
			else:
				x = SaveLoad.rng.randi() % WORLD_SIZE
				y = SaveLoad.rng.randi() % WORLD_SIZE
			#Debugging
#			var x: int = i * 20
#			var y: int = i * 20
			dungeons[i] = {"dungeon_position": Vector2i(x,y), "seed": (x ^ y)}
		for i in range(1, max_dungeons+1):
			var dungeon: Dungeon_Entrance = Dungeon_Entrance.instantiate()
			dungeon.position = dungeons[i].dungeon_position
			add_child(dungeon)
			get_off_water(dungeon)
		SaveLoad.dungeons = dungeons

# A function for handling noise initialization
func noise_init() -> void:
	# Start the noise by randomizing everything using the seed
	moisture.initialize(SaveLoad.moisture_seed)
	temperature.initialize(SaveLoad.temperature_seed)
	altitude.initialize(SaveLoad.altitude_seed)
	plants.initialize(SaveLoad.plant_seed)
	# Set all the values for terrain generation
	moisture.set_octaves(moisture_octaves)
	moisture.set_persistence(moisture_persistence)
	moisture.set_lacunarity(moisture_lacunarity)
	moisture.set_period(moisture_period)
	temperature.set_octaves(temperature_octaves)
	temperature.set_persistence(temperature_persistence)
	temperature.set_lacunarity(temperature_lacunarity)
	temperature.set_period(temperature_period)
	altitude.set_octaves(altitude_octaves)
	altitude.set_persistence(altitude_persistence)
	altitude.set_lacunarity(altitude_lacunarity)
	altitude.set_period(altitude_period)
	plants.set_octaves(plants_octaves)
	plants.set_persistence(plants_persistence)
	plants.set_lacunarity(plants_lacunarity)
	plants.set_period(plants_period)

# Handling the window being closed
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		PlayerStats.update_stats(player.health, player.damage, player.max_health, Vector2(player.position.x, player.position.y))
		SaveLoad.all_chunks = all_chunks
		SaveLoad.dungeons = dungeons
		for key in dungeons:
			if dungeons[key].dungeon_position == Vector2i(int(position.x), int(position.y)):
				SaveLoad.dungeon_seed = dungeons[key].seed
		SaveLoad.save_data()

# A function called every frame
func _process(_delta):
	update_health_bar()
	if PlayerStats.is_moving:
		var tile_type: String = tile_under_player(player.position)
		play_walking_sound(tile_type)

# A function to play the appropriate sound
func play_walking_sound(tile_type: String) -> void:
	match tile_type:
		"grass":
			if not grass.playing:
				grass.play()
		"dry_grass":
			if not dry_grass.playing:
				dry_grass.play()
		"sand":
			if not sand.playing:
				sand.play()
		"water":
			if not water.playing:
				water.play()
		"snow":
			if not snow.playing:
				snow.play()
		"stone":
			if not stone.playing:
				stone.play()
		"leaves":
			if not leaves.playing:
				leaves.play()
		"":
			pass

# A function to track what tile the player is on
func tile_under_player(pos: Vector2) -> String:
	var tile_pos: Vector2i = Map.get_cell_atlas_coords(0, Map.local_to_map(pos))
	if tile_pos in tile_types:
		return tile_types[tile_pos]
	else:
		return ""

# A function to calculate and update the health bar value
func update_health_bar() -> void:
	health_bar.value = ((float(SaveLoad.health) / float(SaveLoad.max_health)) * 100.0)

# A function that allows the player to enter a dungeon
func enter_the_dungeon(position: Vector2i) -> void:
	#Update player stats
	PlayerStats.update_stats(player.health, player.damage, player.max_health, Vector2(player.position.x, player.position.y + 15))
	#Save necessary data
	SaveLoad.all_chunks = all_chunks
	SaveLoad.dungeons = dungeons
	for key in dungeons:
		if dungeons[key].dungeon_position == Vector2i(int(position.x), int(position.y)):
			SaveLoad.dungeon_seed = dungeons[key].seed
	SaveLoad.next_scene = "res://Scenes/dungeon_main.tscn"
	SaveLoad.save_data()
	#Switch to the loading screen
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

# A function to add a chunk at a position
func add_chunk(x: int, y: int) -> void:
	var key: String = str(x) + "," + str(y)
	# Only add a chunk if it doesn't already exist
	if not chunks.has(key):
		load_chunk(x, y)

# Function to load a new chunk
func load_chunk(x: int, y: int) -> void:
	var new_chunk: Chunk = create_chunk(x, y)
	var key: String = str(x) + "," + str(y)
	add_child(new_chunk)
	chunks[key] = new_chunk

# Function to update player pos internal variable
func on_player_move(position: Vector2) -> void:
	player_pos = position
	determine_chunks_to_keep()
	clean_up_chunks()

# Function to determine which chunks will be kept
func determine_chunks_to_keep() -> void:
	var p_x: int = int(floor(player_pos.x / tilesize / chunk_size)) % WORLD_SIZE
	var p_y: int = int(floor(player_pos.y / tilesize / chunk_size)) % WORLD_SIZE
	var chunks_to_keep: Array[String] = []
	# Determine which chunks should be kept and add missing chunks
	for x in range(p_x - chunk_radius, p_x + chunk_radius + 1):
		for y in range(p_y - chunk_radius, p_y + chunk_radius + 1):
			var key: String = str(x * chunk_size) + "," + str(y * chunk_size)
			chunks_to_keep.append(key)
			if key not in all_chunks:
				all_chunks[key] = generate_tile_data(x * chunk_size, y * chunk_size)
			# Add a chunk if it's rendered and not in the dictionary
			if not chunks.has(key):
				add_chunk(x * chunk_size, y * chunk_size)
	# Mark chunks for removal if they're not in the chunks_to_keep list
	for key in chunks:
		if key in chunks_to_keep:
			chunks[key].should_remove = false
		else:
			chunks[key].should_remove = true

# Function that looks for a chunk to remove and removes it
func clean_up_chunks() -> void:
	for key in chunks:
		var chunk: Chunk = chunks[key]
		# If it has been marked for removal...
		if chunk.should_remove:
			# ...remove it
			chunk.visible = false
			free_chunk(chunk, key)

# Function to free chunk
func free_chunk(chunk: Chunk, key: String) -> void:
	var current_chunk: Chunk = chunk
	var current_key: String = key
	chunks.erase(current_key)
	for tile in current_chunk.tiles_to_set:
		Map.erase_cell(0, tile["position"])
		Map.erase_cell(1, tile["position"])
	return_chunk(current_chunk)

# Function to create chunk at x, y position
func create_chunk(x: int, y: int) -> Chunk:
	var new_chunk: Chunk = get_chunk()
	new_chunk.visible = true
	var key: String = str(x) + "," + str(y)
	var tile_data: Array
	if key in all_chunks:
		tile_data = all_chunks[key]
	else:
		tile_data = generate_tile_data(x * chunk_size, y * chunk_size)
	new_chunk.initialize(x, y, tile_data)
	all_chunks[key] = new_chunk.tiles_to_set
	if new_chunk.tiles_to_set:
		for tile in new_chunk.tiles_to_set:
			Map.set_cell(0, tile["position"], 0, tile["value"])
			if tile["plant"]:
				if tile["value"] == empty_grass:
					var x_value: int = SaveLoad.rng.randi_range(0,3)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 0))
				elif tile["value"] == empty_dark_grass:
					var x_value: int = SaveLoad.rng.randi_range(0,3)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 1))
				elif tile["value"] == empty_dark_dirt:
					var x_value: int = SaveLoad.rng.randi_range(0,7)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 2))
				elif tile["value"] == empty_dirt:
					var x_value: int = SaveLoad.rng.randi_range(0,7)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 3))
				elif tile["value"] == empty_grass_light or tile["value"] == empty_grass_dark:
					var x_value: int = SaveLoad.rng.randi_range(0,6)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 4))
				elif tile["value"] == empty_desert1 or tile["value"] == empty_desert2:
					var x_value: int = SaveLoad.rng.randi_range(0,9)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 5))
				elif tile["value"] == empty_sand:
					var x_value: int = SaveLoad.rng.randi_range(0,5)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 6))
				elif tile["value"] == empty_snow or tile["value"] == empty_stone:
					var x_value: int = SaveLoad.rng.randi_range(0,13)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 7))
				elif tile["value"] == empty_jungle or tile["value"] == empty_forest:
					var x_value: int = SaveLoad.rng.randi_range(0,8)
					Map.set_cell(1, tile["position"], 1, Vector2i(x_value, 8))
	return new_chunk

# Function to get noise that tiles in two dimensions
func torus_noise(nx: float, ny: float) -> Array[float]:
	if Vector2(nx, ny) not in noise_values:
		var angle_x: float = TAU * nx
		var angle_y: float = TAU * ny
		var values: Array[float] = []
		var moist: float = moisture.noise4((cos(angle_x)), (sin(angle_x)), (cos(angle_y)), (sin(angle_y)))
		var temp: float = temperature.noise4((cos(angle_x)), (sin(angle_x)), (cos(angle_y)), (sin(angle_y)))
		var alt: float = altitude.noise4((cos(angle_x)), (sin(angle_x)), (cos(angle_y)), (sin(angle_y)))
		var plant: float = plants.noise4(50*(cos(angle_x)), 50*(sin(angle_x)), 50*(cos(angle_y)), 50*(sin(angle_y)))
		values.append(moist)
		values.append(temp)
		values.append(alt)
		values.append(plant)
		noise_values[Vector2(nx, ny)] = values
		return values
	else:
		return noise_values[Vector2(nx, ny)]

# Function to generate all the tile data for a chunk
func generate_tile_data(x_pos: int, y_pos: int) -> Array[Dictionary]:
	var number_of_calls: int = 0
	var tiles_to_set: Array[Dictionary] = []
	for x in range(x_pos, x_pos + chunk_size):
		for y in range(y_pos, y_pos + chunk_size):
			var data: Dictionary = {}
			data["position"] = Vector2i(x,y)
			var x_wrapped: int = x % WORLD_SIZE
			var y_wrapped: int = y % WORLD_SIZE
			var x_scaled: float = float(x_wrapped) / float(WORLD_SIZE)
			var y_scaled: float = float(y_wrapped) / float(WORLD_SIZE)
			var noise_values: Array[float] = torus_noise(x_scaled, y_scaled)
			var moist: float = noise_values[0] * noise_norm_factor
			var temp: float = noise_values[1] * noise_norm_factor
			var alt: float = noise_values[2] * noise_norm_factor
			var plant: float = noise_values[3] * noise_norm_factor
			number_of_calls += 1
			if alt < sea_level:
				var x_value: int = round((temp) / num_sea_tiles)
				if x_value > sea_tiles_index:
					x_value = sea_tiles_index
				elif x_value < 0:
					x_value *= -1
				data["value"] = Vector2i(x_value, sea_tiles)
				if plant > plant_level:
					data["plant"] = true
				else:
					data["plant"] = false
			elif alt >= sea_level and alt < snow_level:
				var x_value: int = round(moist)
				var y_value: int = round((temp) / num_y_tiles)
				if y_value > y_tiles_index:
					y_value = y_tiles_index
				if y_value < 0:
					y_value *= -1
				if y_value == 0:
					x_value = round(x_value / num_grassland_tiles)
					if x_value > grassland_tiles_index:
						x_value = grassland_tiles_index
					elif x_value < 0:
						x_value *= -1
						if x_value > grassland_tiles_index:
							x_value = grassland_tiles_index
				elif y_value == 1:
					x_value = round(x_value / num_grassland_tiles)
					if x_value > grassland_tiles_index:
						x_value = grassland_tiles_index
					elif x_value < 0:
						x_value *= -1
						if x_value > grassland_tiles_index:
							x_value = grassland_tiles_index
				elif y_value == 2:
					x_value = round(x_value / num_grassland_tiles)
					if x_value > grassland_tiles_index:
						x_value = grassland_tiles_index
					elif x_value < 0:
						x_value *= -1
						if x_value > grassland_tiles_index:
							x_value = grassland_tiles_index
				elif y_value == 3:
					x_value = round(x_value / num_grassland_tiles)
					if x_value > grassland_tiles_index:
						x_value = grassland_tiles_index
					elif x_value < 0:
						x_value *= -1
						if x_value > grassland_tiles_index:
							x_value = grassland_tiles_index
				elif y_value == 4:
					x_value = round(x_value / num_plains_tiles)
					if x_value > plains_tiles_index:
						x_value = plains_tiles_index
					elif x_value < 0:
						x_value *= -1
						if x_value > plains_tiles_index:
							x_value = plains_tiles_index
				elif y_value == 5:
					x_value = 0
				else:
					if x_value < 0:
						x_value = swamp_index
					else:
						x_value = jungle_index
				data["value"] = Vector2i(x_value, y_value)
				if plant > plant_level:
					data["plant"] = true
				else:
					data["plant"] = false
			else:
				var x_value: float = moist
				# Normalizing the value
				x_value = clamp((x_value - min_value) / (max_value - min_value), 0, 1)
				# Mapping the normalized value to the range 3 to 5
				x_value = lerp(snow_min, snow_max, x_value)
				data["value"] = Vector2i(x_value, snow_y_index)
				if plant > plant_level:
					data["plant"] = true
				else:
					data["plant"] = false
			tiles_to_set.append(data)
	return tiles_to_set

# Function to move an object off of a water tile
func get_off_water(object: Node2D) -> void:
	var pos = Map.local_to_map(object.position)
	while Map.get_cell_atlas_coords(0, pos) in water_tiles:
		pos.x += 32
		object.position = pos
		pos = Map.local_to_map(object.position)

# Function to retrieve a chunk from the chunk pool
func get_chunk() -> Chunk:
	if chunk_pool.size() > 0:
		return chunk_pool.pop_front()
	else:
		return Chunk.instantiate()

# Function to return a chunk to the pool
func return_chunk(chunk: Chunk) -> void:
	if chunk_pool.size() < max_pool_size:
		chunk.reset()
		chunk_pool.append(chunk)
