extends Node3D
class_name game

@onready var arena_container: Node3D = $arenaContainer
@onready var player: Player3D = $Player
@onready var the_box: Node3D = $theBox
@onready var box_animations: AnimationPlayer = $theBox/boxAnimations

var current_arena: Arena

func _ready() -> void:
	current_arena = arena_container.get_child(0)

func _process(delta: float) -> void:
	the_box.global_position = player.global_position

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		change_arena_to_scene(preload("res://game/arena/test/test_arena.tscn"))

func change_arena_to_scene(scene: PackedScene):
	box_animations.play("fadeIn")
	await get_tree().create_timer(box_animations.get_animation("fadeIn").length+0.5).timeout
	if is_instance_valid(current_arena):
		current_arena.queue_free()
	var new_arena = scene.instantiate()
	current_arena = new_arena
	player.global_position = new_arena.player_start_pos.global_position
	the_box.global_position = player.global_position
	arena_container.add_child(new_arena)
	box_animations.play("fadeOut")
