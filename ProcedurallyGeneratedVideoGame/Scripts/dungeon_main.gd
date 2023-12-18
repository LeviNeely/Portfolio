extends Node2D

#####TODO: Fine-tune timing of everything (most everything can be a lot shorter now)

## The MainScene node that holds the dungeon world currently
##
## This node contains all the information that is needed to interact with the
## dungeon as a player. Contains all the functions needed to build and interact
## with the dungeon.
## !!!Replace the next part with the devlog!!!
## @tutorial:            https://the/tutorial1/url.com

## These are all the constant scenes that need to be preloaded to utilize
const _Room: PackedScene = preload("res://Scenes/room.tscn")
const Enemy: PackedScene = preload("res://Scenes/enemy.tscn")
const Exit: PackedScene = preload("res://Scenes/exit.tscn")
const Chest: PackedScene = preload("res://Scenes/chest.tscn")
const Player: PackedScene = preload("res://Scenes/player.tscn")
const Balloon: PackedScene = preload("res://Dialogue/balloon.tscn")
var dialogue = preload("res://Dialogue/enemy_dialogue.dialogue")

## Onready variables for nodes
@onready var Map: TileMap = %TileMap
@onready var Rooms: Node = %Rooms
@onready var HUD: CanvasLayer = %HUD
@onready var health_bar: TextureProgressBar = %PlayerHealthBar
@onready var music: AudioStreamPlayer = %DungeonMusic
@onready var walking_sound: AudioStreamPlayer = %WalkingSound

## Variables that control the tile size, number of rooms, minimum room size, 
## maximum room size, the horizontal spread of the rooms, how many rooms should
## be cut, the positions of the rooms, and the list of rooms
const tile_size: int = 16
const num_rooms: int = 35
const min_size: int = 20
const max_size: int = 30
const horizontal_spread: int = 3
const percent_cut: float = 0.69

## Variables for data to be stored
var dungeon_data: Dictionary = {}
var tile_data: Dictionary = {}
var enemy_data: Dictionary = {}
var item_data: Dictionary = {}
var chest_data: Dictionary = {}
var room_positions: Array[Vector2] = []
var rooms: Array = []

## A variable to tell the whole world when it is done rendering the dungeon
var dungeon_complete: bool = false

## The AStar pathfinding object
var path: AStar2D

## The full rectangle that will encompass all the rooms generated
var full_rect: Rect2 = Rect2()

## Two dictionaries that translate between names of tiles inside the tileset
## and their coordinates inside the tileset atlas
const tile_dict: Dictionary = {
	"EMPTY": Vector2i(-1,-1),
	"FLOOR": Vector2i(2,2),
	"WALL_BOTTOM_CENTER": Vector2i(1,4),
	"WALL_BOTTOM_LEFT_CORNER": Vector2i(0,4),
	"WALL_BOTTOM_RIGHT_CORNER": Vector2i(5,4),
	"WALL_TOP_CENTER": Vector2i(2,0),
	"WALL_TOP_LEFT_CORNER": Vector2i(0,0),
	"WALL_TOP_RIGHT_CORNER": Vector2i(5,0),
	"TOP_OF_WALL_LEFT": Vector2i(0,1),
	"TOP_OF_WALL_RIGHT": Vector2i(5,1),
	"INTERNAL_LEFT_CORNER": Vector2i(0,5),
	"INTERNAL_RIGHT_CORNER": Vector2i(3,5)
}
const dict_tile: Dictionary = {
	Vector2i(-1,-1): "EMPTY",
	Vector2i(2,2): "FLOOR",
	Vector2i(1,4): "WALL_BOTTOM_CENTER",
	Vector2i(0,4): "WALL_BOTTOM_LEFT_CORNER",
	Vector2i(5,4): "WALL_BOTTOM_RIGHT_CORNER",
	Vector2i(2,0): "WALL_TOP_CENTER",
	Vector2i(0,0): "WALL_TOP_LEFT_CORNER",
	Vector2i(5,0): "WALL_TOP_RIGHT_CORNER",
	Vector2i(0,1): "TOP_OF_WALL_LEFT",
	Vector2i(5,1): "TOP_OF_WALL_RIGHT",
	Vector2i(0,5): "INTERNAL_LEFT_CORNER",
	Vector2i(3,5): "INTERNAL_RIGHT_CORNER"
}

