extends Node

onready var message = $Message
onready var right = $Right

# Guess betwee 0 to 1000
var guess
var min_guessed = 0
var max_guessed = 1000
var ended = false


func _ready():
	guess = (min_guessed + max_guessed) / 2
	_guess_display()
	
	
#func _process(delta):
#	if Input.is_action_just_pressed("up"):
#		_try_guess("up")
#	if Input.is_action_just_pressed("down"):
#		_try_guess("down")
#	if Input.is_action_just_pressed("space"):
#		if ended:
#			_restart_game()
#		else:
#			_end_game()
			
func _guess_display():
	message.text = "Is " + str(guess) + " your number?"
		
func _end_game():
	ended = true
	message.text = "Your number was: " + str(guess)
	right.text = "Restart?"
	
func _restart_game():
	get_tree().reload_current_scene()

# func _try_guess(type):
#	if type == "up":
# 		min_guessed = guess
#	if type == "down":
#		max_guessed = guess
#	guess = (min_guessed + max_guessed) / 2
#	message.text = "Is " + str(guess) + " your number?"

func _on_Right_pressed():
	if ended:
		_restart_game()
	else:
		_end_game()


func _on_Lesser_pressed():
	max_guessed = guess
	guess = (min_guessed + max_guessed) / 2
	_guess_display()


func _on_Greater_pressed():
	min_guessed = guess
	guess = (min_guessed + max_guessed) / 2
	_guess_display()
