extends Node2D

onready var scoreLabel = self.get_node("player").get_node("camera").get_node("HUD").get_node("score")

var score

# Called when the node enters the scene tree for the first time.
func _ready():
  score = 0
  add_to_group("level")

func on_add_score(scoreAmmount):
	score += scoreAmmount
	scoreLabel.text = "%06d" % score
