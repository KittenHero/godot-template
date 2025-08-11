@tool
extends Resource
class_name AudioBusFlag

var buses : int

func _get_property_list() -> Array[Dictionary]:
	var bus_names := PackedStringArray()
	bus_names.resize(AudioServer.bus_count)
	for i in range(AudioServer.bus_count):
		bus_names[i] = AudioServer.get_bus_name(i)
	return [{
		"name": "buses",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": ",".join(bus_names),
	}]
