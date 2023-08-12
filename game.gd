extends Node

enum PHASE {MOVE, ACTION}

var players: Array[Player] = [
	Player.new("Nils", Vector2(0, 0)),
	Player.new("Paul", Vector2(100, -40)),
	Player.new("Pia", Vector2(200, 0)),
]
var turn = 0
var current_phase: PHASE = PHASE.MOVE

signal stats_changed
signal next_turn

func do_next_turn():
	if current_phase != PHASE.ACTION: return
	current_phase = PHASE.MOVE
	turn = (turn + 1) % players.size()
	next_turn.emit()

func get_player(player_name: String):
	for player in players:
		if player.name.to_lower() == player_name.to_lower():
			return player
	return null

func get_current_player():
	return players[turn]

class Player:
	var name: String
	var money: int
	var speed: int
	var armor: int
	var damage: int
	var health: int
	var node: Map.NODES
	var offset: Vector2

	func _init(player_name: String, offset: Vector2):
		self.name = player_name
		self.money = 0
		self.speed = 10
		self.armor = 20
		self.damage = 10
		self.health = 100
		self.node = Map.NODES.start
		self.offset = offset
