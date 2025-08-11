extends Control

@export var rebindable_keys : Array[Action]
@export var template_label : Label
@export var template_button : ActionRemapButton
@export var container : Container
@onready var reset_button: Button = %ResetButton

func _ready() -> void:
	reset_button.pressed.connect(reset_control_mapping)
	
	for action in rebindable_keys:
		if not InputMap.has_action(action.name): continue
		var label := template_label.duplicate() as Label
		label.text = action.label
		container.add_child(label)
		var button := template_button.duplicate() as ActionRemapButton
		button.action = action.name
		reset_button.pressed.connect(button.reload)
		container.add_child(button)
	template_label.hide()
	template_button.hide()

func reset_control_mapping() -> void:
	InputMap.load_from_project_settings()
	Settings.action_remap.clear()
