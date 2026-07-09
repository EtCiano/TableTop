class_name Token
extends Node2D

var data: assetData
var clicado: int = 0
var segurando: bool = false
const POP_UP_SCENE = preload("res://scenes/pop_up_asset.tscn")
const MAIN_SCENE = preload("res://scenes/main.tscn")

func setup(asset: assetData):
	data = asset
	
	$texture.material = data.material
	
	$texture.texture = asset.texture
	z_index = asset.z_index
	
	var tex_size = asset.texture.get_size()
	$texture.scale = asset.size / tex_size
	$moverIcon.scale = (asset.size / tex_size)/2
	$moverIcon.visible = false
	$selecionadoIcon.scale = asset.size / tex_size
	$selecionadoIcon.visible = false
	
	var shape = RectangleShape2D.new()
	shape.size = asset.size
	$Area2D/CollisionShape2D.shape = shape

func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if clicado > 0:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				segurando = true
				fechar_popUp()
				$moverIcon.visible = true
				clicado = 0
		else:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and clicado == 0:
				
				clicado += 1
				abrir_popUp()
				get_viewport().set_input_as_handled()
				
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			segurando = false
			$moverIcon.visible = false
			
	if event is InputEventMouseMotion and segurando:
		var mouse_pos = get_global_mouse_position()
		global_position = Vector2(snapped(mouse_pos.x, Global.tamanho_grid/2), snapped(mouse_pos.y, Global.tamanho_grid/2))

func _ready():
	$Area2D.input_event.connect(_on_area_2d_input_event)
	$Area2D.input_pickable = true
	add_to_group("tokens")

func _on_deletar_pressed():
	queue_free()

func _on_bloquear_pressed():
	data.movivel = !data.movivel
	print(data.movivel)
	fechar_popUp()
			
func fechar_popUp():
	$selecionadoIcon.visible = false
	var nodeGrupo = get_node("Node")
	if nodeGrupo.get_children().size() >= 1:
		for popUpUsado in nodeGrupo.get_children():
			popUpUsado.queue_free()

func abrir_popUp():
	var nodeGrupo = get_node("Node")
	
	var pop_up = POP_UP_SCENE.instantiate()
	
	fechar_popUp()
	nodeGrupo.add_child(pop_up)
	
	pop_up.name = 'pop_up_asset'
	
	if data.movivel:
		pop_up.get_node('GridContainer/BotaoBloquear').texture_normal = preload("res://sprites/icones/bloquearIcon.png")
	else:
		pop_up.get_node('GridContainer/BotaoBloquear').texture_normal = preload("res://sprites/icones/desbloquearIcon.png")
	
	pop_up.get_node('GridContainer/BotaoDeletar').pressed.connect(_on_deletar_pressed)
	pop_up.get_node('GridContainer/BotaoBloquear').pressed.connect(_on_bloquear_pressed)
	pop_up.get_node('GridContainer/BotaoMover').pressed.connect(_on_mover_pressed)
	
	pop_up.get_node('GridContainer/BotaoFechar').pressed.connect(_signal_fechar_popUp)
	
	pop_up.global_position = get_global_mouse_position()
	
	$selecionadoIcon.visible = true
	
	$Timer.start()

func _signal_fechar_popUp():
	clicado = 0
	fechar_popUp()

func _on_mover_pressed():
	segurando = true
	$moverIcon.visible = true
	fechar_popUp()

func _on_timer_timeout() -> void:
	fechar_popUp()