## A variable for item coordinates
const coords: Array[Vector2i] = [
	Vector2i(3,9), 
	Vector2i(4,9), 
	Vector2i(5,9), 
	Vector2i(6,9), 
	Vector2i(7,7), 
	Vector2i(8,6), 
	Vector2i(9,5), 
	Vector2i(9,4)
	]

## Variables for the different objects to be spawned inside the dungeon
var player: Player
var enemies: Array[Enemy] = []
var chests: Array[Chest] = []
var exit: Exit

## Random number generator
var rng: RandomNumberGenerator = SaveLoad.rng

## Signals to allow for room generation to happen correctly
signal rooms_made
signal mst_found
signal rooms_removed
signal map_made
signal items_placed
signal enemies_placed
signal walls_made
signal blanks_checked
signal walls_placed
signal path_carved

## The ready function
func _ready() -> void:
	#Set the seed for the dungeon
	SaveLoad.rng.seed = SaveLoad.dungeon_seed
	#If this dungeon has been loaded before...
	if SaveLoad.dungeon_data and SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)]:
		load_dungeon()
	else:
		generate_dungeon()
	music.play()
	start_dialogue()

## A function to load the dialogue
func start_dialogue() -> void:
	var balloon = Balloon.instantiate()
	add_child(balloon)
	balloon.start(dialogue, "start")

## A function to generate a dungeon
func generate_dungeon() -> void:
	#Make rooms
	make_rooms()
	#Allow time for everything thusfar to finish
	await rooms_made
	#Make the map and set all the pieces
	make_map()
	#Allow time for everything in the map to be made
	await map_made
	#Connect signals to methods
	connect_signals()
	#Make the HUD visible
	HUD.visible = true
	#Check to see if dungeon is done
	if dungeon_complete:
		var pos: Vector2i = Map.local_to_map(full_rect.position)
		var size = (full_rect.size / tile_size).floor()
		for x in range(0, size.x):
			for y in range(0, size.y):
				tile_data[Vector2i(x, y)] = {"position": Vector2i(pos.x+x, pos.y+y), "tile": Map.get_cell_atlas_coords(0, Vector2(pos.x+x, pos.y+y))}
		dungeon_data["tile_data"] = tile_data
		dungeon_data["enemy_data"] = enemy_data
		dungeon_data["item_data"] = item_data
		dungeon_data["chest_data"] = chest_data
		dungeon_data["rooms"] = rooms
		SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)] = dungeon_data

## A function for loading the dungeon
func load_dungeon() -> void:
	#Load all the data from the earlier load
	tile_data = SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)].tile_data
	item_data = SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)].item_data
	chest_data = SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)].chest_data
	enemy_data = SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)].enemy_data
	rooms = SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)].rooms
	#Place tiles
	for key in tile_data:
		Map.set_cell(0, tile_data[key].position, 0, tile_data[key].tile)
	#Place items
	for key in item_data:
		Map.set_cell(1, key, 0, coords[item_data[key]])
	#Place chests
	for key in chest_data:
		spawn_chests(key)
	#Place enemies
	for key in enemy_data:
		spawn_enemies(key)
	#Place the exit
	place_exit()
	#Place the player
	place_player()
	#Connecting signals
	connect_signals()
	#Save data
	dungeon_data["tile_data"] = tile_data
	dungeon_data["enemy_data"] = enemy_data
	dungeon_data["item_data"] = item_data
	dungeon_data["chest_data"] = chest_data
	dungeon_data["rooms"] = rooms
	SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)] = dungeon_data
	#Make the HUD visible
	HUD.visible = true

## A function to place the player
func place_player() -> void:
	#Place the player, set it's position in the first room, and add it as one of the children
	PlayerStats.health = SaveLoad.health
	PlayerStats.save_stats()
	SaveLoad.save_data()
	player = Player.instantiate()
	player.position = rooms.front().room_position * tile_size
	add_child(player)
	player.health = PlayerStats.health
	health_bar.value = player.health

