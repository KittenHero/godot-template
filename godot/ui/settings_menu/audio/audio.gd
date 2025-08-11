extends Control

@export var template_label : Label
@export var template_slider: Range
@export var container : Container
@export var exposed_buses := AudioBusFlag.new()
@onready var debouncer : Timer = %Debouncer
## Audio samples under %Samples Node which plays while sliders are adjusted
var samples : Dictionary[int, AudioStreamPlayer] = {}

func _ready() -> void:
	for i in range(AudioServer.bus_count):
		if not exposed_buses.buses & 1 << i: continue
		var label : Label = template_label.duplicate()
		label.text = AudioServer.get_bus_name(i)
		var slider : Slider = template_slider.duplicate()
		slider.value = db_to_linear(AudioServer.get_bus_volume_db(i))
		slider.value_changed.connect(self.on_volume_value_changed.bind(i))
		container.add_child(label)
		container.add_child(slider)

	template_label.hide()
	template_slider.hide()

	for sound : AudioStreamPlayer in %Samples.get_children():
		samples[AudioServer.get_bus_index(sound.bus)] = sound
		debouncer.timeout.connect(sound.stop)

func on_volume_value_changed(volume: float, bus: int) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(volume))
	debouncer.start(1)
	if not samples.has(bus):
		return
	var sound := samples[bus]
	if not sound.playing:
		sound.play()
