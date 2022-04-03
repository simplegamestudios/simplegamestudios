extends Area2D

signal captured
signal died

onready var trail = $Trail/Points

var velocity = Vector2(100, 0)
var jump_speed = 3000
var target = null
var trail_length = 2.5

func  _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()
		
func jump():
	target.Explode()
	target = null
	velocity = transform.x * jump_speed
	if Settings.enable_sound:
		$jump.play()

func _on_Jumper_area_entered(area):
	target = area 
	velocity = Vector2.ZERO
	emit_signal("captured", area)
	if Settings.enable_sound:
		$capture.play()
	
func _physics_process(delta):
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
		
func die():
	target = null
	queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	if !target:
		emit_signal("died")
		die()
