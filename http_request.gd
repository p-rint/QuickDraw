extends HTTPRequest

@onready var main: Node3D = $"../.."


var test = ["111", "2222", "3333", "8888"]

var currentWord : String

func _ready():
	print("a")
	fetch_words()

func fetch_words():
	var url = "https://random-word-api.herokuapp.com/word?number=10"  # Adjust for more words
	request(url)
	print(2)



func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		main.words = json  # Assuming it returns an array of strings
		
		print("Fetched words: ", main.words)
		main.setWord()
		
		# now, spawn word objects in the game
	else:
		print("Failed to fetch words")
		
