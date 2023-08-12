extends Node2D

@onready var label = $Label
@onready var map = $map
@onready var shop = $shop

@onready var good_wheel = $good_wheel
@onready var bad_wheel = $bad_wheel
@onready var battle_wheel = $battle_wheel
@onready var jackpot_wheel = $jackpot_wheel
@onready var slot_wheel = $slot_wheel
@onready var surprise_wheel = $surprise_wheel

func _ready():
	map.player_moved.connect(_on_player_moved)
	shop.finish_shopping.connect(_on_finished_shopping)
	
func _on_player_moved(target: Map.NODES):
	print("_on_player_moved", target)
	match target:
		Map.NODES.good_1, Map.NODES.good_2:
			update_good_wheel()
			good_wheel.visible = true
		Map.NODES.bad_1, Map.NODES.bad_2:
			update_bad_wheel()
			bad_wheel.visible = true
		Map.NODES.battle_1, Map.NODES.battle_2:
			update_battle_wheel()
			battle_wheel.visible = true
		Map.NODES.shop_1, Map.NODES.shop_2:
			shop.visible = true
		Map.NODES.nothing_1, Map.NODES.nothing_2:
			Game.do_next_turn()
		Map.NODES.slot_1, Map.NODES.slot_2, Map.NODES.slot_3:
			update_slot_wheel()
			slot_wheel.visible = true
		Map.NODES.jackpot:
			update_jackpot_wheel()
			jackpot_wheel.visible = true
		Map.NODES.start:
			Game.do_next_turn()
		Map.NODES.surprise:
			update_surprise_wheel()
			surprise_wheel.visible = true

func _on_finished_shopping():
	Game.do_next_turn()
	shop.visible = false
	
func update_good_wheel():
	var player = Game.get_current_player()
	
	var options = [
		{
			"name": "+10$",
			"chance": 0.5,
			"callback": func():
		player.money += 10
		map.update_stats()
		},
		{
			"name": "-10$",
			"chance": 0.5,
			"callback": func(): 
		player.money -= 10
		map.update_stats()
		},
		{
			"name": "+50$",
			"chance": 0.5,
			"callback": func():
		player.money += 50
		map.update_stats()
		},
		{
			"name": "-50$",
			"chance": 0.2,
			"callback": func(): 
		player.money -= 50
		map.update_stats()
		},
		{
			"name": "steal 20$",
			"chance": 0.3,
			"callback": func(): 
		var i = floor(randf() * 3)
		Game.players[i].money -= 20
		player.money += 20
		map.update_stats()
		},
		{
			"name": "nothing",
			"chance": 0.3,
		},
		{
			"name": "+10 armor",
			"chance": 0.2,
			"callback": func(): 
		player.armor += 10
		map.update_stats()
		},
		{
			"name": "double money",
			"chance": 0.05,
			"callback": func(): 
		player.money *= 2
		map.update_stats()
		},
		{
			"name": "+10 damage",
			"chance": 0.1,
			"callback": func(): 
		player.damage += 10
		map.update_stats()
		},
		{
			"name": "+10 speed",
			"chance": 0.1,
			"callback": func(): 
		player.speed += 10
		map.update_stats()
		},	
	]
	
	options.shuffle()
	
	good_wheel.options = options
	
func update_bad_wheel():
	var player = Game.get_current_player()
	
	var options = [
		{
			"name": "+10$",
			"chance": 0.5,
			"callback": func():
		player.money += 10
		map.update_stats()
		},
		{
			"name": "-10$",
			"chance": 0.5,
			"callback": func(): 
		player.money -= 10
		map.update_stats()
		},
		{
			"name": "-50$",
			"chance": 0.2,
			"callback": func(): 
		player.money -= 50
		map.update_stats()
		},
		{
			"name": "gift everybody 20$",
			"chance": 0.2,
			"callback": func(): 
		Game.players[(Game.turn + 1) % Game.players.size()].money += 20
		Game.players[(Game.turn + 2) % Game.players.size()].money += 20
		player.money -= 40
		map.update_stats()
		},
		{
			"name": "nothing",
			"chance": 0.4,
		},
		{
			"name": "-5 armor",
			"chance": 0.2,
			"callback": func(): 
		player.armor -= 5
		map.update_stats()
		},
		{
			"name": "half money",
			"chance": 0.05,
			"callback": func(): 
		player.money = floor(player.money / 2)
		map.update_stats()
		},
		{
			"name": "-5 damage",
			"chance": 0.2,
			"callback": func(): 
		player.damage -= 5
		map.update_stats()
		},
		{
			"name": "-5 speed",
			"chance": 0.2,
			"callback": func(): 
		player.speed -= 5
		map.update_stats()
		},	
	]
	
	options.shuffle()
	
	bad_wheel.options = options

