extends SpinBox


func _ready():
	connect("value_changed", _on_spin_box_value_changed)

func _on_spin_box_value_changed(novo_valor: float):
	suffix = "tiles ({valorEmPx} px)".format({'valorEmPx' : int(novo_valor)*Global.tamanho_grid})
	Global.asset_config.size.x = novo_valor*Global.tamanho_grid 
	var tex_size = Global.asset_config.texture.get_size()
	Global.token_selecionado.get_node('texture').scale = Global.asset_config.size / tex_size
	Global.token_selecionado.get_node('Area2D/CollisionShape2D').shape.size = Global.asset_config.size
