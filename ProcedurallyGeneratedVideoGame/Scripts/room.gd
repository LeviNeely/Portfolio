extends RigidBody2D

class_name Room

## The Room node that helps to generate the rooms inside the dungeon
##
## This node allows us to create nodes that - due to it's RigidBody2D properties
## - interact in such a way to spread out when they have a collision shape
## !!!Replace the next part with the devlog!!!
## @tutorial:            https://the/tutorial1/url.com

var size: Vector2

## A function that creates the collision shape for the room node
func make_room(_pos: Vector2, _size: Vector2) -> void:
	position = _pos
	size = _size
	var s: RectangleShape2D = RectangleShape2D.new()
	s.set_size(size)
	%CollisionShape2D.shape = s
