extends CharacterBody2D

@export var time := 1.0
@export var move_start := 1.0
@export var move_speed := 1.0
@export var move_curve: Curve
@export var base_size := 32.0
@export var min_size := 0.15

var proj_count := 16
var spread_deg := 16

var age := 0.0

@onready var start := position

func _physics_process(delta: float) -> void:
	age += delta
	var distance := 0.0
	if is_instance_valid(move_curve):
		distance = move_curve.sample_baked(age / time)
	else:
		distance = move_start + move_speed * age
	position = start + Vector2.RIGHT.rotated(rotation) * distance * 16.0
	var s := (TAU * distance * 16.0) / (spread_deg / 180.0) / proj_count
	scale.y = max(s / base_size / 2.0, min_size)
	# or test_move(transform, Vector2.ZERO)
	if age > time or abs(position.x) > Consts.BOUNDS or abs(position.y) > Consts.BOUNDS:
		queue_free()
