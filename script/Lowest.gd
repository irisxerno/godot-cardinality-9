extends Control


func update_text(lowest):
	$Score.text = str(int(lowest["score"]))+"."
	$Progress.text = str(int(lowest["progress"]))+"."
	$Time.text = str(int(lowest["time"]/60)) + " m"

