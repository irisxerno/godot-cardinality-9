extends Control

signal select_tile
signal ccount

var tiles = []
var tile_rsize = 125
var tile_csize = 100
var num = 0

var states = ["hide", "peek", "show", "defeated"]


func clear():
	for tile in tiles:
		tile.queue_free()
	tiles = []


func progress_from_data(p):
	for i in range(len(tiles)):
		var tile = tiles[i]
		tile.state = states[p[i]]
		tile.update()
		emit_signal("ccount", ccount())


func progress_to_data():
	var data = []
	for tile in tiles:
		data.append(states.find(tile.state))
	return data


func from_data(world, n):
	clear()
	num = n
	$Label.text = "W: " + str(num)
	if len(world) != 15:
		emit_signal("ccount", 0)
		return
	var tile_scene = preload("res://scene/Tile.tscn")
	var row = 0
	var col = 0 
	for dat in world:
		var tile = tile_scene.instance()
		tile.cards = dat[0]
		tile.armories = dat[1]
		tile.reward = dat[2]
		tile.row = row
		tile.col = col
		tile.rect_position += Vector2(tile_rsize*row + tile_rsize/2*col, -tile_csize*col)
		if col == 0:
			tile.state = "show"
		tile.connect("request_select", self, "request_select")
		add_child(tile)
		tiles.append(tile)
		row += 1
		if row > 4-col:
			row = 0
			col += 1
	emit_signal("ccount", ccount())


func ccount():
	var minc = 0
	var maxc = 0
	for tile in tiles:
		if tile.state == "defeated" or tile.state == "hide":
			continue
		if tile.col < minc:
			minc = tile.col
		if tile.col > maxc:
			maxc = tile.col
	var ccount = maxc - minc + 1
	return ccount


func request_select(inst):
	emit_signal("select_tile", inst)


func defeat(inst):
	inst.state = "defeated"
	inst.update()
	if inst.col == 4:
		return
	for tile in tiles:
		if tile.row > inst.row - 2 and tile.row < inst.row + 2 and tile.col > inst.col - 2 and tile.col < inst.col + 2:
			if not (tile.row - inst.row == tile.col - inst.col):
				tile.advance_state()
				emit_signal("ccount", ccount())
	var wprogc = 0
	for tile in tiles:
		if tile.state == "defeated":
			wprogc += 1
	print("wprogc: ", wprogc)
