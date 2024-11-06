extends CharacterBody2D

@export var speed = 400
var last_direction = Vector2.ZERO

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")	
	velocity = input_direction * speed
	
	if input_direction != Vector2.ZERO:
		last_direction = input_direction
	
	# horizontal movement
	if velocity.x != 0 and velocity.y == 0:
		$AnimatedSprite2D.play("side")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	# diagonal movement
	elif velocity.x != 0 and velocity.y < 0:
		$AnimatedSprite2D.play("up_diagonal")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.x != 0 and velocity.y > 0:
		$AnimatedSprite2D.play("down_diagonal")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	#vertical movement
	elif velocity.x == 0 and velocity.y < 0:
		$AnimatedSprite2D.play("up")
	elif velocity.x == 0 and velocity.y > 0:
		$AnimatedSprite2D.play("down")
	
	# idle
	else:
		if last_direction.y != -1:
			$AnimatedSprite2D.play("idle_down")
		else:
			$AnimatedSprite2D.play("idle_up")
		$AnimatedSprite2D.flip_h = true if last_direction.x != 1 else false 
	
func _physics_process(delta):
	get_input()
	move_and_slide()
