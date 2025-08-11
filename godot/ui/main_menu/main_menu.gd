extends Control

@export_file("*.scn", "*.tscn") var main_scene : String

@onready var title: Label = %Title
@onready var subtitle: Label = %Subtitle
@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton
@onready var submenu: Submenu = %Submenu
@onready var settings: SettingsMenu = %Settings
@onready var credits: Credits = %Credits

func _ready() -> void:
	title.text = ProjectSettings.get_setting("application/config/name")
	settings_button.pressed.connect(submenu.show_submenu.bind(settings))
	credits_button.pressed.connect(submenu.show_submenu.bind(credits))
	quit_button.pressed.connect(get_tree().quit)
	start_button.pressed.connect(SceneLoader.switch_to_path_scene.bind(main_scene))
	AutoFocus.set_auto_focus(start_button)
	start_button.disabled = true
	if ResourceLoader.exists(main_scene):
		SceneLoader.background_load(main_scene)
		SceneLoader.load_completed.connect(scene_loaded)
	if OS.has_feature("web"): quit_button.hide()

func scene_loaded(path: String) -> void:
	if path != main_scene: return
	start_button.disabled = false
