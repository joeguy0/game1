extends Path2D


var fistpath
var off
var area
var bodies
signal end
signal hitt





func _ready(): 
	fistpath = get_node("Fol")
	off = fistpath.get_offset()
	fistpath.set_offset(109.0)
	set_process(true)
	area = get_node("Fol/hit")



# warning-ignore:unused_argument
func _process(delta):
	
	fistpath.set_offset(fistpath.get_offset() - 200.0 * delta)

	if fistpath.unit_offset == 0:
		fistpath.set_unit_offset(1)
		emit_signal("end")

