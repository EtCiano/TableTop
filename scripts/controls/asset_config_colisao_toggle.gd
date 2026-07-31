extends CheckButton

func _on_toggled(toggled_on: bool) -> void:
	Global.asset_config.collision = toggled_on
	var body_col = Global.token_selecionado.get_node_or_null("BodyCollisionShape")
	if body_col:
		body_col.disabled = not toggled_on
