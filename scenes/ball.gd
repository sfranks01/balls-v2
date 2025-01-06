# Ball.gd
class_name Ball

extends CharacterBody2D

signal ball_lost(x_position: float)  # Modified to pass the x position

const SPEED: float = 800.0
const COLLISION_BOUNCE: float = 1.0
var window_size: Vector2 = DisplayServer.window_get_size()

func _ready():
	set_physics_process(false)  # Don't start moving until launched

func launch(direction: Vector2):
	velocity = direction.normalized() * SPEED
	set_physics_process(true)

func _physics_process(delta):
	# check if window size has changed
	window_size = DisplayServer.window_get_size()
	 
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		
		# Tell the collided object it was hit
		if collision.get_collider().has_method("on_ball_hit"):
			var damage_amount: int = 1
			collision.get_collider().on_ball_hit(damage_amount)
	
	# Check if ball is below screen
	if position.y > 827 + 1:  # iPhone 16 height + buffer
		emit_signal("ball_lost", position.x)  # Pass the exit position
		queue_free()
