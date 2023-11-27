extends Control

func _ready():
	hide()

func _sleep_variables() -> int:
	var count = 0
	if GlobalScript.lampshade_on:
		$SleepVariables.text = "[!] Light is on\n"
		count += 1
	if GlobalScript.rooftop_light_on:
		$SleepVariables.text = "[!] Light is on\n"
		count += 1
	if !GlobalScript.is_with_pajamas:
		$SleepVariables.text = "[!] Not wearing pajamas\n"
		count += 1
		
	print("Sleep Variables Count: " + str(count))
	return count

func _on_timer_timeout():
	$DebugLabel.text = "ProgressBarValue: " + str($ProgressBar.value)
	if GlobalScript.is_resting and GlobalScript.is_eyes_closed:
		if $ProgressBar.value < 100:
			show()
			$ProgressBar.value += _increase_sleep_progress()
		else:
			hide()
	else:
		hide()
		$SleepVariables.text = ""
		#$ProgressBar.value -= progress_value
		$ProgressBar.value = 0.0
		
func _increase_sleep_progress() -> int:
	var progress_value = 0.0
	match _sleep_variables():
		# zero is ideal sceneray
		0:
			progress_value += 7
		1:
			progress_value += 3
		2:
			progress_value += 2
		3:
			progress_value += 1
		_:
			progress_value += 0
			
	return progress_value
	
