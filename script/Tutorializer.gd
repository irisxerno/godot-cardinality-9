extends Node


signal save
signal show_tab

var stats

var tutorial = false
var inhibit = 0
var stats_progress = 6
var control = false
var scores = false


func show_tabs(uninhibit=false):
	if stats.unlocked > 0 or stats.progress > 0:
		emit_signal("show_tab","StatsView")

	control = true
	if inhibit > 0:
		if uninhibit:
			inhibit = 0
			stats.inhibit = false
			stats_progress = stats.unlocked
		else:
			return

	emit_signal("show_tab","SaveView")
	emit_signal("show_tab","WorldView")
	emit_signal("show_tab","ScoreView")


func _on_Deal_count(count):
	if inhibit == 1 and control and count <= stats.get_extra():
		show_tabs(true)


func on_win(col, w_num):
	progress_stats()


func progress_stats():
	stats.inhibit = false
	if stats_progress < 0:
		stats_progress = 0
	if stats_progress >= 6:
		return
	var stat = stats.list[stats_progress]
	if stats.unlocked-1 >= stats_progress:
		if stats.xp >= stat.cost():
			if stats_progress == 3 or stats_progress == 4:
				inhibit = stats_progress
			else:
				inhibit = 2
		else:
			stats.inhibit = true


func _on_Stats_buy_pressed():
	if inhibit == 2:
		show_tabs(true)


func set_progress(p):
	inhibit = 0
	if typeof(p) < 2: # null or bool
		stats_progress = 6
	else:
		stats_progress = p
		progress_stats()
	control = false
	print(inhibit)


func _on_Builder_uselect(n):
	if inhibit == n:
		show_tabs(true)
