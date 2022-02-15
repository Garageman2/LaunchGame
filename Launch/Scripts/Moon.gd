extends Sprite

signal MoonHit

func _ready():
	rand_seed(OS.get_time().second)
	set("position",Vector2(rand_range(500,5000),rand_range(-8000,-500)))


func _on_Area2D_area_entered(area):
	print(area.get_parent().get_parent().name)
	if area.get_parent().get_parent().name == "RocketRoot":
		emit_signal("MoonHit")
