extends Node2D

onready var Menu = $TextureRect
onready var Backplate = $TextureRect2

func _ready():
	Backplate.set("rect_scale",Vector2((get_viewport().size.x/4096)+.02,(get_viewport().size.y/2304)+.02))
	Menu.set("rect_scale",Vector2(((get_viewport().size.y/1024)+.02),(get_viewport().size.y/1024)+.02))
	Menu.set("rect_position",Vector2(get_viewport().size.x/4,0))
	pass

func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.
