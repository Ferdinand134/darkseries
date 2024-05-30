extends CanvasLayer

# Instructions array where each entry is a dictionary with text and corresponding action
var instructions = [
	{"text": "Press W to jump", "action": "jump"},
	{"text": "Press A to move left", "action": "move_left"},
	{"text": "Press D to move right", "action": "move_right"},
	{"text": "Press J to dash", "action": "dash"},
	{"text": "Press K to attack", "action": "attack"},
	{"text": "Kill this","action":"attack"}
]
var current_instruction_index = 0

func _ready():
	# Display the first instruction
	update_instruction()

func _input(event):
	if event.is_action_pressed(instructions[current_instruction_index]["action"]):
		change_instruction()

func change_instruction():
	current_instruction_index = (current_instruction_index + 1) % instructions.size()
	update_instruction()

func update_instruction():
	$ScoreLabel.text = instructions[current_instruction_index]["text"]
