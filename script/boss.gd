extends CharacterBody2D

var speed = 200
var health = 100
var damage
var can_be_damaged = true
var dead = false
var player_in_area = false
var player_in_range = false
var player

func _ready():
	dead = false

func _physics_process(delta):
	deal_with_damage()
	
	
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position)/speed
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$detection_area/CollisionShape2D.disabled = true

func boss():
	pass

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body
	
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		player = body

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false

func deal_with_damage():
	if player_in_range and global.player_current_attack == true:
		if can_be_damaged == true:
			$takeDamage.start()
			can_be_damaged = false
			health = health - 10
			print("boss - 10")
			if health <= 0:
				self.queue_free()


func _on_take_damage_timeout() -> void:
	can_be_damaged = true
