extends Sprite

onready var Parent = get_parent();
onready var Spring = Parent.get_child(1)

# Declare member variables here. Examples:
var RocketPos = Vector2(0,0)
onready var LaunchRoot = get_parent();
export var Radius = 300
var HasLaunched = false
signal Launched(Force, WorldPos)


func Setup():
	LaunchRoot.set("position",Vector2(-200,666))
	HasLaunched = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Setup()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !HasLaunched:
		RocketPos = get_global_mouse_position();
		RocketPos = RocketPos - LaunchRoot.get("position")
		set("position",FindPosition(RocketPos))
		if Input.is_action_pressed("Launch"):
			print("Launch lanuch!")
			HasLaunched = true;
			emit_signal("Launched", get("position"), global_position)
	return


func FindPosition(RocketPos):
	var NewCoords = null;
	NewCoords = cartesian2polar(RocketPos.x,RocketPos.y)
	NewCoords.x = clamp(NewCoords.x,75,Radius)
	NewCoords.y = clamp(NewCoords.y,-1.5,-.2)
	Spring.set("rotation_degrees",rad2deg(NewCoords.y)+90)
	set("rotation_degrees",rad2deg(NewCoords.y)+90)
	Spring.set("scale",Vector2(.3,NewCoords.x*.0015))
	
	NewCoords = polar2cartesian(NewCoords.x,NewCoords.y)

	#theta can be used to calculate the forward vector for the motion
	#R can be used for x for the spring force.
	return NewCoords;
