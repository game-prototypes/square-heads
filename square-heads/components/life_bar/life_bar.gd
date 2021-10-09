extends ProgressBar

func initialize(inital_life:int):
	max_value=inital_life
	update_life(inital_life)

func decrease_life(decrease:int) -> int:
	return update_life(int(value)-decrease)

func update_life(new_life:int)->int:
	value=new_life
	if value<=30:
		modulate=Color(1, 0, 0)
	if value<=0:
		value=0
	return int(value)
