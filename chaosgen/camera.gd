extends Node


var radius:float
var anglex:float
var angley:float

var rot:Quaternion
func updateRotation():

		var x=Quaternion(cos(anglex/2), sin(anglex/2), 0, 0)
		var y=Quaternion(cos(angley/2), 0,sin(angley/2), 0)
		var q=x*y
		print(q," x:",anglex," y:",angley)
		rot=q
func _ready() -> void:
	updateRotation()
func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		anglex+=event.relative.x*get_process_delta_time()
		angley+=event.relative.y*get_process_delta_time()
		updateRotation()
	if event is InputEventMouseButton:
		event as InputEventMouseButton
		if event.pressed:
			if(event.button_index==MOUSE_BUTTON_WHEEL_UP):
				radius=clamp(radius+0.1,-30,10)
			if(event.button_index==MOUSE_BUTTON_WHEEL_DOWN):
				radius=clamp(radius-0.1,-30,10)

func _process(delta: float) -> void:
	pass
