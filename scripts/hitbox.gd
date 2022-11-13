class_name Hitbox extends Area2D

func _ready() -> void:
	connect('area_entered', on_Hitbox_area_entered)

func on_Hitbox_area_entered(area: Area2D) -> void:
	if is_in_group('player') == area.owner.is_in_group('player'): return
	if area.owner.has_method('attacked'):
		area.owner.attacked()
