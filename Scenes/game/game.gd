extends Control

@export var miss_mult: float = 0.5
@export var miss_flat: int = 50

@export var good_mult: float = 0.01
@export var good_flat: int = 10

@export var perfect_mult: float = 0.1
@export var perfect_flat: int = 50

@onready var rythm_board: CanvasLayer = $RythmBoard
@onready var score_board: CanvasLayer = $score_board
@onready var shop: CanvasLayer = $shop

func _ready() -> void:
	rythm_board.miss.connect(_on_miss)
	rythm_board.good.connect(_on_good)
	rythm_board.perfect.connect(_on_perfect)
	shop.nextRound.connect(_startNextRound)
	shop.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cashout"):
		shop.process_mode = Node.PROCESS_MODE_INHERIT
		rythm_board.process_mode = Node.PROCESS_MODE_DISABLED
		shop.currentMoney = score_board.total
		score_board.resetScore()
		shop.cashout()

func _on_miss() -> void:
	score_board.mult -= miss_mult
	score_board.flat -= miss_flat
	recheckCheckout()
	
func _on_good() -> void:
	score_board.mult += good_mult
	score_board.flat += good_flat
	recheckCheckout()
	
func _on_perfect() -> void:
	score_board.mult += perfect_mult
	score_board.flat += perfect_flat
	recheckCheckout()

# updates the red - green indicator for if a checkout is possible
func recheckCheckout() -> void:
	if score_board.total >= shop.moneyCashOut:
		shop.cashOutPossible()
	else:
		shop.cashOutImpossible()

func _startNextRound() -> void:
	rythm_board.process_mode = Node.PROCESS_MODE_INHERIT
	shop.process_mode = Node.PROCESS_MODE_DISABLED
	score_board.resetScore()
	rythm_board.resetBoard()
	
