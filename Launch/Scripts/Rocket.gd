extends Node2D

var Velocity  = null
var Acceleration = -9.81
var Mass = 20.0
var SpringConst = .8
var InFlight = false
var Emitting = true
onready var Fire = $Sprite/FireParticles
onready var Smoke = $Sprite/Smoke
onready var Cam = $Camera2D
onready var MyTween = $CamTween
onready var BoostTween = $BoostTween
onready var Flag = $Flag
var HasBoosted = false
var Boosting = false
onready var CounterTimer = $Counter
var Time = 0
signal Crash


func PhysicsSetup(ForcePolar, OldCam):
	Velocity = polar2cartesian(.5*SpringConst*(450-ForcePolar.x)*(1/Mass) * 6,ForcePolar.y)
	InFlight = true
	CounterTimer.start()
	Cam.set_global_position(OldCam.get("position"))
	Cam.make_current()
	MyTween.interpolate_property(Cam,"position",Cam.get("position"),Vector2(0,0),3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	MyTween.start()
	pass

func _input(event):
	if event.is_action_pressed("Boost") and !HasBoosted:
		HasBoosted = true
		Boost()


func _physics_process(delta):
	if InFlight:
		set("position",get("position") + (Velocity))
		set("rotation_degrees", rad2deg(cartesian2polar(Velocity.x,Velocity.y).y)+90)
		Velocity.y -= delta*Acceleration
		
		Cam.limit_bottom = 750
		
		if Velocity.y > 0 && !Boosting:
			Emitting = false
			Fire.set("emitting",Emitting)
			Smoke.set("emitting",Emitting)
		if get("position").y >  666:
			InFlight = false
			CounterTimer.stop()
			print("Giga Crash")
			emit_signal("Crash")
	pass
	
func Success():
	InFlight = false
	MyTween.interpolate_property(Flag,"position",Vector2(0,0),Vector2(-42,0),.5,MyTween.TRANS_EXPO,Tween.EASE_IN_OUT)
	MyTween.start()
	Emitting = false
	Fire.set("emitting",Emitting)
	Smoke.set("emitting",Emitting)
	Flag.set("playing", true)
	CounterTimer.stop()
	pass

func Boost():
	BoostTween.interpolate_property(self,"Acceleration",-9.81,.5,BoostTween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	BoostTween.start()
	Fire.set("amount",150)
	Fire.set("scale_amount",.2)
	Fire.set("initial_velocity",1.5)
	Boosting = true
	Fire.set("emitting",true)
	Smoke.set("emitting",true)
	$Timer.start()
	pass





func _on_Timer_timeout():
		BoostTween.interpolate_property(self,"Acceleration",0.5,-9.81,BoostTween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		BoostTween.start()
		Fire.set("amount",100)
		Fire.set("scale_amount",.11)
		Fire.set("initial_velocity",.93)
		Boosting = false



func _on_Counter_timeout():
	Time+=1
