extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	
func activate():
	$Audio/Theme.play()
	GameInfo.is_blue_ai = false
	GameInfo.is_red_ai = false
	set_process(true)
	set_physics_process(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
