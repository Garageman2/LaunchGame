extends Node2D
onready var CloudTex = preload("res://Assets/Cloud.png")

func _ready():
	randomize()
	for _i in range ((randi()%20)+1):
		var Cloud = Sprite.new()
		Cloud.set("texture",CloudTex)
		Cloud.set("position",Vector2(randi()%15000,-1*randi()%5000))
		add_child(Cloud)
	pass
