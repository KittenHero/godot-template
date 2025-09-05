extends Resource
class_name Action

@export var name : StringName
@export var label : String

enum InputScheme {
	KEYBOARD_AND_MOUSE,
	GAMEPAD,
	UNSUPPORTED,
}

static func scheme(event: InputEvent) -> InputScheme:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		return InputScheme.KEYBOARD_AND_MOUSE
	if event is InputEventJoypadButton or event is InputEventJoypadMotion and abs((event as InputEventJoypadMotion).axis_value) > 0.5:
		return InputScheme.GAMEPAD
	return InputScheme.UNSUPPORTED

static func display_text(event: InputEvent) -> String:
	if event is InputEventMouseButton:
		return event.as_text()
	if event is InputEventKey:
		var keyevenet := event as InputEventKey
		if keyevenet.physical_keycode:
			var keycode := DisplayServer.keyboard_get_keycode_from_physical(keyevenet.physical_keycode)
			return OS.get_keycode_string(keycode)
		return event.as_text()
	# TODO: unhack game pad
	if event is InputEventJoypadButton:
		var text := event.as_text()
		var begin := text.find("(") + 1
		var end := text.find(")", begin)
		text = text.substr(begin, end - begin).split(",")[0]
		return text
	if event is InputEventJoypadMotion:
		var text := event.as_text()
		var begin := text.find("(") + 1
		var end := text.find(")", begin)
		text = text.substr(begin, end - begin).split(",")[0]
		return ("+ %s" if event.axis_value > 0.0 else "- %s") % text

	return event.as_text()
