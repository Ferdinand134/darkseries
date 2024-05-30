extends CharacterBody2D

signal enemy_killed

func _on_Hitbox_area_entered(area):
	if area.is_in_group("player_attack"):
		emit_signal("enemy_killed")
		queue_free()  # Remove the enemy from the scene
