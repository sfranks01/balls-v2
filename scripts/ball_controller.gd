# BallController.gd
extends Node2D

signal all_balls_lost

const BALL_SCENE = preload("res://scenes/Ball.tscn")
const LAUNCH_DELAY = 0.1

@onready var stats_manager = get_node("../StatsManager")

var initial_position: Vector2
var active_balls: int = 0
var preview_ball = null
var is_launching: bool = false
var last_ball_x_position: float = -1  # Store last ball's x position
var launch_position: Vector2  # Renamed from initial_position to be clearer
#@onready var launch_area_visual = ColorRect.new()
#var can_launch = true 

func _ready():
	# Set initial launch position only for the first time
	launch_position = Vector2(393/2, 852 - 25)
	last_ball_x_position = launch_position.x  # Initialize with center position
	create_preview_ball()
	#
	#launch_area_visual.color = Color(0, 1, 0, 0.2)  # Semi-transparent green
	## Position and size (making it the bottom half of the screen)
	#var viewport_size = get_viewport_rect().size
	#launch_area_visual.position = Vector2(0, viewport_size.y / 2)
	#launch_area_visual.size = Vector2(viewport_size.x, viewport_size.y / 2)
	#
	#add_child(launch_area_visual)

func create_preview_ball():
	preview_ball = BALL_SCENE.instantiate()
	add_child(preview_ball)
	preview_ball.position = Vector2(last_ball_x_position, launch_position.y)
	preview_ball.set_physics_process(false)

func start_launch_sequence(direction: Vector2):
	if is_launching:
		return
		
	if active_balls > 0:
		return
		
	is_launching = true
	preview_ball.hide()
	#launch_area_visual.hide()
	
	var launch_position = preview_ball.position
	
	for i in stats_manager.ball_count:
		launch_single_ball(direction, launch_position)
		await get_tree().create_timer(LAUNCH_DELAY).timeout
	
	is_launching = false
	
func _physics_process(delta):
	# Existing movement code...

	# Check if ball is below screen
	if position.y > 852 + 20:  # iPhone 16 height + buffer
		# Store x position in controller before destroying
		var controller = get_parent()
		controller.last_ball_x_position = position.x
		emit_signal("ball_lost")
		queue_free()


func _on_ball_lost(exit_x_position: float):  # Modified to receive the x position
	active_balls -= 1
	if active_balls <= 0:
		last_ball_x_position = exit_x_position  # Store where the ball actually exited
		emit_signal("all_balls_lost")
		preview_ball.position = Vector2(last_ball_x_position, launch_position.y)
		preview_ball.show()

func launch_single_ball(direction: Vector2, pos: Vector2):
	var new_ball = BALL_SCENE.instantiate()
	add_child(new_ball)
	new_ball.position = pos
	new_ball.launch(direction)
	active_balls += 1
	
	new_ball.connect("ball_lost", _on_ball_lost)
