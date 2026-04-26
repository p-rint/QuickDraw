extends Node3D

var words = ["111", "2222", "3333", "8888"] #These are just placeholders
var curWord : String

@onready var textbox: LineEdit = $FlameStuff/CanvasLayer/textbox
@onready var wordLabel: Label = $FlameStuff/CanvasLayer/CurrentWord
@onready var flame_timer: Timer = $FlameStuff/Timers/FlameTimer
@onready var timeLeftLabel: Label = $FlameStuff/CanvasLayer/TimeLeft

@onready var wait_timer: Timer = $FlameStuff/Timers/WaitTimer
@onready var time_left: Timer = $FlameStuff/Timers/TimeLeft


var finishedWord = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#setWord() #remove when the api works
	runGame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setWord():
	if not words.is_empty():
		curWord = words[0]
		wordLabel.text = curWord

func cycleWord():
	wordLabel.visible = false
	textbox.text = ""
	words.remove_at(0)
	setWord()

func die():
	wordLabel.text = "DEAD \n nice try."

func runGame():
	#Anticipation
	finishedWord = false
	wait_timer.start(randf_range(2,4))
	print("pt1")
	
	await wait_timer.timeout
	#FIRE!!!! (type word, quick)
	textbox.grab_focus()
	wordLabel.visible = true
	time_left.start((randf_range(2,3)))
	print("pt2")
	
	# Did ya win?
	await time_left.timeout
	if finishedWord:
		cycleWord()
	else:
		die()
	print("pt3")
	

func _on_textbox_text_changed(new_text: String) -> void:
	if new_text == curWord:
		print("Finished!!!")
		finishedWord = true
