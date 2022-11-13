class_name SpriteStack extends Node2D

@export var model: SpriteStackModel

@export var quality := 1

@export var xoffset := 0.0
@export var yoffset := 0.0

func _ready() -> void:
	var index := 0
	var count := model.column_count * model.row_count
	for i in count:
		for _i in quality:
			var sprite := Sprite2D.new()
			sprite.texture = model.texture
			sprite.hframes = model.column_count
			sprite.vframes = model.row_count
			sprite.frame = i
			
			sprite.position.y = float(-index) / quality
			
			add_child(sprite)
			
			index += 1

func _process(delta: float) -> void:
	var parent := get_parent() as Node2D
	position = parent.global_position + Vector2(xoffset, yoffset)
	scale = parent.global_scale
	
	var rot := parent.global_rotation
	for child in get_children():
		child.rotation = rot