## A function to place the exit
func place_exit() -> void:
	#Place the exit, set it's position in the center of the last room, and add it as one of the children
	exit = Exit.instantiate()
	exit.position = rooms.back().room_position * tile_size
	exit.position.x += tile_size/2
	add_child(exit)

## A function to spawn enemies
func spawn_enemies(pos: Vector2) -> void:
	var enemy: Enemy = Enemy.instantiate()
	enemy.position = pos
	enemy.start_position = pos
	enemies.append(enemy)
	add_child(enemy)

## A function to spawn chests
func spawn_chests(pos: Vector2) -> void:
	var chest: Chest = Chest.instantiate()
	chest.position = pos
	chest.start_position = pos
	chests.append(chest)
	add_child(chest)

## A function to connect signals
func connect_signals() -> void:
	#Connect signals to methods
	Events.dungeon_exited.connect(exit_the_dungeon)
	Events.enemy_defeated.connect(on_enemy_defeat)
	Events.chest_opened.connect(on_chest_opened)

## A function that updates every frame
func _process(_delta) -> void:
	update_health_bar()
	walk_noise()

## A function to play the walking sound
func walk_noise() -> void:
	if PlayerStats.is_moving:
		if not walking_sound.playing:
			walking_sound.play()

## A function to update the health bar
func update_health_bar() -> void:
	health_bar.value = ((float(PlayerStats.health) / float(PlayerStats.max_health)) * 100.0)

## A function called when an enemy is defeated
func on_enemy_defeat() -> void:
	var index: int = 0
	for enemy in enemies:
		if enemy.defeated:
			enemy_data.erase(enemy.start_position)
			enemies.remove_at(index)
			enemy.queue_free()
		index += 1

## A function called when a chest is opened
func on_chest_opened() -> void:
	var index: int = 0
	for chest in chests:
		if chest.opened:
			chest_data.erase(chest.start_position)
			chests.remove_at(index)
			chest.queue_free()
		index += 1

## The function that takes us out of the dungeon
func exit_the_dungeon() -> void:
	PlayerStats.health = player.health
	PlayerStats.damage = player.damage
	PlayerStats.save_stats()
	SaveLoad.health = PlayerStats.health
	SaveLoad.next_scene = "res://Scenes/world_map_main.tscn"
	dungeon_data["tile_data"] = tile_data
	dungeon_data["enemy_data"] = enemy_data
	dungeon_data["item_data"] = item_data
	dungeon_data["chest_data"] = chest_data
	dungeon_data["rooms"] = rooms
	SaveLoad.dungeon_data[str(SaveLoad.dungeon_seed)] = dungeon_data
	SaveLoad.save_data()
	SaveLoad.rng.seed = SaveLoad.seed
	HUD.visible = false
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

## The function that creates all the room nodes
func make_rooms() -> void:
	for i in range(num_rooms):
		#Selects a random position within the horizontal spread variable
		var pos: Vector2 = Vector2(rng.randf_range(-horizontal_spread, horizontal_spread), 0)
		#Instances a room node, sets the width and height, then creates the room
		var r: Room = _Room.instantiate()
		var w: int = min_size + rng.randi() % (max_size - min_size)
		var h: int = min_size + rng.randi() % (max_size - min_size)
		r.make_room(pos, (Vector2(w, h) * tile_size))
		#This adds the room into the rooms node, acting sort of as an array
		Rooms.add_child(r)
	#Wait for rooms to spread out
	await get_tree().create_timer(0.2).timeout
	#Cut rooms we don't want
	remove_rooms()
	await get_tree().create_timer(0.01).timeout
	for i in Rooms.get_children():
		if not is_instance_valid(i):
			continue
		i.freeze = true
	#Generate minimum spanning tree connecting all the rooms
	path = await find_mst(room_positions)
	emit_signal("rooms_made")

