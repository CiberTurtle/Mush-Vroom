extends CharacterBody2D

@export var speed := 6.0

var forward: Vector2

func _ready() -> void:
	forward = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

func _physics_process(delta: float) -> void:
	var hit := move_and_collide(forward * speed * 16.0 * delta)
	
	if hit:
		# forward = forward.reflect(-hit.get_normal())
		forward = -forward
