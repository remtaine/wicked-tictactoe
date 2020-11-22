extends GridContainer

signal filled_up_by_none
var filled_up_tiles = 0
var is_selectable = true
var current_value = -1


func _ready() -> void:
	for tile in get_children():
		tile.connect("changed_color", self, "_on_Tile_changed_color")

func _on_Tile_changed_color(value, tile_position, small_square_position) -> void:
	filled_up_tiles += 1
#	if filled_up_tiles == 9:
##		for tile in get_children():
##			tile.capture()
#		emit_signal("filled_up_by_none")
