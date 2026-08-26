class_name DirectionalAnim extends BillboardAnim

@export var front_frames: SpriteFrames
@export var side_frames: SpriteFrames
@export var back_frames: SpriteFrames


func update_sprite_flip(dir: float) -> void:
	var dir_x: float = cos(fposmod((cam.global_rotation.y - dir), 2*PI))
	if absf(dir_x) > 0.01:
		flip_h = dir_x < 0.0
	var dir_y: float = sin(fposmod((cam.global_rotation.y - dir), 2*PI))
	if absf(dir_y) > 0.71:
		change_sprite_frames(back_frames if dir_y < 0.0 else front_frames)
	else:
		change_sprite_frames(side_frames)

func change_sprite_frames(frames: SpriteFrames) -> void:
	var anim: StringName = animation
	var f: int = frame
	var p: float = frame_progress
	stop()
	sprite_frames = frames
	play(anim)
	set_frame_and_progress(f, p)
