extends Control
onready var Arrow =  $TextureRect
onready var Timer = $Timer
onready var MyTween = $Tween
onready var PosTween = $Tween2
onready var ViewSize = get_viewport_rect().size
var Tracker
var MoonPos
var Dist
var Pol
var NewPos



func UpdateMoon(Moon):
	MoonPos = Moon.get_global_position()
	


func _on_Timer_timeout():
	if MoonPos && Tracker:
		Dist = MoonPos-Tracker.get_global_position()
		Pol = cartesian2polar(Dist.x,Dist.y)
		NewPos = Vector2.ZERO
		NewPos.x = clamp(Dist.x,64,ViewSize.x-64)
		NewPos.y = clamp(Dist.y+650,64,ViewSize.y-128)
		MyTween.interpolate_property(Arrow,"rect_rotation",Arrow.get("rect_rotation"),rad2deg(Pol.y)+90,.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		PosTween.interpolate_property(self,"rect_position",get("rect_position"),NewPos,.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		MyTween.start()
		PosTween.start()
	pass # Replace with function body.
