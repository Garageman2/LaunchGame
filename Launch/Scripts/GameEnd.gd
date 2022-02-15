extends Control

signal ResetGame
onready var Score = $NinePatchRect/HBoxContainer/Label

func UpdateScores(YourScore,HighScore):
	Score.text = "Your Score: " + String(YourScore) + "\n" +"High Score: " + String(HighScore) + "\n"
	pass

func _on_Button_pressed():
	print("Reset!")
	emit_signal("ResetGame")
	pass # Replace with function body.
