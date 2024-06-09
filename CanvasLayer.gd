extends Node

@onready var transition_button = $"../player/CanvasLayer3/TransitionButton"


var instructions = [
	{"text": "How to play (press enter)", "action": "continue"},
	{"text": "Press W to jump", "action": "jump"},
	{"text": "Press A to move left", "action": "move_left"},
	{"text": "Press D to move right", "action": "move_right"},
	{"text": "Move and press J to dash", "action": "dash"},
	{"text": "Press K to attack", "action": "attack"},
	{"text": "Kill this", "message": "none"},
	{"text": "Congrats (press enter)", "action": "continue"},
	{"text": "In this game, you have 5 hearts", "action": "continue"},
	{"text": "You can only get hit 5 times", "action": "continue"},
	{"text": "Press enter to enter doors", "action": "continue"},
	{"text": "Good Luck!", "action": "continue"},
]

var current_instruction_index = 0

func _ready():
	update_instruction()

func _input(event):
	if Global.count == 12:
		transition_button._on_toggled(true)
		Global.count =0
	elif Global.count == 7:
		change_instruction1()
	else:
		if event.is_action_pressed(instructions[current_instruction_index]["action"]):
			change_instruction()

func change_instruction():
	current_instruction_index = (current_instruction_index + 1) % instructions.size()
	update_instruction()

	
func change_instruction1():
	if Global.all_ghouls_dead:
		current_instruction_index = (current_instruction_index + 1) % instructions.size()
		update_instruction()

func update_instruction():
	var current_instruction = instructions[current_instruction_index]["text"]
	# Assuming you have a UI label named "instructionLabel":
	$Label.text = current_instruction
	Global.count += 1
