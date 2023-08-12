extends Node2D
class_name Map

enum NODES {start, good_1, bad_1, battle_1, shop_1, nothing_1, slot_1, nothing_2, good_2, battle_2, surprise, bad_2, slot_2, slot_3, shop_2, jackpot}

var MOVE_EDGES = [
	[NODES.start, NODES.good_1],
	[NODES.good_1, NODES.battle_1],
	[NODES.battle_1, NODES.nothing_1],
	[NODES.battle_1, NODES.slot_1],
	[NODES.slot_1, NODES.bad_2],
	[NODES.battle_1, NODES.slot_2],
	[NODES.slot_2, NODES.shop_2],
	[NODES.shop_2, NODES.jackpot],
	[NODES.start, NODES.bad_1],
	[NODES.bad_1, NODES.shop_1],
	[NODES.bad_1, NODES.nothing_2],
	[NODES.nothing_2, NODES.surprise],
	[NODES.nothing_2, NODES.battle_2],
	[NODES.shop_1, NODES.battle_2],
	[NODES.shop_1, NODES.good_2],
	[NODES.battle_2, NODES.good_2],
	[NODES.good_2, NODES.slot_3],
	[NODES.slot_3, NODES.shop_2],
	[NODES.bad_2, NODES.slot_2],
	[NODES.jackpot, NODES.start],
	[NODES.nothing_1, NODES.slot_2],
	[NODES.surprise, NODES.surprise],
]

@onready var nils = $stats/nils
@onready var paul = $stats/paul
@onready var pia = $stats/pia

@onready var nils_char = $players/Garen
@onready var paul_char = $players/Kindred
@onready var pia_char = $players/Lulu

@onready var running = $running

signal player_moved(target: NODES)

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.stats_changed.connect(_on_stats_changed)
	Game.next_turn.connect(func(): update_running())
	update_stats()
	update_running()

	for button in get_node("buttons").get_children():
		button.pressed.connect(func(): _on_button_pressed(button))

func _on_button_pressed(button):
	var target = NODES[button.name]
	
	if Game.current_phase != Game.PHASE.MOVE or is_move_allowed(Game.get_current_player(), target) == false:
		return
		
	Game.get_current_player().node = target
	Game.current_phase = Game.PHASE.ACTION
	update_positions()
	update_running()
		
	player_moved.emit(target)

func _on_stats_changed():
	pass
	
func is_move_allowed(player: Game.Player, target: NODES):
	var current_pos = player.node
	var allowed = false
	for moves in MOVE_EDGES:
		if moves[0] == current_pos and moves[1] == target:
			allowed = true
			
	return allowed

func update_running():
	var current_player = Game.get_current_player()
	
	running.position = get_node("stats").get_node(current_player.name.to_lower()).position + Vector2(100, 40)

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
	var nils_data = Game.get_player("nils")
	var nils_node_pos: Button = get_node("buttons").get_node(NODES.keys()[nils_data.node])
	nils_char.set_position(nils_node_pos.position + nils_data.offset)

	var paul_data = Game.get_player("paul")
	var paul_node_pos = get_node("buttons").get_node(NODES.keys()[paul_data.node])
	paul_char.set_position(paul_node_pos.position + paul_data.offset)

	var pia_data = Game.get_player("pia")
	var pia_node_pos = get_node("buttons").get_node(NODES.keys()[pia_data.node])
	pia_char.set_position(pia_node_pos.position + pia_data.offset)
