extends CanvasLayer

@onready var item1_button: Button = $VBoxContainer/HBoxContainer/VBoxContainer/Button
@onready var item2_button: Button = $VBoxContainer/HBoxContainer/VBoxContainer2/Button
@onready var item3_button: Button = $VBoxContainer/HBoxContainer/VBoxContainer3/Button
@onready var next_round: Button = $VBoxContainer/NextRound

@onready var color_rect: ColorRect = $ColorRect

@export var moneyCashOut: int = 1000

@onready var money_display: Label = $VBoxContainer/MoneyDisplay
@onready var money_required_label: Label = $ColorRect/moneyRequiredLabel

var item1_price: float = 50

signal nextRound

var currentMoney: float:
	set(value):
		currentMoney = snappedf(value, 0.01)
		money_display.text = "$"+str(currentMoney)
		

func _ready() -> void:
	item1_button.pressed.connect(_buyItem)
	item2_button.pressed.connect(_buyItem)
	item3_button.pressed.connect(_buyItem)
	next_round.pressed.connect(_nextRound)
	
	cashOutImpossible()
	updateMoneyRequiredLabel()

func cashout() -> void:
	if currentMoney < moneyCashOut:
		print("Game Over")
		return
	currentMoney -= moneyCashOut
	moneyCashOut *= 2
	print("Cashing out")
	color_rect.hide()
	updateMoneyRequiredLabel()
	

func recheckPrice() -> void:
	pass

func _buyItem() -> void:
	if currentMoney < item1_price:
		print("failed to buy")
		return
	print("bought")
	currentMoney -= item1_price

func _nextRound() -> void:
	color_rect.show()
	nextRound.emit()
	cashOutImpossible()
	
func updateMoneyRequiredLabel() -> void:
	money_required_label.text = "$" + str(moneyCashOut)
	
func cashOutPossible():
	print("Possible")
	color_rect.color = Color.DARK_GREEN
	
func cashOutImpossible():
	print("impossible")
	color_rect.color = Color.DARK_RED
