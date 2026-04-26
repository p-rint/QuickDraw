extends Node2D

var words = []
var curWord : String

@onready var textbox: LineEdit = $CanvasLayer/textbox
@onready var wordLabel: Label = $CanvasLayer/CurrentWord
@onready var flame_timer: Timer = $FlameTimer
@onready var timeLeftLabel: Label = $CanvasLayer/TimeLeft


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeLeftLabel.text = str(int(flame_timer.time_left))
	

func setWord():
	if not words.is_empty():
		curWord = words[0]
		wordLabel.text = curWord

func cycleWord():
	textbox.text = ""
	words.remove_at(0)
	setWord()
	addTime()

func addTime():
	if flame_timer.time_left > 0:
		flame_timer.start(flame_timer.time_left + 2)
	

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text == curWord:
		print("Finished!!!")
		cycleWord()
		
