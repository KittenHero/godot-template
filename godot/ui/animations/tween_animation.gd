extends Node
class_name TweenAnimation

@export var target : NodePath = "../"
@export var duration : float = 0.2
@export var delay : float = 0.1
@export var easing : Tween.EaseType = Tween.EASE_IN_OUT
@export var transtion : Tween.TransitionType = Tween.TRANS_LINEAR
@export var auto_start : bool = true
var property : String
var initial_value : Variant = null
var final_value : Variant  = null

var default_value : Variant
var node : CanvasItem
var tween : Tween

signal finished();

func _ready() -> void:
	node = get_node(target) as Control
	set_up.call_deferred()
	node.visibility_changed.connect(set_up, CONNECT_DEFERRED)

func set_up() -> void:
	if not node.is_visible_in_tree(): return
	default_value = node[property]
	if final_value == null: final_value = default_value
	if initial_value == null: initial_value = default_value
	tween = create_tween()
	tween.tween_property(node, property, initial_value, delay).from(initial_value)
	if auto_start:
		animate()
	else:
		tween.set_loops()

func animate() -> void:
	tween.stop()
	tween.set_loops(1)
	tween.tween_property(node, property, final_value, duration)\
		.from(initial_value).set_ease(easing).set_trans(transtion)
	tween.finished.connect(finished.emit)
	tween.play()
