extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const DASH_VELOCITY = 7000.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var attackbox = $player_attack
@onready var timer = $Timer
@onready var idle = $idle
@onready var collision_shape_2d = $CollisionShape2D
@onready var attack_cooldown = $AttackCooldown


var is_attacking = false



func _physics_process(delta):
	
	if is_attacking:
		if idle.animation != "attacking":
			is_attacking = false
			print("Attack finished, resuming movement.")
		else:
			return  # Skip movement if still attacking

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

	if is_on_floor():
		if direction == 0:
			idle.play("idle")
		else:
			idle.play("runningr")
	else:
		if velocity.y < 0:
			idle.play("going_up")
		elif velocity.y > 0:
			idle.play("going_down")

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
			timer.start()
			start_attack()
			attack_cooldown.start()

	move_and_slide()

func start_attack():
	is_attacking = true
	timer.wait_time= 0.4
	velocity = Vector2.ZERO
	idle.play("attacking")
	idle.frame = 0  # Ensure the animation starts from the first frame
	if idle.frame ==2:
		enable_hitbox()
	print("Attack started.")
	
func enable_hitbox():
	attackbox.set_deferred("monitoring", true)
	attackbox.set_deferred("disabled", false)

func disable_hitbox():
	attackbox.set_deferred("monitoring", false)
	attackbox.set_deferred("disabled", true)



func _on_timer_timeout():
	is_attacking =false
	print("attack finished") # Replace with function body.
	disable_hitbox()
	
func _on_attack_hitbox_entered(body):
	if body.is_in_group("enemies"):
		print("Hit enemy: ", body.name)
		# Handle enemy hit logic here
