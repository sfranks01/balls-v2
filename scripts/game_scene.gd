# GameScene.gd
extends Node2D

@onready var stats_manager = $StatsManager
@onready var ball_controller = $BallController
@onready var aim_line = $AimLine
@onready var brick_controller: Node2D = $BrickController

var is_aiming = false
var aim_start_position = Vector2.ZERO
var aim_direction = Vector2.ZERO

func _ready():
	stats_manager.start_game()
	ball_controller.connect("all_balls_lost", _on_all_balls_lost)

# Input handling for aiming and launching
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start aiming
				is_aiming = true
				aim_start_position = event.position
			else:
				# Launch balls
				is_aiming = false
				aim_line.hide_line()
				if aim_direction != Vector2.ZERO:
					ball_controller.start_launch_sequence(aim_direction)

func _process(_delta):
	if is_aiming:
		# Update aim direction
		aim_direction = (aim_start_position - get_viewport().get_mouse_position()).normalized()
		aim_line.update_aim(ball_controller.preview_ball.position, aim_direction)

func _on_all_balls_lost():
	stats_manager.advance_level()
	brick_controller.advance_rows()

# Add this for debugging
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # Escape key
		print("Current Level: ", stats_manager.current_level)
		print("Ball Count: ", stats_manager.ball_count)


func _on_brick_controller_game_over() -> void:
	#restart game
	if is_instance_valid(self) and not is_queued_for_deletion():
		var tree = get_tree()
		if tree:
			tree.reload_current_scene()
