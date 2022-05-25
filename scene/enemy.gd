extends KinematicBody2D

const GRAV = 50

var hitTimer

#var rng
var velocity
var hP = 10
onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	velocity = Vector2.ZERO
	hitTimer = get_node("atk_hit_timeout")
	hitTimer.connect("timeout",self,"on_atk_hit_timeout")
	hitTimer.set_wait_time(.05)
	#add_collision_exception_with(player)

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
		$AnimatedSprite.set_modulate(Color ("ff557d"))
		hitTimer.start()
	if hP < 1:
		queue_free()

func on_atk_hit_timeout():
	$AnimatedSprite.set_modulate(Color ("ffffff"))
	hitTimer.stop()
