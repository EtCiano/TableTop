# token_manager.gd
class_name TokenManager
extends Node2D

const TOKEN_SCENE = preload("res://scenes/token.tscn")

var tokens: Array[Token] = []

func spawn_token(asset: assetData, pos: Vector2) -> Token:
	var token = TOKEN_SCENE.instantiate()
	add_child(token)
	token.global_position = pos
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
