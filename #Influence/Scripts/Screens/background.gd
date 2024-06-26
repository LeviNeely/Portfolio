extends Control

var one_click: bool = false

func _ready() -> void:
	TurnData.load_data()

func _on_texture_button_button_up() -> void:
	ButtonClick.play()
	if one_click:
		get_tree().change_scene_to_file("res://Scenes/Screens/splash_screen.tscn")
	else:
		one_click = true

func _on_texture_button_mouse_entered() -> void:
	ButtonHover.play()
