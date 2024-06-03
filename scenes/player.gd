extends CharacterBody2D

class_name Player

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const DASH_VELOCITY = 7000.0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var timer = $Timer
@onready var idle = $idle
@onready var collision_shape_2d = $CollisionShape2D
@onready var attack_cooldown = $AttackCooldown
@onready var damage_cooldown = $damage_cooldown
@onready var sword = $sword


var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var is_attacking = false
signal facing_direction_changed(facing_right : bool)


func _physics_process(delta):
	#handles attacking animations
	if is_attacking:
		if idle.animation != "attacking":
			is_attacking = false
			print("Attack finished, resuming movement.")
		else:
			return  # Skip movement if still attacking
	
	if health <=0:
		player_alive = false # add in screen text
		health = 0
		idle.play("death")
		print("ur dead")
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

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
			idle.position.x = -10
			idle.position.y = -20
		elif velocity.y > 0:
			idle.play("going_down")
			idle.position.y = -15
	
	

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("dash"):
		if direction > 0:
			velocity.x = DASH_VELOCITY
		elif direction <0:
			velocity.x = -DASH_VELOCITY

	if Input.is_action_just_pressed("attack"):
		if not attack_cooldown.is_stopped():
			print("Attack is on cooldown.")
		else:
			Global.player_current_attack = true
			timer.start()
			start_attack()
			attack_cooldown.start()
			

	move_and_slide()
	#enemy_attack()
	
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
