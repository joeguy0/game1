extends Node2D

onready var Tile = preload("res://scene/square.tscn")

var rng = RandomNumberGenerator.new()

var minX = -4000
var maxX = 2000
var minY = -10000
var maxY = 2000


func spawnTile(x ,y):
	var tile = Tile.instance()
	add_child(tile)
	#tile.z_index = 99
	tile.add_to_group("tile")
	tile.global_position = Vector2(x, y)

func spawnLine(start, end, increments):
	var xDiff = (end.x - start.x) / increments
	var yDiff = (end.y - start.y) / increments
	for i in range(increments):
		spawnTile(start.x + xDiff * i, start.y + yDiff * i)

func spawnTunnel(start, end, prevDir, nextDir, increments):
	var width = 400
	var offset = 500
	var newStart1 = Vector2(start.x - width + (offset * prevDir), start.y + width - (offset * prevDir))
	var newStart2 = Vector2(start.x + width + (offset * prevDir), start.y - width + (offset * prevDir))
	var newEnd1 = Vector2(end.x - width + (offset * nextDir), end.y + width + (offset * nextDir))
	var newEnd2 = Vector2(end.x + width + (offset * nextDir), end.y - width - (offset * nextDir))
	spawnLine(newStart1, newEnd1, increments)
	spawnLine(newStart2, newEnd2, increments)

func mainPathGen(startX, startY, endY):
	var units = 100
	var lineArray = [Vector2(startX, startY)]
	var lastPoint = lineArray[len(lineArray) - 1]
	while (lastPoint.y > endY):
		var yLength = rng.randi_range(2, 4) * units
		var nextY = lastPoint.y - 1 * yLength
		lineArray.append(Vector2(lastPoint.x, nextY))
		var xDirection = -1 if rng.randi_range(0,1) > 0 else 1
		var xLength = rng.randi_range(8, 15) * units
		var nextX = lastPoint.x + xDirection * xLength
		lineArray.append(Vector2(nextX, nextY))
		lastPoint = lineArray[len(lineArray) - 1]
	return lineArray

func getDirection(start, end):
	return 0 if end.x == start.x else (1 if end.x > start.x else -1)

func generate():
	spawnLine(Vector2(minX, maxY), Vector2(maxX, maxY), 1000)
	var mainPath = mainPathGen(0, maxY, minY)
	var pathLength = len(mainPath)
	spawnTunnel(mainPath[0], mainPath[1], 1, getDirection(mainPath[1], mainPath[2]), 100)
	for i in pathLength - 2:
		spawnTunnel(mainPath[i], mainPath[i+1], getDirection(mainPath[i-1], mainPath[i]), getDirection(mainPath[i], mainPath[i+1]), 100)
	spawnTunnel(mainPath[pathLength-2], mainPath[pathLength-1], getDirection(mainPath[pathLength-3], mainPath[pathLength-2]), 1, 100)
	#for i in range((maxY - minY) / floorHeight):
	#	spawnLine(Vector2(minX, minY + i * floorHeight), Vector2(maxX, minY + i * floorHeight), 100)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	generate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
