extends Node2D

onready var RocketClass = preload("res://Scenes/Launcher.tscn")
onready var Rocket = $Launcher/LaunchRoot/Rocket
onready var LaunchRocketClass = preload("res://Scenes/Rocket.tscn")
onready var LaunchRocket = LaunchRocketClass.instance();
onready var Cam = $Camera2D
onready var Moon = $Moon
onready var HitTimer = $MoonEndTimer

func MakeConnections():
	print(Rocket)
	Rocket.connect("Launched",self,"OnLaunch")
	Cam.make_current()
	Moon.connect("MoonHit",self,"MoonHit")
	pass

func _ready():
	MakeConnections()
	pass


func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func OnLaunch(Force,Position):
	print("Launching Happy")
	$Launcher.queue_free();
	add_child(LaunchRocket);
	
	var ForcePolar = cartesian2polar(Force.x,Force.y)
	

	LaunchRocket.set("position", Position)
	LaunchRocket.set("rotation_degrees", rad2deg(ForcePolar.y)+90)
	LaunchRocket.PhysicsSetup(ForcePolar, Cam)
		
	pass
	
	
func ResetGame():
	pass
	
func RocketReset():
	LaunchRocket.queue_free()
	Rocket = RocketClass.instance()
	Rocket.set_name("Launcher")
	add_child(Rocket)
	Rocket = Rocket.get_child(0).get_child(0)
	Cam.set("position",Vector2(512,0))
	Cam.make_current()
	MakeConnections()
	LaunchRocket = LaunchRocketClass.instance()
	pass

func MoonHit():
	LaunchRocket.Success()
	HitTimer.start()
	pass


func _on_Timer_timeout():
	RocketReset()
	pass # Replace with function body.
