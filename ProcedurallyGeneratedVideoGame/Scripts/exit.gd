extends StaticBody2D
class_name Exit

@onready var teleport_sound: AudioStreamPlayer = %TeleportSound

## Some simple variables that help to display the object in an animated way
var opacity: float = 0.0
var increment: bool = true

## For each frame of the game, check these conditions
func _physics_process(delta) -> void:
	#We will set the opacity of the text sprite and make it visible
	%portal_green.self_modulate.a = opacity
	%portal_green.visible = true
	#Next, we will slowly increment up and then decrement down the opacity
	if opacity >= 1.0:
		increment = false
	if opacity <= 0.0:
		increment = true
	if increment:
		opacity += 0.01
	else:
		opacity -= 0.01

## A function to detect bodies entering the area within the exit object
func _on_area_2d_body_entered(body) -> void:
	#If it's the player, then we can teleport back
	if body.name == "Player":
		#Play the sound
		teleport_sound.play()
		await teleport_sound.finished
		#Change scenes
		Events.emit_signal("dungeon_exited")
