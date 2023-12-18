class_name Chunk

extends Node2D

# Tilemap data array
var tiles_to_set: Array[Dictionary] = []

# Variables
var chunk_x: int = 0
var chunk_y: int = 0
var should_remove: bool = false

func initialize(x_pos: int, y_pos: int, tile_data: Array) -> void:
	chunk_x = x_pos
	chunk_y = y_pos
	tiles_to_set = tile_data

func reset() -> void:
	chunk_x = 0
	chunk_y = 0
	should_remove = false
	tiles_to_set = []
