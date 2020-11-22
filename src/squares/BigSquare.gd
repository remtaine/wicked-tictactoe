class_name BigSquare
extends Control

signal changed_color(value, tile_position, small_square_position)


onready var grid = $Grid

func _ready() -> void:
	for small_square in grid.get_children():
		small_square.connect("filled_up_by_none", self, "_on_Small_Square_filled_up")
		for tile in small_square.get_children():
			tile.connect("changed_color", self, "_on_Tile_changed_color")
			
			
func _on_Tile_changed_color(value, tile_position, small_square_position) -> void:
	emit_signal("changed_color", value, tile_position, small_square_position)

func _on_Small_Square_filled_up() -> void:
	pass
