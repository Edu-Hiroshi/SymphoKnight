extends CharacterBody2D

var speed = 150
var health = 100
var basic_damage = 2
var match_damage = 10

var can_be_damaged = true
var player_in_pursuit_area = false
var player_in_attack_area = false
var player_in_range = false
var player
var attackCooldown = false

func _ready():
	global.boss_dead = false

func _physics_process(_delta):
	deal_with_damage()
	update_healthbar()
	pursuit()
	
func pursuit():
	if !global.boss_dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_pursuit_area and !player_in_attack_area:
			position += (player.position - position)/speed
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = (player.position.x - position.x) > 0
		
		elif player_in_attack_area and global.boss_on_beat and !attackCooldown:
			attackCooldown = true
			$attackCooldown.start()
			match global.boss_attack_type:
				Color(1, 0, 0):
					$AnimatedSprite2D.play("attackR")
					$AttackAnim.play("effectR")
					$AttackAnim.flip_h = (player.position.x - position.x) > 0
					$sfx/slash.play()
				Color(0, 1, 0):
					$AnimatedSprite2D.play("attackG")
					$AttackAnim.play("effectG")
					$AttackAnim.flip_h = (player.position.x - position.x) > 0
					$sfx/bass.play()
				Color(0, 0, 1):
					$AnimatedSprite2D.play("attackB")
					$AttackAnim.play("effectB")
					$AttackAnim.flip_h = (player.position.x - position.x) > 0
					$sfx/slash.play()
				_:
					pass
			global.boss_current_attack = true
			
			
		elif player_in_attack_area and global.boss_attack_type == Color(1, 1, 1):
			position += (player.position - position)/speed
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = (player.position.x - position.x) > 0
		
		elif !player_in_pursuit_area:
			$AnimatedSprite2D.play("idle")

	else:
		$detection_area/CollisionShape2D.disabled = true

func deal_with_damage():
	if can_be_damaged == true:
		if  player_in_range and global.player_current_attack == true:
			$takeDamage.start()
			can_be_damaged = false
			health -= basic_damage
			$sfx/lowdmg.play()
		elif  player_in_attack_area and global.player_current_attack == true and global.boss_on_beat and global.boss_attack_type == global.player_attack_type:
			$takeDamage.start()
			can_be_damaged = false
			health -= match_damage
				
		if health <= 0 and !global.boss_dead:
			death()

func death():
	global.boss_dead = true
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D.flip_h = (player.position.x - position.x) > 0
	$sfx/death.play()
	$Music.queue_free()
	$deathAnim.start()

func update_healthbar():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health > 0:
		healthbar.visible = true
	else:
		healthbar.visible = false

func boss():
	pass


# player detection for pursuit
func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_pursuit_area = true
		player = body
	
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_pursuit_area = false
		player = body


# player can damage boss
func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false

func _on_take_damage_timeout() -> void:
	can_be_damaged = true


# death handler
func _on_death_anim_timeout() -> void:
	self.queue_free()


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_area = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_area = false

func _on_attack_cooldown_timeout() -> void:
	attackCooldown = false
