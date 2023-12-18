extends StaticBody2D

class_name Chest

## Onready variables
@onready var open_sound: AudioStreamPlayer = %OpenSound
@onready var drink_sound: AudioStreamPlayer = %DrinkSound
@onready var sword_sound: AudioStreamPlayer = %SwordSound

## Some simple variables that help to display the object in a more interesting way
var display_reward: bool = false
var reward_opacity: float = 0.0
var increment: bool = true
var chance: float = SaveLoad.rng.randf()

## Variable to track opened chests
var opened: bool = false
var start_position: Vector2

## For each frame of the game, check these conditions
func _physics_process(delta) -> void:
	#If display_text is true...
	if display_reward:
		#Hide the chest
		$Chest.visible = false
		$Area2D/CollisionShape2D.disabled = true
		#Figure out which reward to give
		if chance < 0.5:
			#Then set the opacity of the sprite and make it visible
			$Sword.self_modulate.a = reward_opacity
			$Sword.visible = true
		else:
			#Then set the opacity of the sprite and make it visible
			$Potion.self_modulate.a = reward_opacity
			$Potion.visible = true
		#Next, we will slowly increment up the item opacity and down the chest opacity
		if reward_opacity >= 1.0:
			increment = false
			if $Sword.visible:
				$Sword/Area2D/CollisionShape2D.disabled = false
			if $Potion.visible:
				$Potion/Area2D/CollisionShape2D.disabled = false
		if reward_opacity <= 0.0:
			increment = true
		if increment:
			reward_opacity += 0.01

func _on_area_2d_body_entered(body) -> void:
	#If it's the player, then we can start displaying the text
	if body.name == "Player":
		display_reward = true
		open_sound.play()

func _on_sword_area_2d_body_entered(body):
	if body.name == "Player":
		sword_sound.play()
		await sword_sound.finished
		PlayerStats.damage += 1
		PlayerStats.save_stats()
		opened = true
		Events.emit_signal("chest_opened")

func _on_potion_area_2d_body_entered(body):
	if body.name == "Player":
		drink_sound.play()
		await drink_sound.finished
		PlayerStats.health += 5
		PlayerStats.save_stats()
		opened = true
		Events.emit_signal("chest_opened")
