class_name BillboardSprite extends Sprite3D

@export var z_offset: float = 0.5

var cam: Camera3D
@onready var pivot: Marker3D = $".."

func _physics_process(delta: float) -> void:
	update_sprite_z()

func update_sprite_z() -> void:
	pivot.position = cam.global_basis.z*z_offset

func update_sprite_flip(dir: float) -> void:
	var dir_x: float = cos(fposmod((cam.global_rotation.y - dir), 2*PI))
	if absf(dir_x) > 0.1:
		flip_h = dir_x < 0.0

func update_sprite_scale(base_scale: float = 1.0) -> void:
	var cos_angle: float = maxf(absf(cos(cam.global_rotation.x)), 0.01)
	scale.y = base_scale/cos_angle
