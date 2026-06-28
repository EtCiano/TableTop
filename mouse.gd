extends Node2D

var segurando: bool = false
var mouse_pos_origin: Vector2
var node_pos_origin: Vector2 

func _unhandled_input(event: InputEvent) -> void:
	
	print($Camera2D.zoom)
	
	var contagem_wheel = 0
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		segurando = event.pressed
		if segurando:
			mouse_pos_origin = event.global_position
			node_pos_origin = global_position

	elif event is InputEventMouseMotion and segurando:
		var delta: Vector2 = event.global_position - mouse_pos_origin
		global_position = node_pos_origin + (delta * -1)
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		contagem_wheel += 0.1
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		contagem_wheel -= 0.1
	
	$Camera2D.zoom += Vector2(contagem_wheel, contagem_wheel)
