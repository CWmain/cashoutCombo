extends Control

@onready var rythm_board: CanvasLayer = $RythmBoard
@onready var score_board: CanvasLayer = $score_board

func _ready() -> void:
	rythm_board.miss.connect(_on_miss)
	rythm_board.good.connect(_on_good)
	rythm_board.perfect.connect(_on_perfect)
	
func _on_miss() -> void:
	score_board.mult -= 0.5
	
func _on_good() -> void:
	score_board.mult += 0.01
	score_board.flat += 10
	
func _on_perfect() -> void:
	score_board.mult += 0.1
	score_board.flat += 50
