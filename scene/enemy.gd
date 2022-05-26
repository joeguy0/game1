extends KinematicBody2D

const GRAV = 50

var hitTimer
signal add_score
#var rng
var velocity

var hP = 10

onready var level = get_parent()

func _ready():
	velocity = Vector2.ZERO
	hitTimer = get_node("hit_timer")
	hitTimer.connect("timeout",self,"on_hit_timeout")
	hitTimer.set_wait_time(.05)
	self.connect("add_score",level,"on_add_score")
	#add_collision_exception_with(player)

func _on_eneHurtBox_area_entered(area):
	if area.get_name() == "bulletHitBox":
		hP = hP - 1 
		$AnimatedSprite.set_modulate(Color ("ff557d"))
		hitTimer.start()
	if hP < 1:
		emit_signal("add_score", 50)
		queue_free()

func on_hit_timeout():
	$AnimatedSprite.set_modulate(Color ("ffffff"))
	hitTimer.stop()
