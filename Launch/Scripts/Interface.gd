extends Control

onready var Life1 = $NinePatchRect/Left2
onready var Life2 =$NinePatchRect/Middle2
onready var Life3 = $NinePatchRect/Right2
onready var Score = $NinePatchRect/Score 



func UpdateLives(Lives):
	if Lives == 0:
		Life1.set("visible",false)
		Life2.set("visible",false)
		Life3.set("visible",false)
	elif Lives == 1:
		Life2.set("visible",false)
		Life3.set("visible",false)
	elif Lives == 2:
		Life3.set("visible",false)

func UpdateScore(DeltaScore):
	var OldScore = Score.text
	OldScore = int(OldScore)
	print(DeltaScore+OldScore)
	Score.set_text(String(OldScore+(DeltaScore*5.0)))
