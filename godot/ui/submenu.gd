extends Control
class_name Submenu

@export var main_menu : Control
@export var back_button : Button
var active_submenu : Control = null

func _ready() -> void:
	back_button.pressed.connect(hide_submenu)

func show_submenu(node: Node) -> void:
	main_menu.hide()
	active_submenu = node
	active_submenu.show()
	self.show()

func hide_submenu() -> void:
	self.hide()
	active_submenu.hide()
	main_menu.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and active_submenu != null:
		hide_submenu()
		get_viewport().set_input_as_handled()
