extends Node2D

onready var Rocket = $Launcher/LaunchRoot/Rocket
onready var LaunchRocket = preload("res://Scenes/Rocket.tscn").instance();
onready var Cam = $Camera2D



func _ready():
	Rocket.connect("Launched",self,"OnLaunch")
	Cam.make_current()
	pass

func OnLaunch(Force,Position):
	$Launcher.queue_free();
	add_child(LaunchRocket);
	print(LaunchRocket)
	
	var ForcePolar = cartesian2polar(Force.x,Force.y)
	
	
	LaunchRocket.set("position", Position)
	LaunchRocket.set("rotation_degrees", rad2deg(ForcePolar.y)+90)
	
	LaunchRocket.PhysicsSetup(ForcePolar, Cam)
	
		
	pass
