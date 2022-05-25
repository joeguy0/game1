extends RigidBody2D

var bulletvelo = Vector2.ZERO




# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodies = get_colliding_bodies()
	if bodies == []:
		pass
	else:
		queue_free() 
	pass





func _on_bulletHitBox_area_entered(area):
	queue_free()
	pass # Replace with function body.
