extends TileMapLayer

const TERRAIN_SET: int = 0
const TERRAIN_ID: int = 0 

var is_drawing: bool = false
var is_erasing: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_drawing = event.pressed
		if is_drawing:
			modify_terrain(TERRAIN_ID)

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		is_erasing = event.pressed
		if is_erasing:
			modify_terrain(-1)

	elif event is InputEventMouseMotion:
		if is_drawing:
			modify_terrain(TERRAIN_ID)
		elif is_erasing:
			modify_terrain(-1)

func modify_terrain(terrain_to_apply: int) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_coords: Vector2i = local_to_map(to_local(mouse_pos))
	
	var cells_to_modify: Array[Vector2i] = [tile_coords]
	
	set_cells_terrain_connect(cells_to_modify, TERRAIN_SET, terrain_to_apply)
