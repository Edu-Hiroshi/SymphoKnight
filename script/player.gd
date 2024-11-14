extends CharacterBody2D

@export var speed = 500
var last_direction = Vector2.ZERO
var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var is_alive = true
var is_attacking = false

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")	
	velocity = input_direction * speed
	
	if input_direction != Vector2.ZERO:
		last_direction = input_direction
	
	# horizon$maestroAnimtal movement
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

func player():
	pass
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
	enemy_attack()
	attack()
	
	if health <= 0:
		is_alive = false #add menu later
		health = 0
		print("you died")

func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown:
		health = health - 1
		enemy_attack_cooldown = false
		$attackCooldown.start()
		print(health)

func attack():
	if Input.is_action_just_pressed("attackA"):
		global.player_current_attack = true
		is_attacking = true
		$attackAnim.play("attack_A")
		$dealAttackTimer.start()
			
	elif Input.is_action_just_pressed("attackB"):
		global.player_current_attack = true
		is_attacking = true
		$attackAnim.play("attack_B")
		$dealAttackTimer.start()

func _on_player_hitbox_body_entered(body):
	if body.has_method("boss"):
		enemy_in_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("boss"):
		enemy_in_range = false

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func _on_deal_attack_timer_timeout() -> void:
	$dealAttackTimer.stop()
	global.player_current_attack = false
