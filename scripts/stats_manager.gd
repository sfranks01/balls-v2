# StatsManager.gd
extends Node

# Signals
signal level_changed(new_level)
signal score_changed(new_score)
signal balls_changed(new_count)
signal game_over
signal game_started

# Game state
enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

@onready var score_label: Label = $ScoreLabel

# Properties
var current_state: GameState = GameState.MENU
var current_level: int = 1
var current_score: int = 0
var high_score: int = 0
var ball_count: int = 1


func _ready():
	load_high_score()

func start_game():
	current_state = GameState.PLAYING
	current_level = 1
	ball_count = 1
	score_label.text = "Score: " + str(current_level)
	emit_signal("game_started")

func advance_level():
	current_level += 1
	ball_count += 1
	score_label.text = "Score: " + str(current_level)
	emit_signal("level_changed", current_level)
	emit_signal("balls_changed", ball_count)

# StatsManager.gd
func get_brick_health() -> int:
	# 80% chance for level health, 20% chance for double level health
	if randf() <= 0.8:
		return current_level
	else:
		return current_level * 2

func is_playing() -> bool:
	return current_state == GameState.PLAYING

func save_high_score():
	var save_data = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	save_data.store_var(high_score)

func load_high_score():
	if FileAccess.file_exists("user://highscore.save"):
		var save_data = FileAccess.open("user://highscore.save", FileAccess.READ)
		high_score = save_data.get_var()
