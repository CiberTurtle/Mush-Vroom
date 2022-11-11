extends CharacterBody2D

@export var time := 1.0
@export var curve: Curve
@export var scale_curve: Curve

var age := 0.0

@onready var start := position

func _physics_process(delta: float) -> void:
	age += delta
	var ratio := age / time
	position = start + Vector2.RIGHT.rotated(rotation) * curve.sample_baked(ratio) * 16.0
	scale = Vector2.ONE * scale_curve.sample_baked(ratio)
	if age > time:
		queue_free()
