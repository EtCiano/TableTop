extends Control

@export var asset_folder: String = "res://assets/"
@onready var grid = $ColorRect/ScrollContainer/GridContainer

const AssetButton = preload("res://scenes/asset_button.tscn")

func _ready() -> void:
	_load_assets()

func _load_assets() -> void:
	var dir = DirAccess.open(asset_folder)
	if not dir:
		push_error("Pasta não encontrada: " + asset_folder)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var path = asset_folder + file_name
			var asset = load(path)

			if asset is assetData:
				_spawn_button(asset)

		file_name = dir.get_next()

	dir.list_dir_end()

func _spawn_button(asset: assetData) -> void:
	var btn = AssetButton.instantiate()
	grid.add_child(btn)
	btn.setup(asset)
	btn.pressed.connect(_on_asset_selected.bind(asset))

func _on_asset_selected(asset: assetData) -> void:
	print("Asset selecionado: ", asset.name)
	# TODO: logica de colcoar o asset nop mapa
