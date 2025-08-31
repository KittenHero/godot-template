extends TweenAnimation
class_name ScaleAnimation

@export var initial_scale : Vector2 = Vector2.ZERO
@export var final_scale : Vector2 = Vector2(1, 1)

func _ready() -> void:
	property = "scale"
	initial_value = initial_scale
	final_value = final_scale
	super()

func set_up() -> void:
	if node is Control:
		var control := node as Control
		control.pivot_offset = control.size / 2
	super()
