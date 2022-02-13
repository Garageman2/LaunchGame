extends Node2D

var Velocity  = null
var Acceleration = -9.81
var Mass = 20.0
var SpringConst = .8
var InFlight = false
onready var Cam = $Camera2D
onready var MyTween = $Tween

func PhysicsSetup(ForcePolar, OldCam):
	Velocity = polar2cartesian(.5*SpringConst*(450-ForcePolar.x)*(1/Mass) * 4,ForcePolar.y)
	InFlight = true
	Cam.set_global_position(OldCam.get("position"))
	Cam.make_current()
	MyTween.interpolate_property(Cam,"position",Cam.get("position"),Vector2(0,0),3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	MyTween.start()
	pass

func PhysicsMove():
	pass
	
func _physics_process(delta):
	if InFlight:
		set("position",get("position") + (Velocity))
		set("rotation_degrees", rad2deg(cartesian2polar(Velocity.x,Velocity.y).y)+90)
		Velocity.y -= delta*Acceleration
		if get("position").y >  get_viewport_rect().size.y - 40:
			InFlight = false
	pass

