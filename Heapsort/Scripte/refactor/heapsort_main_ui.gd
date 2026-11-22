extends Control

@export var heapsort: HeapSort
@onready var auto_algo: Button = $VBoxContainer/AutoAlgo

func on_forward_pressed() -> void:
	heapsort.stepForward()
	
func on_backward_pressed() -> void:
	heapsort.stepBackward()
	
func on_auto_algo_toggled(toggled_on: bool) -> void:
	heapsort.toggleAuto()
	if toggled_on:
		auto_algo.text = "Stop"
	else:
		auto_algo.text = "Start"
	
func on_auto_algo_speed_value_changed(value: float) -> void:
	match value:
		1.0:
			heapsort.setStepInterval(3)
		2.0:
			heapsort.setStepInterval(2)
		3.0:
			heapsort.setStepInterval(1)
		4.0:
			heapsort.setStepInterval(0.5)
		5.0:
			heapsort.setStepInterval(0.1)

func on_numbers_text_submitted(new_text: String) -> void:
	heapsort.setCustomNumbers(new_text)
