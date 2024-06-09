extends Node2D

var again = true
@onready var enter_area = $enter_area
@onready var transition_button = $CanvasLayer2/TransitionButton
@onready var player = $player
@onready var death_screen = $player/death_screen
@onready var deathscr = $player/death_screen/deathscr
var on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func _process(delta):
	if on == false:
		_player_death()


func _player_death():
	if Global.player_isdead:
		transition_button._on_toggled(true)
		on = true
