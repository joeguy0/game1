extends Area2D


# Declare member variables here. Examples:
var rng=RandomNumberGenerator.new()
var sprite
var rngr
var rngb
var rngg
var color
var colorr
var colorg
var colorb
var newcolor
# Called when the node enters the scene tree for the first time.
func _ready():
	rngr=rng.randf_range(0,1)
	rngb=rng.randf_range(0,1)
	rngg=rng.randf_range(0,1)
	sprite=get_node("Sprite")
	colorr=rngr
	colorb=rngb
	colorg=rngg
	color=Color(rngr,rngg,rngb,1)
	newcolor=color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color=Color(colorr,colorg,colorb,1)
	sprite.set_self_modulate(color)
	if newcolor == color:
		rng.randomize()
		rngr=rng.randf_range(0,1)
		rngb=rng.randf_range(0,1)
		rngg=rng.randf_range(0,1)
		newcolor=Color(rngr,rngg,rngb,1)
	else:
		colorr=lerp(colorr,rngr,.8)
		colorb=lerp(colorb,rngb,.8)
		colorg=lerp(colorg,rngg,.8)

	
	pass


func _on_die_time_timeout():
	queue_free()
	pass # Replace with function body.
