extends Node
class_name MenuManager

# Add values to this enum for add extra menus, also InGame menu is supposed to be a blank scene
# Health bar, xp level labels should be its own canvas layer and not attached to the menu manager
enum MenuKeys {MainMenu,Settings}
# Storing the menus in a dict using the menu keys as a way to index it.
var menus : Dictionary = {}
# Current menu is the actual scene
var current_menu : Control
var current_menu_key : MenuKeys
# Previous menus is how we load previous menus so the current menu doesnt need
# to have information about previous menus
var previous_menus : Array = []
# Where we instance the current menu
var menu_container : CanvasLayer

func _ready() -> void:
	set_up_menu_container()
	
	add_menu(MenuKeys.MainMenu,"res://Menus/MainMenu/main_menu.tscn")
	add_menu(MenuKeys.Settings,"res://Menus/Settings/Settings.tscn")
	
	load_menu(MenuKeys.MainMenu)

func add_menu(menu_key : MenuKeys , menu_path : String) -> void:
	menus[menu_key] = load(menu_path)

func load_menu(menu_key : MenuKeys) -> void:
	# Should wait one frame before loading the next menu, to avoid any unwanted issue.
	call_deferred("deferred_menu_load",menu_key)

func load_previous_menu() -> void:
	# Delete the last menu in the previous menu array and load it
	previous_menus.pop_back()
	call_deferred("deferred_menu_load",previous_menus[-1])

func deferred_menu_load(menu_key : MenuKeys) -> void:
	
	# Stop attempt as menu does not exist
	#assert(not menus.has(menu_key), "Menu key does not exist - Menu has not been added")
	
	# If the previous menu array is empty we add the first menu,
	# elif the last menu isnt the same one as the current one we add it
	if previous_menus.size() == 0:
		previous_menus.append(menu_key)
	elif previous_menus[-1] != menu_key:
		previous_menus.append(menu_key)
	
	# Queue free current menu if its not null.
	if current_menu:
		current_menu.queue_free()
	
	# Get the next menu from the menus dict
	var next_menu : PackedScene = menus[menu_key]
	
	# Set the current menu by instancing the next menu
	current_menu = next_menu.instantiate()
	# Add it to the menus container
	menu_container.add_child(current_menu)
	# Set the menu manager to the menu so it can do menu changes
	current_menu.set_menu_manager(self)
	
	# Set the game to paused if a menu pauses the game
	get_tree().paused = current_menu.is_paused


func set_up_menu_container() -> void:
	# If we dont have a place to store the menus we need to create it
	if not menu_container:
		var canvas : CanvasLayer = CanvasLayer.new()
		canvas.name = "Menu Container"
		add_child(canvas)
		menu_container = canvas
