extends ProjectileBrain


func start() -> void:
	hitboxes["A/0"].hitbox_connected.connect(func(b, d, e): on_hit_entity.emit(e))

func spawn(data: Dictionary = {}) -> void:
	super(data)
	if data.has("dir"):
		var dir: float = data.dir
		var speed: float = 7.5
		velocity.x = dir*speed
		update_facing_dir(Vector3(dir, 0.0, 0.0))
	global_position = proj_owner.global_position
	anim_player.stop()
	anim_player.play(&"default")
	hitboxes["A/0"].hit_group.hit_log.clear_log()
	hitboxes["A/0"].activate()

func update_projectile(delta: float) -> void:
	if frame >= 39.0:
		despawn()
		return
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
	if frame < 30.0:
		frame = 30.0
		anim_player.seek(30.0/60.0)
		velocity.x = 0.0
		velocity.z = 0.0
