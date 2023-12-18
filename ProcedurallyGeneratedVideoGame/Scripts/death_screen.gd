extends Control

@onready var music: AudioStreamPlayer = %DeathMusic
@onready var mouse_on: AudioStreamPlayer = %MouseOn
@onready var mouse_off: AudioStreamPlayer = %MouseOff
@onready var click: AudioStreamPlayer = %Click

func _ready() -> void:
	music.play()

func main_menu() -> void:
	SaveLoad.next_scene = "res://Scenes/start_screen.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

func respawn() -> void:
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.save_stats()
	SaveLoad.save_data()
	SaveLoad.load_data()
	SaveLoad.next_scene = "res://Scenes/world_map_main.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

func _on_respawn_pressed():
	click.play()
	await click.finished
	respawn()

func _on_main_menu_pressed():
	click.play()
	await click.finished
	main_menu()

func _on_respawn_mouse_entered():
	mouse_on.play()

func _on_respawn_mouse_exited():
	mouse_off.play()

func _on_main_menu_mouse_entered():
	mouse_on.play()

func _on_main_menu_mouse_exited():
	mouse_off.play()
