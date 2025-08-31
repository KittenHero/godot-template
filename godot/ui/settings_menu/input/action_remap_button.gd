extends Button
class_name ActionRemapButton

@export var action: StringName
var mapped_event: InputEvent
 
func _ready() -> void:
	if not InputMap.has_action(action): return
	set_process_input(false)
	reload()
	Settings.control_reset.connect(self.reload)
	self.pressed.connect(self._on_pressed)
 
func reload() -> void:
	if not InputMap.has_action(action): return
	mapped_event = InputMap.action_get_events(action)[0]
	text = mapped_event.as_text()

func remap_action_to(event: InputEvent) -> void:
	if not InputMap.has_action(action): return
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	Settings.action_remap[action] = event
	mapped_event = event
	text = event.as_text()
 
func _on_pressed() -> void:
	set_process_input(true)
	text = "press any key"
 
func _input(event: InputEvent) -> void:
	if event.is_released(): return
	if not (
		event is InputEventKey
		or event is InputEventJoypadButton
		or event is InputEventJoypadMotion and abs((event as InputEventJoypadMotion).axis_value) > 0.5
	):
		return
	remap_action_to(event)
	get_viewport().set_input_as_handled()
	set_process_input(false)
