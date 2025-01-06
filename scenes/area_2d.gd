extends Area2D
@onready var brick: CharacterBody2D = $".."

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("area 2d entered1")
	if body is Ball:
		print("area 2d entered")
		brick.take_damage()
