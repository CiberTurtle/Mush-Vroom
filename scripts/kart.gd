class_name Kart extends CharacterBody2D

@export_category('Movement')
var move_spd := 0.0
@export var move_inc := 8.0
@export var move_dec := 8.0
@export var move_break := 8.0
@export var move_rev := 8.0
@export var move_max := 16.0
@export var move_back_max := 6.0

@export_category('Turning')
var turn_spd := 0.0
@export var turn_inc := 0.25
@export var turn_dec := 0.40
@export var turn_opp := 0.50
@export var turn_max := 1.00
@export var turn_control_curve: Curve

@export_category('Misc')
@export var bonk_factor := 0.75
@export var min_bonk_spd := 8.0

@export var jump_time := 0.5
@export var jump_height := 32.0
@export var jump_arc_curve: Curve
var jump_timer := 0.0

# input
var input_accelerate := false
var input_break := false
var input_turn := 0.0
var input_jump := false

var rot := 0.0
var forward := Vector2.RIGHT

@onready var kart: Node2D = $'Kart'

@onready var trail_fx: GPUParticles2D = $Kart/TrailFX
@onready var accel_fx: GPUParticles2D = $Kart/AccelerateFX
@onready var break_fx: GPUParticles2D = $Kart/BreakFX
@onready var jump_fx: GPUParticles2D = $Kart/JumpFX
@onready var land_fx: GPUParticles2D = $Kart/LandFX

func _ready() -> void:
	trail_fx.visible = true
	accel_fx.visible = true
	break_fx.visible = true
	jump_fx.visible = true

func is_grounded() -> bool:
	return jump_timer < 0

func _physics_process(delta: float) -> void:
	do_move(delta)
	
	do_turn(delta)
	
	if jump_timer >= 0.0:
		jump_timer -= delta
		if jump_timer < 0.0:
			land_fx.restart()
			land_fx.emitting = true
	
	if input_jump and jump_timer < 0:
		jump_timer = jump_time
		jump_fx.restart()
		jump_fx.emitting = true
	input_jump = false
	
	# move
	if is_grounded():
		forward = Vector2.RIGHT.rotated(rot)
	
	velocity = move_spd * 16.0 * forward
	var hit := move_and_slide()
	
	if hit:
		if abs(move_spd) < min_bonk_spd:
			move_spd = min_bonk_spd * -sign(move_spd)
		else:
			move_spd = move_spd * -bonk_factor
	
	trail_fx.emitting = jump_timer < 0
	
	var arc := jump_arc_curve.sample_baked(1.0 - jump_timer / jump_time)
	var offset := Vector2(0.0, arc * -jump_height)
	kart.position = offset
	kart.scale = Vector2.ONE + Vector2.ONE * arc
	kart.rotation = rot
	
	accel_fx.emitting = input_accelerate
	break_fx.emitting = input_break if move_spd > 0.0 else false
	
	if jump_timer < 0.0:
		$JumpSprite.position = position + forward * move_spd * 16.0 * jump_time

func do_move(delta: float) -> void:
	if is_grounded():
		if input_break:
			if move_spd > 0:
				move_spd = move_toward(move_spd, -move_back_max, move_break * delta)
			else:
				move_spd = move_toward(move_spd, -move_back_max, move_rev * delta)
		elif input_accelerate:
			move_spd = move_toward(move_spd, move_max, move_inc * delta)
		else:
			move_spd = move_toward(move_spd, 0.0, move_dec * delta)

func do_turn(delta: float) -> void:
	var spd_ratio := move_spd / move_max
	
	if input_turn != 0.0:
		var input_sign: float = sign(input_turn)
		var move_sign: float = sign(turn_spd)
		
		if input_sign == move_sign:
			turn_spd = move_toward(turn_spd, turn_max * input_sign, turn_inc * delta)
		else:
			turn_spd = move_toward(turn_spd, turn_max * input_sign, turn_opp * delta)
	else:
		turn_spd = move_toward(turn_spd, 0.0, turn_dec * delta)
	
	# turn
	var turn_control:float = turn_control_curve.sample_baked(abs(spd_ratio)) * sign(spd_ratio)
	rot += turn_to_rad(turn_spd * turn_control) * delta

func turn_to_rad(turn: float) -> float:
	return 2.0 * PI * turn
