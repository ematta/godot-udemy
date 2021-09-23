extends Node

onready var bar = $HealthBar
onready var player = $Player

func _ready():
	bar.max_value = player.health
	bar.value = player.health

func _on_Player_was_hit():
	bar.value -= 10
