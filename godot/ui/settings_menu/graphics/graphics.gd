extends Control
class_name GraphicsSettings

@onready var resolution: OptionButton = %Resolution
@onready var preset: OptionButton = %Preset
@onready var vsync: CheckButton = %Vsync
@onready var gi: OptionButton = %GI
@onready var ssr: OptionButton = %SSR
@onready var ssao: OptionButton = %SSAO
@onready var ssil: OptionButton = %SSIL
@onready var sss: OptionButton = %SSS
@onready var glow: OptionButton = %Glow

func _ready() -> void:
	resolution.item_selected.connect(change_resolution)
	if OS.has_feature("web"):
		resolution.remove_item(3) # 720
		resolution.remove_item(2) # 900
		resolution.remove_item(1) # 1080
		
		ssr.disabled = true
		ssr.select(5) # disabled
		
		ssao.disabled = true
		ssao.select(5) # disabled
		
		ssil.disabled = true
		ssil.select(5) # disabled
		
		gi.disabled = true
		gi.select(2) # disabled

func change_resolution(idx: int) -> void:
	var text := resolution.get_item_text(idx)
	match text:
		"Full Screen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_ when text.contains("x"):
			var n := text.split("x")
			assert(n.size() == 2)
			var w := int(n[0])
			var h := int(n[1])
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().size = Vector2(w, h)
		_:
			push_error("Unknown Option")
