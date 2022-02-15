extends Sprite

signal MoonHit

func _ready():
	MoonRand()


func _on_Area2D_area_entered(area):
	print(area.get_parent().get_parent().name)
	if area.get_parent().get_parent().name == "RocketRoot":
		emit_signal("MoonHit")

func MoonRand():
	rand_seed(OS.get_time().second)
	set("position",Vector2(rand_range(1000,3000),rand_range(-1000,-500)))
