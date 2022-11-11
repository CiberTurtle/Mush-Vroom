extends CharacterBody2D

@export var attack_range := 16.0
@export var cooldown_time := 1.0
@export var charge_time := 1.0
@export var charge_decay_rate := 3.0
var charge := 0.0
var cooldown_timer := 0.0

@export var scale_curve: Curve

@export var spread_deg := 90.0
@export var proj_count := 12.0
@export var proj_scene: PackedScene

func _ready() -> void:
	$RangeSprite.position = position
	$RangeSprite.scale = Vector2.ONE * (attack_range / (128.0 / 16.0) * 2.0)

func _physics_process(delta: float) -> void:
	cooldown_timer -= delta
	if cooldown_timer > 0: return
	
	var distance := Globals.player.position.distance_squared_to(position)
	var is_player_in_range := distance < (attack_range * 16.0) * (attack_range * 16.0)
	
	if is_player_in_range:
		charge += delta
		if charge > charge_time:
			charge = 0.0
			cooldown_timer = cooldown_time
			shoot()
	else:
		charge = move_toward(charge, 0.0, delta * charge_decay_rate)
	# look_at(Globals.player.position)
	
	scale = Vector2.ONE * scale_curve.sample_baked(charge / charge_time)

func shoot() -> void:
	var step := spread_deg * 2.0 / proj_count
	for rot in range(-spread_deg, spread_deg, step):
		var proj := proj_scene.instantiate() as Node2D
		proj.position = position
		proj.rotation = rotation + deg_to_rad(rot)
		get_parent().add_child(proj)
