extends Node

var health: int
var max_health: int
var damage: int
var current_position: Vector2
var is_moving: bool = false
var first_time: bool = true

func update_stats(current_health: int, current_damage: int, current_max_health: int, position: Vector2) -> void:
	health = current_health
	damage = current_damage
	max_health = current_max_health
	current_position = position
	save_stats()

func save_stats() -> void:
	SaveLoad.health = health
	SaveLoad.max_health = max_health
	SaveLoad.damage = damage
	SaveLoad.current_position = current_position
	SaveLoad.first_time = first_time
