# Ball.gd
class_name Ball

extends CharacterBody2D

signal ball_lost(x_position: float)  # Modified to pass the x position

var SPEED: float = 800.0
const COLLISION_BOUNCE: float = 1.0
var window_size: Vector2 = DisplayServer.window_get_size()

func _ready():
	set_physics_process(false)  # Don't start moving until launched

func launch(direction: Vector2):
	velocity = direction.normalized() * SPEED
	set_physics_process(true)

# Ball.gd
func _physics_process(delta):
	var viewport_size = get_viewport_rect().size
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		
		if collision.get_collider().has_method("on_ball_hit"):
			var damage_amount: int = 1
			collision.get_collider().on_ball_hit(damage_amount)
	
	# Check if ball is below screen using dynamic height
	if position.y > viewport_size.y + 1:
		emit_signal("ball_lost", position.x)
		queue_free()
