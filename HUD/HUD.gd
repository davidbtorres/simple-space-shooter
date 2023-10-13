extends Control

var pLifeIcon := preload("res://HUD/LifeIcon.tscn")

onready var lifeContainer := $LifeContainer
onready var scoreLabel := $Score
onready var finalScoreLabel := $FinalScore
onready var restartButton := $RestartButton

var score: int = 0

func _ready():
	clearLives()
	
	Signals.connect("on_player_life_changed", self, "_on_player_life_changed")
	Signals.connect("on_score_increment", self, "_on_score_increment")
	Signals.connect("on_game_over", self, "_on_game_over")
	
func clearLives():
	if lifeContainer.get_children() != null:
		for child in lifeContainer.get_children():
			child.queue_free()


func setLives(lives: int):
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instance())

func _on_score_increment(amount: int):
	score += amount
	scoreLabel.text = str(score)

func _on_player_life_changed(life: int):
	setLives(life)
	
func _on_game_over():
	finalScoreLabel.text = "Final Score:\n      " + str(score)
	finalScoreLabel.show()
	restartButton.show()


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
	finalScoreLabel.hide()
	restartButton.hide()
