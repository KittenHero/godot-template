extends Control
class_name PauseMenu

@onready var resume_button: Button = %ResumeButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

@onready var submenu: Submenu = %Submenu
@onready var settings: SettingsMenu = %Settings

func _ready() -> void:
	AutoFocus.set_auto_focus(resume_button)
	resume_button.pressed.connect(toggle.bind(false))
	main_menu_button.pressed.connect(go_to_main_menu)
	settings_button.pressed.connect(submenu.show_submenu.bind(settings))
	quit_button.pressed.connect(get_tree().quit)
	if OS.has_feature("web"):
		quit_button.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree() and get_viewport().gui_get_focus_owner() == null and event.is_action_pressed("ui_menu"):
		toggle(true)
		get_viewport().set_input_as_handled()
		
	if is_visible_in_tree() and event.is_action_pressed("ui_cancel"):
		toggle(false)
		get_viewport().set_input_as_handled()

func toggle(on: bool) -> void:
	visible = on
	get_tree().paused = on
	get_viewport().set_input_as_handled()

func go_to_main_menu() -> void:
	var main_menu := str(ProjectSettings.get_setting("application/run/main_scene"))
	SceneLoader.load_scene(main_menu)

func quit() -> void:
	get_tree().quit()
