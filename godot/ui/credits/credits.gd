@tool
extends Control
class_name Credits

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var top_spacer: Control = %TopSpacer
@onready var credits_text: RichTextLabel = %CreditsText
@onready var bottom_spacer: Control = %BottomSpacer
@onready var auto_scroll_timer: Timer = %AutoScrollTimer

@export_file("*.txt") var credits_file_path : String

@export var preprocess_text : Dictionary = {
	"title": "font_size=64",
	"heading": "font_size=48",
	"subheading": "font_size=32",
}
@export_range(0.01, 100.0) var scroll_speed := 64.0

var current_scroll : float = 0.0
var scrolling := true

signal finished

func _ready() -> void:
	AutoFocus.set_auto_focus(scroll_container)
	scroll_container.resized.connect(resize_spacer)
	scroll_container.gui_input.connect(process_input)
	credits_text.meta_clicked.connect(url_clicked)
	visibility_changed.connect(reset_scroll)
	auto_scroll_timer.timeout.connect(continue_scroll)

func load_credits() -> void:
	if not Engine.is_editor_hint(): return
	var file := FileAccess.open(credits_file_path, FileAccess.READ)
	if file == null: return
	credits_text.text = process_text(file.get_as_text())
	file.close()

func process_text(text: String) -> String:
	for key : String in preprocess_text:
		text = (
			text.replace("[%s]" % key, "[%s]" % preprocess_text[key])
			.replace(
				"[/%s]" % key,
				"[/%s]" %  (preprocess_text[key] as String)
					.get_slice(" ", 0)
					.get_slice("=", 0)
			)
		)
	return text

func process_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		scrolling = false
		current_scroll = scroll_container.scroll_vertical
		auto_scroll_timer.start()

func url_clicked(meta: String) -> void:
	if meta.begins_with("https://"): OS.shell_open(meta)

func resize_spacer() -> void:
	if Engine.is_editor_hint(): return
	top_spacer.custom_minimum_size = scroll_container.size
	bottom_spacer.custom_minimum_size = scroll_container.size

func reset_scroll() -> void:
	scrolling = true
	current_scroll = 0.0

func continue_scroll() -> void:
	scrolling = true
	current_scroll = scroll_container.scroll_vertical

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return load_credits()
	if not is_visible_in_tree(): return
	if current_scroll > top_spacer.size.y + credits_text.size.y + 5:
		scrolling = false
		finished.emit()
	var input := Input.get_axis("ui_up", "ui_down")
	if input != 0:
		current_scroll += input * scroll_speed * delta * 4
	elif scrolling:
		current_scroll += delta * scroll_speed
	scroll_container.scroll_vertical = round(current_scroll)
