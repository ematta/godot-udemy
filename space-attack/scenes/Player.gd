extends KinematicBody2D

const SPEED = 500

export(PackedScene) var projectile

onready var sprite = $Sprite
onready var timer = $Timer
onready var death_timer = $DeathTimer
onready var audio = $Audio

export var health = 100

var screen_size
var half_sprite
var can_shoot = true
var dead = false

signal was_hit

func _ready():
	screen_size = get_viewport_rect().size.x
	half_sprite = (sprite.texture.get_width() * scale.x )/ 2
	

func _process(delta):
	if Input.is_action_pressed("left"):
		position.x -= SPEED * delta
	elif Input.is_action_pressed("right"):
		position.x += SPEED * delta
	if can_shoot and Input.is_action_just_pressed("shoot"):
		can_shoot=false
		var new_projectile = projectile.instance()
		get_parent().add_child(new_projectile)
		new_projectile.position = position
		timer.start()
		audio.play()
	position.x = clamp(position.x, 0 + half_sprite, screen_size - half_sprite)

func _on_Timer_timeout():
	can_shoot=true

func add_damage(damage):
	if dead:
		return
	health -= damage
	print("hit, emiting")
	emit_signal("was_hit")
	if health <= 0:
		dead = true
		health = 0
		death_timer.start()
		set_process(false)
		sprite.queue_free()

func _on_DeathTimer_timeout():
	get_tree().reload_current_scene()
