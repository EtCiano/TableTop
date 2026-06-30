extends Button

var data: assetData

func setup(asset: assetData) -> void:
	data = asset
	$VBoxContainer/Label.text = asset.name
	$VBoxContainer/TextureRect.texture = asset.texture
