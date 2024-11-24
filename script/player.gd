extends CharacterBody2D

@export var speed = 500
var health = 100
var contact_damage = 1
var boss_attack_damage = 5
var heal = 5

var last_direction = Vector2.ZERO
var enemy_contact = false
var enemy_in_attack_range = false
var enemy_contact_cooldown = true
var enemy_attack_cooldown = true
var is_alive = true
var is_dodging = false
var dodge_cooldown = false

func _physics_process(_delta):
	move()
	dodge()
	move_and_slide()
	damaging()
	attack()
	update_healthbar()
	
	if health <= 0:
		is_alive = false #add menu later
		health = 0
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func move():
	var input_direction = Input.get_vector("left", "right", "up", "down")	
	velocity = input_direction * speed
	
	if is_dodging:
		velocity = velocity * 3
	
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

func damaging():
	if global.boss_attack_type == global.player_attack_type and global.player_current_attack and \
	   global.boss_current_attack and enemy_attack_cooldown:
		health += heal
		enemy_attack_cooldown = false
		$bossAttackCooldown.start()
	
	elif global.boss_current_attack and enemy_attack_cooldown and enemy_in_attack_range:
		health -= boss_attack_damage
		enemy_attack_cooldown = false
		$bossAttackCooldown.start()
		
	if enemy_contact and enemy_contact_cooldown:
		health -= contact_damage
		enemy_contact_cooldown = false
		$contactCooldown.start()

func dodge():
	if Input.is_action_just_pressed("dodge") and !dodge_cooldown and !global.player_current_attack:
		is_dodging = true
		dodge_cooldown = true
		$playerHitbox/CollisionShape2D.disabled = true
		$dodgeTimer.start()
		$dodgeCooldown.start()

func attack():
	if Input.is_action_just_pressed("attackR") and !is_dodging and !global.player_current_attack:
		global.player_current_attack = true
		global.player_attack_type = Color(1, 0, 0)
		$attackAnim.play("attackR")
		$dealAttackTimer.start()
			
	elif Input.is_action_just_pressed("attackB") and !is_dodging and !global.player_current_attack:
		global.player_current_attack = true
		global.player_attack_type = Color(0, 0, 1)
		$attackAnim.play("attackB")
		$dealAttackTimer.start()
	
	elif Input.is_action_just_pressed("attackG") and !is_dodging and !global.player_current_attack:
		global.player_current_attack = true
		global.player_attack_type = Color(0, 1, 0)
		$attackAnim.play("attackG")
		$dealAttackTimer.start()

func update_healthbar():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health > 0:
		healthbar.visible = true
	else:
		healthbar.visible = false
		
func player():
	pass

# enemy contact damage
func _on_player_hitbox_body_entered(body):
	if body.has_method("boss"):
		enemy_contact = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("boss"):
		enemy_contact = false

func _on_contact_cooldown_timeout() -> void:
	enemy_contact_cooldown = true

# player currently attacking
func _on_deal_attack_timer_timeout() -> void:
	#$dealAttackTimer.stop()
	global.player_current_attack = false

# dodge timers
func _on_dodge_timer_timeout() -> void:
	$playerHitbox/CollisionShape2D.disabled = false
	is_dodging = false

func _on_dodge_cooldown_timeout() -> void:
	dodge_cooldown = false

func _on_boss_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func _on_player_attack_hitbox_area_entered(area: Area2D) -> void:
	if "attack_range" in area.name:
		enemy_in_attack_range = true

func _on_player_attack_hitbox_area_exited(area: Area2D) -> void:
	if "attack_range" in area.name:
		enemy_in_attack_range = false
