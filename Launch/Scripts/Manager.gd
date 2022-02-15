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
onready var Arrow = $CanvasLayer/ArrowControl
onready var EndScreen = $CanvasLayer/GameEnd
var InGame = true
var HighScore = 0
var ScoreFile = "user://score.save"

var CanLaunch = false
var CanPan = true
var PanVec = Vector2.ZERO
onready var CamTween = $CamTween

func MakeConnections():
	Rocket.connect("Launched",self,"OnLaunch")
	Cam.make_current()
	Moon.connect("MoonHit",self,"MoonHit")
	LaunchRocket.connect("Crash",self,"RocketCrash")
	Arrow.UpdateMoon(Moon)
	Arrow.Tracker = $Camera2D/Tracker
	LoadScore()
	pass

func SaveScore():
	var file = File.new()
	file.open(ScoreFile, File.WRITE)
	file.store_var(HighScore)
	file.close()
	pass

func LoadScore():
	var file = File.new()
	if file.file_exists(ScoreFile):
		file.open(ScoreFile,File.READ)
		HighScore = file.get_var()
		file.close()
	pass
	
func _ready():
	LoadScore()
	MakeConnections()
	Arrow.set("visible",true)
	pass


func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	if CanPan:
		if event.is_action_pressed("Pan_Left"):
			PanVec.x = -1
		elif event.is_action_pressed("Pan_Right"):
			PanVec.x = 1
		elif event.is_action_pressed("Pan_Up"):
			PanVec.y = -1
		elif event.is_action_pressed("Pan_Down"):
			PanVec.y = 1
		elif event.is_action_released("Pan_Left"):
			PanVec.x = 0
		elif event.is_action_released("Pan_Right"):
			PanVec.x = 0
		elif event.is_action_released("Pan_Up"):
			PanVec.y = 0
		elif event.is_action_released("Pan_Down"):
			PanVec.y = 0
	if event.is_action_pressed("Recenter") && CanPan == true:
		PanVec = Vector2.ZERO
		Arrow.set("visible",false)
		CanPan = false
		CanLaunch = true
		CamTween.interpolate_property(Cam,"position",Cam.get("position"),Vector2(512,0),.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		CamTween.start()
		Rocket.CanLaunch = CanLaunch

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
	Cam.set("position",Vector2(512,500))
	Cam.make_current()
	LaunchRocket = LaunchRocketClass.instance()
	MakeConnections()
	pass


func _physics_process(delta):
	if CanPan:
		var NewPos = Cam.get("position")+(PanVec*300)
		NewPos.x = clamp(NewPos.x,Cam.limit_left,Cam.limit_right)
		NewPos.y = clamp(NewPos.y,Cam.limit_top,Cam.limit_bottom)
		Cam.set("position",NewPos)


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
		Moon.MoonRand()
		Arrow.UpdateMoon(Moon)
		Arrow.set("visible",true)
		CanPan = true
	else: 
		GameEnd()
	pass 

func GameEnd():
	InGame = false
	if int(UI.Score.text) > HighScore:
		HighScore = int(UI.Score.text)
		SaveScore()
	EndScreen.UpdateScores(UI.Score.text,HighScore)
	EndScreen.set("visible",true)
	EndScreen.connect("ResetGame",self,"GameReset")
	pass
	
func GameReset():
	get_tree().reload_current_scene()
	pass
