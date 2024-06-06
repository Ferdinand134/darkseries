extends Node2D

var again = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.count == 7:
		if Global.enemy_count ==0 and again == true:
			# Load the Ghoul1 scene (assuming it's a separate scene file)
			var ghoul_scene = preload("res://ghoul_1.tscn")

			# Create an instance of the Ghoul1 scene
			var ghoul_instance = ghoul_scene.instantiate()

	
			# Set any initial properties or configurations for the Ghoul1 (e.g., position, health, etc.)
			
			ghoul_instance.position = Vector2(-400, 1900)  # Set the initial position
			ghoul_instance.scale = Vector2(0.65, 0.65)
			# Add the Ghoul1 instance as a child using call_deferred
			get_tree().get_root().call_deferred("add_child", ghoul_instance)
			again = false

