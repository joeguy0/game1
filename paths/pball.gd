extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2 var b = "text"
var listid = 1254
var ball


# Called when the node enters the scene tree for the first time.
func _ready():
	ball = self
	ball.connect("hitt",self,"on_hit")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_hit():
		ball.apply_central_impulse(Vector2(0,-40))

