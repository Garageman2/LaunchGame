extends Node2D

onready var Rocket = $Launcher/LaunchRoot/Rocket


func _ready():
	Rocket.connect("Launched",self,"OnLaunch")
	pass

func OnLaunch():
	$Launcher.queue_free();
	pass
