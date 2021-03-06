extends "res://scene/enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	hP = 5

func _physics_process(delta):
	#var num = (rng.randi_range(0, 4) - 2) * 100
	var enemyPos = self.get_position()
	if (player):
		var playerPos = player.get_position()
		var xDiff = playerPos.x - enemyPos.x
		var yDiff = playerPos.y - enemyPos.y
	# fly follow
		#velocity.x += xDiff * delta
		#velocity.y += yDiff * delta
	#walk follow
		velocity.y = velocity.y + GRAV
		velocity.x += xDiff * delta

	velocity.x = clamp(velocity.x, -1000, 1000)
	velocity = move_and_slide(velocity,Vector2.UP)
