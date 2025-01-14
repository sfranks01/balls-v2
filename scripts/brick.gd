# Brick.gd
extends CharacterBody2D

signal brick_destroyed(brick)
var health: int = 1
var stats_manager
@onready var health_label = $Health
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var brick_destroyed_sound: AudioStreamPlayer = $BrickDestroyedSound
var brick_destroyed_sounds = [
	preload("res://assets/sounds/d_sharp.wav"),
	preload("res://assets/sounds/g_bell.wav"),
]

func _ready():
	update_appearance()
	
func set_health(new_health: int):
	health = new_health
	update_appearance()

func on_ball_hit(damage_amount):
	health -= damage_amount
	if health <= 0:
		emit_signal("brick_destroyed", self)
		#if randf() <= 1:
			#var play_g = brick_destroyed_sounds[1].stream
			#play_g.play()
		play_random_brick_sound()
		animation_player.play("brick_destroyed")
	else:
		update_appearance()

func update_appearance():
	if health_label:
		health_label.text = str(health)
		
func play_random_brick_sound():
	# Randomly select a sound
	var random_sound = brick_destroyed_sounds[randi() % brick_destroyed_sounds.size()]
	
	# Create a new audio player
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = random_sound
	
	# Connect to free the player after it finishes
	player.finished.connect(func(): player.queue_free())
	
	# Play the sound
	player.play()
