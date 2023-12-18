extends CharacterBody2D
class_name Enemy

## The Enemy class that will pursue and attack the player
##
## This class contains all the different functions that control the state
## of the enemy and access it's movement, attack, stats, etc.
## !!!Replace the next part with the devlog!!!
## @tutorial:            https://the/tutorial1/url.com

## The constant speed of this enemy
const SPEED: float = 60.0

## Onready variables
@onready var ap: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var hitbox: CollisionShape2D = %HitBoxShape
@onready var hurtbox: CollisionShape2D = %HurtBoxShape
@onready var health_bar: TextureProgressBar = %EnemyHealthBar
@onready var sprite: Sprite2D = %Sprite2D
@onready var attack_sound: AudioStreamPlayer = %AttackSound
@onready var hurt_sound: AudioStreamPlayer = %HurtSound
@onready var death_sound: AudioStreamPlayer = %DeathSound

## The variables that are exported
@export var health: int = 20
@export var damage: int = 5

## Variables that track the enemy's cooldown and their target
var cooldown: int = 100
var target = null

## Other variables
var defeated: bool = false
var start_position: Vector2

## Shader variables
var sensitivity: float = 0.0
var red: float = 1.0
var increasing: bool = true

## Death audio player
var can_play: bool = true

## The ready function
func _ready() -> void:
	#Duplicate the shader so that each enemy works independently of the others
	var material_copy: Material = sprite.material.duplicate(true)
	sprite.material = material_copy
	#Set the animation tree to active so that it works
	animation_tree.active = true
	#Set the enemy's velocity to a random angled velocity
	velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * SPEED
	#Make sure that the enemy's hitbox is disabled at the beginning
	hitbox.disabled = true
	#Make sure the enemy is moving
	animation_tree["parameters/conditions/is_moving"] = true

## A function to be called on death
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
	defeated = true
	if not death_sound.playing:
		Events.emit_signal("enemy_defeated")

## The physics function called every frame of the game
func _physics_process(delta) -> void:
	#If the enemy is out of health
	if health <= 0:
		if can_play:
			can_play = false
			death_sound.play(0.4)
		death()
	#If the enemy has a target...
	if target:
		#Make sure the health bar is accurate and visible
		update_health_bar()
		health_bar.visible = true
		#Set the enemy's target to the player's position
		velocity = global_position.direction_to(target.global_position)
		move_and_collide(velocity * SPEED * delta)
		#If the enemy is within 50 pixels...
		if global_position.distance_to(target.global_position) < 50:
			#And the cooldown is larger than 25...
			if cooldown > 25:
				#Decrement the cooldown and just continue moving
				cooldown -= 1
				animation_tree["parameters/conditions/attack"] = false
				animation_tree["parameters/conditions/is_moving"] = true
			#Otherwise if the cooldown is <= 25...
			else:
				#And if the cooldown is 0 exactly...
				if cooldown == 0:
					#Reset the cooldown
					cooldown = 100
				#Otherwise, decrement the cooldown and let the state chart know to attack
				else:
					cooldown -= 1
				animation_tree["parameters/conditions/is_moving"] = false
				animation_tree["parameters/conditions/attack"] = true
		#Otherwise, continue moving towards the enemy
		else:
			animation_tree["parameters/conditions/is_moving"] = true
			animation_tree["parameters/conditions/attack"] = false
	#If there is no target...
	else:
		#Shut off the health bar
		health_bar.visible = false
		#Move
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/attack"] = false
		var collision = move_and_collide(velocity * delta)
		#If there is a collision (with a wall or another enemy)...
		if collision:
			#Then bounce away
			var bounce_velocity: Vector2 = velocity.bounce(collision.get_normal())
			velocity = bounce_velocity
	#This portion just ensures that the correct direction animation is playing
	if velocity != Vector2.ZERO:
		animation_tree["parameters/attack/blend_position"] = velocity.normalized()
		animation_tree["parameters/idle/blend_position"] = velocity.normalized()
		animation_tree["parameters/walk/blend_position"] = velocity.normalized()

## A function to update the health bar
func update_health_bar() -> void:
	health_bar.value = health * 5

## A function called whenever a body enteres the enemy's view area
func _on_view_body_entered(body) -> void:
	#If the body is a player...
	if body.name == "Player":
		#Set it as the target and move towards it
		target = body

## A function called whenever a body exits the enemy's view area
func _on_view_body_exited(body) -> void:
	#If the body was a player...
	if body.name == "Player":
		#Remove the player as a target, have the enemy stop, set the velocity 
		#to random and have it move again
		target = null
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/idle"] = true
		velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * SPEED
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/idle"] = false

## A function called whenever a body enters the enemy's hurtbox
func _on_hurt_box_area_entered(area) -> void:
	#If the area is a hitbox...
	if area.name == "HitBox":
		sprite.material.set_shader_parameter("active", true)
		#Decrement the health and let the state chart know
		health -= area.get_parent().damage
		hurt_sound.play()

## A function called whenever an area exits the enemy's hurtbox
func _on_enemy_hurt_box_area_exited(area):
	if area.name == "HitBox":
		sprite.material.set_shader_parameter("active", false)
