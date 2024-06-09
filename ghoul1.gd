extends CharacterBody2D
class_name ghoul1

@onready var area_detection = $Area_detection
@onready var enemy_attack = $enemy_attack
@onready var idle = $idle
@onready var attack_timer = $attack_timer
@onready var enemy_damage = $damageable
@onready var damage_timer = $damage_timer
@onready var body_enemy = $body_enemy
@onready var detect_player = $detect_player
@export var knockback_velocity : float = 1000
@onready var bug_timer = $bug_timer


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
var spawning = true
signal facing_direction_changed(facing_right : bool)

func _ready():
	idle.play("spawn_in")

func _physics_process(delta):
	var gravity_force = Vector2(0, gravity * delta)  # Calculate gravity force
	velocity += gravity_force  # Update velocity
	move_and_slide()  # Apply movement
	
	if spawning:
		is_attacking = false
		moving = false
	elif enemy_hit:
		if idle.flip_h:
			position.x= position.x+1
			moving = true
		if idle.flip_h == false:
			position.x = position.x-1
			moving = true
		if taking_damage ==  false:
			enemy_hit = false
			
		elif dead:
			area_detection.monitoring = false
			pass
	elif is_attacking:
		moving = false
		idle.play("attacking")
		if idle.frame==6:
			is_attacking = false
			print("Enemy Attack finished, resuming movement.")
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
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_area_detection_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false

func _on_detect_player_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
		is_attacking = true
		attack_cooldown = false
		moving = false
		print("player has entered attack range")
		hit()

func _on_detect_player_body_exited(body):
	if idle.animation == "attacking":
		bug_timer.start()
	else:
		player_inattack_zone = false
		is_attacking = false
		attack_cooldown = true
		if body.has_method("player"):
			print("player has exited attack range")

func hit():
	if attack_cooldown == false and player_inattack_zone and dead == false and moving == false:
		is_attacking = true
		attack_cooldown = true
		attack_timer.start()
		
func _on_attack_timer_timeout():
	attack_cooldown = false
	print("done")
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
	

func _on_idle_frame_changed():
	if spawning:
		if idle.animation == "spawn_in":
			if idle.frame == 10:
				spawning = false
				idle.play("idle")
	if is_attacking:
		if idle.animation == "attacking":
			if idle.frame == 2:
				enemy_attack.monitoring = true
			else:
				enemy_attack.monitoring = false



func _on_bug_timer_timeout():
	player_inattack_zone = false
	is_attacking = false
	attack_cooldown = true


func _on_tree_entered():
	Global.enemy_count += 1
	print("enter ", Global.enemy_count)


func _on_tree_exited():
	Global.enemy_count -= 1
	if Global.enemy_count == 0:
		Global.all_ghouls_dead = true
		print(Global.all_ghouls_dead)
		

