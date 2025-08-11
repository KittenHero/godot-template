extends Control
class_name SettingsMenu

@onready var tabs: TabContainer = %TabContainer

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)
	AutoFocus.set_auto_focus_tab_container(tabs)

func on_visibility_changed() -> void:
	if is_visible_in_tree(): return
	Settings.save()

func _exit_tree() -> void:
	Settings.save()
