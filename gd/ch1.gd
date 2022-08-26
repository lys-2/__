extends KinematicBody

var socket : PhoenixSocket
var channel : PhoenixChannel
var presence : PhoenixPresence
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rf = 0
var pf = 0

# Called when the node enters the scene tree for the first time.
func _ready():
# Contains the following default values:
	socket = PhoenixSocket.new("lws://localhost:4000/socket", {
			params = {user_id = "aaa"}
		})
	socket.connect_socket()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(Vector3(0,-1,0), Vector3.UP, true)
	print(rotation, transform, pf, " ", rf)
	pf+=1
	
	pass
	
func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseMotion:
		print(event.relative, rotation, transform, pf, " ", rf)
	rf+=1
