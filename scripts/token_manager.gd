# token_manager.gd
class_name TokenManager
extends Node2D

#var Global.tamanho_grid: int = 64

const TOKEN_SCENE = preload("res://scenes/token.tscn")

var tokens: Array[Token] = []

func spawn_token(asset: assetData, pos: Vector2) -> Token:
	#if fmod(asset.size.x/64, 2) == 0 or fmod(asset.size.y/64, 2) == 0:
		#Global.tamanho_grid = 64
	#else:
		#Global.tamanho_grid = 128
	var token = TOKEN_SCENE.instantiate()
	add_child(token)
	token.global_position = Vector2(snapped(pos.x, Global.tamanho_grid/2), snapped(pos.y, Global.tamanho_grid/2))
	token.setup(asset)
	tokens.append(token)
	return token

func remove_token(token: Token):
	tokens.erase(token)
	token.queue_free()

func remove_all_tokens():
	for token in tokens:
		token.queue_free()
	tokens.clear()
