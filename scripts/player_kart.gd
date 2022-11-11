class_name PlayerKart extends Kart

@export var lookahead_curve: Curve

func _process(delta: float) -> void:
	input_accelerate = Input.is_action_pressed('accelerate')
	input_break = Input.is_action_pressed('break')
	input_turn = Input.get_axis('turn_left', 'turn_right')
	
	if Input.is_action_just_pressed('boost'):
		input_boost = true
		
	if Input.is_action_just_pressed('jump'):
		input_jump = true
	
	super._process(delta)
	
	var forward := Vector2.RIGHT.rotated(rotation)
	var spd_ratio := move_spd / move_max
	
	$Camera2D.position = position + forward * lookahead_curve.sample_baked(spd_ratio)