func update_battle_wheel():
	var player = Game.get_current_player()
	
	var options = [
		{
			"name": "fight Nami",
			"chance": 0.5,
			"callback": func():
		if player.speed < 20:
			player.health -= 5
		else:
			player.speed -= 1
		map.update_stats()
		},
		{
			"name": "fight Garen",
			"chance": 0.5,
			"callback": func():
		if player.armor < 30:
			player.health -= 15
		else:
			player.armor -= 5
		map.update_stats()
		},
		{
			"name": "fight Vayne",
			"chance": 0.5,
			"callback": func():
		if player.damage < 25:
			player.health -= 10
		else:
			player.damage -= 2
		map.update_stats()
		},
	]
	
	options.shuffle()
	
	battle_wheel.options = options

func update_jackpot_wheel():
	var player = Game.get_current_player()
	
	var options = [
		{
			"name": "Jackpot",
			"chance": 0.01,
			"callback": func():
		player.money += 300
		map.update_stats()
		},
		{
			"name": "Trostpreis",
			"chance": 0.99,
			"callback": func():
		player.money += 1
		map.update_stats()
		},
	]
	
	options.shuffle()
	
	jackpot_wheel.options = options
	
func update_slot_wheel():
	var player = Game.get_current_player()
	
	var options = [
		{
			"name": "Swap Places",
			"chance": 0.4,
			"callback": func():
		var target = Game.players[(Game.turn + floor(Game.players.size() * randf() - 1)) % Game.players.size()]
		var target_node = target.node.clone()
		target.node = player.node.clone()
		player.node = target_node
		map.update_stats()
		},
		{
			"name": "nothing",
			"chance": 0.6,
		},
		{
			"name": "random stat +20",
			"chance": 0.1,
			"callback": func():
		var stats = ['speed', 'money', 'health', 'armor', 'damage']
		
		player[stats.pick_random()] += 20
		
		map.update_stats()
		},
		{
			"name": "random stat -10",
			"chance": 0.1,
			"callback": func():
		var stats = ['speed', 'money', 'health', 'armor', 'damage']
		
		player[stats.pick_random()] -= 10
		
		map.update_stats()
		},
		{
			"name": "goto random spot",
			"chance": 0.3,
			"callback": func():
		var stats = ['speed', 'money', 'health', 'armor', 'damage']
		
		player.node = Map.NODES[Map.NODES.keys().pick_random()]
		
		map.update_positions()
		},
		{
			"name": "+15$",
			"chance": 0.6,
			"callback": func():
		
		player.money += 15
		map.update_stats()
		},
	]
	
	options.shuffle()
	
	slot_wheel.options = options

func update_surprise_wheel():
	var player = Game.get_current_player()
	
	var options = [
		{
			"name": "goto random spot",
			"chance": 0.6,
			"callback": func():
		
		player.node = Map.NODES[Map.NODES.keys().pick_random()]
		
		map.update_positions()
		},
		{
			"name": "fuck you",
			"chance": 0.2,
		},
		{
			"name": "random stat +20",
			"chance": 0.2,
			"callback": func():
		var stats = ['speed', 'money', 'health', 'armor', 'damage']
		
		player[stats.pick_random()] += 20
		
		map.update_stats()
		},
	]
	
	options.shuffle()
	
	surprise_wheel.options = options

func _on_slot_wheel_spin_finished(option):
	slot_wheel.visible = false
	Game.do_next_turn()


func _on_battle_wheel_spin_finished(option):
	battle_wheel.visible = false
	Game.do_next_turn()


func _on_bad_wheel_spin_finished(option):
	bad_wheel.visible = false
	Game.do_next_turn()
	


func _on_good_wheel_spin_finished(option):
	good_wheel.visible = false
	Game.do_next_turn()
	


func _on_jackpot_wheel_spin_finished(option):
	jackpot_wheel.visible = false
	Game.do_next_turn()
	


func _on_surprise_wheel_spin_finished(option):
	surprise_wheel.visible = false
	Game.do_next_turn()
	
