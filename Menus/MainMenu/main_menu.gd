extends MenuBase


func _on_settings_pressed() -> void:
	menu_manager.load_menu(menu_manager.MenuKeys.Settings)


func _on_quit_pressed() -> void:
	get_tree().quit()
