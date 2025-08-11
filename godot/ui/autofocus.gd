extends Control
class_name AutoFocus

static func should_focus(node: Control) -> bool:
	return node.is_visible_in_tree() and (
		node.get_viewport().gui_get_focus_owner() == null
	)

static func set_auto_focus(node: Control) -> void:
	node.set_focus_mode(Control.FOCUS_ALL)
	auto_focus(node)
	node.visibility_changed.connect(auto_focus.bind(node))

static func auto_focus(node: Control) -> void:
	if should_focus(node): node.grab_focus.call_deferred()

static func set_auto_focus_tab_container(tab_container: TabContainer) -> void:
	auto_focus_tab_container(tab_container)
	tab_container.visibility_changed.connect(auto_focus_tab_container.bind(tab_container))

static func auto_focus_tab_container(tab_container: TabContainer) -> void:
	if should_focus(tab_container): tab_container.get_tab_bar().grab_focus.call_deferred()

func _ready() -> void:
	set_auto_focus(self)
