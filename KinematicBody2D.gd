extends KinematicBody2D

const MAXSPEEDX = 500
const MAXSPEEDY = 2000
const ACEL = 2000
const JUMPFORCE = -1000
const DJUMPFORCE = -900
const GRAV = 50

onready var dashHitbox = preload ("res://scene/dash_hitbox.tscn")
onready var bullet = preload ("res://scene/bullet.tscn")

var doublejump=2
var velocity = Vector2.ZERO
var grnd = true
var isAirDashing = false
var wallcling = 0
var shottimer
var wctimer 
var wctimercooldown
var airdash = 2
var adtimer 
var sprite
var dashHitboxInstance
var bulletInstance
var atkTimer

var shotDLast = Vector2(800,0)


signal hit

func _ready():
	shottimer = get_node("atk_hit_timeout")
	shottimer.connect("timeout",self,"on_atk_hit_timeout")
	shottimer.set_wait_time(.5)
	adtimer=get_node("ad_timer")
	adtimer.connect("timeout",self,"on_adtimer_timeout")
	adtimer.set_wait_time(.2)
	wctimer=get_node("wc_timer")
	wctimer.connect("timeout",self,"on_wctimer_timeout")
	wctimer.set_wait_time(.3)
	wctimercooldown=get_node("wc_timer2")
	wctimercooldown.connect("timeout",self,"on_wctimercd_timeout")
	wctimercooldown.set_wait_time(.4)
	sprite = get_node("AnimatedSprite")
	add_to_group("player")

func _physics_process(delta):
	
	#declare the input
	var input_y = 0
	var input_x = 0
	var inputls = Vector2.ZERO
	var shotD = Vector2.ZERO

	input_y = Input.get_action_strength("leftstick_up") - Input.get_action_strength("Leftstick_down")
	input_x = Input.get_action_strength("leftstick_right") - Input.get_action_strength("leftstick_left")
	inputls.x = Input.get_action_strength("leftstick_right") - Input.get_action_strength("leftstick_left")
	inputls.y = Input.get_action_strength("Leftstick_down") - Input.get_action_strength("leftstick_up")
	if input_x > 0:
		 shotD.x = 1000
	if input_x == 0 && input_y == 0:
		 shotD = shotDLast
	if input_x < 0:
		shotD.x = -1000

	if input_y > 0:
		 shotD.y = -1000
	if input_y < 0:
		shotD.y = 1000
	shotDLast = shotD
	
	if input_x > 0:
		sprite.flip_h = true
	if input_x < 0:
		sprite.flip_h = false
	
	#grounded jump
	if Input.is_action_just_pressed("a") and is_on_floor() and !wallcling:
		velocity.y = JUMPFORCE
	
	#duoble jump
	if Input.is_action_just_pressed("a") && doublejump >= 1 && !is_on_floor() and !wallcling:
		velocity.y = 0
		velocity.y = DJUMPFORCE
		doublejump = doublejump - 1
	
	#airdash
	if Input.is_action_just_pressed("air_dash") && airdash >= 1 && !is_on_floor() and !wallcling:
		isAirDashing = true 
		sprite.play("dash")
		velocity = Vector2.ZERO
		velocity.x = sin(inputls.x) * 6000
		velocity.y = sin(inputls.y) * 1000
		airdash = airdash - 1
		adtimer.start()
	if isAirDashing:
		dashHitboxInstance= dashHitbox.instance()
		dashHitboxInstance.set_position(Vector2(0,0))
		get_parent().add_child(dashHitboxInstance)
		dashHitboxInstance.set_position(self.get_position())
		
	#attacking?
	if Input.is_action_pressed("atk1") && shottimer.is_stopped():
		bulletInstance = bullet.instance()
		get_parent().get_parent().add_child(bulletInstance)
		bulletInstance.set_position(self.get_position())
		bulletInstance.set_linear_velocity(shotD)

		shottimer.start()
		
		pass
	
	#wallcling
	if !wallcling and is_on_wall() and !is_on_floor() and wctimercooldown.is_stopped() and !isAirDashing:
		velocity = Vector2.ZERO
		wctimer.start()
		sprite.play("wallc")
		input_x = Input.get_action_strength("leftstick_right") - Input.get_action_strength("leftstick_left")
		if input_x > 0:
			wallcling = -1
		if input_x < 0:
			wallcling = 1

	#wallhop
	if wallcling and !wctimer.is_stopped():
		if input_x == wallcling:
			velocity.x = 2000 * wallcling
			velocity.y = -1500
			wallcling = 0
			wctimercooldown.start()
		

	#gravity script
	if isAirDashing == false and !wallcling:
		velocity.y = velocity.y + GRAV
	if wallcling:
		velocity.y = velocity.y +.1*GRAV
	
	#move left right
	if input_x != 0 and isAirDashing != true and !wallcling:
		velocity.x += input_x * ACEL * delta
		# if !attacking:
		sprite.play("run")
		#velocity = velocity.clamped(MAXSPEEDX)
	if input_x == 0 and !isAirDashing and !wallcling:
		# if !attacking:
		sprite.play("walk")
		velocity.x = lerp(velocity.x,0,0.1)
	#max speed hori
	if velocity.x >= 600:
		velocity.x = 600
	
	if velocity.x <= -600:
		velocity.x = -600
	#regain jumps and land
	if is_on_floor():
		doublejump = 2
		airdash = 2
		grnd = true
	else:
		grnd = false
	if !is_on_floor() and !isAirDashing and !wallcling:
		sprite.play("jump")
	#movement lol
	velocity = move_and_slide(velocity,Vector2.UP)

func on_adtimer_timeout():
	isAirDashing = false
	adtimer.stop()
func on_wctimer_timeout():
	wctimer.stop()
	wallcling = 0
	wctimercooldown.start()
func on_wctimercd_timeout():
	wctimercooldown.stop()
func on_atk_hit_timeout():
	shottimer.stop()
	

