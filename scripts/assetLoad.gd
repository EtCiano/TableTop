extends Node

signal asset_selected(asset: assetData)

@export var assets: Array[assetData]
@export var grid_container: GridContainer

var selected_asset: assetData


func _ready() -> void:
	if not grid_container:
		return

	if assets.is_empty():
		print("assetLoad: 'assets' array vazio. Atribua os arquivos .tres no Inspector.")
		return

	for asset in assets:
		var btn = TextureButton.new()
		if asset.texture:
			btn.texture_normal = asset.texture
		btn.tooltip_text = asset.name
		btn.custom_minimum_size = Vector2(64, 64)
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		btn.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
		btn.connect("pressed", Callable(self, "_on_asset_pressed").bind(asset))
		grid_container.add_child(btn)


func _on_asset_pressed(asset: assetData) -> void:
	selected_asset = asset
	asset_selected.emit(asset)
