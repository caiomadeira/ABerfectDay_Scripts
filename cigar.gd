extends Interactable

@onready var information_label = $InformationLabel
@onready var game_utils = get_node("/root/GlobalGameUtils")
@onready var cigarettes_count_label = $CigarettesCountLabel

var cigarettes_count = 7
var cigar_process = 0

func _ready():
	information_label.visible = false
	information_label.font_size = 60

func _cigarettesbox_is_empty():
	if cigarettes_count < 1:
		GlobalScript.is_smoking = false
		GlobalScript.can_smoke = false
		GlobalScript.is_mov_enable = true

func _process(delta):
	_cigarettesbox_is_empty()
	information_label.text = "Cigarettes Count: " + str(cigarettes_count)
	if GlobalScript.can_smoke:
		cigarettes_count_label.text = "Cigarettes count: " + str(cigarettes_count) + "\n Cigar progress: " + str(cigar_process) 
		cigarettes_count_label.visible = false
		information_label.visible = false
		visible = false
		_cigar_progress(delta)
	else:
		cigarettes_count_label.visible = false
		if GlobalScript.show_item_information:
			information_label.visible = true
		else:
			information_label.visible = false
			visible = true

func action_use():
	if cigarettes_count == 0:
		GlobalScript.can_smoke = false
	else:
		GlobalScript.can_smoke = true

func _cigar_progress(delta):
	if cigarettes_count != 0:
		if GlobalScript.is_smoking:
			cigar_process += 1
			if cigar_process == 120:
				GlobalScript.is_smoking = false
				cigar_process = 0
				cigarettes_count -= 1
			
func _input(_event):
	if GlobalScript.can_smoke:
		if Input.is_action_just_pressed("click1"):
			#print("do smoke")
			GlobalScript.is_smoking = true
			GlobalScript.is_mov_enable = false
			
		if Input.is_action_just_released("click1"):
			#print("stopped smoke")
			GlobalScript.is_smoking = false
			GlobalScript.is_mov_enable = true
			
		if Input.is_action_just_pressed("leave"):
			#print("throw cigar away")
			GlobalScript.is_smoking = false
			GlobalScript.can_smoke = false
			cigar_process = 0
