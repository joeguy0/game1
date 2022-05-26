extends Node

var rng = RandomNumberGenerator.new()
var ballcount =0
var ballcountmax
var ballspotX
var ballspotY
var b
var balls:Array
var watch
onready var ball = preload ("res://scene/ball.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	ballcountmax = rng.randi_range(1,5)
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ballcount < ballcountmax:
		gen_new_ball()
	if ballcount >= ballcountmax:
		rng.randomize()
		ballcountmax=rng.randi_range(1,5)

func gen_new_ball():
	ballcount = ballcount + 1
	ballspotX = rng.randi_range(-100,1000)
	ballspotY = 800
	b = ball.instance()
	var playerPos = get_parent().get_node("player").position
	b.connect("bdied",self,"on_bdeath")
	b.connect("died",self,"on_death")
	b.set_position(Vector2(ballspotX,-ballspotY) + playerPos) 
	b.set_bounce(rng.randf_range(0,.9)) 
	b.set_mass(rand_range(.9,3))
	b.lifePoint = rng.randi_range(10,20)
	balls = [add_child(b,true)]
	
func on_death():
	ballcount= ballcount-1
func on_bdeath():
	ballcount= ballcount-1

# Called every frame. 'delta' is the elapsed time since the previous frame.
