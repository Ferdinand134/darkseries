extends CharacterBody2D

class_name Player




var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") +80
@onready var timer = $Timer
@onready var idle = $idle
@onready var collision_shape_2d = $CollisionShape2D
@onready var dashing_timer = $Dashing_timer
@onready var attack_cooldown = $AttackCooldown
@onready var damage_cooldown = $damage_cooldown
@onready var transition_button = $"../CanvasLayer2/TransitionButton"
@onready var sword = $sword
@onready var enter_area = $"../enter_area"
@onready var player_hitbox = $player_hitbox
@onready var damageable = $damageable
@export var knockback_velocity : float = 1000
@export var SPEED = 150.0
@export var JUMP_VELOCITY = -400.0
@export var DASH_VELOCITY = 4000.0
@onready var death_timer = $damageable/death_timer


var door_area =false
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var is_attacking = false
signal facing_direction_changed(facing_right : bool)
var player_hit = false
var taking_damage = false
var dead = false
var moving = false
var is_dashing = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player_hit:
		if dead == false: 
			if idle.flip_h:
				velocity.x = move_toward(velocity.x, knockback_velocity, knockback_velocity * 0.1)
				velocity.y = move_toward(velocity.y, knockback_velocity, knockback_velocity * 0.1)
				move_and_slide()
				moving = true
			elif idle.flip_h ==false:
				velocity.x = move_toward(velocity.x, -knockback_velocity, knockback_velocity * 0.1)
				velocity.y = move_toward(velocity.y, knockback_velocity, knockback_velocity * 0.1)
				move_and_slide()
				moving = true
		elif dead:
			player_hitbox.monitoring = false
			player_hitbox.monitorable = false
		moving = false
		
	#handles attacking animations
	elif is_attacking:
		moving = false
		if idle.animation != "attacking":
			is_attacking = false
			print("Attack finished, resuming movement.")
	#handels all movement
	else:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		

		var direction = Input.get_axis("move_left", "move_right")

		if direction > 0:
			idle.flip_h = false
		elif direction < 0:
			idle.flip_h = true
	
		emit_signal("facing_direction_changed", !idle.flip_h)

		if is_on_floor():
			if direction == 0:
				idle.play("idle")
			else:
				idle.play("runningr")
			idle.position.x = -24
			idle.position.y = -39
		else:
			if velocity.y < 0:
				idle.play("going_up")
				if idle.flip_h == false:
					idle.position.x = -10
					idle.position.y = -20
				else:
					idle.position.x = -40
					idle.position.y = -30
			elif velocity.y > 0:
				idle.play("going_down")
				idle.position.y = -15
	

		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_just_pressed("dash") and not is_dashing:
			is_dashing = true
			dashing_timer.start()

		if is_dashing:
			if direction > 0:
				velocity.x = move_toward(velocity.x, DASH_VELOCITY, DASH_VELOCITY * 0.1)
			elif direction < 0:
				velocity.x = move_toward(velocity.x, -DASH_VELOCITY, DASH_VELOCITY * 0.1)
			else:
				is_dashing = false

		if Input.is_action_just_pressed("attack"):
			if not attack_cooldown.is_stopped():
				print("Attack is on cooldown.")
			else:
				Global.player_current_attack = true
				timer.start()
				start_attack()
				attack_cooldown.start()
		
		if door_area:
			if Input.is_action_just_pressed("continue"):
				transition_button._on_toggled(true)

		move_and_slide()

func start_attack():
	is_attacking = true
	velocity = Vector2.ZERO
	idle.play("attacking")
	idle.frame = 0  # Ensure the animation starts from the first frame
	print("Attack started.")

#stops player movement when they attack
func _on_timer_timeout():
	is_attacking =false
	print("attack finished") # Replace with function body.
	Global.player_current_attack = false
	
func player():
	pass

func _on_idle_frame_changed():
	if is_attacking:
		if idle.frame == 1:
			sword.monitoring = true
		else:
			sword.monitoring = false


func _on_damageable_enemy_hit(word):
	if word == "hit_enemy":
		player_hit =true
		taking_damage = true
		print("start timer")
		damage_cooldown.start()
	elif word == "death":
		player_hit = true
		dead = true
		taking_damage = true
		death_timer.start()


func _on_damage_cooldown_timeout():
	player_hit = false
	print("end timer")



	

func _on_dashing_timer_timeout():
	is_dashing = false


func _on_enter_area_body_entered(body):
	if body.has_method("player"):
		door_area = true


func _on_death_timer_timeout():
	print("finished")
	self.queue_free()
