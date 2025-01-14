# BallController.gd
extends Node2D

signal all_balls_lost

const BALL_SCENE = preload("res://scenes/Ball.tscn")
const LAUNCH_DELAY = 0.1

@onready var stats_manager = get_node("../StatsManager")
@onready var launch_zone: Area2D = $LaunchZone


var initial_position: Vector2
var active_balls: int = 0
var preview_ball = null
var is_launching: bool = false
var last_ball_x_position: float = -1  # Store last ball's x position
var launch_position: Vector2  # Renamed from initial_position to be clearer


# BallController.gd
func _ready():
	# Set initial launch position based on viewport size
	var viewport_size = get_viewport_rect().size
	launch_position = Vector2(
		viewport_size.x / 2,  # Center horizontally
		viewport_size.y - 25  # 25 pixels from bottom
	)
	last_ball_x_position = launch_position.x
	create_preview_ball()
	

func _physics_process(delta):
	var viewport_size = get_viewport_rect().size
	if position.y > viewport_size.y + 20:  # Screen height + buffer
		var controller = get_parent()
		controller.last_ball_x_position = position.x
		emit_signal("ball_lost")
		queue_free()

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
	launch_zone.hide()
	
	
	var launch_position = preview_ball.position
	
	for i in stats_manager.ball_count:
		launch_single_ball(direction, launch_position)
		await get_tree().create_timer(LAUNCH_DELAY).timeout
	
	is_launching = false


func _on_ball_lost(exit_x_position: float):  # Modified to receive the x position
	active_balls -= 1
	if active_balls <= 0:
		last_ball_x_position = exit_x_position  # Store where the ball actually exited
		emit_signal("all_balls_lost")
		preview_ball.position = Vector2(last_ball_x_position, launch_position.y)
		preview_ball.show()
		launch_zone.show()

func launch_single_ball(direction: Vector2, pos: Vector2):
	var new_ball = BALL_SCENE.instantiate()
	add_child(new_ball)
	new_ball.position = pos
	new_ball.launch(direction)
	active_balls += 1
	
	new_ball.connect("ball_lost", _on_ball_lost)