## A function that calculates the AStar path using Prim's algorithm
func find_mst(nodes: Array) -> AStar2D:
	#Use prim's algorithm
	var pathway: AStar2D = AStar2D.new()
	pathway.add_point(pathway.get_available_point_id(), nodes.pop_front())
	#Repeat the algorithm until no more nodes remain
	while nodes:
		var min_distance = INF #Minimum distance so far
		var min_position = null #Position of the current node
		var current_position = null #Current position
		#Loop through all points in path
		for point in pathway.get_point_ids():
			var point1 = pathway.get_point_position(point)
			#Loop through remaining nodes
			for point2 in nodes:
				if point1.distance_to(point2) < min_distance:
					min_distance = point1.distance_to(point2)
					min_position = point2
					current_position = point1
		#Now that we have the distances we can calculate pathways
		var neighbor: int = pathway.get_available_point_id()
		pathway.add_point(neighbor, min_position)
		pathway.connect_points(pathway.get_closest_point(current_position), neighbor)
		nodes.erase(min_position)
	emit_signal("mst_found")
	#Return the completed AStar pathway
	return pathway

## A function that cuts rooms that won't be necessary
func remove_rooms() -> void:
	for room in Rooms.get_children():
		if not is_instance_valid(room):
			continue
		if rng.randf() < percent_cut:
			room.queue_free()
		else:
			#Here we add the positions of the rooms to use in the AStar path later
			room_positions.append(Vector2(room.position.x, room.position.y))
	emit_signal("rooms_removed")

## The main driving function in creating the map that the user will interact with
func make_map() -> void:
	#Create a TileMap from the generated rooms and paths
	#Start by clearing the map
	Map.clear()
	#Carve rooms
	var corridors: Array = []
	for room in Rooms.get_children():
		if not is_instance_valid(room):
			continue
		var size = (room.size / tile_size).floor()
		var pos = Map.local_to_map(room.position)
		#Store the room data (size, position, and number of enemies) inside the array of rooms
		rooms.append({room_size = Vector2(size.x, size.y), room_position = pos, num_enemies = 0})
		#This changes the position to be beginning at the top left corner instead of the center
		pos = Vector2(pos.x - int(size.x / 2), pos.y - int(size.y / 2))
		for x in range(2, size.x - 2):
			for y in range(2, size.y - 2):
				#Set each cell as a floor tile, since it will map out the floor of the dungeon rooms
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y), 0, tile_dict["FLOOR"])
		#Carve connecting corridors
		var p = path.get_closest_point(Vector2(room.position.x, room.position.y))
		for conn in path.get_point_connections(p):
			#This makes sure we don't carve multiple corridors between multiple rooms
			if not conn in corridors:
				var start = Map.local_to_map(path.get_point_position(p))
				var end = Map.local_to_map(path.get_point_position(conn))
				#Carve the path, place the tiles
				await carve_path(start, end)
		corridors.append(p)
	#Now we can go ahead and remove all the shapes of the rooms, so they don't collide with other
	#collision shapes, otherwise our player wouldn't be able to move and walls wouldn't be able to
	#be placed
	for room in Rooms.get_children():
		if not is_instance_valid(room):
			continue
		for shape in room.get_children():
			shape.queue_free()
	#Make the walls for the rooms
	await make_walls()
	#Wait for just a second to make sure everything is done
	await get_tree().create_timer(0.1).timeout
	#Place the exit
	place_exit()
	#Place enemies inside the dungeon
	await place_enemies(rooms)
	#Place items/decorations and chests in the dungeon
	await place_items(rooms)
	#Place the player
	place_player()
	#Tell the world that the dungeon is finished
	dungeon_complete = true
	emit_signal("map_made")

