# LaunchZone.gd
extends Area2D

signal launch_requested(direction: Vector2)

var drag_start: Vector2
var is_dragging: bool = false

func _ready():
	input_pickable = true
	
	# Create collision shape
	var shape = RectangleShape2D.new()
	# Adjust these values based on your game's needs
	shape.size = Vector2(393, 200)  # Using your window width
	
	var collision = CollisionShape2D.new()
	collision.shape = shape
	collision.position = Vector2(shape.size.x / 2, 852 - shape.size.y / 2)  # Positioning near your launch height
	add_child(collision)

func _input_event(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_start = event.position
				is_dragging = true
			elif is_dragging:
				is_dragging = false
				var direction = drag_start - event.position
				if direction.length() > 10:  # Minimum drag distance
					launch_requested.emit(direction)

func _input(event):
	# Cancel drag if mouse leaves area
	if event is InputEventMouseMotion and is_dragging:
		if !Rect2(position, get_node("CollisionShape2D").shape.size).has_point(event.position):
			is_dragging = false
