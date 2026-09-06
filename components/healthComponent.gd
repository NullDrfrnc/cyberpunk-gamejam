extends Node
class_name HealthComponent

@export var hp: float = 50

signal damaged(amount)
signal death

func damage(amount: float):
	hp -= amount
	damaged.emit(amount)
	if hp <= 0:
		die()

func die():
	death.emit()
