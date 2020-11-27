class_name Tile
extends TextureRect

signal changed_color(value, tile_position, small_square_position)

enum Value {
	EMPTY = -1,
	BLUE = 0,
	RED = 1,
	NONE = 2,
}
export (Value) var current_value := Value.EMPTY setget set_value

export (float) var scale_on_hover = 1.1
export (float) var modulate_on_unselectable = 0.6

#export (PackedScene) var clicked_particle


var is_selectable = true setget set_selectable
var is_clickable = true setget set_clickable
var intro_tween_duration = 0.2
var clicked_tween_duration = 0.3

onready var tween = $Tween
onready var clicked_particle = preload("res://src/particles/ClickedParticle.tscn")


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	visible = false
#	rect_scale = Vector2.ZERO
	is_clickable = false
	
func intro() -> void:
#	tween.interpolate_property(self, "rect_rotation", rect_rotation - 360, rect_rotation, intro_tween_duration, Tween.TRANS_LINEAR,Tween.EASE_IN)
#	tween.interpolate_property(self, "rect_scale", Vector2.ZERO, Vector2.ONE, intro_tween_duration, Tween.TRANS_LINEAR,Tween.EASE_IN)
	visible = true
	tween.interpolate_property(self, "rect_position", rect_position + Vector2.UP * 6, rect_position, intro_tween_duration, Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	
func capture(value = Value.NONE) -> void:
	$TopTiles.play("full")
	
	match value:
		Value.BLUE:
#			$TopTiles.play("full")
			$TopTiles.modulate = GameInfo.blue
			$ColorblindTiles.play("blue_bg")
		Value.RED:
#			$TopTiles.play("full")			
			$TopTiles.modulate = GameInfo.red
			$ColorblindTiles.play("red_bg")
		Value.NONE:
#			$TopTiles.play("full")
			$TopTiles.modulate = GameInfo.yellow
#			$ColorblindTiles.play("yellow_bg")
			
	set_clickable(false)

func _on_Tile_mouse_entered() -> void:
#	set_value((current_value + 1) % 2)
	if is_clickable and is_selectable:
		rect_scale *= scale_on_hover
	

func _on_Tile_mouse_exited() -> void:
	if is_clickable and is_selectable:
		rect_scale /= scale_on_hover


func _on_Tile_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and is_clickable and is_selectable:
#		$Audio/Clicked.pitch_scale = rand_range(1.00, 1.05)
		click()
		
#		animate("top_rotation")
#		tween.interpolate_property($TopTiles, "rotation_degrees", $TopTiles.rotation_degrees + 360, $TopTiles.rotation_degrees, clicked_tween_duration, Tween.TRANS_LINEAR,Tween.EASE_IN)
#		tween.start()
#		$TopTiles.modulate = Color(1,1,1,1)
		
func click():
	$Audio/Clicked.play()
		
	var particle = clicked_particle.instance()
	particle.position = get_global_mouse_position()
	GameInfo.current_level.add_child(particle)
	particle.emitting = true
	
	match GameInfo.current_level.current_turn:
		"blue":
			set_value(0)
			GameInfo.current_level.current_turn = "red"
		"red":
			set_value(1)
			GameInfo.current_level.current_turn = "blue"
	set_clickable(false)
		
func set_value(v : int) -> void:
	if current_value == v:
		return
		
	current_value = v
	
	match current_value:
		Value.BLUE:
			$TopTiles.play("blue")
		Value.RED:
			$TopTiles.play("red")
	emit_signal("changed_color", current_value, get_name(), get_parent().get_name())	
		
		
func set_selectable(s : bool):
	if is_selectable == s:
		return
		
	is_selectable = s
	if not is_selectable:# and $TopTiles.animation == ("empty"):
#		$TopTiles.play("full")
		
		$BottomTiles.modulate *= modulate_on_unselectable
#		modulate *= modulate_on_unselectable
	else: #if $TopTiles.animation == ("full"):
#		$TopTiles.play("empty")
		$BottomTiles.modulate /= modulate_on_unselectable
#		modulate /= modulate_on_unselectable
	
func animate(property) -> void:
	match property:
		"top_rotation":
			tween.interpolate_property($TopTiles, "scale", Vector2.ZERO, $TopTiles.scale, clicked_tween_duration, Tween.TRANS_LINEAR,Tween.EASE_IN)
			
			
func set_clickable(c) -> void:
	if is_clickable == c:
		return
	is_clickable = c
	rect_scale = Vector2.ONE


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
#	$Audio/Spawned.play()
	pass

func _on_Tween_tween_started(object: Object, key: NodePath) -> void:
#	if key == ":rect_scale":
	$Audio/Spawned.play()
	
	pass # Replace with function body.
