# main.gd
extends Node2D

@onready var token_manager: TokenManager = $TokenManager
@onready var palette = $UI/assetPalette

var selected_asset: assetData = null

func _ready():
	palette.asset_selected.connect(_on_asset_selected)

func _on_asset_selected(asset: assetData):
	selected_asset = asset

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if selected_asset != null:
				token_manager.spawn_token(selected_asset, get_global_mouse_position())
