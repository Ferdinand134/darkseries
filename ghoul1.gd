extends CharacterBody2D
class_name ghoul1

@onready var area_detection = $Area_detection
@onready var player_detector = $PlayerDetector
@onready var enemy_attack = $enemy_attack
@onready var idle = $idle
@onready var attack_timer = $attack_timer
@onready var damageable = $damageable
@onready var damage_timer = $damage_timer
@onready var death_timer = $death_timer
@onready var body = $body


var enemy_hit = false
var speed = 150
var player_chase = false
var player = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 10
var player_inattack_zone = false
var is_attacking = false
var attack_cooldown = false
var taking_damage = false
var dead = false
var moving = false
signal facing_direction_changed(facing_right : bool)


func _physics_process(delta):
	var gravity_force = Vector2(0, gravity * delta)  # Calculate gravity force
	velocity += gravity_force  # Update velocity
	move_and_slide()  # Apply movement
	
	if enemy_hit:
		if idle.flip_h:
			position.x= position.x+1
			moving = true
		if idle.flip_h ==false:
			position.x = position.x-1
			moving = true
		if taking_damage ==  false:
			enemy_hit = false
			
		elif dead:
			area_detection.monitoring = false
			pass
		moving = false
	elif is_attacking:
		moving = false
		if idle.animation != "attacking":
			is_attacking = false
			print("Attack finished, resuming movement.")
	else:
		if player_chase:
			position += (player.position - position)/speed
			idle.play("walking")
			if (player.position.x -position.x) <0:
				idle.flip_h = true
			else:
				idle.flip_h = false
			emit_signal("facing_direction_changed", !idle.flip_h)
		else:
			idle.play("idle")
		



func _on_area_detection_body_entered(body):
	player = body
	player_chase = true

func _on_area_detection_body_exited(body):
	player = null
	player_chase = false

func _on_enemy_attack_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
		is_attacking = true
		attack_cooldown = false
		moving = false
		print("player has entered attack range")
		hit()

func _on_enemy_attack_body_exited(body):
	player_inattack_zone = false
	is_attacking = false
	attack_cooldown = true
	if body.has_method("player"):
		print("player has exited attack range")

func hit():
	if attack_cooldown == false and player_inattack_zone and dead == false and moving == false:
		is_attacking = true
		attack_cooldown = true
		idle.play("attacking")
		attack_timer.start()
		if idle.frame == 2:
			enemy_attack.monitoring == true

func _on_attack_timer_timeout():
	attack_cooldown = false
	hit()
	

func _on_damageable_enemy_hit(word):
	if word == "hit_enemy":
		enemy_hit =true
		taking_damage = true
		damage_timer.start()
	elif word == "death":
		enemy_hit = true
		dead = true
		taking_damage = true


func _on_damage_timer_timeout():
	print("timer is done")
	taking_damage = false




func _on_death_timer_timeout():
	print("finished")
	self.queue_free()
	
