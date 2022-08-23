extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
# Contains the following default values:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(Vector3(0,-1,0), Vector3.UP, true)
	
	pass
	
func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseMotion:
		print(event.relative, rotation, transform)
