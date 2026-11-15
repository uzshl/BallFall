extends Node2D
var player = null
func _process(_delta):
	queue_redraw()

var speed

func _draw():
	if player == null or player.dead or player.won:
		return
	var pos = Vector2.ZERO
	var vy = player.JUMP_FORCE if player.is_on_floor() else player.velocity.y
	var dt = 0.03
	for i in range(1, 22):
		vy += player.GRAVITY * dt
		pos.x += player.SPEED * dt
		pos.y += vy * dt
		if player.global_position.y + pos.y > 576:
			break
		draw_circle(pos, 3.5, Color(0.2, 0.2, 0.2, 0.55))
