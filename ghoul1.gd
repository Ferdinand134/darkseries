extends CharacterBody2D

@onready var idle = $idle
signal enemy_killed
var speed = 150
var player_chase = false
var player = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var player_inattack_zone = false

func _physics_process(delta):
	deal_with_damage()
	
	var gravity_force = Vector2(0, gravity * delta)  # Calculate gravity force
	velocity += gravity_force  # Update velocit
	move_and_slide()  # Apply movement
	
	if player_chase:
		position += (player.position - position)/speed
		idle.play("walking")
		if (player.position.x -position.x) <0:
			idle.flip_h = true
		else:
			idle.flip_h = false
	else:
		idle.play("idle")



func _on_area_detection_body_entered(body):
	player = body
	player_chase = true


func _on_area_detection_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
		print("in attack zone")

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		print("exicted attack zone")
		
func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack:
		health = health - 20
		print("Ghoul =", health)
		if health <=0:
			self.queue_free()
