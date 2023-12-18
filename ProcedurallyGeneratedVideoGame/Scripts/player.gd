extends CharacterBody2D
class_name Player

## The Player class that the user will control throughout the game
##
## This class contains all the different functions that control the state
## of the player and access it's movement, attack, stats, etc.
## !!!Replace the next part with the devlog!!!
## @tutorial:            https://the/tutorial1/url.com

## Exportable variables
@export var health: int = 100
@export var max_health: int = 100
@export var damage: int = 5
@export var speed: int = 150

## OnReady variables
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox: CollisionShape2D = $HitBox/CollisionShape2D
@onready var hurtbox: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_sound: AudioStreamPlayer = %AttackSound
@onready var hurt_sound: AudioStreamPlayer = %HurtSound
@onready var death_sound: AudioStreamPlayer = %DeathSound

## Shader variables
var sensitivity: float = 0.0
var red: float = 1.0
var increasing: bool = true

## Various other variables
var direction: Vector2 = Vector2.ZERO
var is_attacking: bool = false
var can_play: bool = true

# This method handles movement
func _physics_process(_delta) -> void:
	#If the player is attacking, we don't want movement to happen
	if is_attacking:
		velocity = Vector2.ZERO
		PlayerStats.is_moving = false
	else:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
		if direction:
			velocity = direction * speed
			PlayerStats.is_moving = true
		else:
			velocity = Vector2.ZERO
			PlayerStats.is_moving = false
	move_and_slide()

# This is the ready function, ensuring that all the various component nodes of
# the player are set to their intended functionality
func _ready() -> void:
	if PlayerStats.health:
		health = PlayerStats.health
	else:
		PlayerStats.health = health
	if PlayerStats.max_health:
		max_health = PlayerStats.max_health
	else:
		PlayerStats.max_health = max_health
	if PlayerStats.damage:
		damage = PlayerStats.damage
	else:
		PlayerStats.damage = damage
	sprite.material = sprite.material.duplicate(true)
	animation_tree.active = true
	hitbox.disabled = true
	PlayerStats.save_stats()
	Events.emit_signal("player_move", global_position)

#Function for dying
func death() -> void:
	hurtbox.disabled = true
	sensitivity += 0.05
	if increasing:
		red += 0.1
	if red >= 1.0:
		increasing = false
	if not increasing:
		red -= 0.1
	if red <= 0.0:
		increasing = true
	sprite.material.set_shader_parameter("sensitivity", sensitivity)
	sprite.material.set_shader_parameter("red", red)
	if sensitivity >= 1.0:
		SaveLoad.next_scene = "res://Scenes/death_screen.tscn"
		get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

#Function to be called each frame
func _process(_delta) -> void:
	update_animation_parameters()
	if health <= 0:
		if can_play:
			can_play = false
			death_sound.play()
		death()
	if velocity != Vector2.ZERO:
		PlayerStats.is_moving = true
		Events.emit_signal("player_move", global_position)
	if PlayerStats.health != health:
		health = PlayerStats.health
	if PlayerStats.max_health != max_health:
		max_health = PlayerStats.max_health
	if PlayerStats.damage != damage:
		damage = PlayerStats.damage

## This function updates the various parameters of the animation tree so that
## the appropriate animation can play during the appropriate state
func update_animation_parameters() -> void:
	#Check to see if the player is moving, if not...
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	#If the player is moving...
	else:
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	#If the "attack" button is pressed, then play the attack animation
	if Input.is_action_just_released("attack"):
		animation_tree["parameters/conditions/attack"] = true
		if not is_attacking:
			attack_sound.play()
	else:
		animation_tree["parameters/conditions/attack"] = false
	#This portion just ensures that the correct direction animation is playing
	if direction != Vector2.ZERO:
		animation_tree["parameters/attack/blend_position"] = direction
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction

## This function checks to see if the attack animation is started, if so, then movement should stop
func _on_animation_tree_animation_started(anim_name) -> void:
	if anim_name == "attack_up" or anim_name == "attack_down" or anim_name == "attack_left" or anim_name == "attack_right":
		is_attacking = true

## This function checks to see if the attack animation has finished, if so, then movement can resume
func _on_animation_tree_animation_finished(anim_name) -> void:
	if anim_name == "attack_up" or anim_name == "attack_down" or anim_name == "attack_left" or anim_name == "attack_right":
		is_attacking = false

## A function to track damage
func _on_hurt_box_area_entered(area) -> void:
	if area.name == "EnemyHitBox":
		sprite.material.set_shader_parameter("active", true)
		health -= area.get_parent().damage
		PlayerStats.health = health
		PlayerStats.save_stats()
		hurt_sound.play()

## A function for tracking when to end the shader animation
func _on_hurt_box_area_exited(area):
	if area.name == "EnemyHitBox":
		sprite.material.set_shader_parameter("active", false)
