extends Sprite
var dowmmovement
var startpos
var intense
var intensenew

# Declare member variables here. Examples:
# var a = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	dowmmovement= rand_range(.5,3.5)
	intense= rand_range(.1,1)
	intensenew= intense
	
	startpos= position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	set_modulate(Color(1,1,1,intense))
	if intensenew == intense:
		intensenew = rand_range(.1,1)
	if intensenew != intense:
		intense= lerp(intense,intensenew,.2) 
	position=get_position()
	set_position(Vector2(position.x+dowmmovement,position.y+2))
	if position.y>=1000:
		set_position(Vector2(startpos.x,-500))
	pass
