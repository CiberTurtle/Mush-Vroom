extends CharacterBody2D

@export var time := 1.0
@export var pos_curve: Curve
@export var scale_x_curve: Curve
@export var scale_y_curve: Curve

var age := 0.0

@onready var start := position

func _physics_process(delta: float) -> void:
	age += delta
	var ratio := age / time
	position = start + Vector2.RIGHT.rotated(rotation) * pos_curve.sample_baked(ratio) * 16.0
	scale.x = scale_x_curve.sample_baked(ratio)
	scale.y = scale_y_curve.sample_baked(ratio)
	# or test_move(transform, Vector2.ZERO)
	if age > time:
		queue_free()
