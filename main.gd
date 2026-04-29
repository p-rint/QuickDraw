extends Node3D

var words = ["111", "2222", "3333", "8888"] #These are just placeholders
var curWord : String

@onready var textbox: LineEdit = $FlameStuff/CanvasLayer/textbox
@onready var wordLabel: Label = $FlameStuff/CanvasLayer/CurrentWord
@onready var flame_timer: Timer = $FlameStuff/Timers/FlameTimer
@onready var timeLeftLabel: Label = $FlameStuff/CanvasLayer/TimeLeft

@onready var wait_timer: Timer = $FlameStuff/Timers/WaitTimer
@onready var time_left: Timer = $FlameStuff/Timers/TimeLeft

@onready var http_request: HTTPRequest = $FlameStuff/HTTPRequest
@onready var animPlr: AnimationPlayer = $Camera3D/AnimationPlayer


var finishedWord = false
var anticipating = false

var panAnims = ["Pan1", "Pan2", "Pan3"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	await get_tree().create_timer(2).timeout
	print(words == http_request.test)
	setWord() #remove when the api works (NVM)
	runGame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if anticipating == true:
		anticipate()

func setWord():
	print(words)
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
	anticipating = true
	animPlr.play("Pan1")
	finishedWord = false
	wait_timer.start(randf_range(1,1))
	print("pt1")
	await wait_timer.timeout
	anticipating = false
	
	#FIRE!!!! (type word, quick)
	textbox.grab_focus()
	wordLabel.visible = true
	time_left.start((randf_range(2,3)))
	print("pt2")
	
	# Did ya win?
	await time_left.timeout
	if finishedWord: #if you win
		animPlr.play("EnemyDed")
		await get_tree().create_timer(3).timeout
		cycleWord()
		runGame()
	else:
		die()
	print("pt3")
	

func anticipate():
	while anticipating:
		if not animPlr.is_playing():
			animPlr.play(panAnims[randi_range(0,1)])
			print("a")
	

func _on_textbox_text_changed(new_text: String) -> void:
	if new_text == curWord:
		print("Finished!!!")
		time_left.start(0)
		
		finishedWord = true
		wordLabel.text = "POW!!!"
