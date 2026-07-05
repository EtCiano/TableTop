extends Node2D

const GRID_COLOR: Color = Color(1, 1, 1, 0.1)

func _ready():
	set_process(true)

func _process(_delta):
	queue_redraw()

func _draw():
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var camera_pos = camera.global_position
	var camera_zoom = camera.zoom
	
	if camera_zoom == Vector2.ZERO:
		camera_zoom = Vector2.ONE
	
	var half_size = viewport_size * 0.5 / camera_zoom
	
	var top_left = camera_pos - half_size
	var bottom_right = camera_pos + half_size
	
	var start_x = floor(top_left.x / Global.tamanho_grid) * Global.tamanho_grid
	var start_y = floor(top_left.y / Global.tamanho_grid) * Global.tamanho_grid
	var end_x = ceil(bottom_right.x / Global.tamanho_grid) * Global.tamanho_grid
	var end_y = ceil(bottom_right.y / Global.tamanho_grid) * Global.tamanho_grid
	
	var width = max(1.0, 1.0 / camera_zoom.x)
	
	var x = start_x
	while x <= end_x:
		draw_line(Vector2(x, top_left.y), Vector2(x, bottom_right.y), GRID_COLOR, width)
		x += Global.tamanho_grid
	
	var y = start_y
	while y <= end_y:
		draw_line(Vector2(top_left.x, y), Vector2(bottom_right.x, y), GRID_COLOR, width)
		y += Global.tamanho_grid
