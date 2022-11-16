class_name Ghast extends CharacterBody2D

@export var chase_speed := 4.0
@export var intercept_speed := 6.0
var following_ghast: Ghast

func _ready() -> void:
	following_ghast = Globals.follow_ghast
	Globals.follow_ghast = self

func _physics_process(delta: float) -> void:
	var p_pos := Globals.player.position
	var target := p_pos
	var spd := chase_speed
	if is_instance_valid(following_ghast):
		target = p_pos + (p_pos - following_ghast.position)
		spd = intercept_speed
	$Inter.visible = is_instance_valid(following_ghast)
	$Point.position = target
	
	position = position.move_toward(target, spd * 16.0 * delta)
