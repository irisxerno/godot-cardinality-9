extends Control


signal load_save
signal request_saves

var saves = []
var curr_gm = "tutorial"
var m_gm = "tutorial"
var m_list = "latest"

func _ready():
	var cursor = Vector2(0,0)
	var scene = preload("res://scene/Save.tscn")
	for i in range(5):
		var inst = scene.instance()
		inst.rect_position = cursor
		inst.visible = false
		inst.connect("load_save", self, "load_save")
		saves.append(inst)
		add_child(inst)
		cursor += Vector2(0, 60)


func load_save(index):
	emit_signal("load_save", m_list, index, m_gm)


func set_saves(save_data, w):
	$worlds.visible = false
	if w:
		$worlds.visible = true
	for inst in saves:
		inst.clear()
	for i in range(len(save_data)):
		var save = save_data[-1-i]
		var inst = saves[i]
		inst.set_save(save, len(save_data)-i-1)
		inst.visible = true


func _on_Gamemodes_selected(g):
	m_gm = g
	emit_signal("request_saves", m_gm, m_list)


func _worlds_click(b):
	if b:
		m_list = "world"
	else:
		m_list = "latest"
	emit_signal("request_saves", m_gm, m_list)


func _on_SaveView_trans_state(state):
	if state == "close":
		$worlds/Label.select(false)
		$Gamemodes.select($Gamemodes.get_node(curr_gm))


func update_gamemode(new_gm):
	curr_gm = new_gm
	m_gm = new_gm


func _on_newgame_click(b):
	if not b:
		emit_signal("load_save", m_list, false, m_gm)
