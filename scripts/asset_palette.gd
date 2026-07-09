# asset_palette.gd
extends PanelContainer

signal asset_selected(asset: assetData)

var available_assets: Array[assetData] = []

const BOTAO_CENA = preload("res://scenes/botao_asset.tscn")

func _ready():
	$ScrollContainer.custom_minimum_size = Vector2(size.x-50, size.y-50)
	_load_assets_from_folder("res://assets/")
	_populate_grid()

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
