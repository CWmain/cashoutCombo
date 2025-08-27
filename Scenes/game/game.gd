extends Control

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
	score_board.mult -= 0.5
	score_board.flat -= 5
	recheckCheckout()
	
func _on_good() -> void:
	score_board.mult += 0.01
	score_board.flat += 10
	recheckCheckout()
	
func _on_perfect() -> void:
	score_board.mult += 0.1
	score_board.flat += 50
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
	
