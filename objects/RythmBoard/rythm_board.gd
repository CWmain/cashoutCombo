extends CanvasLayer

@export var arrowSpawnTimer: float
@export var arrowFallSpeed: float

var leftNotes: Array[FallingNote]
var downNotes: Array[FallingNote]
var upNotes: Array[FallingNote]
var rightNotes: Array[FallingNote]
var columnNotes: Array = [leftNotes, downNotes, upNotes, rightNotes]

signal miss
signal good
signal perfect

const FALLING_NOTE = preload("res://objects/fallingNote/falling_note.tscn")
# Derived from rough placement of TopLine and BottomLine
const TOP_LINE: int = 420
const BOTTOM_LINE: int = 540
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("RandomNote"):
		spawnRandomNote()
		
	if Input.is_action_just_pressed("Left"):
		checkNote(0)
		
	if Input.is_action_just_pressed("Down"):
		checkNote(1)
		
	if Input.is_action_just_pressed("Up"):
		checkNote(2)
		
	if Input.is_action_just_pressed("Right"):
		checkNote(3)
		
	for column in columnNotes:
		while column.size() > 0 and column[0].position.y > 650:
			column[0].deactivateNote()
			miss.emit()
			column.pop_front()

func spawnRandomNote() -> void:
	var r = randf()
	var newNote: FallingNote
	newNote = FALLING_NOTE.instantiate()
	if r < 0.25:
		newNote.direction = FallingNote.Directions.LEFT
		newNote.position.x = 60
		leftNotes.append(newNote)
	elif r < 0.5:
		newNote.direction = FallingNote.Directions.DOWN
		newNote.position.x = 160
		downNotes.append(newNote)
	elif r < 0.75:
		newNote.direction = FallingNote.Directions.UP
		newNote.position.x = 260
		upNotes.append(newNote)
	elif r < 1:
		newNote.direction = FallingNote.Directions.RIGHT
		newNote.position.x = 360
		rightNotes.append(newNote)
	add_child(newNote)
	
func checkNote(index: int) -> void:
	var curColumn = columnNotes[index]
	if curColumn.size() == 0:
		print("No notes in " + str(index) + " to check")
		return
	var noteToCheck: FallingNote = curColumn[0]
	noteToCheck.deactivateNote()
	curColumn.pop_front()
	var curPosition = noteToCheck.position.y
	
	# Since the note graphic is 64x64 center at 32
	# we check outwards 32px either direction for misses
	if curPosition < TOP_LINE-32 or curPosition > BOTTOM_LINE+32:
		print("MISSED")
		miss.emit()
	# we check inwards 32px to check for partial hits
	elif curPosition < TOP_LINE+32 or curPosition > BOTTOM_LINE-32:
		print("GOOD")
		good.emit()
	# otherwise we consider it perfect
	else:
		print("PERFECT")
		perfect.emit()
