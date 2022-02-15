extends Sprite

var BG1 = preload("res://Assets/Background.png")
var BG2 = preload("res://Assets/Background2.png")
var BG3 = preload("res://Assets/Background3.png")
var Backgrounds = [BG1,BG2,BG3]

func _ready():
	randomize()
	set("texture",Backgrounds[randi()%3])
	pass
