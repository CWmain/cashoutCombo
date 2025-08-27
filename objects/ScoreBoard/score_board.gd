extends CanvasLayer

@onready var total_label: Label = %Total
@onready var mult_label: Label = %Mult
@onready var flat_label: Label = %Flat

var total: float = 0:
	set(value):
		total = snappedf(value, 0.01)
		total_label.text = str(total)
		
var mult: float = 1:
	set(value):
		mult = max(1,snappedf(value, 0.01))
		mult_label.text = str(mult)
		_updateTotal()
var flat: int = 0:
	set(value):
		flat = max(0,snappedf(value, 0.01))
		flat_label.text = str(flat)
		_updateTotal()

func _updateTotal() -> void:
	total = flat*mult

func resetScore() -> void:
	mult = 1
	flat = 0
	
