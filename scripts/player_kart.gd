class_name PlayerKart extends Kart

@export var lookahead_curve: Curve

func _enter_tree() -> void:
	Globals.player = self

func _process(delta: float) -> void:
	input_accelerate = Input.is_action_pressed('accelerate')
	input_break = Input.is_action_pressed('break')
	input_turn = Input.get_axis('turn_left', 'turn_right')
	
	if Input.is_action_just_pressed('jump'):
		input_jump = true
	
	var spd_ratio := move_spd / move_max
	
	var fwd := Vector2.RIGHT.rotated(rot)
	$Camera2D.position = position + fwd * lookahead_curve.sample_baked(spd_ratio)

func attacked() -> bool:
	if jump_timer > 0.0: return false
	
	position = Vector2.ZERO
	
	return true
