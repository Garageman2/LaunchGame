extends Node2D

onready var RocketClass = preload("res://Scenes/Launcher.tscn")
onready var Rocket = $Launcher/LaunchRoot/Rocket
onready var LaunchRocketClass = preload("res://Scenes/Rocket.tscn")
onready var LaunchRocket = LaunchRocketClass.instance();
onready var Cam = $Camera2D
onready var Moon = $Moon
onready var HitTimer = $MoonEndTimer
var Lives = 3
onready var UI = $CanvasLayer/Interface

func MakeConnections():
	Rocket.connect("Launched",self,"OnLaunch")
	Cam.make_current()
	Moon.connect("MoonHit",self,"MoonHit")
	LaunchRocket.connect("Crash",self,"RocketCrash")
	pass

func _ready():
	MakeConnections()
	pass


func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func OnLaunch(Force,Position):
	Rocket.disconnect("Launched",self,"OnLaunch")
	$Launcher.queue_free();
	add_child(LaunchRocket);

	
	var ForcePolar = cartesian2polar(Force.x,Force.y)
	

	LaunchRocket.set("position", Position)
	LaunchRocket.set("rotation_degrees", rad2deg(ForcePolar.y)+90)
	LaunchRocket.PhysicsSetup(ForcePolar, Cam)
		
	pass
	
	
func RocketReset():
	Moon.disconnect("MoonHit",self,"MoonHit")
	LaunchRocket.disconnect("Crash",self,"RocketCrash")
	LaunchRocket.queue_free()
	Rocket = RocketClass.instance()
	Rocket.set_name("Launcher")
	add_child(Rocket)
	Rocket = Rocket.get_child(0).get_child(0)
	Cam.set("position",Vector2(512,0))
	Cam.make_current()
	LaunchRocket = LaunchRocketClass.instance()
	MakeConnections()
	pass



func RocketCrash():
	Lives -= 1
	HitTimer.start()
	pass

func MoonHit():
	UI.UpdateScore(LaunchRocket.Time)
	LaunchRocket.Success()
	HitTimer.start()
	pass


func _on_Timer_timeout():
	UI.UpdateLives(Lives)
	if Lives > 0:
		RocketReset()
	else: 
		GameEnd()
	pass # Replace with function body.

func GameEnd():
	pass
