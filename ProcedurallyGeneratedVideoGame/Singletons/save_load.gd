extends Node

const SAVE_FILE = "user://savefile.dat"

#Game data
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var seed: int
var altitude_seed: int
var temperature_seed: int
var moisture_seed: int
var plant_seed: int

#World data
var all_chunks: Dictionary = {}

#Dungeon data
var dungeons: Dictionary = {}
var dungeon_seed: int
var dungeon_data: Dictionary = {}

#Player data
var health: int
var max_health: int
var damage: int
var current_position: Vector2
var first_time: bool

var data: Dictionary = {}

#Data to be stored, but not saved
var next_scene: String

func save_data() -> void:
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	data = {
		"seed": seed,
		"altitude_seed": altitude_seed,
		"temperature_seed": temperature_seed,
		"moisture_seed": moisture_seed,
		"plant_seed": plant_seed,
		"all_chunks": all_chunks,
		"dungeons": dungeons,
		"dungeon_seed": dungeon_seed,
		"dungeon_data": dungeon_data,
		"health": health,
		"max_health": max_health,
		"damage": damage,
		"current_position": current_position,
		"first_time": first_time
	}
	file.store_var(data)
	file = null

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_FILE):
		save_data()
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	data = file.get_var()
	seed = data.seed
	altitude_seed = data.altitude_seed
	temperature_seed = data.temperature_seed
	moisture_seed = data.moisture_seed
	plant_seed = data.plant_seed
	all_chunks = data.all_chunks
	dungeons = data.dungeons
	dungeon_seed = data.dungeon_seed
	dungeon_data = data.dungeon_data
	health = data.health
	max_health = data.max_health
	damage = data.damage
	current_position = data.current_position
	first_time = data.first_time
