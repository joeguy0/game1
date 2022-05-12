extends RigidBody2D


# Declare member variables here. Examples:
var hurtbox
var hitboxp
var ball
var lifePoint = 10 setget set_lifePoint, get_lifePoint
var randommov
var randommovx
var sprite
var rng = RandomNumberGenerator.new()
var motion
var idletimer
signal died
signal bdied



# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var frame=rng.randi_range(0,9)
	sprite = get_node("Sprite")
	motion = get_colliding_bodies()
	idletimer = get_node("sitTimer")
	idletimer.set_wait_time(.2)
	idletimer.start()
	sprite.set_frame(frame)
	
	
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	motion = get_colliding_bodies()
	if motion==[]:
		idletimer.set_paused(true)
		pass
	else:
		idletimer.set_paused(false)


func _on_ball_hurtbox_area_entered(area):
	
	sprite.set_self_modulate(Color(1.0,1.0,0.1*lifePoint,0.1*lifePoint))
	rng.randomize()
	randommov = rng.randi_range(280,400)
	if randommov % 2 == 0:
		randommovx = (randommov*-1)+140
	else:
		randommovx = randommov-140
	
	if area.get_name() == "hit1":
		apply_central_impulse(Vector2(randommovx,-randommov*2))
		lifePoint= lifePoint - 2
	if area.get_name() == "dash_hitbox":
		apply_central_impulse(Vector2(0,-randommov*4))
		lifePoint= lifePoint - 5
		
	if area.get_name() == "hit2":
		apply_central_impulse(Vector2(randommovx,-randommov*3))
		lifePoint= lifePoint -5
	if lifePoint<=0:
		emit_signal("died")
		queue_free()
func set_lifePoint(param1):
	lifePoint=lifePoint
	pass
	
func get_lifePoint():
	lifePoint=lifePoint
	pass


func _on_sitTimer_timeout():
	emit_signal("bdied")
	queue_free()
	pass
