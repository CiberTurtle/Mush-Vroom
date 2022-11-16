extends CharacterBody2D

enum State {
	Aim,
	Warn,
	Attack,
	Cooldown,
}

@export var aim_time_min := 3.0
@export var aim_time_max := 3.0
@export var warn_time := 1.0
@export var attack_time := 3.0
@export var cooldown_time_min := 5.0
@export var cooldown_time_max := 5.0

@export var attack_laser_size := 30.0
@export var attack_laser_amp := 4.0
@export var attack_laser_rate := 6.0

var time := 0.0
var timer := 0.0
var state := State.Aim

func _ready() -> void:
	time = randf_range(aim_time_min, aim_time_max)

func _physics_process(delta: float) -> void:
	timer += delta
	
	match state:
		State.Aim:
			look_at(Globals.player.position)
			if timer > time:
				timer = 0.0
				state = State.Warn
		State.Warn:
			if timer > warn_time:
				timer = 0.0
				state = State.Attack
				$WarningLine.visible = false
				$LaserLine.visible = true
				$Hitbox.monitoring = true
		State.Attack:
			$LaserLine.width = attack_laser_size + sin(TAU * timer * attack_laser_rate) * attack_laser_amp
			if timer > attack_time:
				timer = 0.0
				time = randf_range(cooldown_time_min, cooldown_time_max)
				state = State.Cooldown
				$LaserLine.visible = false
				$Hitbox.monitoring = false
		State.Cooldown:
			if timer > time:
				timer = 0.0
				state = State.Aim
				$WarningLine.visible = true
				time = randf_range(aim_time_min, aim_time_max)
