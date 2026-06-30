extends Control

@export var asset_folder: String = "res://assets/"
@onready var grid = $ColorRect/ScrollContainer/GridContainer

const AssetButton = preload("res://scenes/asset_button.tscn")
const AssetMap = preload("res://scenes/asset_map.tscn")

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
	pass
	#var assetOnMap = AssetMap.instantiate()
	#get_tree().current_scene.add_child(assetOnMap)
	#assetOnMap.position = Vector2(0, 0)
	#var texturaAsset = assetOnMap.add_node($textura)
	#var colisaoAsset = assetOnMap.add_node($colisao)
	#texturaAsset.texture = asset.texture
	#texturaAsset.size = Vector2(asset.sizeX, asset.sizeY)
	#colisaoAsset.size = Vector2(asset.sizeX, asset.sizeY)
	
	# Lógica de fazer um objeto para cada não funcionou, fazer usando tileMap e colcoar o asset no tileMapLayer na cena main
	
	# Problemas: 
	# - não consegui colocar o tileset direto no valor dos assets, então será necessário transformar a textura em tile set OU *predefinir um tileset com a textura e só colocar os valores necessários para encontra-lo (as coordenadas, caso coloque o asset no tileMap padrão ou apenas o id do Tilemap caso separe em diferentes Tilemaps)*
	# - Não sei como farei para mover os assets com eles como tileSets, talvez colocar para o mestre deletar tile por tile em vez de mover o tileSet completo
	
	# TODO: logica de colcoar o asset nop mapa
