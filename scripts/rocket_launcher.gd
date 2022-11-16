extends CharacterBody2D

@export var attack_range := 16.0
@export var noattack_range := 3.0
@export var cooldown_time := 1.0
@export var charge_time := 1.0
@export var charge_decay_rate := 4.0
var charge := 0.0
var cooldown_timer := 0.0

@export var scale_curve: Curve

@export var rocket_scene: PackedScene

func _physics_process(delta: float) -> void:
	cooldown_timer -= delta
	if cooldown_timer > 0: return
	
	var distance := Globals.player.position.distance_squared_to(position)
	var is_player_in_range := distance < (attack_range * 16.0) * (attack_range * 16.0)
	
	if is_player_in_range:
		charge += delta
		look_at(Globals.player.position)
		if charge > charge_time and distance > noattack_range * 16.0 * noattack_range * 16.0:
			charge = 0.0
			cooldown_timer = cooldown_time
			shoot()
	else:
		charge = move_toward(charge, 0.0, delta * charge_decay_rate)
	
	scale = Vector2.ONE * scale_curve.sample_baked(charge / charge_time)

func shoot() -> void:
	var rocket := rocket_scene.instantiate() as Node2D
	rocket.position = position
	rocket.rotation = rotation
	get_parent().add_child(rocket)
