class_name Token
extends Node2D

var data: assetData
const POP_UP_SCENE = preload("res://scenes/pop_up_asset.tscn")
const MAIN_SCENE = preload("res://scenes/main.tscn")

func setup(asset: assetData):
	data = asset
	
	$texture.material = data.shader
	
	$texture.texture = asset.texture
	z_index = asset.z_index
	
	var tex_size = asset.texture.get_size()
	$texture.scale = asset.size / tex_size
	
	var shape = RectangleShape2D.new()
	shape.size = asset.size
	$Area2D/CollisionShape2D.shape = shape
	
	$Label.text = asset.name
	$Label.visible = asset.name != ""

func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
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
			
			pop_up.get_node('GridContainer/BotaoFechar').pressed.connect(_signal_fechar_popUp)
			
			pop_up.global_position = get_global_mouse_position()
			
			
			get_viewport().set_input_as_handled()
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
	var nodeGrupo = get_node("Node")
	if nodeGrupo.get_children().size() >= 1:
		for popUpUsado in nodeGrupo.get_children():
			popUpUsado.queue_free()

func _signal_fechar_popUp():
	fechar_popUp()
