extends Control
class_name MenuBase

var menu_manager : MenuManager
@export var is_paused : bool = false

func set_menu_manager(_menu_manager : MenuManager) -> void:
	menu_manager = _menu_manager
