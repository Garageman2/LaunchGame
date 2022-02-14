extends Sprite

signal MoonHit



func _on_Area2D_area_entered(area):
	print(area.get_parent().get_parent().name)
	if area.get_parent().get_parent().name == "RocketRoot":
		emit_signal("MoonHit")
