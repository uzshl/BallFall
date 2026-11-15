extends Node2D

const TILE = 64
const END_X = 6400.0
var block_tex = preload("res://assets/block.png")
var spike_tex = preload("res://assets/spike.png")
var attempts = 1
@onready var player = $Player
@onready var cam = $Camera2D
@onready var status_label = $UI/StatusLabel
@onready var world = $World

func _ready():
	$Player/Trajectory.player = player
	build_level()

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		restart()
		return

	cam.position.x = player.global_position.x + 220

	if not player.dead and not player.won:
		var pct = clamp(int((player.global_position.x / END_X) * 100.0), 0, 100)
		status_label.text = "Attempt: %d   |   %d%%" % [attempts, pct]

func build_level():
	for c in world.get_children():
		c.queue_free()

	for x in range(-2, 110):
		add_block(x, 9)
		add_block(x, 10)

	var blocks = [
		[18, 8], [19, 8],
		[24, 7], [25, 7],
		[38, 8], [42, 7], [46, 6],
		[58, 8], [59, 8], [60, 8],
		[74, 8], [78, 7], [82, 8],
	]
	for b in blocks:
		add_block(b[0], b[1])

	var spikes = [
		[12, 8],
		[21, 8], [22, 8],
		[31, 8],
		[40, 8], [44, 8],
		[52, 8], [53, 8],
		[66, 8],
		[76, 8], [80, 8],
		[90, 8], [91, 8],
	]
	for s in spikes:
		add_spike(s[0], s[1])

	var fin = Area2D.new()
	fin.add_to_group("finish")
	fin.position = Vector2(END_X, 400)
	var cs = CollisionShape2D.new()
	var r = RectangleShape2D.new()
	r.size = Vector2(40, 500)
	cs.shape = r
	fin.add_child(cs)
	world.add_child(fin)

func add_block(gx, gy):
	var b = StaticBody2D.new()
	b.position = Vector2(gx * TILE + 32, gy * TILE + 32)
	var cs = CollisionShape2D.new()
	var r = RectangleShape2D.new()
	r.size = Vector2(64, 64)
	cs.shape = r
	var sp = Sprite2D.new()
	sp.texture = block_tex
	b.add_child(cs)
	b.add_child(sp)
	world.add_child(b)

func add_spike(gx, gy):
	var a = Area2D.new()
	a.add_to_group("spike")
	a.position = Vector2(gx * TILE + 32, gy * TILE + 32)
	var cs = CollisionShape2D.new()
	var r = RectangleShape2D.new()
	r.size = Vector2(28, 34)
	cs.shape = r
	cs.position = Vector2(0, 8)
	var sp = Sprite2D.new()
	sp.texture = spike_tex
	a.add_child(cs)
	a.add_child(sp)
	world.add_child(a)

func on_player_died():
	status_label.text = "Dead! Press R"
	await get_tree().create_timer(0.5).timeout
	restart()

func on_player_won():
	status_label.text = "You Win! Press R to play again"
func restart():
	attempts += 1
	player.global_position = Vector2(128, 520)
	player.velocity = Vector2.ZERO
	player.dead = false
	player.won = false
	player.sprite.rotation = 0
