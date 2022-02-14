extends Control
onready var Arrow =  $TextureRect
onready var Timer = $Timer
onready var MyTween = $Tween
onready var PosTween = $Tween2
onready var ViewSize = get_viewport_rect().size
var Rocket
var MoonPos
var RocketPos
var Theta
var Dist
var Pol
var NewPos



func UpdateMoon(Moon):
	MoonPos = Moon.get_global_position()
	


func _on_Timer_timeout():
	if MoonPos && Rocket:
		RocketPos = Rocket.get_global_position()
		Dist = MoonPos-RocketPos
		Pol = cartesian2polar(Dist.x,Dist.y)
		Theta = Pol.y
		NewPos = Vector2.ZERO
		NewPos.x = clamp(Dist.x,64,ViewSize.x-64)
		NewPos.y = clamp(Dist.y,64,ViewSize.y-128)
		MyTween.interpolate_property(Arrow,"rect_rotation",Arrow.get("rect_rotation"),rad2deg(Theta)+90,.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		PosTween.interpolate_property(self,"rect_position",get("rect_position"),NewPos,.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		MyTween.start()
		PosTween.start()
		set("rect_position", NewPos)
		print(rad2deg(Theta))
	pass # Replace with function body.
