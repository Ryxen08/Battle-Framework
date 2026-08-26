extends Node3D

# Determines which layers correspond to regular sprites and which ones correspond to flipped sprites
# Cull mask will be changed depending on the camera's rotation
# See components/battle_sprite/battle_sprite.gd for more info
const SPRITE_DEFAULT_VISUAL_LAYER: int = 7
const SPRITE_FLIPPED_VISUAL_LAYER: int = 8

@onready var anim = $AnimationPlayer
@onready var camera = $Camera

var taps: int = 0
var taptime: float = 0.0
var follow_player = false
var player_to_follow: PlayerBrain : set = set_player_to_follow

var _offset_from_player: Vector3


func _ready() -> void:
	rotation.y = 0.0
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var rot: float = snappedf(rotation.y, 1.0)
	if taptime > 0.0:
		taptime -= floorf(delta*60.0)
	else:
		taptime = 0.0
		taps = 0
	if Input.is_action_just_pressed(&"Guard") && player_to_follow.control_mode == PlayerBrain.ControlModes.INP_PLR:
		taps += 1
		
		match taps:
			1:
				taptime = 20.0
			2:
				match rot:
					0.0:
						anim.play("Flip1")
					3.0:
						anim.play("Flip2")
				taptime = 0.0
				taps = 0
	
	if follow_player and player_to_follow:
		global_position = player_to_follow.global_position
	
	if rotation_degrees.y >= 90:
		camera.set_cull_mask_value(SPRITE_DEFAULT_VISUAL_LAYER + 1, false)
		camera.set_cull_mask_value(SPRITE_FLIPPED_VISUAL_LAYER + 1, true)
	else:
		camera.set_cull_mask_value(SPRITE_DEFAULT_VISUAL_LAYER + 1, true)
		camera.set_cull_mask_value(SPRITE_FLIPPED_VISUAL_LAYER + 1, false)
		


func set_player_to_follow(player: PlayerBrain):
	player_to_follow = player
	_offset_from_player = global_position - player_to_follow.global_position
