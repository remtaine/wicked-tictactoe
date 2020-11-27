extends Control

export var skip_splashscreen := false

var path = "res://src/menus/MainMenu.tscn"


func _ready() -> void:
	if skip_splashscreen:
		SceneChanger.change_scene(path, false)
	else:
		$AnimationPlayer.play("show")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	SceneChanger.change_scene(path, false)
