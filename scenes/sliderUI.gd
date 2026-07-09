extends HSlider

# Conecta ao nó Label que exibirá o valor
@onready var label: Label = get_node("../tamanhoLabel")

func _on_value_changed(novo_valor: float) -> void:
	Global.tamanho_individual = novo_valor
	label.text = "%d px (%.1f quadrados)" % [Global.tamanho_grid*novo_valor, novo_valor]
	Global.tamanho_celula = Vector2(Global.tamanho_individual*Global.tamanho_grid, Global.tamanho_individual*Global.tamanho_grid)
