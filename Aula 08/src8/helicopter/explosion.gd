extends Node3D

@onready var particles = $GPUParticles3D
@onready var sound = $AudioStreamPlayer3D

func _ready():
	particles.emitting = true
	sound.play()

func _process(delta: float) -> void:
	if not particles.emitting:
		queue_free()
