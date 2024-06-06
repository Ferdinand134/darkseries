extends Node

class_name damageable
@onready var idle = $"../idle"
@export var health : float = 20
@export var knockback_velocity : Vector2 = Vector2(100,0)
signal enemy_hit(word: String)
@onready var death_timer = $death_timer



func hurt (damage : int):
	health -= damage
	print("player hit", health)
	if(health <=0):
		idle.play("death")
		death_timer.start()
		print("started death ")
		emit_signal("enemy_hit","death")
	else:
		idle.play("hit")
		
		emit_signal("enemy_hit","hit_enemy")
	

