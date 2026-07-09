extends TileMapLayer

const TERRAIN_SET: int = 0
const TERRAIN_ID: int = 0 

var is_drawing: bool = false
var is_erasing: bool = false

func _ready() -> void:
	scale = Global.tamanho_celula/128
	#tile_set.tile_size = Global.tamanho_grid*2

func _process(delta: float) -> void:
	scale = Global.tamanho_celula/128

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_drawing = event.pressed
		if is_drawing and not _is_token_at_mouse():
			modify_terrain(TERRAIN_ID)

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		is_erasing = event.pressed
		if is_erasing and not _is_token_at_mouse():
			modify_terrain(-1)

	elif event is InputEventMouseMotion:
		if is_drawing and not _is_token_at_mouse():
			modify_terrain(TERRAIN_ID)
		elif is_erasing and not _is_token_at_mouse():
			modify_terrain(-1)

func _is_token_at_mouse() -> bool:
	var mouse_pos = get_global_mouse_position()

	var main = get_tree().current_scene
	if main and "selected_asset" in main and main.selected_asset != null:
		return true

	for token in get_tree().get_nodes_in_group("tokens"):
		var token_rect = Rect2(token.global_position - token.data.size / 2, token.data.size)
		if token_rect.has_point(mouse_pos):
			return true
	return false

func modify_terrain(terrain_to_apply: int) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_coords: Vector2i = local_to_map(to_local(mouse_pos))
	
	var cells_to_modify: Array[Vector2i] = [tile_coords]
	
	set_cells_terrain_connect(cells_to_modify, TERRAIN_SET, terrain_to_apply)
