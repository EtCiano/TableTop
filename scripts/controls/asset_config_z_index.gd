extends SpinBox


func _ready():
	connect("value_changed", _on_spin_box_value_changed)

func _on_spin_box_value_changed(novo_valor: float):
	Global.asset_config.z_index = int(novo_valor)
	Global.token_selecionado.z_index = int(novo_valor)
