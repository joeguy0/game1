extends Node2D

var rng = RandomNumberGenerator.new()
var ballcount =0
var ballcountmax
var ballspotX
var ballspotY
var b
var balls:Array
var watch
var level = GameStats.level
var highscore = GameStats.highscore


onready var ball = preload ("res://scene/ball.tscn")
onready var player= preload ("res://scene/player.tscn")
onready var bg = preload ("res://scene/back.tscn")
onready var wall = preload ("res://scene/wall.tscn")
onready var flr = preload ("res://scene/floor.tscn")




# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
