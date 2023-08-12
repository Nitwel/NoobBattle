extends Node2D
class_name Map

enum MOVE_NODES {start, good_1, bad_1, battle_1, shop_1, nothing_1, slot_1, nothing_2, good_2, battle_2, surprise, bad_2, slot_2, slot_3, shop_2, jackpot}

var MOVE_EDGES = [
	[MOVE_NODES.start, MOVE_NODES.good_1],
	[MOVE_NODES.good_1, MOVE_NODES.battle_1],
	[MOVE_NODES.battle_1, MOVE_NODES.nothing_1],
	[MOVE_NODES.battle_1, MOVE_NODES.slot_1],
	[MOVE_NODES.slot_1, MOVE_NODES.bad_2],
	[MOVE_NODES.battle_1, MOVE_NODES.slot_2],
	[MOVE_NODES.slot_2, MOVE_NODES.shop_2],
	[MOVE_NODES.shop_2, MOVE_NODES.jackpot],
	[MOVE_NODES.start, MOVE_NODES.bad_1],
	[MOVE_NODES.bad_1, MOVE_NODES.shop_1],
	[MOVE_NODES.bad_1, MOVE_NODES.nothing_2],
	[MOVE_NODES.nothing_2, MOVE_NODES.surprise],
	[MOVE_NODES.nothing_2, MOVE_NODES.battle_2],
	[MOVE_NODES.shop_1, MOVE_NODES.battle_2],
	[MOVE_NODES.shop_1, MOVE_NODES.good_2],
	[MOVE_NODES.battle_2, MOVE_NODES.good_2],
	[MOVE_NODES.good_2, MOVE_NODES.slot_3],
	[MOVE_NODES.slot_3, MOVE_NODES.shop_2],

	[MOVE_NODES.start, MOVE_NODES.good_1],
	[MOVE_NODES.start, MOVE_NODES.good_1],
]

@onready var nils = $stats/nils
@onready var paul = $stats/paul
@onready var pia = $stats/pia

@onready var nils_char = $stats/players/Garen
@onready var paul_char = $stats/players/Kindred
@onready var pia_char = $stats/players/Lulu

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.stats_changed.connect(_on_stats_changed)
	update_stats()

	for button in get_node("buttons").get_children():
		print(button.pressed)
		button.pressed.connect(func(): _on_button_pressed(button.name))

func _on_button_pressed(button):
	print("button pressed: " + button)
	Game.get_current_player().node = MOVE_NODES[button]
	update_positions()

func _on_stats_changed():
	pass

func update_stats():
	nils.get_node("money").text = str(Game.get_player("nils").money) + "$"
	nils.get_node("speed").text = "speed: " + str(Game.get_player("nils").speed)
	nils.get_node("armor").text = "armor: " + str(Game.get_player("nils").armor)
	nils.get_node("damage").text = "damage: " + str(Game.get_player("nils").damage)
	nils.get_node("health").text = "health: " + str(Game.get_player("nils").health)

	pia.get_node("money").text = str(Game.get_player("pia").money) + "$"
	pia.get_node("speed").text = "speed: " + str(Game.get_player("pia").speed)
	pia.get_node("armor").text = "armor: " + str(Game.get_player("pia").armor)
	pia.get_node("damage").text = "damage: " + str(Game.get_player("pia").damage)
	pia.get_node("health").text = "health: " + str(Game.get_player("pia").health)

	paul.get_node("money").text = str(Game.get_player("paul").money) + "$"
	paul.get_node("speed").text = "speed: " + str(Game.get_player("paul").speed)
	paul.get_node("armor").text = "armor: " + str(Game.get_player("paul").armor)
	paul.get_node("damage").text = "damage: " + str(Game.get_player("paul").damage)
	paul.get_node("health").text = "health: " + str(Game.get_player("paul").health)

func update_positions():
	var nils_node = Game.get_player("nils").node
	print(MOVE_NODES.keys()[nils_node])
	var nils_node_pos = get_node("buttons").get_node(MOVE_NODES.keys()[nils_node])
	nils_char.set_position(nils_node_pos.position)

	var paul_node = Game.get_player("paul").node
	var paul_node_pos = get_node("buttons").get_node(MOVE_NODES.keys()[paul_node])
	paul_char.set_position(paul_node_pos.position)

	var pia_node = Game.get_player("pia").node
	var pia_node_pos = get_node("buttons").get_node(MOVE_NODES.keys()[pia_node])
	pia_char.set_position(pia_node_pos.position)
