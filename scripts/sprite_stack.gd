class_name SpriteStack extends Node2D

@export var model: SpriteStackModel

var rot := 0.0
var tilt := 0.0

func _ready() -> void:
	var index := 0
	for i in model.layers.size():
		var layer := model.layers[i]
		
		for _i in layer:
			var sprite := Sprite2D.new()
			sprite.texture = model.texture
			sprite.hframes = model.column_count
			sprite.vframes = model.row_count
			sprite.frame = i
			
			sprite.position.y = -index
			
			add_child(sprite)
			
			index += 1

func _process(delta: float) -> void:
	position = get_parent().global_position
	rot = get_parent().global_rotation
	
	for child in get_children():
		child.rotation = rot
