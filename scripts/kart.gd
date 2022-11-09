class_name Kart extends CharacterBody2D

# speed
var move_spd := 0.0
@export var move_inc := 8.0
@export var move_dec := 8.0
@export var move_break := 8.0
@export var move_rev := 8.0
@export var move_max := 16.0
@export var move_back_max := 6.0

# turn
var turn_spd := 0.0
@export var turn_inc := 0.25
@export var turn_dec := 0.40
@export var turn_opp := 0.50
@export var turn_max := 1.00
@export var turn_control_curve: Curve

# boost
@export var boost_max := 12.0
@export var boost_dec := 12.0
var boost_spd := 0.0

# input
var input_accelerate := false
var input_break := false
var input_turn := 0.0

var input_boost := false

func _ready() -> void:
	$TrailFX.visible = true
	$AccelerateFX.visible = true
	$BreakFX.visible = true
	$BoostFX.visible = true

func _process(delta: float) -> void:
	$AccelerateFX.emitting = input_accelerate
	$BreakFX.emitting = input_break if move_spd > 0.0 else false

func _physics_process(delta: float) -> void:
	if input_break:
		if move_spd > 0:
			move_spd = move_toward(move_spd, -move_back_max, move_break * delta)
		else:
			move_spd = move_toward(move_spd, -move_back_max, move_rev * delta)
	elif input_accelerate:
		move_spd = move_toward(move_spd, move_max, move_inc * delta)
	else:
		move_spd = move_toward(move_spd, 0.0, move_dec * delta)
	
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
	
	var forward := Vector2.RIGHT.rotated(rotation)
	
	# turn
	var turn_control:float = turn_control_curve.sample_baked(abs(spd_ratio)) * sign(spd_ratio)
	rotate(turn_to_rad(turn_spd * turn_control) * delta)
	
	# boost
	boost_spd = move_toward(boost_spd, 0.0, boost_dec * delta)
	if input_boost:
		boost_spd = boost_max
		$BoostFX.restart()
		$BoostFX.emitting = true
	input_boost = false
	
	# move
	velocity = (move_spd + boost_spd) * 16 * forward
	var hit := move_and_slide()
	
	if hit:
		move_spd = move_spd * -0.5

func turn_to_rad(turn: float) -> float:
	return 2.0 * PI * turn
