# asset_palette.gd
extends PanelContainer

signal asset_selected(asset: assetData)

var available_assets: Array[assetData] = []

var _sliders_visiveis: bool = true
var _paleta_expandida: bool = true

const BOTAO_CENA = preload("res://scenes/botao_asset.tscn")
const ICONE_COLAPSAR = preload("res://sprites/icones/diminuirIcon.png")

func _ready():
	$ScrollContainer.custom_minimum_size = Vector2(size.x-50, size.y-50)
	_load_assets_from_folder("res://assets/")
	_populate_grid()
	_conectar_colapsar_sliders()
	_criar_botao_colapsar_assets()

func _conectar_colapsar_sliders():
	var botao = get_parent().get_node("colapsarSliders")
	if not botao.pressed.is_connected(_on_colapsar_sliders_pressed):
		botao.pressed.connect(_on_colapsar_sliders_pressed)

func _criar_botao_colapsar_assets():
	var botao = get_parent().get_node_or_null("colapsarAssets")
	if botao == null:
		botao = Button.new()
		botao.name = "colapsarAssets"
		botao.offset_left = 799.0
		botao.offset_top = 311.0
		botao.offset_right = 927.0
		botao.offset_bottom = 324.0
		botao.pivot_offset = Vector2(64, 64)
		botao.rotation = -PI / 2
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.6, 0.6, 0.6, 0)
		botao.add_theme_stylebox_override("normal", style)
		var icon = TextureRect.new()
		icon.name = "TextureRect"
		icon.set_anchors_preset(Control.PRESET_FULL_RECT)
		icon.grow_horizontal = Control.GROW_DIRECTION_BOTH
		icon.grow_vertical = Control.GROW_DIRECTION_BOTH
		icon.texture = ICONE_COLAPSAR
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		botao.add_child(icon)
		get_parent().add_child(botao)
	if not botao.pressed.is_connected(_on_colapsar_assets_pressed):
		botao.pressed.connect(_on_colapsar_assets_pressed)

func _on_colapsar_sliders_pressed():
	var offSet = get_node('../sliderParede').size.y
	_sliders_visiveis = not _sliders_visiveis
	get_parent().get_node("sliderParede").visible = _sliders_visiveis
	get_parent().get_node("sliderSnap").visible = _sliders_visiveis
	var botaoSliders = get_parent().get_node("colapsarSliders")
	if _sliders_visiveis:
		botaoSliders.position.y -= offSet
	else:
		botaoSliders.position.y += offSet

func _on_colapsar_assets_pressed():
	var offSet = size.x
	_paleta_expandida = not _paleta_expandida
	visible = _paleta_expandida
	var botaoAssets = get_parent().get_node("colapsarAssets")
	if _paleta_expandida:
		botaoAssets.position.x -= offSet
	else:
		botaoAssets.position.x += offSet

func _load_assets_from_folder(path: String):
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Pasta não encontrada: " + path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		var full_path = path + file_name

		if dir.current_is_dir() and file_name != "." and file_name != "..":
			_load_assets_from_folder(full_path + "/")

		elif file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var resource = load(full_path)
			if resource is assetData:
				available_assets.append(resource)

		file_name = dir.get_next()

	dir.list_dir_end()

func _populate_grid():
	for child in $ScrollContainer/GridContainer.get_children():
		child.queue_free()

	for asset in available_assets:
		var btn = BOTAO_CENA.instantiate()
		btn.get_node("VBoxContainer/TextureRect").texture = asset.texture
		btn.get_node("VBoxContainer/Label").text = asset.name
		btn.pressed.connect(func(): asset_selected.emit(asset))
		$ScrollContainer/GridContainer.add_child(btn)
