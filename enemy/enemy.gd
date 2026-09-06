extends Node
class_name enemy

@export var enemy_name: String
@export_multiline var description: String
@export var health: HealthComponent

func _ready() -> void:
	health.death.connect(death)
	add_to_group("enemy")

func death():
	pass #spawn the corpse to retrieve energy from
