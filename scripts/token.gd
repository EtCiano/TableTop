class_name Token
extends Node2D

var data: assetData
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func setup(asset: assetData):
	data = asset
	
	$texture.texture = asset.texture
	z_index = asset.z_index
	
	var tex_size = asset.texture.get_size()
	$texture.scale = asset.size / tex_size
	
	var shape = RectangleShape2D.new()
	shape.size = asset.size
	$Area2D/CollisionShape2D.shape = shape
	
	$Label.text = asset.name
	$Label.visible = asset.name != ""

func _ready():
	$Area2D.input_event.connect(_on_input_event)
	set_process(false)

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if not data.movivel:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_start_drag(event.global_position)
			else:
				_end_drag()

func _start_drag(mouse_pos: Vector2):
	is_dragging = true
	drag_offset = global_position - mouse_pos
	z_index += 10  
	set_process(true)

func _end_drag():
	is_dragging = false
	z_index = data.z_index
	set_process(false)

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
