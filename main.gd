extends Node3D

var words = ["work", "hole", "dairy", "organisation", "unfair", "abortion", "oppose", "characteristic", "thank", "straighten"] #These are just placeholders
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

var panAnims = ["Pan1", "Pan2", "Pan3", "Pan4"]

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	await get_tree().create_timer(2).timeout
	$FlameStuff/CanvasLayer/Load.visible = false
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
	finishedWord = false
	wordLabel.visible = false
	dead = false
	textbox.text = ""
	words.remove_at(0)
	setWord()

func die():
	animPlr.play("PlayerDed")
	$Audio/MetalPipeClang.play(.17)
	wordLabel.text = "DEAD \n Nice try."
	dead = true

func runGame():
	if words.is_empty():
		$FlameStuff/CanvasLayer/End.visible = true
		return
	animPlr.stop()
	#Anticipation
	anticipating = true
	finishedWord = false
	wait_timer.start(randf_range(4,10))
	print("pt1")
	await wait_timer.timeout
	anticipating = false
	
	#FIRE!!!! (type word, quick)
	animPlr.stop()
	animPlr.play("SHOOT!!!")
	textbox.grab_focus()
	wordLabel.visible = true
	time_left.start(( (words[0].length() * .3) + .5)) #.2 seconds per character, + .2 seconds
	print("pt2")
	
	# Did ya win?
	await time_left.timeout
	animPlr.stop()
	if finishedWord: #if you win
		animPlr.play("EnemyDed")
		$Audio/FahhhKcgAXfs.play(.18)
	else:
		die()
		
	print("pt3")
	
	await get_tree().create_timer(3).timeout
	cycleWord()
	runGame()
	

func anticipate():
	if not animPlr.is_playing():
		animPlr.play(panAnims[randi_range(0, panAnims.size() - 1 )])
		print("a")
	

func _on_textbox_text_changed(new_text: String) -> void:
	if new_text == curWord and not dead:
		print("Finished!!!")
		time_left.start(.01)
		
		finishedWord = true
		wordLabel.text = "POW!!!"
		
func uhh():
	print("ye")



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
