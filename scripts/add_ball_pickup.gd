# add_ball_pickup.gd
extends Area2D

#@onready var stats_manager: Node2D = %StatsManager
@onready var stats_manager = get_node("/root/GameScene/StatsManager")

func _ready():
	print("Stats Manager reference:", stats_manager)
	
func _on_body_entered(body):
	print("ball_collide")
	stats_manager.add_ball(1)
	queue_free()
