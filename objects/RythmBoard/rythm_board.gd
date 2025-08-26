extends CanvasLayer

@export var BaseNoteBurstContents: int = 4
@export var BaseNoteBurstGap: float = 1
@export var BaseNoteGap: float = 0.5
@export var BaseNoteFallSpeed: float = 1

# The amount of notes in a burst
@export var noteBurstContents: int = 4

# The minimum timer gap for burst and noteGap
const MIN_GAP: float = 0.1


#The time between each note burst
@export var noteBurstGap: float = 1:
	set(value):
		noteBurstGap = max(MIN_GAP, value)
		if note_burst_timer != null:
			note_burst_timer.wait_time = noteBurstGap

#The time between each note
@export var noteGap: float = 0.5:
	set(value):
		noteGap = max(MIN_GAP, value)
		if note_gap_timer != null:
			note_gap_timer.wait_time = noteGap

@export var noteFallSpeed: float = 1

@onready var note_gap_timer: Timer = %noteGapTimer
@onready var note_burst_timer: Timer = %noteBurstTimer

var spawnedNotes: int = 0

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

func _ready() -> void:
	note_gap_timer.wait_time = noteGap
	note_burst_timer.wait_time = noteBurstGap
	
	note_gap_timer.timeout.connect(_on_noteGapTimer)
	note_burst_timer.timeout.connect(_on_noteBurstTimer)
	
	startGame()

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

func startGame() -> void:
	note_gap_timer.start()

func resetBoard() -> void:
	# Clear all notes
	for column in columnNotes:
		for note in column:
			note.deactivateNote()
		column.clear()
	#Reset spawnedNotes count as they have been cleared
	spawnedNotes = 0

	# Reset starting values to base (may be modified by shop in the future)
	noteBurstContents = BaseNoteBurstContents
	noteBurstGap = BaseNoteBurstGap
	noteGap = BaseNoteGap
	noteFallSpeed = BaseNoteFallSpeed
	
	note_burst_timer.stop()
	note_gap_timer.stop()
	note_gap_timer.start()
	
func _on_noteGapTimer() -> void:
	if spawnedNotes == noteBurstContents:
		note_gap_timer.stop()
		note_burst_timer.start()
		return
	spawnRandomNote()
	spawnedNotes += 1
	
func _on_noteBurstTimer() -> void:
	spawnedNotes = 0
	randomDiffIncrease()
	note_burst_timer.stop()
	note_gap_timer.start()

# Selects a random stat to increment difficulty
func randomDiffIncrease() -> void:
	var r = randf()

	if r < 0.25:
		noteBurstContents += 1
	elif r < 0.5:
		noteBurstGap -= 0.1
	elif r < 0.75:
		noteGap -= 0.1
	elif r < 1:
		noteFallSpeed += 0.5
	
func spawnRandomNote() -> void:
	var r = randf()
	var newNote: FallingNote
	newNote = FALLING_NOTE.instantiate()
	newNote.fallSpeed = noteFallSpeed
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