## A function to place items inside the dungeon map
func place_items(rooms: Array) -> void:
	var coords_size: int = coords.size()
	var last_room: int = rooms.size() - 1
	var index: int = 0
	for room in rooms:
		#Check to see the "difficulty" of the room, if it's over a threshold, then place a chest
		if room.num_enemies >= 2 and index != last_room:
			var chest: Chest = Chest.instantiate()
			chest.position = room.room_position * tile_size
			add_child(chest)
			chest.start_position = chest.position
			chests.append(chest)
			chest_data[chest.start_position] = chest.opened
		#Run this code for each one of the four corners of a room
		for i in range(4):
			var chance: float = rng.randf_range(0, 1)
			#50% chance to place items
			if chance >= 0.50:
				#Top left corner
				if i == 0:
					var pos1: Vector2 = Vector2(room.room_position.x - (room.room_size.x / 2), room.room_position.y - (room.room_size.y / 2)) + Vector2(3, 3)
					var pos2: Vector2 = Vector2(room.room_position.x - (room.room_size.x / 2), room.room_position.y - (room.room_size.y / 2) + (rng.randi() % 4 + 1)) + Vector2(3, 3)
					var pos3: Vector2 = Vector2(room.room_position.x - (room.room_size.x / 2) + (rng.randi() % 4 + 1), room.room_position.y - (room.room_size.y / 2)) + Vector2(3, 3)
					var coords1: int = rng.randi() % coords_size
					var coords2: int = rng.randi() % coords_size
					var coords3: int = rng.randi() % coords_size
					Map.set_cell(1, pos1, 0, coords[coords1])
					Map.set_cell(1, pos2, 0, coords[coords2])
					Map.set_cell(1, pos3, 0, coords[coords3])
					item_data[pos1] = coords1
					item_data[pos2] = coords2
					item_data[pos3] = coords3
				#Top right corner
				elif i == 1:
					var pos1: Vector2 = Vector2(room.room_position.x + (room.room_size.x / 2), room.room_position.y - (room.room_size.y / 2)) + Vector2(-3, 3)
					var pos2: Vector2 = Vector2(room.room_position.x + (room.room_size.x / 2), room.room_position.y - (room.room_size.y / 2) + (rng.randi() % 4 + 1)) + Vector2(-3, 3)
					var pos3: Vector2 = Vector2(room.room_position.x + (room.room_size.x / 2) - (rng.randi() % 4 + 1), room.room_position.y - (room.room_size.y / 2)) + Vector2(-3, 3)
					var coords1: int = rng.randi() % coords_size
					var coords2: int = rng.randi() % coords_size
					var coords3: int = rng.randi() % coords_size
					Map.set_cell(1, pos1, 0, coords[coords1])
					Map.set_cell(1, pos2, 0, coords[coords2])
					Map.set_cell(1, pos3, 0, coords[coords3])
					item_data[pos1] = coords1
					item_data[pos2] = coords2
					item_data[pos3] = coords3
				#Bottom left corner
				elif i == 2:
					var pos1: Vector2 = Vector2(room.room_position.x - (room.room_size.x / 2), room.room_position.y + (room.room_size.y / 2)) + Vector2(3, -3)
					var pos2: Vector2 = Vector2(room.room_position.x - (room.room_size.x / 2), room.room_position.y + (room.room_size.y / 2) - (rng.randi() % 4 + 1)) + Vector2(3, -3)
					var pos3: Vector2 = Vector2(room.room_position.x - (room.room_size.x / 2) + (rng.randi() % 4 + 1), room.room_position.y + (room.room_size.y / 2)) + Vector2(3, -3)
					var coords1: int = rng.randi() % coords_size
					var coords2: int = rng.randi() % coords_size
					var coords3: int = rng.randi() % coords_size
					Map.set_cell(1, pos1, 0, coords[coords1])
					Map.set_cell(1, pos2, 0, coords[coords2])
					Map.set_cell(1, pos3, 0, coords[coords3])
					item_data[pos1] = coords1
					item_data[pos2] = coords2
					item_data[pos3] = coords3
				#Bottom right corner
				else:
					var pos1: Vector2 = Vector2(room.room_position.x + (room.room_size.x / 2), room.room_position.y + (room.room_size.y / 2)) + Vector2(-3, -3)
					var pos2: Vector2 = Vector2(room.room_position.x + (room.room_size.x / 2), room.room_position.y + (room.room_size.y / 2) - (rng.randi() % 4 + 1)) + Vector2(-3, -3)
					var pos3: Vector2 = Vector2(room.room_position.x + (room.room_size.x / 2) - (rng.randi() % 4 + 1), room.room_position.y + (room.room_size.y / 2)) + Vector2(-3, -3)
					var coords1: int = rng.randi() % coords_size
					var coords2: int = rng.randi() % coords_size
					var coords3: int = rng.randi() % coords_size
					Map.set_cell(1, pos1, 0, coords[coords1])
					Map.set_cell(1, pos2, 0, coords[coords2])
					Map.set_cell(1, pos3, 0, coords[coords3])
					item_data[pos1] = coords1
					item_data[pos2] = coords2
					item_data[pos3] = coords3
		index += 1
	emit_signal("items_placed")

