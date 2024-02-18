extends Node


signal return_cards
signal card_data
signal reset
signal update_saves
signal update_scoreboard
signal update_results


var savable = false

var n_i = false
var n_list = "latest"

var stats
var armory
var diamond
var world
var generator
var color
var idle_filter

var version = 1

var save_data
var savefile_json

var file_path = "user://save"
var file_compression = 2


func color(c):
	color = c


func start():
	savable = false
	n_i = -1
	n_list = "latest"
	save_data = {
		"version": version,
		"latest": [],
		"world": []
	}
	var save_f = File.new()
	var dir = Directory.new()
	if dir.file_exists(file_path):
		if file_compression != -1:
			save_f.open_compressed(file_path, File.READ, file_compression)
		else:
			save_f.open(file_path, File.READ)
		var savefile = parse_json(save_f.get_line())
		if typeof(savefile) == 18 and "version" in savefile:
			var sv_ver = savefile["version"]
			if version == sv_ver:
				save_data = savefile
		save_f.close()
	load_save()


func cards_to_data(c):
	var data = []
	for inst in c:
		data.append([inst.value, inst.suit])
	return data


func get_cards(cards):
	if savable:
		save(cards)
	emit_signal("return_cards", cards)


func save_file():
	savefile_json = to_json(save_data)
	save_to_file()


func save_to_file():
	if not savefile_json:
		return
	var save_game = File.new()
	if file_compression != -1:
		save_game.open_compressed(file_path, File.WRITE, file_compression)
	else:
		save_game.open(file_path, File.WRITE)
	save_game.store_line(savefile_json)


func save(cards):
	var card_data = cards_to_data(cards)
	var armory_data = armory.to_data()
	var diamond_data = diamond.to_data()
	var stat_data = stats.to_data()
	var world_progress = world.progress_to_data()

	var data = {
		"color": color,
		"cards": card_data,
		"armories": armory_data,
		"diamond": diamond_data,
		"stats": stat_data,
		"world_num": world.num,
		"world_state": generator.world_state,
		"world_seed": generator.world_seed,
		"world_progress": world_progress,
	}

	var svl = save_data["latest"]
	svl.append(data)
	while len(svl) > 5:
		svl.pop_front()
	save_data["latest"] = svl
	
	svl = save_data["world"]
	var si = 0
	var wa = true
	while si < len(svl):
		if svl[si]["world_num"] == world.num:
			wa = false
			break
		si += 1
	if wa:
		svl.append(data)
	else:
		svl[si] = data

	while len(svl) > 5:
		svl.pop_front()
	save_data["world"] = svl

	save_file()


func _on_request_saves(m_list):
	var w = false
	if len(save_data["world"]) >= 2:
		w = true
	emit_signal("update_saves", save_data[m_list], w)


func _on_Saves_load_save(m_list, index):
	n_list = m_list
	n_i = index
	load_save()


func load_save():
	savable = false
	emit_signal("reset")


func load_next():
	if typeof(n_i) < 2 or len(save_data[n_list]) < 1: # null or bool
		generator.new_game()
		return
	var data = save_data[n_list][n_i]

	emit_signal("card_data", data["cards"])
	armory.from_data(data["armories"])
	diamond.from_data(data["diamond"])
	stats.from_data(data["stats"])

	generator.world_seed = data["world_seed"]
	generator.rng.seed = generator.world_seed
	generator.world_state = data["world_state"]
	generator.rng.state = generator.world_state

	generator.world_num = data["world_num"]
	generator.return_world()
	world.progress_from_data(data["world_progress"])

	color = data["color"]
