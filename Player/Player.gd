extends Area2D
class_name Player

var plBullet := preload("res://Bullet/Bullet.tscn")

onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibilityTimer

var speed: float = 200
export var fireDelay: float = 0.15
export var life: int = 3
export var damageInvincibilityTime := 0.5

var velocity := Vector2(0, 0)

func _ready():
	Signals.emit_signal("on_player_life_changed", life)

func _process(delta):
	if !visible:
		queue_free()
		
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		
		for child in firingPositions.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)

func _physics_process(delta):
	var directionVector := Vector2(0, 0)
	
	if Input.is_action_pressed("move_left"):
		directionVector.x = -1
	elif Input.is_action_pressed("move_right"):
		directionVector.x = 1
	if Input.is_action_pressed("move_up"):
		directionVector.y = -1
	elif Input.is_action_pressed("move_down"):
		directionVector.y = 1

	velocity = directionVector.normalized() * speed
	position += velocity * delta
	var viewRect := get_viewport_rect()
	
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)

func damage(amount: int):
	if !invincibilityTimer.is_stopped():
		return
		
	invincibilityTimer.start(damageInvincibilityTime)
	life -= amount
	Signals.emit_signal("on_player_life_changed", life)
	
	
	var cam := get_tree().current_scene.find_node("Cam", true, false)
	cam.shake(20)
	
	if life <= 0:
		#visible = false
		Signals.emit_signal("on_game_over")
		queue_free()


func _on_ScoreTimer_timeout():
	Signals.emit_signal("on_score_increment", 1)
