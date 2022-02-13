extends Node2D

onready var Rocket = $Launcher/LaunchRoot/Rocket
onready var LaunchRocket = preload("res://Scenes/Rocket.tscn").instance();
onready var Cam = $Camera2D
onready var Moon = $Moon



func _ready():
	Rocket.connect("Launched",self,"OnLaunch")
	Cam.make_current()
	Moon.connect("MoonHit",self,"MoonHit")
	pass


func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func OnLaunch(Force,Position):
	$Launcher.queue_free();
	add_child(LaunchRocket);
	
	var ForcePolar = cartesian2polar(Force.x,Force.y)
	
	LaunchRocket.set("position", Position)
	LaunchRocket.set("rotation_degrees", rad2deg(ForcePolar.y)+90)
	LaunchRocket.PhysicsSetup(ForcePolar, Cam)
	
		
	pass
func ResetGame():
	pass

func MoonHit():
	print("DanielHit")
	LaunchRocket.Success()
	pass