## A function that places enemies inside the dungeon map
func place_enemies(rooms: Array) -> void:
	var first_room: bool = false
	var index: int = 1
	var min: int = 1
	for room in rooms:
		#If this is the first room, we don't want to place any enemies, since this is the player's
		#start area inside the dungeon
		if !first_room:
			first_room = true
			continue
		#This bit of code helps to determine the "difficulty" of the various rooms. As the number of rooms
		#increases, so does the index aka the max number of enemies that could be spawned. There is also
		#a chance that the minimum number of enemies could also be increased, so as the player gets closer
		#to the end of the dungeon, the difficulty via the number of enemies will also get larger over time
		var num_enemies: int = (rng.randi() % index) + min
		room.num_enemies = num_enemies
		index += 1
		if rng.randf_range(0, 1) > 0.95:
			min += 1
		#Create enemies for the room
		for i in range(num_enemies):
			var enemy: Enemy = Enemy.instantiate()
			var x: int = rng.randi() % int(room.room_size.x / 4)
			var y: int = rng.randi() % int(room.room_size.y / 4)
			enemy.position = Vector2(room.room_position.x + x, room.room_position.y + y) * tile_size
			add_child(enemy)
			enemy.start_position = enemy.position
			enemies.append(enemy)
			enemy_data[enemy.start_position] = enemy.defeated
	emit_signal("enemies_placed")

## A function that creates the walls for a room
func make_walls() -> void:
	#First we need to get a rectangle that gets the entired of the map in its scope
	for room in Rooms.get_children():
		if not is_instance_valid(room):
			continue
		var r: Rect2 = Rect2(room.position - (room.size), room.size*2)
		full_rect = full_rect.merge(r)
	#Now we get the position and the size set so that it fits within the tile size
	#of the tileset as well as starts us from the top left corner
	var pos: Vector2i = Map.local_to_map(full_rect.position)
	var size = (full_rect.size / tile_size).floor()
	#We now check for single blank spaces and fix those
	for y in range(0, size.y):
		for x in range(0, size.x):
			await check_for_single_blanks(x, y, pos, Vector2(pos.x+x, pos.y+y))
	#We check another time for single blank spaces and fix those
	for y in range(0, size.y):
		for x in range(0, size.x):
			await check_for_single_blanks(x, y, pos, Vector2(pos.x+x, pos.y+y))
	#Place walls
	for y in range(0, size.y):
		for x in range(0, size.x):
			await check_and_place_walls(x, y, pos, Vector2(pos.x+x, pos.y+y))
	emit_signal("walls_made")

