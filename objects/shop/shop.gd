extends CanvasLayer

@onready var item1_button: Button = $VBoxContainer/MissStuff/HBoxContainer/VBoxContainer/MissMult
@onready var item2_button: Button = $VBoxContainer/MissStuff/HBoxContainer/VBoxContainer2/MissFlat
@onready var next_round: Button = $VBoxContainer/NextRound

@onready var color_rect: ColorRect = $ColorRect

@export var moneyCashOut: int = 1000

@onready var money_display: Label = $VBoxContainer/MoneyDisplay
@onready var money_required_label: Label = $ColorRect/moneyRequiredLabel

var item1_price: float = 50

signal nextRound

signal incrementFlatMiss
signal incrementMultMiss

signal incrementFlatGood
signal incrementMultGood

signal incrementFlatPerfect
signal incrementMultPerfect


var currentMoney: float:
	set(value):
		currentMoney = snappedf(value, 0.01)
		money_display.text = "$"+str(currentMoney)
		

func _ready() -> void:
	item1_button.pressed.connect(_buyItem)
	item2_button.pressed.connect(_buyItem)

	next_round.pressed.connect(_nextRound)
	
	cashOutImpossible()
	updateMoneyRequiredLabel()

func cashout() -> void:
	if currentMoney < moneyCashOut:
		print("Game Over")
		return
	currentMoney -= moneyCashOut
	moneyCashOut *= 2
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
	color_rect.color = Color.DARK_GREEN
	
func cashOutImpossible():
	color_rect.color = Color.DARK_RED
