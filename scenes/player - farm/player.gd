class_name FarmPlayer
extends CharacterBody2D

@export var speed = 100.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hand_equip: HandEquip = $HandEquip
@onready var inventory: Inventory = $Inventory


var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true

func _process(delta: float) -> void:
	update_animation_parameters()

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if Input.is_action_just_pressed("use"):
		animation_tree["parameters/conditions/swing"] = true
	else:
		animation_tree["parameters/conditions/swing"] = false
	
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Walk/blend_position"] = direction
	animation_tree["parameters/Swing/blend_position"] = direction
	