## A function to check for single blank spaces and fix them
func check_for_single_blanks(x, y, pos, current_cell_position) -> void:
	#First we get the current tile from the tile dictionary
	var current_tile = dict_tile[Map.get_cell_atlas_coords(0, current_cell_position)]
	#If the current tile is empty...
	if current_tile == "EMPTY":
		#Then we check for the top, right, bottom, and left tiles
		var top = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x, pos.y+y-1))]
		var right = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x+1, pos.y+y))]
		var bottom = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x, pos.y+y+1))]
		var left = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x-1, pos.y+y))]
		#This handles the case where there is a long single horizontal blank space
		if top == "FLOOR" and bottom == "FLOOR" and right == "EMPTY" and left == "EMPTY":
			Map.set_cell(0, Vector2(pos.x+x, pos.y+y), 0, tile_dict["FLOOR"])
		#This handles the case where there is a long single vertical blank space
		elif top == "EMPTY" and bottom == "EMPTY" and right == "FLOOR" and left == "FLOOR":
			Map.set_cell(0, Vector2(pos.x+x, pos.y+y), 0, tile_dict["FLOOR"])
		#This handles the case where only the current tile is a single blank space
		elif top == "FLOOR" and bottom == "FLOOR" and right == "FLOOR" and left == "FLOOR":
			Map.set_cell(0, Vector2(pos.x+x, pos.y+y), 0, tile_dict["FLOOR"])
	#If the current tile is a floor...
	elif current_tile == "FLOOR":
		#Check all the eight directions
		var top = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x, pos.y+y-1))]
		var top_right = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x+1, pos.y+y-1))]
		var right = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x+1, pos.y+y))]
		var bottom = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x, pos.y+y+1))]
		var bottom_right = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x+1, pos.y+y+1))]
		var left = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x-1, pos.y+y))]
		var bottom_left = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x-1, pos.y+y+1))]
		var top_left = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x-1, pos.y+y-1))]
		#This handles the case of a single bottom blank space
		if right == "FLOOR" and left == "FLOOR" and bottom_right == "FLOOR" and bottom_left == "FLOOR" and bottom != "FLOOR":
			Map.set_cell(0, Vector2(pos.x+x, pos.y+y+1), 0, tile_dict["FLOOR"])
		#This handles the case of a single left blank space
		if top == "FLOOR" and bottom == "FLOOR" and bottom_left == "FLOOR" and top_left == "FLOOR" and left != "FLOOR":
			Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y), 0, tile_dict["FLOOR"])
		#This handles the case of a single top blank space
		if right == "FLOOR" and left == "FLOOR" and top_right == "FLOOR" and top_left == "FLOOR" and top != "FLOOR":
			Map.set_cell(0, Vector2(pos.x+x, pos.y+y-1), 0, tile_dict["FLOOR"])
		#This handles the case of a single right blank space
		if top == "FLOOR" and bottom == "FLOOR" and bottom_right == "FLOOR" and top_right == "FLOOR" and right != "FLOOR":
			Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y), 0, tile_dict["FLOOR"])
	emit_signal("blanks_checked")

