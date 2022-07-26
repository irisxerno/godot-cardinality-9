extends Node2D

export var move = Vector2(105, 0)
export var mover = Vector2(0,148)
export var count = 9
export var countr = 3

func _enter_tree():
	randomize()
	var scene = load("res://scene/Card.tscn")
	var cursori = self.position
	for i in range(self.countr):
		var cursorj = cursori
		for j in range(self.count):
			var inst = scene.instance()
			inst.position = cursorj
			inst.value = randi() % 12 + 2
			inst.suit = j % 9 + 1
			get_parent().call_deferred("add_child",inst)
			cursorj += move
		cursori += mover

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
