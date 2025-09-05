extends Node

const PATH = "user://settings.cfg"
var loaded := false
var current_input_scheme := Action.InputScheme.KEYBOARD_AND_MOUSE:
	set(value):
		current_input_scheme = value
		control_reset.emit()

@export var action_remap := {}:
	set(value):
		action_remap = value
		control_reset.emit()
		save()

signal control_reset();

func _ready() -> void:
	self.load()
	loaded = true

func save() -> void:
	if not loaded: return
	var config := ConfigFile.new()
	for bus in range(AudioServer.bus_count):
		var bus_name := AudioServer.get_bus_name(bus)
		var volume_db := AudioServer.get_bus_volume_db(bus)
		config.set_value("Audio", bus_name, db_to_linear(volume_db))
	for action : String in action_remap:
		config.set_value("Keybind", action, action_remap[action])

	config.save(PATH)


func load() -> void:
	var config := ConfigFile.new()
	if config.load(PATH) != OK: return
	for bus in range(AudioServer.bus_count):
		var bus_name := AudioServer.get_bus_name(bus)
		var volume : float = config.get_value("Audio", bus_name, 1.0)
		AudioServer.set_bus_volume_db(bus, linear_to_db(volume))

	if not config.has_section("Keybind"): return
	for action in config.get_section_keys("Keybind"):
		var value: InputEvent = config.get_value("Keybind", action)
		action_remap[action] = value
		var scheme := Action.scheme(value)
		for event in InputMap.action_get_events(action):
			if Action.scheme(event) == scheme:
				InputMap.action_erase_event(action, event)
		InputMap.action_add_event(action, value)

func _unhandled_input(event: InputEvent) -> void:
	var scheme := Action.scheme(event)
	if scheme != Action.InputScheme.UNSUPPORTED:
		current_input_scheme = scheme
