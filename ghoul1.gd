extends CharacterBody2D
@onready var idle = $idle
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal enemy_killed
var speed = 25
var player_chase = false
var player = null


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player_chase:
		position += (player.position-position)/speed


func _on_Hitbox_area_entered(area):
	if area.is_in_group("player_attack"):
		emit_signal("enemy_killed")
		print("enemy has been hit")
		idle.play("hit")
		queue_free()  # Remove the enemy from the scene


func _on_area_detection_body_entered(body):
	player = body
	player_chase = true


func _on_area_detection_body_exited(body):
	player = null
	player_chase = false
