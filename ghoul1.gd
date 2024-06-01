extends CharacterBody2D

@onready var idle = $idle
signal enemy_killed
var speed = 150
var player_chase = false
var player = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
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
