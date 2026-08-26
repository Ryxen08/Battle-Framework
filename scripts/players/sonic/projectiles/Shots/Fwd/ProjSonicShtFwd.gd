extends ProjectileBrain


@export var north_frames: SpriteFrames
@export var east_frames: SpriteFrames
@export var south_frames: SpriteFrames

func start() -> void:
	hitboxes["A/0"].hitbox_connected.connect(func(b, d, e): on_hit_entity.emit(e))

func spawn(data: Dictionary = {}) -> void:
	super(data)
	if data.has("dir"):
		var dir: float = data.dir
		var speed: float = 10.0
		velocity.x = Basis(Vector3.UP, dir).x.x*speed
		velocity.z = Basis(Vector3.UP, dir).x.z*speed
		update_facing_dir(Basis(Vector3.UP, dir).x)
	global_position = proj_owner.global_position
	anim_player.stop()
	anim_player.play(&"default")
	hitboxes["A/0"].hit_group.hit_log.clear_log()
	hitboxes["A/0"].activate()

func update_projectile(delta: float) -> void:
	if frame >= 42.0:
		despawn()
		return
	
	var dir_y: float = sin(fposmod((cam.global_rotation.y - global_facing_dir), 2*PI))
	if dir_y < -0.8:
		sprite.sprite_frames = north_frames
	elif dir_y > 0.8:
		sprite.sprite_frames = south_frames
	else:
		sprite.sprite_frames = east_frames
	
	sprite.update_sprite_flip(global_facing_dir)
	sprite.update_sprite_scale()

func despawn() -> void:
	hitboxes["A/0"].deactivate()
	super()

func _on_hit_entity(entity: EntityBody) -> void:
	pass

func _on_hit_floor(normal: Vector3) -> void:
	pass

func _on_hit_wall(normal: Vector3) -> void:
	if frame < 33.0:
		frame = 33.0
		anim_player.seek(33.0/60.0)
		velocity.x = 0.0
		velocity.z = 0.0
