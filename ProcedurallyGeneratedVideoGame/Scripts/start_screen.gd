extends Control

@onready var music: AudioStreamPlayer = %StartScreenMusic
@onready var mouse_on: AudioStreamPlayer = %MouseOn
@onready var mouse_off: AudioStreamPlayer = %MouseOff
@onready var click: AudioStreamPlayer = %Click

func _ready() -> void:
	music.play()

func start_new_game() -> void:
	SaveLoad.seed = floor(Time.get_unix_time_from_system())
	SaveLoad.rng.seed = SaveLoad.seed
	SaveLoad.altitude_seed = SaveLoad.rng.randi()
	SaveLoad.temperature_seed = SaveLoad.rng.randi()
	SaveLoad.moisture_seed = SaveLoad.rng.randi()
	SaveLoad.plant_seed = SaveLoad.rng.randi()
	SaveLoad.current_position = Vector2(0,0)
	SaveLoad.next_scene = "res://Scenes/world_map_main.tscn"
	save_seed_info()
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

func load_game() -> void:
	SaveLoad.load_data()
	SaveLoad.next_scene = "res://Scenes/world_map_main.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

func _on_new_game_pressed() -> void:
	click.play()
	await click.finished
	start_new_game()

func _on_load_game_pressed() -> void:
	click.play()
	await click.finished
	load_game()

func save_seed_info() -> void:
	SaveLoad.save_data()

func _on_new_game_mouse_entered():
	mouse_on.play()

func _on_new_game_mouse_exited():
	mouse_off.play()

func _on_load_game_mouse_entered():
	mouse_on.play()

func _on_load_game_mouse_exited():
	mouse_off.play()
