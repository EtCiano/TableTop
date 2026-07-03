class_name Token
extends Node2D

var data: assetData

func setup(asset: assetData):
	data = asset
	
	$texture.texture = asset.texture
	z_index = asset.z_index
	
	var tex_size = asset.texture.get_size()
	$texture.scale = asset.size / tex_size
	
	var shape = RectangleShape2D.new()
	shape.size = asset.size
	$Area2D/CollisionShape2D.shape = shape
	
	$Label.text = asset.name
	$Label.visible = asset.name != ""


func _ready():
	pass
