extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const GRAV = 50
#var rng
var velocity
var hP = 10
onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	velocity = Vector2.ZERO
	#add_collision_exception_with(player)
	#rng = RandomNumberGenerator.new()
	#rng.randomize()

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

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_eneHurtBox_area_entered(area):
	if area.get_name() == "bulletHitBox":
		hP = hP - 1 
	if hP < 1:
		queue_free()
