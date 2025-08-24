extends Node2D
class_name FallingNote

enum Directions {LEFT, DOWN, UP, RIGHT}

@export var direction: Directions
@export var fallSpeed: float = 5

var active: bool = true

@onready var left_arrow: Sprite2D = $LeftArrow
@onready var down_arrow: Sprite2D = $DownArrow
@onready var up_arrow: Sprite2D = $UpArrow
@onready var right_arrow: Sprite2D = $RightArrow

func _ready() -> void:
	activateNote()

func activateNote() -> void:
	match direction:
		Directions.LEFT:
			left_arrow.show()
		Directions.DOWN:
			down_arrow.show()
		Directions.UP:
			up_arrow.show()
		Directions.RIGHT:
			right_arrow.show()
	active = true
			
func deactivateNote() -> void:
	active = false
	left_arrow.hide()
	down_arrow.hide()
	up_arrow.hide()
	right_arrow.hide()

func _process(delta: float) -> void:
	if active:
		position.y += fallSpeed
