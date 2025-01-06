# Brick.gd
extends CharacterBody2D

signal brick_destroyed(brick)
var health: int = 1
var stats_manager
@onready var health_label = $Health

func _ready():
	update_appearance()
	
func set_health(new_health: int):
	health = new_health
	update_appearance()

func on_ball_hit(damage_amount):
	health -= damage_amount
	if health <= 0:
		emit_signal("brick_destroyed", self)
		queue_free()
	else:
		update_appearance()

func update_appearance():
	if health_label:
		health_label.text = str(health)
