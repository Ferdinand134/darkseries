extends CheckButton

@export var transitioner : Transitioner



func _on_toggled(button_pressed):
	transitioner.set_nextanimation(button_pressed)

