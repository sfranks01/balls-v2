# WallController.gd
extends Node2D

const WALL_THICKNESS: int = 0


func _ready():
	setup_walls()	

func setup_walls():
	var viewport_size = get_viewport().get_visible_rect().size
	var window_width: int = viewport_size.x
	var window_height: int = viewport_size.y
	
	# Left Wall
	create_wall(
		Vector2(0, window_height/2), 
		Vector2(WALL_THICKNESS, window_height)
	)
	
	# Right Wall
	create_wall(
		Vector2(window_width, window_height/2),
		Vector2(WALL_THICKNESS, window_height)
	)
	
	# Top Wall
	create_wall(
		Vector2(window_width/2, 0),
		Vector2(window_width, WALL_THICKNESS)
	)
	return [window_width,window_height]

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
