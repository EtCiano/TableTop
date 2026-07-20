class_name Token
extends CharacterBody2D

var pop_up_atual: PanelContainer
var data: assetData
var clicado: bool = false
var segurando: bool = false
var selecionado: bool = false

const POP_UP_SCENE = preload("res://scenes/pop_up_asset.tscn")
const MAIN_SCENE = preload("res://scenes/main.tscn")
const CONFIG_SCENE = preload("res://scenes/modal_asset_config.tscn")

func _ready():
	$Area2D.input_event.connect(_on_area_2d_input_event)
	$Area2D.input_pickable = true
	add_to_group("tokens")

func setup(asset: assetData):
	data = asset
	$texture.material = data.material
	$texture.texture = asset.texture
	z_index = asset.z_index
	
	var tex_size = asset.texture.get_size()
	$texture.scale = asset.size / tex_size
	$moverIcon.scale = (asset.size / tex_size) / 2
	$moverIcon.visible = false
	$selecionadoIcon.scale = asset.size / tex_size
	$selecionadoIcon.visible = false
	
	var shape = RectangleShape2D.new()
	shape.size = asset.size
	$Area2D/CollisionShape2D.shape = shape
	var body_col = CollisionShape2D.new()
	body_col.shape = shape
	body_col.name = "BodyCollisionShape"
	add_child(body_col)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if clicado and data.movivel:
					segurando = true
					fechar_popUp()
					$moverIcon.visible = true
					clicado = false
				else:
					clicado = true
					abrir_popUp()
					get_viewport().set_input_as_handled()
			else:
				segurando = false
				$moverIcon.visible = false
				abrir_popUp()
				clicado = true
			
	if event is InputEventMouseMotion and segurando:
		var mouse_pos = get_global_mouse_position()
		var target_pos = Vector2(
			snapped(mouse_pos.x, Global.snap / 2),
			snapped(mouse_pos.y, Global.snap / 2)
		)
		var displacement = target_pos - global_position
		if displacement.length() > 0:
			move_and_collide(displacement)
			
		if mouse_pos.distance_to(global_position) > Global.tamanho_grid * 1.5:
			segurando = false
			$moverIcon.visible = false

func abrir_popUp():
	if Global.token_selecionado and self != Global.token_selecionado:
		Global.token_selecionado.clicado = false
		Global.token_selecionado.fechar_popUp()
	
	selecionado = true
	Global.token_selecionado = self
	
	var nodeGrupo = get_node("Node")
	var pop_up = POP_UP_SCENE.instantiate()
	pop_up_atual = pop_up
	
	fechar_popUp()
	nodeGrupo.add_child(pop_up)
	pop_up.name = 'pop_up_asset'

	if not data.movivel:
		pop_up.get_node('GridContainer/BotaoBloquear').texture_normal = preload("res://sprites/icones/bloquearIcon.png")
	else:
		pop_up.get_node('GridContainer/BotaoBloquear').texture_normal = preload("res://sprites/icones/desbloquearIcon.png")
	
	pop_up.get_node('GridContainer/BotaoDeletar').pressed.connect(_on_deletar_pressed)
	pop_up.get_node('GridContainer/BotaoBloquear').pressed.connect(_on_bloquear_pressed)
	pop_up.get_node('GridContainer/BotaoMover').pressed.connect(_on_mover_pressed)
	pop_up.get_node('GridContainer/BotaoFechar').pressed.connect(_signal_fechar_popUp)
	pop_up.get_node('GridContainer/BotaoConfig').pressed.connect(_on_config_pressed)
	
	pop_up.global_position = get_global_mouse_position()
	$selecionadoIcon.visible = true
	$Timer.start()

func fechar_popUp():
	selecionado = false
	$selecionadoIcon.visible = false
	var nodeGrupo = get_node("Node")
	for child in nodeGrupo.get_children():
		child.queue_free()

func _signal_fechar_popUp():
	clicado = false
	fechar_popUp()

func _on_deletar_pressed():
	queue_free()

func _on_bloquear_pressed():
	data.movivel = !data.movivel
	if not data.movivel:
		pop_up_atual.get_node('GridContainer/BotaoBloquear').texture_normal = preload("res://sprites/icones/bloquearIcon.png")
	else:
		pop_up_atual.get_node('GridContainer/BotaoBloquear').texture_normal = preload("res://sprites/icones/desbloquearIcon.png")

func _on_mover_pressed():
	if data.movivel:
		segurando = true
		$moverIcon.visible = true
		fechar_popUp()

func _on_timer_timeout():
	clicado = false
	fechar_popUp()

func _on_config_pressed():
	var modal_config = get_node("/root/Main/UI/ModalAssetConfig")
	Global.asset_config = data
	modal_config.visible = true
	modal_config.get_node('HBoxContainer2/VBoxContainer1/imagemAsset').texture_normal = data.texture
	#modal_config
