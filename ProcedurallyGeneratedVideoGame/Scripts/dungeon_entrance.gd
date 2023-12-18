extends Node2D

class_name Dungeon_Entrance

@onready var open_sound: AudioStreamPlayer = %OpenSound

func _on_area_2d_body_entered(body) -> void:
	if body.name == "Player":
		body.speed = 0
		open_sound.play()
		await open_sound.finished
		Events.emit_signal("dungeon_entered", Vector2i(global_position.x, global_position.y))
