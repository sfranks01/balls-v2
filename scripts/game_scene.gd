# GameScene.gd
extends Node2D

@onready var stats_manager = $StatsManager
@onready var ball_controller = $BallController
@onready var aim_line = $AimLine
@onready var brick_controller: Node2D = $BrickController
@onready var music_player = $BackgroundChord
@onready var launch_zone = $BallController/LaunchZone  # Add this line

var is_aiming = false
var aim_start_position = Vector2.ZERO
var aim_direction = Vector2.ZERO


func _ready():
	stats_manager.start_game()
	ball_controller.connect("all_balls_lost", _on_all_balls_lost)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if click is within launch zone
				var collision_shape = launch_zone.get_node("CollisionShape2D")
				var shape_rect = Rect2(
					collision_shape.global_position - collision_shape.shape.size / 2,
					collision_shape.shape.size
				)
				
				if shape_rect.has_point(event.position):
					# Start aiming only if click is in launch zone
					is_aiming = true
					aim_start_position = event.position
			else:
				# Handle release
				if is_aiming:
					is_aiming = false
					aim_line.hide_line()
					if aim_direction != Vector2.ZERO:
						ball_controller.start_launch_sequence(aim_direction)


func _process(_delta):
	if is_aiming:
		# Update aim direction
		aim_direction = (aim_start_position - get_viewport().get_mouse_position()).normalized()
		aim_line.update_aim(ball_controller.preview_ball.position, aim_direction)
	
	## Background music, commented out for now
	#if !music_player.playing:
		#music_player.play()
		## Connect the signal only if it's not already connected
		#if !music_player.finished.is_connected(_on_music_finished):
			#music_player.finished.connect(_on_music_finished)

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
			
			
#func start_music():
	#if !music_player.playing:
		#music_player.play()
		## Connect the signal only if it's not already connected
		#if !music_player.finished.is_connected(_on_music_finished):
			#music_player.finished.connect(_on_music_finished)
#
#func _on_music_finished():
	## This will restart the music as soon as it finishes
	#music_player.play()
#
#func stop_music():
	#music_player.stop()
	## Optionally disconnect the signal if you want to fully stop looping
	#if music_player.finished.is_connected(_on_music_finished):
		#music_player.finished.disconnect(_on_music_finished)
