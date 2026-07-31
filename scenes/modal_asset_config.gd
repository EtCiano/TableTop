extends PanelContainer

func _ready():
	var botao = $Button
	if botao.pressed.is_connected(_on_button_pressed):
		botao.pressed.disconnect(_on_button_pressed)
	botao.pressed.connect(_on_button_pressed)
	botao.z_index = 100
	botao.move_to_front()

func _on_button_pressed() -> void:
	print("fechar modal")
	visible = false

func setup(asset: assetData) -> void:
	Global.asset_config = asset
	$HBoxContainer2/VBoxContainer1/imagemAsset.texture_normal = asset.texture
	$HBoxContainer2/VBoxContainer1/tamanhoHBox/VBoxContainer3/sizeX.value = asset.size.x / Global.tamanho_grid
	$HBoxContainer2/VBoxContainer1/tamanhoHBox/VBoxContainer3/sizeY.value = asset.size.y / Global.tamanho_grid
	$HBoxContainer2/VBoxContainer1/ZIndexHBox/ZIndex.value = asset.z_index
	$HBoxContainer2/VBoxContainer1/ColisaoHBox/TogglesVBox/colisaoToggle.button_pressed = asset.collision
	visible = true
