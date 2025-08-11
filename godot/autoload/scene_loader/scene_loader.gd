extends Node

@onready var active_scene_root: Node = %ActiveSceneRoot

var loading: String = ""
var progress: Array[float] = []
@onready var bar: ProgressBar = %ProgressBar
@onready var label: Label = %Label
@onready var animation: AnimationPlayer = %AnimationPlayer

signal load_completed(path: String);

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	animation.play("initial")
	animation.advance(0)
	var current_scene := get_tree().current_scene
	get_tree().root.remove_child.call_deferred(current_scene)
	set_active_scene.call_deferred(current_scene)

func set_active_scene(node: Node) -> void:
	if active_scene_root.get_child_count() != 0 and node == active_scene_root.get_child(0): return
	for child in active_scene_root.get_children():
		active_scene_root.remove_child(child)
		child.queue_free()
	active_scene_root.add_child(node)

func _process(delta: float) -> void:
	if loading.is_empty(): return
	var status := load_status(loading)
	bar.value = move_toward(bar.value, status, delta * bar.max_value)
	if status >= 100.0:
		bar.value = status
		load_completed.emit(loading)
		loading = ""

func load_status(path: String) -> float:
	var status := ResourceLoader.load_threaded_get_status(path, progress)
	if status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE or status == ResourceLoader.THREAD_LOAD_FAILED:
		return -100
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		return 100
	return 100 * progress[0]

func background_load(path: String) -> Error:
	if not loading.is_empty(): return ERR_UNAVAILABLE
	loading = path
	var err := ResourceLoader.load_threaded_request(path)
	return err

func get_packed_scene(path: String) -> PackedScene:
	return ResourceLoader.load_threaded_get(path) as PackedScene

func load_scene(path: String) -> void:
	animation.play("fade-to-black")
	background_load(path)
	await animation.animation_finished
	get_tree().paused = true
	if loading == path:
		await load_completed
	switch_to_path_scene(path)
	animation.queue("fade-from-black")
	get_tree().set_pause.call_deferred(false)

func switch_to_path_scene(path: String) -> void:
	switch_to_scene(get_packed_scene(path))

func switch_to_scene(packed_scene: PackedScene) -> void:
	set_active_scene(packed_scene.instantiate())
