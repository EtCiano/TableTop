extends CheckButton

func _on_toggled(toggled_on: bool) -> void:
	Global.asset_config.collision = toggled_on
