extends CharacterBody2D
const SPEED = 340.0
const GRAVITY = 2100.0
const JUMP_FORCE = -720.0
var dead = false
var won = false
@onready var sprite = $Sprite2D
@onready var jump_sfx = $JumpSfx
@onready var die_sfx = $Fahh

func _ready():
	die_sfx.stop()
func _physics_process(delta):
	if dead or won:
		return
		
	velocity.x = SPEED
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		sprite.rotation += 5.0 * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		jump_sfx.play()

	move_and_slide()
	
	if is_on_wall():
		die()
		return
		
	if global_position.y > 720:
		die()

func die():
	if dead:
		return
	dead = true
	jump_sfx.stop()
	die_sfx.play()
	get_parent().on_player_died()

func _on_spike_detector_area_entered(area):
	if area.is_in_group("spike"):
		die()
	elif area.is_in_group("finish"):
		won = true
		get_parent().on_player_won()
