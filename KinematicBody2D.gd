extends KinematicBody2D

const MAXSPEEDX = 500
const MAXSPEEDY = 2000
const ACEL = 2000
const JUMPFORCE = -1000
const DJUMPFORCE = -900
const GRAV = 50

onready var dashHitbox = preload ("res://scene/dash_hitbox.tscn")
var doublejump=2
var velocity = Vector2.ZERO
var grnd = true
var sp = false
var wallcling = false
var wallclingp= false
var wallclingl= false
var wctimer 
var parent
var wctimercooldown
var atkhittimer
var airdash = 2
var adtimer 
var fist
var sprite
var attacking
var attack_press
var fistr
var hb
var dashbox
signal hit

func _ready():
	adtimer=get_node("ad_timer")
	adtimer.connect("timeout",self,"on_adtimer_timeout")
	adtimer.set_wait_time(.2)
	wctimer=get_node("wc_timer")
	wctimer.connect("timeout",self,"on_wctimer_timeout")
	atkhittimer=get_node("atk_hit_timeout")
	atkhittimer.connect("timeout",self,"on_atk_hit_timeout_timeout")
	wctimer.set_wait_time(.3)
	atkhittimer.set_wait_time(.1)
	wctimercooldown=get_node("wc_timer2")
	wctimercooldown.connect("timeout",self,"on_wctimercd_timeout")
	wctimercooldown.set_wait_time(.4)
	sprite = get_node("AnimatedSprite")
	fist = get_node("fist_path")
	fistr = get_node("fist_path2")
	parent = get_parent()
	fist.connect("hitt",self,"on_hit")
	fist.connect("end",self,"on_atk_end")
	fistr.connect("end2",self,"on_atk_end")
	fistr.connect("hitt2",self,"on_hit")
	remove_child(fist)
	remove_child(fistr)
func _physics_process(delta):
	
	#declare the input
	var input_x = 0
	var inputls = Vector2.ZERO
	
	
	
	
	input_x = Input.get_action_strength("leftstick_right") - Input.get_action_strength("leftstick_left")
	inputls.x = Input.get_action_strength("leftstick_right") - Input.get_action_strength("leftstick_left")
	inputls.y = Input.get_action_strength("Leftstick_down") - Input.get_action_strength("leftstick_up")
	
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
	if Input.is_action_just_pressed("air_dash") && airdash >= 1 && !is_on_floor() and !wallcling and !attacking:
		sp = true 
		sprite.play("dash")
		velocity = Vector2.ZERO
		velocity.x = sin(inputls.x) * 6000
		velocity.y = sin(inputls.y) * 1000
		#velocity = Vector2.clamped(25000)
		airdash = airdash - 1
		adtimer.start()
	if sp:
		hb= dashHitbox.instance()
		hb.set_position(Vector2(0,0))
		parent.add_child(hb)
		#hb.set_owner(parent)
		hb.set_position(self.get_position())
		
	
	#wallhop right
	if is_on_wall() and !is_on_floor() and wctimercooldown.is_stopped() and !wallclingl and !sp and !wallclingp:
		velocity = Vector2.ZERO
		wctimer.start()
		wallcling = true
		sprite.play("wallc")
		input_x = Input.get_action_strength("leftstick_right") - Input.get_action_strength("leftstick_left")
		if input_x > 0:
			wallclingp = true
			wallclingl = false
		else:
			wallclingl = true
			wallclingp = false
			


	
	if wallclingp and !wctimer.is_stopped() and wallcling and !wallclingl:
		if input_x == -1:
			velocity.x = -2000
			velocity.y = -1500
			wallclingp = false
			wctimercooldown.start()
		
		#wallhop left
	#if is_on_wall() and !is_on_floor() and input_x <0 and wctimercooldown.is_stopped() and !wallclingp and !sp:
		#wctimer.start()
		#wallcling = true
		#sprite.play("wallc")
		#velocity = Vector2.ZERO
		#wallclingl = true
		#wallclingp = false
		#wctimer.start()
	if wallclingl and !wctimer.is_stopped() and wallcling and !wallclingp:
		if input_x == 1:
			velocity.x = 2000
			velocity.y = -1500
			wallcling = false
			wallclingl = false
			wctimercooldown.start()
		
	#gravity script
	if sp == false and !wallcling:
		velocity.y = velocity.y + GRAV
	if wallcling:
		velocity.y = velocity.y +.1*GRAV
	
	#move left right
	if input_x != 0 and sp != true and !wallcling:
		velocity.x += input_x * ACEL * delta
		if !attacking:
			sprite.play("run")
		#velocity = velocity.clamped(MAXSPEEDX)
	if input_x == 0 and !sp and !wallcling:
		if !attacking:
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
		#sp = false
	
	
	else:
		grnd = false
	if !is_on_floor() and !sp and !wallcling and !attacking:
		sprite.play("jump")
	#movement lol
	velocity = move_and_slide(velocity,Vector2.UP)
	attack_press = Input.is_action_just_pressed("atk1")
	
	if attack_press and !sp and !attacking:
		if sprite.flip_h: 
			add_child(fistr)
		else:
			add_child(fist)
		
		
		sprite.play("attack")
		attacking = true

	
func on_atk_end():
	if fist:
		remove_child(fist)
	if fistr:
		remove_child(fistr)
	attacking = false
func on_adtimer_timeout():
	sp = false
	adtimer.stop()
func on_wctimer_timeout():
	wctimer.stop()
	wallcling = false
	wallclingl = false
	wallclingp = false
	wctimercooldown.start()
func on_wctimercd_timeout():
	wctimercooldown.stop()
