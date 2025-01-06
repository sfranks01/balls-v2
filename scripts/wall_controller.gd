# WallController.gd
extends Node2D

const WINDOW_WIDTH: int = 393
const WINDOW_HEIGHT: int = 852
const WALL_THICKNESS: int = 0

func _ready():
	setup_walls()

func setup_walls():
	# Left Wall
	create_wall(
		Vector2(0, WINDOW_HEIGHT/2), 
		Vector2(WALL_THICKNESS, WINDOW_HEIGHT)
	)
	
	# Right Wall
	create_wall(
		Vector2(WINDOW_WIDTH, WINDOW_HEIGHT/2),
		Vector2(WALL_THICKNESS, WINDOW_HEIGHT)
	)
	
	# Top Wall
	create_wall(
		Vector2(WINDOW_WIDTH/2, 0),
		Vector2(WINDOW_WIDTH, WALL_THICKNESS)
	)

func return_window_height():
	return WINDOW_HEIGHT

func return_window_width():
	return WINDOW_WIDTH

func create_wall(pos: Vector2, size: Vector2):
	var wall = StaticBody2D.new()
	add_child(wall)
	
	var collision = CollisionShape2D.new()
	wall.add_child(collision)
	
	var shape = RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	
	wall.position = pos
	
	return wall
