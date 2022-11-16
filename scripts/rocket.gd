extends CharacterBody2D

@export var max_lifetime := 10.0

@export var move_speed_curve: Curve
@export var turn_speed_curve: Curve

var age := 0.0

@onready var dir := Vector2.RIGHT.rotated(rotation)

func _ready() -> void:
	$TrailFX.visible = true

func _physics_process(delta: float) -> void:
	age += delta
	var ratio := age / max_lifetime
	
	var target_dir := position.direction_to(Globals.player.position)
	dir = dir.move_toward(target_dir, turn_speed_curve.sample_baked(ratio) * delta)
	rotation = dir.angle()
	
	var vel := Vector2.RIGHT.rotated(rotation) * move_speed_curve.sample_baked(ratio)
	var hit := move_and_collide(vel * 16.0 * delta)
	
	if hit:
		queue_free()
