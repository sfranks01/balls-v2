# LaunchZone.gd
extends Area2D

# Instead of a custom signal, we'll directly call start_launch_sequence
@onready var ball_controller = get_parent()

var drag_start: Vector2
var is_dragging: bool = false

func _ready():
	input_pickable = true
	
	# Create the collision shape
	setup_collision_shape()
	
	# Optional: Add visual feedback for debugging
	if OS.is_debug_build():
		add_debug_visual()

func setup_collision_shape():
	var viewport_size = get_viewport_rect().size
	var shape = RectangleShape2D.new()
	# Make the launch zone the bottom half of the screen
	shape.size = Vector2(viewport_size.x, viewport_size.y / 2)
	
	var collision = CollisionShape2D.new()
	collision.set_name("CollisionShape2D")
	collision.shape = shape
	collision.position = Vector2(
		viewport_size.x / 2,
		viewport_size.y - (shape.size.y / 2)
	)
	add_child(collision)

func add_debug_visual():
	var collision_shape = get_node("CollisionShape2D")
	var debug_rect = ColorRect.new()
	debug_rect.set_name("DebugVisual")
	debug_rect.size = collision_shape.shape.size
	debug_rect.position = collision_shape.position - debug_rect.size / 2
	debug_rect.color = Color(0, 1, 0, 0.2)
	add_child(debug_rect)

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
					ball_controller.start_launch_sequence(direction)

func _input(event):
	if event is InputEventMouseMotion and is_dragging:
		var collision_shape = get_node("CollisionShape2D")
		var shape_rect = Rect2(
			collision_shape.global_position - collision_shape.shape.size / 2,
			collision_shape.shape.size
		)
		if !shape_rect.has_point(event.position):
			is_dragging = false
