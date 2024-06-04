extends Node

var player_current_attack = false
var enemy_current_attack = false
var player_isdead = false
var all_ghouls_dead = false
var enemy_count = 0

func _ready():
	if enemy_count == 0:
		all_ghouls_dead = true
