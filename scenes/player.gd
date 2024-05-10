extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var idle = $idle
@onready var collision_shape_2d = $CollisionShape2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("move_left", "move_right")
	# Get the input direction and handle the movement/deceleration.

	if direction > 0:
		idle.flip_h = false
	elif direction < 0:
		idle.flip_h = true

	if direction ==0:
		idle.play("idle")
	else:
		idle.play("runningr")

	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
