# AimLine.gd
extends Line2D

func _ready():
	# Initialize line properties
	width = 2.0
	default_color = Color.WHITE
	clear_points()

func update_aim(start_pos: Vector2, direction: Vector2):
	clear_points()
	add_point(start_pos)
	add_point(start_pos + direction * 400)  # Line length of 400 pixels

func hide_line():
	clear_points()
