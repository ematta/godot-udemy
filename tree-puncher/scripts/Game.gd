extends Node

export(PackedScene) var trunk_scene

onready var first_trunk_position = $FirstTrunkPosition
onready var time_left = $TimeLeft
onready var grave = $Grave
onready var player = $Player
onready var timer = $Timer
onready var score = $Score

var last_spawn_position
var last_has_axe = false
var last_axe_right = false
var dead = false
var trunks = []

func _ready():
	score.text = "SCORE: " + str(player.score)
	last_spawn_position = first_trunk_position.position 
	_spawn_first_trunks()
	pass
	
func _process(delta):
	if dead:
		return
	time_left.value -= delta
	if time_left.value <= 0:
		die()
		
func die():
	grave.position.x = player.position.x
	player.queue_free()
	timer.start()
	grave.visible=true
	dead = true

func _spawn_first_trunks():
	for counter in range(5):
		var new_trunk = trunk_scene.instance()
		add_child(new_trunk)
		new_trunk.position = last_spawn_position
		last_spawn_position.y -= new_trunk.sprite_height
		new_trunk.init_trunk(last_has_axe,last_axe_right)
		trunks.append(new_trunk)
		
func _add_trunk(axe, axe_right):
	var new_trunk = trunk_scene.instance()
	add_child(new_trunk)
	new_trunk.position = last_spawn_position
	new_trunk.init_trunk(axe,axe_right)
	trunks.append(new_trunk)

func punch_tree(from_right):
	if !last_has_axe:
		if rand_range(0,100) > 50:
			last_axe_right = rand_range(0,100) > 50
			last_has_axe = true
		else:
			last_has_axe=false
	else:
		if rand_range(0,100) > 50:
			last_has_axe = true
		else:
			last_has_axe = false
	_add_trunk(last_has_axe, last_axe_right)	
	trunks[0].remove(from_right)
	trunks.pop_front()
	for trunk in trunks:
		trunk.position.y += trunk.sprite_height
	time_left.value += 0.25
	if time_left.value > time_left.max_value:
		time_left.value = time_left.max_value
	player.score += 1
	score.text = "SCORE: " + str(player.score)

func _on_Timer_timeout():
	get_tree().reload_current_scene()