## A function to place wall tiles for the dungeon map
func check_and_place_walls(x, y, pos, current_cell_position) -> void:
	#Get the current tile from the tile dictionary
	var current_tile = dict_tile[Map.get_cell_atlas_coords(0, current_cell_position)]
	#If the current tile is a floor...
	if current_tile == "FLOOR":
		#Get all eight of its directions
		var top = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x, pos.y+y-1))]
		var top_right = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x+1, pos.y+y-1))]
		var right = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x+1, pos.y+y))]
		var bottom = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x, pos.y+y+1))]
		var bottom_right = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x+1, pos.y+y+1))]
		var left = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x-1, pos.y+y))]
		var bottom_left = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x-1, pos.y+y+1))]
		var top_left = dict_tile[Map.get_cell_atlas_coords(0, Vector2(pos.x+x-1, pos.y+y-1))]
		#If the right is empty...
		if right == "EMPTY":
			#If the bottom is empty, then it is a bottom right corner
			if bottom == "EMPTY":
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_CENTER"])
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_RIGHT_CORNER"])
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y), 0, tile_dict["TOP_OF_WALL_RIGHT"])
			#Otherwise if the top is empty...
			elif top == "EMPTY":
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y), 0, tile_dict["TOP_OF_WALL_RIGHT"])
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y-1), 0, tile_dict["WALL_TOP_RIGHT_CORNER"])
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y-1), 0, tile_dict["WALL_TOP_CENTER"])
			#Otherwise this is a right wall
			else:
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y), 0, tile_dict["TOP_OF_WALL_RIGHT"])
		#If the right is a floor...
		if right == "FLOOR":
			#If the top is a floor...
			if top == "FLOOR":
				#If the top right is not a floor, then this is a top right corner
				if top_right != "FLOOR":
					Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y-1), 0, tile_dict["WALL_TOP_CENTER"])
				#If the top right is a floor and the bottom is a floor...
				elif bottom == "FLOOR":
					#If the bottom right is not a floor, then this is a top left corner
					if bottom_right != "FLOOR":
						Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y+1), 0, tile_dict["INTERNAL_LEFT_CORNER"])
		#If the right is not a floor and the top is not a floor and the top right is empty, then this
		#is a top right corner
		if right != "FLOOR" and top != "FLOOR" and top_right == "EMPTY":
			Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y-1), 0, tile_dict["TOP_OF_WALL_RIGHT"])
		#Do the same checks as before, but on the left side
		if left == "EMPTY":
			if bottom == "EMPTY":
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_CENTER"])
				Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_LEFT_CORNER"])
				Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y), 0, tile_dict["TOP_OF_WALL_LEFT"])
			#Otherwise if the top is empty...
			elif top == "EMPTY":
				Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y), 0, tile_dict["TOP_OF_WALL_LEFT"])
				Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y-1), 0, tile_dict["WALL_TOP_LEFT_CORNER"])
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y-1), 0, tile_dict["WALL_TOP_CENTER"])
			#Otherwise this is a left wall
			else:
				Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y), 0, tile_dict["TOP_OF_WALL_LEFT"])
		if left == "FLOOR":
			if top == "FLOOR":
				if top_left != "FLOOR":
					Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y-1), 0, tile_dict["WALL_TOP_CENTER"])
				elif bottom == "FLOOR":
					if bottom_left != "FLOOR":
						Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y+1), 0, tile_dict["INTERNAL_RIGHT_CORNER"])
		if left != "FLOOR" and top != "FLOOR" and top_left == "EMPTY":
			Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y-1), 0, tile_dict["TOP_OF_WALL_LEFT"])
		#Now check for top and bottom situations
		if top == "EMPTY":
			if top_right == "FLOOR":
				Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y), 0, tile_dict["TOP_OF_WALL_LEFT"])
				Map.set_cell(0, Vector2(pos.x+x-1, pos.y+y-1), 0, tile_dict["TOP_OF_WALL_LEFT"])
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y-1), 0, tile_dict["WALL_TOP_CENTER"])
			elif top_left == "FLOOR":
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y), 0, tile_dict["TOP_OF_WALL_RIGHT"])
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y-1), 0, tile_dict["TOP_OF_WALL_RIGHT"])
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y-1), 0, tile_dict["WALL_TOP_CENTER"])
			else:
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y-1), 0, tile_dict["WALL_TOP_CENTER"])
		if bottom == "EMPTY":
			if bottom_right == "FLOOR":
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_CENTER"])
			elif bottom_left == "FLOOR":
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_CENTER"])
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_RIGHT_CORNER"])
				Map.set_cell(0, Vector2(pos.x+x+1, pos.y+y), 0, tile_dict["TOP_OF_WALL_RIGHT"])
			else:
				Map.set_cell(0, Vector2(pos.x+x, pos.y+y+1), 0, tile_dict["WALL_BOTTOM_CENTER"])
	emit_signal("walls_placed")

## A function to carve out a bath between two rooms
func carve_path(pos1, pos2) -> void:
	if pos1 == pos2:
		return
	#First we find the difference between the two x and y positions
	var x_diff: int = sign(pos2.x - pos1.x)
	var y_diff: int = sign(pos2.y - pos1.y)
	#If either of those are 0, aka the x or y are the same, then we assign them an x or y difference
	if x_diff ==0:
		x_diff = pow(-1.0, randi() % 2)
	if y_diff ==0:
		y_diff = pow(-1.0, randi() % 2)
	#Randomly choose either x then y or y then x
	var x_y: Vector2 = pos1
	var y_x: Vector2 = pos2
	if randi() % 2 > 0:
		x_y = pos2
		y_x = pos1
	#Place the floor tiles in a two-wide column or row
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(0, Vector2i(x, x_y.y), 0, tile_dict["FLOOR"])
		Map.set_cell(0, Vector2i(x, x_y.y + y_diff), 0, tile_dict["FLOOR"])
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(0, Vector2i(y_x.x, y), 0, tile_dict["FLOOR"])
		Map.set_cell(0, Vector2i(y_x.x + x_diff, y), 0, tile_dict["FLOOR"])
	emit_signal("path_carved")

## Handling the window closing
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		PlayerStats.health = player.health
		PlayerStats.damage = player.damage
		PlayerStats.save_stats()
		SaveLoad.save_data()
