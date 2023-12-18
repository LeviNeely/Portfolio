extends Node

class_name OpenSimplexNoise4D

## Constants
const STRETCH_CONSTANT4: float = -0.138196601125011 # (1/Math.sqrt(4+1)-1)/4
const SQUISH_CONSTANT4: float = 0.309016994374947 # (Math.sqrt(4+1)-1)/4
const NORM_CONSTANT4: int = 30
const GRADIENTS4: Array[int] = [
	3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 
	-3, 1, 1, 1, -1, 3, 1, 1, -1, 1, 3, 1, -1, 1, 1, 3, 
	3, -1, 1, 1, 1, -3, 1, 1, 1, -1, 3, 1, 1, -1, 1, 3, 
	-3, -1, 1, 1, -1, -3, 1, 1, -1, -1, 3, 1, -1, -1, 1, 3, 
	3, 1, -1, 1, 1, 3, -1, 1, 1, 1, 3, -1, 1, 1, -1, 3, 
	-3, 1, -1, 1, -1, 3, -1, 1, -1, 1, 3, -1, -1, 1, -1, 3, 
	3, -1, -1, 1, 1, -3, -1, 1, 1, -1, 3, -1, 1, -1, -1, 3, 
	-3, -1, -1, 1, -1, -3, -1, 1, -1, -1, 3, -1, -1, -1, 1, 3, 
	3, 1, 1, -1, 1, 3, 1, -1, 1, 1, 3, 1, -1, 1, -1, 3, 
	-3, 1, 1, -1, -1, 3, 1, -1, -1, 1, 3, 1, -1, -1, -1, 3, 
	3, -1, 1, -1, 1, -3, 1, -1, 1, -1, 3, 1, -1, -1, -1, 3, 
	-3, -1, 1, -1, -1, -3, 1, -1, -1, -1, 3, 1, -1, -1, -1, 3, 
	3, 1, -1, -1, 1, 3, -1, -1, 1, 1, 3, -1, -1, 1, -1, 3, 
	-3, 1, -1, -1, -1, 3, -1, -1, -1, 1, 3, -1, -1, -1, -1, 3, 
	3, -1, -1, -1, 1, -3, -1, -1, 1, -1, 3, -1, -1, -1, -1, 3, 
	-3, -1, -1, -1, -1, -3, -1, -1, -1, -1, 3, -1, -1, -1, -1, 3
	]

## Variables for noise generation
var perm: Array[int] = []

## Variables that the user can set
var octaves: int = 1
var persistence: float = 0.5
var lacunarity: float = 2.0
var period: float = 15

func initialize(seed: int) -> void:
	# We have to fill with zeros to make this work later
	for i in range(256):
		perm.append(0)
	var source: Array[int] = []
	for i in range(256):
		source.append(i)
	# Generates a proper permutation
	seed = overflow(seed * 6364136223846793005 + 1442695040888963407)
	seed = overflow(seed * 6364136223846793005 + 1442695040888963407)
	seed = overflow(seed * 6364136223846793005 + 1442695040888963407)
	for i in range(255, -1, -1):
		seed = overflow(seed * 6364136223846793005 + 1442695040888963407)
		var r: int = int((seed + 31) % (i + 1))
		if r < 0:
			r += i + 1
		perm[i] = source[r]
		source[r] = source[i]

func set_octaves(oct: int) -> void:
	octaves = oct

func set_persistence(per: float) -> void:
	persistence = per

func set_lacunarity(lacu: float) -> void:
	lacunarity = lacu

func set_period(perio: int) -> void:
	period = perio

func overflow(x):
	var MAX_INT64: int = 9223372036854775807  # 2^63 - 1
	var MIN_INT64: int = -9223372036854775808  # -2^63
	if x > MAX_INT64:
		return x - (MAX_INT64 - MIN_INT64 + 1)
	elif x < MIN_INT64:
		return x + (MAX_INT64 - MIN_INT64 + 1)
	return x

func extrapolate4(xsb: int, ysb: int, zsb: int, wsb: int, dx: float, dy: float, dz: float, dw: float) -> float:
	var index: int = perm[(perm[(perm[(perm[xsb & 0xFF] + ysb) & 0xFF] + zsb) & 0xFF] + wsb) & 0xFF] & 0xFC
	var gradients: Array[int] = GRADIENTS4.slice(index, index + 4)  # Slice the array from 'index' to 'index + 3'
	var g1: int = gradients[0]
	var g2: int = gradients[1]
	var g3: int = gradients[2]
	var g4: int = gradients[3]
	return (g1 * dx + g2 * dy + g3 * dz + g4 * dw)

func noise4(x: float, y: float, z: float, w: float) -> float:
	var total: float = 0.0
	var amplitude: float = 1.0
	var max_amplitude: float = 0.0
	var _period: float = period
	for i in range(octaves):
		total += (single_noise4(x * _period, y * _period, z * _period, w * _period) * amplitude)
		max_amplitude += amplitude
		amplitude *= persistence
		_period *= lacunarity
	return (total / max_amplitude)

func single_noise4(x: float, y: float, z: float, w: float) -> float:
	## Define all needed variables for the rest of the function
	#The value to be returned
	var value: float
	#Offsets
	var stretch_offset: float
	var squish_offset: float
	#*s
	var xs: float
	var ys: float
	var zs: float
	var ws: float
	#*sb
	var xsb: float
	var ysb: float
	var zsb: float
	var wsb: float
	#*b
	var xb: float
	var yb: float
	var zb: float
	var wb: float
	#*ins
	var xins: float
	var yins: float
	var zins: float
	var wins: float
	#in_sum
	var in_sum: float
	#a_po
	var a_po: int
	#a_score
	var a_score: float
	#a_is_bigger_side
	var a_is_bigger_side: bool
	#attn0-attn10
	var attn0: float
	var attn1: float
	var attn2: float
	var attn3: float
	var attn4: float
	var attn5: float
	var attn6: float
	var attn7: float
	var attn8: float
	var attn9: float
	var attn10: float
	#attn_ext0-attn_ext2
	var attn_ext0: float
	var attn_ext1: float
	var attn_ext2: float
	#b_po
	var b_po: int
	#b_score
	var b_score: float
	#b_is_bigger_side
	var b_is_bigger_side: bool
	#c-c2
	var c: int
	var c1: int
	var c2: int
	#d*0 - d*10
	var dx0: float
	var dx1: float
	var dx2: float
	var dx3: float
	var dx4: float
	var dx5: float
	var dx6: float
	var dx7: float
	var dx8: float
	var dx9: float
	var dx10: float
	var dy0: float
	var dy1: float
	var dy2: float
	var dy3: float
	var dy4: float
	var dy5: float
	var dy6: float
	var dy7: float
	var dy8: float
	var dy9: float
	var dy10: float
	var dz0: float
	var dz1: float
	var dz2: float
	var dz3: float
	var dz4: float
	var dz5: float
	var dz6: float
	var dz7: float
	var dz8: float
	var dz9: float
	var dz10: float
	var dw0: float
	var dw1: float
	var dw2: float
	var dw3: float
	var dw4: float
	var dw5: float
	var dw6: float
	var dw7: float
	var dw8: float
	var dw9: float
	var dw10: float
	#d*_ext0-d*_ext2
	var dx_ext0: float
	var dx_ext1: float
	var dx_ext2: float
	var dy_ext0: float
	var dy_ext1: float
	var dy_ext2: float
	var dz_ext0: float
	var dz_ext1: float
	var dz_ext2: float
	var dw_ext0: float
	var dw_ext1: float
	var dw_ext2: float
	#p1-p4
	var p1: float
	var p2: float
	var p3: float
	var p4: float
	#score
	var score: float
	#uins
	var uins: float
	#*sv_ext0-*sv_ext2
	var xsv_ext0: float
	var xsv_ext1: float
	var xsv_ext2: float
	var ysv_ext0: float
	var ysv_ext1: float
	var ysv_ext2: float
	var zsv_ext0: float
	var zsv_ext1: float
	var zsv_ext2: float
	var wsv_ext0: float
	var wsv_ext1: float
	var wsv_ext2: float
	# Place input coordinates on simplectic honeycomb.
	stretch_offset = (x + y + z + w) * STRETCH_CONSTANT4
	xs = x + stretch_offset
	ys = y + stretch_offset
	zs = z + stretch_offset
	ws = w + stretch_offset
	# Floor to get simplectic honeycomb coordinates of rhombo-hypercube super-cell origin.
	xsb = floor(xs)
	ysb = floor(ys)
	zsb = floor(zs)
	wsb = floor(ws)
	# Skew out to get actual coordinates of stretched rhombo-hypercube origin. We'll need these later.
	squish_offset = (xsb + ysb + zsb + wsb) * SQUISH_CONSTANT4
	xb = xsb + squish_offset
	yb = ysb + squish_offset
	zb = zsb + squish_offset
	wb = wsb + squish_offset
	# Compute simplectic honeycomb coordinates relative to rhombo-hypercube origin.
	xins = xs - xsb
	yins = ys - ysb
	zins = zs - zsb
	wins = ws - wsb
	# Sum those together to get a value that determines which region we're in.
	in_sum = xins + yins + zins + wins
	# Positions relative to origin po.
	dx0 = x - xb
	dy0 = y - yb
	dz0 = z - zb
	dw0 = w - wb
	value = 0
	if in_sum <= 1:  # We're inside the pentachoron (4-Simplex) at (0,0,0,0)
		# Determine which two of (0,0,0,1), (0,0,1,0), (0,1,0,0), (1,0,0,0) are closest.
		a_po = 0x01
		a_score = xins
		b_po = 0x02
		b_score = yins
		if a_score >= b_score and zins > b_score:
			b_score = zins
			b_po = 0x04
		elif a_score < b_score and zins > a_score:
			a_score = zins
			a_po = 0x04
		if a_score >= b_score and wins > b_score:
			b_score = wins
			b_po = 0x08
		elif a_score < b_score and wins > a_score:
			a_score = wins
			a_po = 0x08
		# Now we determine the three lattice pos not part of the pentachoron that may contribute.
		# This depends on the closest two pentachoron vertices, including (0,0,0,0)
		uins = 1 - in_sum
		if uins > a_score or uins > b_score:  # (0,0,0,0) is one of the closest two pentachoron vertices.
			c = b_po if (b_score > a_score) else a_po  # Our other closest vertex is the closest out of a and b.
			if (c & 0x01) == 0:
				xsv_ext0 = xsb - 1
				xsv_ext1 = xsb
				xsv_ext2 = xsb
				dx_ext0 = dx0 + 1
				dx_ext1 = dx0
				dx_ext2 = dx0
			else:
				xsv_ext0 = xsb + 1
				xsv_ext1 = xsb + 1
				xsv_ext2 = xsb + 1
				dx_ext0 = dx0 - 1
				dx_ext1 = dx0 - 1 
				dx_ext2 = dx0 - 1
			if (c & 0x02) == 0:
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				ysv_ext2 = ysb
				dy_ext0 = dy0
				dy_ext1 = dy0 
				dy_ext2 = dy0
				if (c & 0x01) == 0x01:
					ysv_ext0 -= 1
					dy_ext0 += 1
				else:
					ysv_ext1 -= 1
					dy_ext1 += 1
			else:
				ysv_ext0 = ysb + 1
				ysv_ext1 = ysb + 1
				ysv_ext2 = ysb + 1
				dy_ext0 = dy0 - 1
				dy_ext1 = dy0 - 1
				dy_ext2 = dy0 - 1
			if (c & 0x04) == 0:
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				zsv_ext2 = zsb
				dz_ext0 = dz0
				dz_ext1 = dz0
				dz_ext2 = dz0
				if (c & 0x03) != 0:
					if (c & 0x03) == 0x03:
						zsv_ext0 -= 1
						dz_ext0 += 1
					else:
						zsv_ext1 -= 1
						dz_ext1 += 1
				else:
					zsv_ext2 -= 1
					dz_ext2 += 1
			else:
				zsv_ext0 = zsb + 1
				zsv_ext1 = zsb + 1
				zsv_ext2 = zsb + 1
				dz_ext0 = dz0 - 1
				dz_ext1 = dz0 - 1
				dz_ext2 = dz0 - 1
			if (c & 0x08) == 0:
				wsv_ext0 = wsb
				wsv_ext1 = wsb
				wsv_ext2 = wsb - 1
				dw_ext0 = dw0
				dw_ext1 = dw0
				dw_ext2 = dw0 + 1
			else:
				wsv_ext0 = wsb + 1
				wsv_ext1 = wsb + 1
				wsv_ext2 = wsb + 1
				dw_ext0 = dw0 - 1
				dw_ext1 = dw0 - 1
				dw_ext2 = dw0 - 1
		else:  # (0,0,0,0) is not one of the closest two pentachoron vertices.
			c = a_po | b_po  # Our three extra vertices are determined by the closest two.
			if (c & 0x01) == 0:
				xsv_ext0 = xsb
				xsv_ext2 = xsb
				xsv_ext1 = xsb - 1
				dx_ext0 = dx0 - 2 * SQUISH_CONSTANT4
				dx_ext1 = dx0 + 1 - SQUISH_CONSTANT4
				dx_ext2 = dx0 - SQUISH_CONSTANT4
			else:
				xsv_ext0 = xsb + 1
				xsv_ext1 = xsb + 1
				xsv_ext2 = xsb + 1
				dx_ext0 = dx0 - 1 - 2 * SQUISH_CONSTANT4
				dx_ext1 = dx0 - 1 - SQUISH_CONSTANT4
				dx_ext2 = dx0 - 1 - SQUISH_CONSTANT4
			if (c & 0x02) == 0:
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				ysv_ext2 = ysb
				dy_ext0 = dy0 - 2 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - SQUISH_CONSTANT4
				dy_ext2 = dy0 - SQUISH_CONSTANT4
				if (c & 0x01) == 0x01:
					ysv_ext1 -= 1
					dy_ext1 += 1
				else:
					ysv_ext2 -= 1
					dy_ext2 += 1
			else:
				ysv_ext0 = ysb + 1
				ysv_ext1 = ysb + 1
				ysv_ext2 = ysb + 1
				dy_ext0 = dy0 - 1 - 2 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 1 - SQUISH_CONSTANT4
				dy_ext2 = dy0 - 1 - SQUISH_CONSTANT4
			if (c & 0x04) == 0:
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				zsv_ext2 = zsb
				dz_ext0 = dz0 - 2 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - SQUISH_CONSTANT4
				dz_ext2 = dz0 - SQUISH_CONSTANT4
				if (c & 0x03) == 0x03:
					zsv_ext1 -= 1
					dz_ext1 += 1
				else:
					zsv_ext2 -= 1
					dz_ext2 += 1
			else:
				zsv_ext0 = zsb + 1
				zsv_ext1 = zsb + 1
				zsv_ext2 = zsb + 1
				dz_ext0 = dz0 - 1 - 2 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 1 - SQUISH_CONSTANT4
				dz_ext2 = dz0 - 1 - SQUISH_CONSTANT4
			if (c & 0x08) == 0:
				wsv_ext0 = wsb
				wsv_ext1 = wsb
				wsv_ext2 = wsb - 1
				dw_ext0 = dw0 - 2 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - SQUISH_CONSTANT4
				dw_ext2 = dw0 + 1 - SQUISH_CONSTANT4
			else:
				wsv_ext0 = wsb + 1
				wsv_ext1 = wsb + 1
				wsv_ext2 = wsb + 1
				dw_ext0 = dw0 - 1 - 2 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 1 - SQUISH_CONSTANT4
				dw_ext2 = dw0 - 1 - SQUISH_CONSTANT4
		# Contribution (0,0,0,0)
		attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0 - dw0 * dw0
		if attn0 > 0:
			attn0 *= attn0
			value += attn0 * attn0 * extrapolate4(xsb + 0, ysb + 0, zsb + 0, wsb + 0, dx0, dy0, dz0, dw0)
		# Contribution (1,0,0,0)
		dx1 = dx0 - 1 - SQUISH_CONSTANT4
		dy1 = dy0 - 0 - SQUISH_CONSTANT4
		dz1 = dz0 - 0 - SQUISH_CONSTANT4
		dw1 = dw0 - 0 - SQUISH_CONSTANT4
		attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
		if attn1 > 0:
			attn1 *= attn1
			value += attn1 * attn1 * extrapolate4(xsb + 1, ysb + 0, zsb + 0, wsb + 0, dx1, dy1, dz1, dw1)
		# Contribution (0,1,0,0)
		dx2 = dx0 - 0 - SQUISH_CONSTANT4
		dy2 = dy0 - 1 - SQUISH_CONSTANT4
		dz2 = dz1
		dw2 = dw1
		attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
		if attn2 > 0:
			attn2 *= attn2
			value += attn2 * attn2 * extrapolate4(xsb + 0, ysb + 1, zsb + 0, wsb + 0, dx2, dy2, dz2, dw2)
		# Contribution (0,0,1,0)
		dx3 = dx2
		dy3 = dy1
		dz3 = dz0 - 1 - SQUISH_CONSTANT4
		dw3 = dw1
		attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
		if attn3 > 0:
			attn3 *= attn3
			value += attn3 * attn3 * extrapolate4(xsb + 0, ysb + 0, zsb + 1, wsb + 0, dx3, dy3, dz3, dw3)
		# Contribution (0,0,0,1)
		dx4 = dx2
		dy4 = dy1
		dz4 = dz1
		dw4 = dw0 - 1 - SQUISH_CONSTANT4
		attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
		if attn4 > 0:
			attn4 *= attn4
			value += attn4 * attn4 * extrapolate4(xsb + 0, ysb + 0, zsb + 0, wsb + 1, dx4, dy4, dz4, dw4)
	elif in_sum >= 3:  # We're inside the pentachoron (4-Simplex) at (1,1,1,1)
		# Determine which two of (1,1,1,0), (1,1,0,1), (1,0,1,1), (0,1,1,1) are closest.
		a_po = 0x0E
		a_score = xins
		b_po = 0x0D
		b_score = yins
		if a_score <= b_score and zins < b_score:
			b_score = zins
			b_po = 0x0B
		elif a_score > b_score and zins < a_score:
			a_score = zins
			a_po = 0x0B
		if a_score <= b_score and wins < b_score:
			b_score = wins
			b_po = 0x07
		elif a_score > b_score and wins < a_score:
			a_score = wins
			a_po = 0x07
		# Now we determine the three lattice pos not part of the pentachoron that may contribute.
		# This depends on the closest two pentachoron vertices, including (0,0,0,0)
		uins = 4 - in_sum
		if uins < a_score or uins < b_score:  # (1,1,1,1) is one of the closest two pentachoron vertices.
			c = b_po if (b_score < a_score) else a_po  # Our other closest vertex is the closest out of a and b.
			if (c & 0x01) != 0:
				xsv_ext0 = xsb + 2
				xsv_ext1 = xsb + 1
				xsv_ext2 = xsb + 1
				dx_ext0 = dx0 - 2 - 4 * SQUISH_CONSTANT4
				dx_ext1 = dx0 - 1 - 4 * SQUISH_CONSTANT4
				dx_ext2 = dx0 - 1 - 4 * SQUISH_CONSTANT4
			else:
				xsv_ext0 = xsb
				xsv_ext1 = xsb
				xsv_ext2 = xsb
				dx_ext0 = dx0 - 4 * SQUISH_CONSTANT4
				dx_ext1 = dx0 - 4 * SQUISH_CONSTANT4
				dx_ext2 = dx0 - 4 * SQUISH_CONSTANT4
			if (c & 0x02) != 0:
				ysv_ext0 = ysb + 1
				ysv_ext1 = ysb + 1
				ysv_ext2 = ysb + 1
				dy_ext0 = dy0 - 1 - 4 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 1 - 4 * SQUISH_CONSTANT4
				dy_ext2 = dy0 - 1 - 4 * SQUISH_CONSTANT4
				if (c & 0x01) != 0:
					ysv_ext1 += 1
					dy_ext1 -= 1
				else:
					ysv_ext0 += 1
					dy_ext0 -= 1
			else:
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				ysv_ext2 = ysb
				dy_ext0 = dy0 - 4 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 4 * SQUISH_CONSTANT4
				dy_ext2 = dy0 - 4 * SQUISH_CONSTANT4
			if (c & 0x04) != 0:
				zsv_ext0 = zsb + 1
				zsv_ext1 = zsb + 1
				zsv_ext2 = zsb + 1
				dz_ext0 = dz0 - 1 - 4 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 1 - 4 * SQUISH_CONSTANT4
				dz_ext2 = dz0 - 1 - 4 * SQUISH_CONSTANT4
				if (c & 0x03) != 0x03:
					if (c & 0x03) == 0:
						zsv_ext0 += 1
						dz_ext0 -= 1
					else:
						zsv_ext1 += 1
						dz_ext1 -= 1
				else:
					zsv_ext2 += 1
					dz_ext2 -= 1
			else:
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				zsv_ext2 = zsb
				dz_ext0 = dz0 - 4 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 4 * SQUISH_CONSTANT4
				dz_ext2 = dz0 - 4 * SQUISH_CONSTANT4
			if (c & 0x08) != 0:
				wsv_ext0 = wsb + 1
				wsv_ext1 = wsb + 1
				wsv_ext2 = wsb + 2
				dw_ext0 = dw0 - 1 - 4 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 1 - 4 * SQUISH_CONSTANT4
				dw_ext2 = dw0 - 2 - 4 * SQUISH_CONSTANT4
			else:
				wsv_ext0 = wsb
				wsv_ext1 = wsb
				wsv_ext2 = wsb
				dw_ext0 = dw0 - 4 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 4 * SQUISH_CONSTANT4
				dw_ext2 = dw0 - 4 * SQUISH_CONSTANT4
		else:  # (1,1,1,1) is not one of the closest two pentachoron vertices.
			c = a_po & b_po  # Our three extra vertices are determined by the closest two.
			if (c & 0x01) != 0:
				xsv_ext0 = xsb + 1
				xsv_ext2 = xsb + 1
				xsv_ext1 = xsb + 2
				dx_ext0 = dx0 - 1 - 2 * SQUISH_CONSTANT4
				dx_ext1 = dx0 - 2 - 3 * SQUISH_CONSTANT4
				dx_ext2 = dx0 - 1 - 3 * SQUISH_CONSTANT4
			else:
				xsv_ext0 = xsb
				xsv_ext1 = xsb
				xsv_ext2 = xsb
				dx_ext0 = dx0 - 2 * SQUISH_CONSTANT4
				dx_ext1 = dx0 - 3 * SQUISH_CONSTANT4
				dx_ext2 = dx0 - 3 * SQUISH_CONSTANT4
			if (c & 0x02) != 0:
				ysv_ext0 = ysb + 1
				ysv_ext1 = ysb + 1
				ysv_ext2 = ysb + 1
				dy_ext0 = dy0 - 1 - 2 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 1 - 3 * SQUISH_CONSTANT4
				dy_ext2 = dy0 - 1 - 3 * SQUISH_CONSTANT4
				if (c & 0x01) != 0:
					ysv_ext2 += 1
					dy_ext2 -= 1
				else:
					ysv_ext1 += 1
					dy_ext1 -= 1
			else:
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				ysv_ext2 = ysb
				dy_ext0 = dy0 - 2 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 3 * SQUISH_CONSTANT4
				dy_ext2 = dy0 - 3 * SQUISH_CONSTANT4
			if (c & 0x04) != 0:
				zsv_ext0 = zsb + 1
				zsv_ext1 = zsb + 1
				zsv_ext2 = zsb + 1
				dz_ext0 = dz0 - 1 - 2 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 1 - 3 * SQUISH_CONSTANT4
				dz_ext2 = dz0 - 1 - 3 * SQUISH_CONSTANT4
				if (c & 0x03) != 0:
					zsv_ext2 += 1
					dz_ext2 -= 1
				else:
					zsv_ext1 += 1
					dz_ext1 -= 1
			else:
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				zsv_ext2 = zsb
				dz_ext0 = dz0 - 2 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 3 * SQUISH_CONSTANT4
				dz_ext2 = dz0 - 3 * SQUISH_CONSTANT4
			if (c & 0x08) != 0:
				wsv_ext0 = wsb + 1
				wsv_ext1 = wsb + 1
				wsv_ext2 = wsb + 2
				dw_ext0 = dw0 - 1 - 2 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 1 - 3 * SQUISH_CONSTANT4
				dw_ext2 = dw0 - 2 - 3 * SQUISH_CONSTANT4
			else:
				wsv_ext0 = wsb
				wsv_ext1 = wsb
				wsv_ext2 = wsb
				dw_ext0 = dw0 - 2 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 3 * SQUISH_CONSTANT4
				dw_ext2 = dw0 - 3 * SQUISH_CONSTANT4
		# Contribution (1,1,1,0)
		dx4 = dx0 - 1 - 3 * SQUISH_CONSTANT4
		dy4 = dy0 - 1 - 3 * SQUISH_CONSTANT4
		dz4 = dz0 - 1 - 3 * SQUISH_CONSTANT4
		dw4 = dw0 - 3 * SQUISH_CONSTANT4
		attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
		if attn4 > 0:
			attn4 *= attn4
			value += attn4 * attn4 * extrapolate4(xsb + 1, ysb + 1, zsb + 1, wsb + 0, dx4, dy4, dz4, dw4)
		# Contribution (1,1,0,1)
		dx3 = dx4
		dy3 = dy4
		dz3 = dz0 - 3 * SQUISH_CONSTANT4
		dw3 = dw0 - 1 - 3 * SQUISH_CONSTANT4
		attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
		if attn3 > 0:
			attn3 *= attn3
			value += attn3 * attn3 * extrapolate4(xsb + 1, ysb + 1, zsb + 0, wsb + 1, dx3, dy3, dz3, dw3)
		# Contribution (1,0,1,1)
		dx2 = dx4
		dy2 = dy0 - 3 * SQUISH_CONSTANT4
		dz2 = dz4
		dw2 = dw3
		attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
		if attn2 > 0:
			attn2 *= attn2
			value += attn2 * attn2 * extrapolate4(xsb + 1, ysb + 0, zsb + 1, wsb + 1, dx2, dy2, dz2, dw2)
		# Contribution (0,1,1,1)
		dx1 = dx0 - 3 * SQUISH_CONSTANT4
		dz1 = dz4
		dy1 = dy4
		dw1 = dw3
		attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
		if attn1 > 0:
			attn1 *= attn1
			value += attn1 * attn1 * extrapolate4(xsb + 0, ysb + 1, zsb + 1, wsb + 1, dx1, dy1, dz1, dw1)
		# Contribution (1,1,1,1)
		dx0 = dx0 - 1 - 4 * SQUISH_CONSTANT4
		dy0 = dy0 - 1 - 4 * SQUISH_CONSTANT4
		dz0 = dz0 - 1 - 4 * SQUISH_CONSTANT4
		dw0 = dw0 - 1 - 4 * SQUISH_CONSTANT4
		attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0 - dw0 * dw0
		if attn0 > 0:
			attn0 *= attn0
			value += attn0 * attn0 * extrapolate4(xsb + 1, ysb + 1, zsb + 1, wsb + 1, dx0, dy0, dz0, dw0)
	elif in_sum <= 2: # We're inside the first dispentachoron (Rectified 4-Simplex)
		a_is_bigger_side = true
		b_is_bigger_side = true
		a_po = 0x0E
		a_score = xins
		b_po = 0x0D
		b_score = yins
		# Decide between (1,1,0,0) and (0,0,1,1)
		if xins + yins > zins + wins:
			a_score = xins + yins
			a_po = 0x03
		else:
			a_score = zins + wins
			a_po = 0x0C
		# Decide between (1,0,1,0) and (0,1,0,1)
		if xins + zins > yins + wins:
			b_score = xins + zins
			b_po = 0x05
		else:
			b_score = yins + wins
			b_po = 0x0A
		# Closer between (1,0,0,1) and (0,1,1,0) will replace the further of a and b, if closer.
		if xins + wins > yins + zins:
			score = xins + wins
			if a_score >= b_score and score > b_score:
				b_score = score
				b_po = 0x09
			elif a_score < b_score and score > a_score:
				a_score = score
				a_po = 0x09
		else:
			score = yins + zins
			if a_score >= b_score and score > b_score:
				b_score = score
				b_po = 0x06
			elif a_score < b_score and score > a_score:
				a_score = score
				a_po = 0x06
		# Decide if (1,0,0,0) is closer.
		p1 = 2 - in_sum + xins
		if a_score >= b_score and p1 > b_score:
			b_score = p1
			b_po = 0x01
			b_is_bigger_side = false
		elif a_score < b_score and p1 > a_score:
			a_score = p1
			a_po = 0x01
			a_is_bigger_side = false
		# Decide if (0,1,0,0) is closer.
		p2 = 2 - in_sum + yins
		if a_score >= b_score and p2 > b_score:
			b_score = p2
			b_po = 0x02
			b_is_bigger_side = false
		elif a_score < b_score and p2 > a_score:
			a_score = p2
			a_po = 0x02
			a_is_bigger_side = false
		# Decide if (0,0,1,0) is closer.
		p3 = 2 - in_sum + zins
		if a_score >= b_score and p3 > b_score:
			b_score = p3
			b_po = 0x04
			b_is_bigger_side = false
		elif a_score < b_score and p3 > a_score:
			a_score = p3
			a_po = 0x04
			a_is_bigger_side = false
		# Decide if (0,0,0,1) is closer.
		p4 = 2 - in_sum + wins
		if a_score >= b_score and p4 > b_score:
			b_po = 0x08
			b_is_bigger_side = false
		elif a_score < b_score and p4 > a_score:
			a_po = 0x08
			a_is_bigger_side = false
		# Where each of the two closest pos are determines how the extra three vertices are calculated.
		if a_is_bigger_side == b_is_bigger_side:
			if a_is_bigger_side:  # Both closest pos on the bigger side
				c1 = a_po | b_po
				c2 = a_po & b_po
				if (c1 & 0x01) == 0:
					xsv_ext0 = xsb
					xsv_ext1 = xsb - 1
					dx_ext0 = dx0 - 3 * SQUISH_CONSTANT4
					dx_ext1 = dx0 + 1 - 2 * SQUISH_CONSTANT4
				else:
					xsv_ext0 = xsb + 1
					xsv_ext1 = xsb + 1
					dx_ext0 = dx0 - 1 - 3 * SQUISH_CONSTANT4
					dx_ext1 = dx0 - 1 - 2 * SQUISH_CONSTANT4
				if (c1 & 0x02) == 0:
					ysv_ext0 = ysb
					ysv_ext1 = ysb - 1
					dy_ext0 = dy0 - 3 * SQUISH_CONSTANT4
					dy_ext1 = dy0 + 1 - 2 * SQUISH_CONSTANT4
				else:
					ysv_ext0 = ysb + 1
					ysv_ext1 = ysb + 1
					dy_ext0 = dy0 - 1 - 3 * SQUISH_CONSTANT4
					dy_ext1 = dy0 - 1 - 2 * SQUISH_CONSTANT4
				if (c1 & 0x04) == 0:
					zsv_ext0 = zsb
					zsv_ext1 = zsb - 1
					dz_ext0 = dz0 - 3 * SQUISH_CONSTANT4
					dz_ext1 = dz0 + 1 - 2 * SQUISH_CONSTANT4
				else:
					zsv_ext0 = zsb + 1
					zsv_ext1 = zsb + 1
					dz_ext0 = dz0 - 1 - 3 * SQUISH_CONSTANT4
					dz_ext1 = dz0 - 1 - 2 * SQUISH_CONSTANT4
				if (c1 & 0x08) == 0:
					wsv_ext0 = wsb
					wsv_ext1 = wsb - 1
					dw_ext0 = dw0 - 3 * SQUISH_CONSTANT4
					dw_ext1 = dw0 + 1 - 2 * SQUISH_CONSTANT4
				else:
					wsv_ext0 = wsb + 1
					wsv_ext1 = wsb + 1
					dw_ext0 = dw0 - 1 - 3 * SQUISH_CONSTANT4
					dw_ext1 = dw0 - 1 - 2 * SQUISH_CONSTANT4
				# One combination is a _permutation of (0,0,0,2) based on c2
				xsv_ext2 = xsb
				ysv_ext2 = ysb
				zsv_ext2 = zsb
				wsv_ext2 = wsb
				dx_ext2 = dx0 - 2 * SQUISH_CONSTANT4
				dy_ext2 = dy0 - 2 * SQUISH_CONSTANT4
				dz_ext2 = dz0 - 2 * SQUISH_CONSTANT4
				dw_ext2 = dw0 - 2 * SQUISH_CONSTANT4
				if (c2 & 0x01) != 0:
					xsv_ext2 += 2
					dx_ext2 -= 2
				elif (c2 & 0x02) != 0:
					ysv_ext2 += 2
					dy_ext2 -= 2
				elif (c2 & 0x04) != 0:
					zsv_ext2 += 2
					dz_ext2 -= 2
				else:
					wsv_ext2 += 2
					dw_ext2 -= 2
			else:  # Both closest pos on the smaller side
				# One of the two extra pos is (0,0,0,0)
				xsv_ext2 = xsb
				ysv_ext2 = ysb
				zsv_ext2 = zsb
				wsv_ext2 = wsb
				dx_ext2 = dx0
				dy_ext2 = dy0
				dz_ext2 = dz0
				dw_ext2 = dw0
				# Other two pos are based on the omitted axes.
				c = a_po | b_po
				if (c & 0x01) == 0:
					xsv_ext0 = xsb - 1
					xsv_ext1 = xsb
					dx_ext0 = dx0 + 1 - SQUISH_CONSTANT4
					dx_ext1 = dx0 - SQUISH_CONSTANT4
				else:
					xsv_ext0 = xsb + 1
					xsv_ext1 = xsb + 1
					dx_ext0 = dx0 - 1 - SQUISH_CONSTANT4
					dx_ext1 = dx0 - 1 - SQUISH_CONSTANT4
				if (c & 0x02) == 0:
					ysv_ext0 = ysb 
					ysv_ext1 = ysb
					dy_ext0 = dy0 - SQUISH_CONSTANT4
					dy_ext1 = dy0 - SQUISH_CONSTANT4
					if (c & 0x01) == 0x01:
						ysv_ext0 -= 1
						dy_ext0 += 1
					else:
						ysv_ext1 -= 1
						dy_ext1 += 1
				else:
					ysv_ext0 = ysb + 1
					ysv_ext1 = ysb + 1
					dy_ext0 = dy0 - 1 - SQUISH_CONSTANT4
					dy_ext1 = dy0 - 1 - SQUISH_CONSTANT4
				if (c & 0x04) == 0:
					zsv_ext0 = zsb
					zsv_ext1 = zsb
					dz_ext0 = dz0 - SQUISH_CONSTANT4
					dz_ext1 = dz0 - SQUISH_CONSTANT4
					if (c & 0x03) == 0x03:
						zsv_ext0 -= 1
						dz_ext0 += 1
					else:
						zsv_ext1 -= 1
						dz_ext1 += 1
				else:
					zsv_ext0 = zsb + 1
					zsv_ext1 = zsb + 1
					dz_ext0 = dz0 - 1 - SQUISH_CONSTANT4
					dz_ext1 = dz0 - 1 - SQUISH_CONSTANT4
				if (c & 0x08) == 0:
					wsv_ext0 = wsb
					wsv_ext1 = wsb - 1
					dw_ext0 = dw0 - SQUISH_CONSTANT4
					dw_ext1 = dw0 + 1 - SQUISH_CONSTANT4
				else:
					wsv_ext0 = wsb + 1
					wsv_ext1 = wsb + 1
					dw_ext0 = dw0 - 1 - SQUISH_CONSTANT4
					dw_ext1 = dw0 - 1 - SQUISH_CONSTANT4
		else: # One po on each "side"
			if a_is_bigger_side:
				c1 = a_po
				c2 = b_po
			else:
				c1 = b_po
				c2 = a_po
			# Two contributions are the bigger-sided po with each 0 replaced with -1.
			if (c1 & 0x01) == 0:
				xsv_ext0 = xsb - 1
				xsv_ext1 = xsb
				dx_ext0 = dx0 + 1 - SQUISH_CONSTANT4
				dx_ext1 = dx0 - SQUISH_CONSTANT4
			else:
				xsv_ext0 = xsb + 1
				xsv_ext1 = xsb + 1
				dx_ext0 = dx0 - 1 - SQUISH_CONSTANT4
				dx_ext1 = dx0 - 1 - SQUISH_CONSTANT4
			if (c1 & 0x02) == 0:
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				dy_ext0 = dy0 - SQUISH_CONSTANT4
				dy_ext1 = dy0 - SQUISH_CONSTANT4
				if (c1 & 0x01) == 0x01:
					ysv_ext0 -= 1
					dy_ext0 += 1
				else:
					ysv_ext1 -= 1
					dy_ext1 += 1
			else:
				ysv_ext0 = ysb + 1
				ysv_ext1 = ysb + 1
				dy_ext0 = dy0 - 1 - SQUISH_CONSTANT4
				dy_ext1 = dy0 - 1 - SQUISH_CONSTANT4
			if (c1 & 0x04) == 0:
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				dz_ext0 = dz0 - SQUISH_CONSTANT4
				dz_ext1 = dz0 - SQUISH_CONSTANT4
				if (c1 & 0x03) == 0x03:
					zsv_ext0 -= 1
					dz_ext0 += 1
				else:
					zsv_ext1 -= 1
					dz_ext1 += 1
			else:
				zsv_ext0 = zsb + 1
				zsv_ext1 = zsb + 1
				dz_ext0 = dz0 - 1 - SQUISH_CONSTANT4
				dz_ext1 = dz0 - 1 - SQUISH_CONSTANT4
			if (c1 & 0x08) == 0:
				wsv_ext0 = wsb
				wsv_ext1 = wsb - 1
				dw_ext0 = dw0 - SQUISH_CONSTANT4
				dw_ext1 = dw0 + 1 - SQUISH_CONSTANT4
			else:
				wsv_ext0 = wsb + 1
				wsv_ext1 = wsb + 1
				dw_ext0 = dw0 - 1 - SQUISH_CONSTANT4
				dw_ext1 = dw0 - 1 - SQUISH_CONSTANT4
			# One contribution is a _permutation of (0,0,0,2) based on the smaller-sided po
			xsv_ext2 = xsb
			ysv_ext2 = ysb
			zsv_ext2 = zsb
			wsv_ext2 = wsb
			dx_ext2 = dx0 - 2 * SQUISH_CONSTANT4
			dy_ext2 = dy0 - 2 * SQUISH_CONSTANT4
			dz_ext2 = dz0 - 2 * SQUISH_CONSTANT4
			dw_ext2 = dw0 - 2 * SQUISH_CONSTANT4
			if (c2 & 0x01) != 0:
				xsv_ext2 += 2
				dx_ext2 -= 2
			elif (c2 & 0x02) != 0:
				ysv_ext2 += 2
				dy_ext2 -= 2
			elif (c2 & 0x04) != 0:
				zsv_ext2 += 2
				dz_ext2 -= 2
			else:
				wsv_ext2 += 2
				dw_ext2 -= 2
		# Contribution (1,0,0,0)
		dx1 = dx0 - 1 - SQUISH_CONSTANT4
		dy1 = dy0 - 0 - SQUISH_CONSTANT4
		dz1 = dz0 - 0 - SQUISH_CONSTANT4
		dw1 = dw0 - 0 - SQUISH_CONSTANT4
		attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
		if attn1 > 0:
			attn1 *= attn1
			value += attn1 * attn1 * extrapolate4(xsb + 1, ysb + 0, zsb + 0, wsb + 0, dx1, dy1, dz1, dw1)
		# Contribution (0,1,0,0)
		dx2 = dx0 - 0 - SQUISH_CONSTANT4
		dy2 = dy0 - 1 - SQUISH_CONSTANT4
		dz2 = dz1
		dw2 = dw1
		attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
		if attn2 > 0:
			attn2 *= attn2
			value += attn2 * attn2 * extrapolate4(xsb + 0, ysb + 1, zsb + 0, wsb + 0, dx2, dy2, dz2, dw2)
		# Contribution (0,0,1,0)
		dx3 = dx2
		dy3 = dy1
		dz3 = dz0 - 1 - SQUISH_CONSTANT4
		dw3 = dw1
		attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
		if attn3 > 0:
			attn3 *= attn3
			value += attn3 * attn3 * extrapolate4(xsb + 0, ysb + 0, zsb + 1, wsb + 0, dx3, dy3, dz3, dw3)
		# Contribution (0,0,0,1)
		dx4 = dx2
		dy4 = dy1
		dz4 = dz1
		dw4 = dw0 - 1 - SQUISH_CONSTANT4
		attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
		if attn4 > 0:
			attn4 *= attn4
			value += attn4 * attn4 * extrapolate4(xsb + 0, ysb + 0, zsb + 0, wsb + 1, dx4, dy4, dz4, dw4)
		# Contribution (1,1,0,0)
		dx5 = dx0 - 1 - 2 * SQUISH_CONSTANT4
		dy5 = dy0 - 1 - 2 * SQUISH_CONSTANT4
		dz5 = dz0 - 0 - 2 * SQUISH_CONSTANT4
		dw5 = dw0 - 0 - 2 * SQUISH_CONSTANT4
		attn5 = 2 - dx5 * dx5 - dy5 * dy5 - dz5 * dz5 - dw5 * dw5
		if attn5 > 0:
			attn5 *= attn5
			value += attn5 * attn5 * extrapolate4(xsb + 1, ysb + 1, zsb + 0, wsb + 0, dx5, dy5, dz5, dw5)
		# Contribution (1,0,1,0)
		dx6 = dx0 - 1 - 2 * SQUISH_CONSTANT4
		dy6 = dy0 - 0 - 2 * SQUISH_CONSTANT4
		dz6 = dz0 - 1 - 2 * SQUISH_CONSTANT4
		dw6 = dw0 - 0 - 2 * SQUISH_CONSTANT4
		attn6 = 2 - dx6 * dx6 - dy6 * dy6 - dz6 * dz6 - dw6 * dw6
		if attn6 > 0:
			attn6 *= attn6
			value += attn6 * attn6 * extrapolate4(xsb + 1, ysb + 0, zsb + 1, wsb + 0, dx6, dy6, dz6, dw6)
		# Contribution (1,0,0,1)
		dx7 = dx0 - 1 - 2 * SQUISH_CONSTANT4
		dy7 = dy0 - 0 - 2 * SQUISH_CONSTANT4
		dz7 = dz0 - 0 - 2 * SQUISH_CONSTANT4
		dw7 = dw0 - 1 - 2 * SQUISH_CONSTANT4
		attn7 = 2 - dx7 * dx7 - dy7 * dy7 - dz7 * dz7 - dw7 * dw7
		if attn7 > 0:
			attn7 *= attn7
			value += attn7 * attn7 * extrapolate4(xsb + 1, ysb + 0, zsb + 0, wsb + 1, dx7, dy7, dz7, dw7)
		# Contribution (0,1,1,0)
		dx8 = dx0 - 0 - 2 * SQUISH_CONSTANT4
		dy8 = dy0 - 1 - 2 * SQUISH_CONSTANT4
		dz8 = dz0 - 1 - 2 * SQUISH_CONSTANT4
		dw8 = dw0 - 0 - 2 * SQUISH_CONSTANT4
		attn8 = 2 - dx8 * dx8 - dy8 * dy8 - dz8 * dz8 - dw8 * dw8
		if attn8 > 0:
			attn8 *= attn8
			value += attn8 * attn8 * extrapolate4(xsb + 0, ysb + 1, zsb + 1, wsb + 0, dx8, dy8, dz8, dw8)
		# Contribution (0,1,0,1)
		dx9 = dx0 - 0 - 2 * SQUISH_CONSTANT4
		dy9 = dy0 - 1 - 2 * SQUISH_CONSTANT4
		dz9 = dz0 - 0 - 2 * SQUISH_CONSTANT4
		dw9 = dw0 - 1 - 2 * SQUISH_CONSTANT4
		attn9 = 2 - dx9 * dx9 - dy9 * dy9 - dz9 * dz9 - dw9 * dw9
		if attn9 > 0:
			attn9 *= attn9
			value += attn9 * attn9 * extrapolate4(xsb + 0, ysb + 1, zsb + 0, wsb + 1, dx9, dy9, dz9, dw9)
		# Contribution (0,0,1,1)
		dx10 = dx0 - 0 - 2 * SQUISH_CONSTANT4
		dy10 = dy0 - 0 - 2 * SQUISH_CONSTANT4
		dz10 = dz0 - 1 - 2 * SQUISH_CONSTANT4
		dw10 = dw0 - 1 - 2 * SQUISH_CONSTANT4
		attn10 = 2 - dx10 * dx10 - dy10 * dy10 - dz10 * dz10 - dw10 * dw10
		if attn10 > 0:
			attn10 *= attn10
			value += attn10 * attn10 * extrapolate4(xsb + 0, ysb + 0, zsb + 1, wsb + 1, dx10, dy10, dz10, dw10)
	else:  # We're inside the second dispentachoron (Rectified 4-Simplex)
		a_is_bigger_side = true
		b_is_bigger_side = true
		# Decide between (0,0,1,1) and (1,1,0,0)
		if xins + yins < zins + wins:
			a_score = xins + yins
			a_po = 0x0C
		else:
			a_score = zins + wins
			a_po = 0x03
		# Decide between (0,1,0,1) and (1,0,1,0)
		if xins + zins < yins + wins:
			b_score = xins + zins
			b_po = 0x0A
		else:
			b_score = yins + wins
			b_po = 0x05
		# Closer between (0,1,1,0) and (1,0,0,1) will replace the further of a and b, if closer.
		if xins + wins < yins + zins:
			score = xins + wins
			if a_score <= b_score and score < b_score:
				b_score = score
				b_po = 0x06
			elif a_score > b_score and score < a_score:
				a_score = score
				a_po = 0x06
		else:
			score = yins + zins
			if a_score <= b_score and score < b_score:
				b_score = score
				b_po = 0x09
			elif a_score > b_score and score < a_score:
				a_score = score
				a_po = 0x09
		# Decide if (0,1,1,1) is closer.
		p1 = 3 - in_sum + xins
		if a_score <= b_score and p1 < b_score:
			b_score = p1
			b_po = 0x0E
			b_is_bigger_side = false
		elif a_score > b_score and p1 < a_score:
			a_score = p1
			a_po = 0x0E
			a_is_bigger_side = false
		# Decide if (1,0,1,1) is closer.
		p2 = 3 - in_sum + yins
		if a_score <= b_score and p2 < b_score:
			b_score = p2
			b_po = 0x0D
			b_is_bigger_side = false
		elif a_score > b_score and p2 < a_score:
			a_score = p2
			a_po = 0x0D
			a_is_bigger_side = false
		# Decide if (1,1,0,1) is closer.
		p3 = 3 - in_sum + zins
		if a_score <= b_score and p3 < b_score:
			b_score = p3
			b_po = 0x0B
			b_is_bigger_side = false
		elif a_score > b_score and p3 < a_score:
			a_score = p3
			a_po = 0x0B
			a_is_bigger_side = false
		# Decide if (1,1,1,0) is closer.
		p4 = 3 - in_sum + wins
		if a_score <= b_score and p4 < b_score:
			b_po = 0x07
			b_is_bigger_side = false
		elif a_score > b_score and p4 < a_score:
			a_po = 0x07
			a_is_bigger_side = false
		# Where each of the two closest pos are determines how the extra three vertices are calculated.
		if a_is_bigger_side == b_is_bigger_side:
			if a_is_bigger_side:  # Both closest pos on the bigger side
				c1 = a_po & b_po
				c2 = a_po | b_po
				# Two contributions are _permutations of (0,0,0,1) and (0,0,0,2) based on c1
				xsv_ext0 = xsb
				xsv_ext1 = xsb
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				wsv_ext0 = wsb
				wsv_ext1 = wsb
				dx_ext0 = dx0 - SQUISH_CONSTANT4
				dy_ext0 = dy0 - SQUISH_CONSTANT4
				dz_ext0 = dz0 - SQUISH_CONSTANT4
				dw_ext0 = dw0 - SQUISH_CONSTANT4
				dx_ext1 = dx0 - 2 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 2 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 2 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 2 * SQUISH_CONSTANT4
				if (c1 & 0x01) != 0:
					xsv_ext0 += 1
					dx_ext0 -= 1
					xsv_ext1 += 2
					dx_ext1 -= 2
				elif (c1 & 0x02) != 0:
					ysv_ext0 += 1
					dy_ext0 -= 1
					ysv_ext1 += 2
					dy_ext1 -= 2
				elif (c1 & 0x04) != 0:
					zsv_ext0 += 1
					dz_ext0 -= 1
					zsv_ext1 += 2
					dz_ext1 -= 2
				else:
					wsv_ext0 += 1
					dw_ext0 -= 1
					wsv_ext1 += 2
					dw_ext1 -= 2
				# One contribution is a _permutation of (1,1,1,-1) based on c2
				xsv_ext2 = xsb + 1
				ysv_ext2 = ysb + 1
				zsv_ext2 = zsb + 1
				wsv_ext2 = wsb + 1
				dx_ext2 = dx0 - 1 - 2 * SQUISH_CONSTANT4
				dy_ext2 = dy0 - 1 - 2 * SQUISH_CONSTANT4
				dz_ext2 = dz0 - 1 - 2 * SQUISH_CONSTANT4
				dw_ext2 = dw0 - 1 - 2 * SQUISH_CONSTANT4
				if (c2 & 0x01) == 0:
					xsv_ext2 -= 2
					dx_ext2 += 2
				elif (c2 & 0x02) == 0:
					ysv_ext2 -= 2
					dy_ext2 += 2
				elif (c2 & 0x04) == 0:
					zsv_ext2 -= 2
					dz_ext2 += 2
				else:
					wsv_ext2 -= 2
					dw_ext2 += 2
			else:  # Both closest pos on the smaller side
				xsv_ext0 = xsb
				xsv_ext1 = xsb
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				wsv_ext0 = wsb
				wsv_ext1 = wsb
				dx_ext0 = dx0 - SQUISH_CONSTANT4
				dy_ext0 = dy0 - SQUISH_CONSTANT4
				dz_ext0 = dz0 - SQUISH_CONSTANT4
				dw_ext0 = dw0 - SQUISH_CONSTANT4
				dx_ext1 = dx0 - 2 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 2 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 2 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 2 * SQUISH_CONSTANT4
				# One of the two extra pos is (1,1,1,1)
				xsv_ext2 = xsb + 1
				ysv_ext2 = ysb + 1
				zsv_ext2 = zsb + 1
				wsv_ext2 = wsb + 1
				dx_ext2 = dx0 - 1 - 4 * SQUISH_CONSTANT4
				dy_ext2 = dy0 - 1 - 4 * SQUISH_CONSTANT4
				dz_ext2 = dz0 - 1 - 4 * SQUISH_CONSTANT4
				dw_ext2 = dw0 - 1 - 4 * SQUISH_CONSTANT4
				# Other two pos are based on the shared axes.
				c = a_po & b_po
				if (c & 0x01) != 0:
					xsv_ext0 = xsb + 2
					xsv_ext1 = xsb + 1
					dx_ext0 = dx0 - 2 - 3 * SQUISH_CONSTANT4
					dx_ext1 = dx0 - 1 - 3 * SQUISH_CONSTANT4
				else:
					xsv_ext0 = xsb
					xsv_ext1 = xsb
					dx_ext0 = dx0 - 3 * SQUISH_CONSTANT4
					dx_ext1 = dx0 - 3 * SQUISH_CONSTANT4
				if (c & 0x02) != 0:
					ysv_ext0 = ysb + 1
					ysv_ext1 = ysb + 1
					dy_ext0 = dy0 - 1 - 3 * SQUISH_CONSTANT4
					dy_ext1 = dy0 - 1 - 3 * SQUISH_CONSTANT4
					if (c & 0x01) == 0:
						ysv_ext0 += 1
						dy_ext0 -= 1
					else:
						ysv_ext1 += 1
						dy_ext1 -= 1
				else:
					ysv_ext0 = ysb
					ysv_ext1 = ysb
					dy_ext0 = dy0 - 3 * SQUISH_CONSTANT4
					dy_ext1 = dy0 - 3 * SQUISH_CONSTANT4
				if (c & 0x04) != 0:
					zsv_ext0 = zsb + 1
					zsv_ext1 = zsb + 1
					dz_ext0 = dz0 - 1 - 3 * SQUISH_CONSTANT4
					dz_ext1 = dz0 - 1 - 3 * SQUISH_CONSTANT4
					if (c & 0x03) == 0:
						zsv_ext0 += 1
						dz_ext0 -= 1
					else:
						zsv_ext1 += 1
						dz_ext1 -= 1
				else:
					zsv_ext0 = zsb
					zsv_ext1 = zsb
					dz_ext0 = dz0 - 3 * SQUISH_CONSTANT4
					dz_ext1 = dz0 - 3 * SQUISH_CONSTANT4
				if (c & 0x08) != 0:
					wsv_ext0 = wsb + 1
					wsv_ext1 = wsb + 2
					dw_ext0 = dw0 - 1 - 3 * SQUISH_CONSTANT4
					dw_ext1 = dw0 - 2 - 3 * SQUISH_CONSTANT4
				else:
					wsv_ext0 = wsb
					wsv_ext1 = wsb
					dw_ext0 = dw0 - 3 * SQUISH_CONSTANT4
					dw_ext1 = dw0 - 3 * SQUISH_CONSTANT4
		else:  # One po on each "side"
			if a_is_bigger_side:
				c1 = a_po
				c2 = b_po
			else:
				c1 = b_po
				c2 = a_po
			# Two contributions are the bigger-sided po with each 1 replaced with 2.
			if (c1 & 0x01) != 0:
				xsv_ext0 = xsb + 2
				xsv_ext1 = xsb + 1
				dx_ext0 = dx0 - 2 - 3 * SQUISH_CONSTANT4
				dx_ext1 = dx0 - 1 - 3 * SQUISH_CONSTANT4
			else:
				xsv_ext0 = xsb
				xsv_ext1 = xsb
				dx_ext0 = dx0 - 3 * SQUISH_CONSTANT4
				dx_ext1 = dx0 - 3 * SQUISH_CONSTANT4
			if (c1 & 0x02) != 0:
				ysv_ext0 = ysb + 1
				ysv_ext1 = ysb + 1
				dy_ext0 = dy0 - 1 - 3 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 1 - 3 * SQUISH_CONSTANT4
				if (c1 & 0x01) == 0:
					ysv_ext0 += 1
					dy_ext0 -= 1
				else:
					ysv_ext1 += 1
					dy_ext1 -= 1
			else:
				ysv_ext0 = ysb
				ysv_ext1 = ysb
				dy_ext0 = dy0 - 3 * SQUISH_CONSTANT4
				dy_ext1 = dy0 - 3 * SQUISH_CONSTANT4
			if (c1 & 0x04) != 0:
				zsv_ext0 = zsb + 1
				zsv_ext1 = zsb + 1
				dz_ext0 = dz0 - 1 - 3 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 1 - 3 * SQUISH_CONSTANT4
				if (c1 & 0x03) == 0:
					zsv_ext0 += 1
					dz_ext0 -= 1
				else:
					zsv_ext1 += 1
					dz_ext1 -= 1
			else:
				zsv_ext0 = zsb
				zsv_ext1 = zsb
				dz_ext0 = dz0 - 3 * SQUISH_CONSTANT4
				dz_ext1 = dz0 - 3 * SQUISH_CONSTANT4
			if (c1 & 0x08) != 0:
				wsv_ext0 = wsb + 1
				wsv_ext1 = wsb + 2
				dw_ext0 = dw0 - 1 - 3 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 2 - 3 * SQUISH_CONSTANT4
			else:
				wsv_ext0 = wsb
				wsv_ext1 = wsb
				dw_ext0 = dw0 - 3 * SQUISH_CONSTANT4
				dw_ext1 = dw0 - 3 * SQUISH_CONSTANT4
			# One contribution is a _permutation of (1,1,1,-1) based on the smaller-sided po
			xsv_ext2 = xsb + 1
			ysv_ext2 = ysb + 1
			zsv_ext2 = zsb + 1
			wsv_ext2 = wsb + 1
			dx_ext2 = dx0 - 1 - 2 * SQUISH_CONSTANT4
			dy_ext2 = dy0 - 1 - 2 * SQUISH_CONSTANT4
			dz_ext2 = dz0 - 1 - 2 * SQUISH_CONSTANT4
			dw_ext2 = dw0 - 1 - 2 * SQUISH_CONSTANT4
			if (c2 & 0x01) == 0:
				xsv_ext2 -= 2
				dx_ext2 += 2
			elif (c2 & 0x02) == 0:
				ysv_ext2 -= 2
				dy_ext2 += 2
			elif (c2 & 0x04) == 0:
				zsv_ext2 -= 2
				dz_ext2 += 2
			else:
				wsv_ext2 -= 2
				dw_ext2 += 2
		# Contribution (1,1,1,0)
		dx4 = dx0 - 1 - 3 * SQUISH_CONSTANT4
		dy4 = dy0 - 1 - 3 * SQUISH_CONSTANT4
		dz4 = dz0 - 1 - 3 * SQUISH_CONSTANT4
		dw4 = dw0 - 3 * SQUISH_CONSTANT4
		attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
		if attn4 > 0:
			attn4 *= attn4
			value += attn4 * attn4 * extrapolate4(xsb + 1, ysb + 1, zsb + 1, wsb + 0, dx4, dy4, dz4, dw4)
		# Contribution (1,1,0,1)
		dx3 = dx4
		dy3 = dy4
		dz3 = dz0 - 3 * SQUISH_CONSTANT4
		dw3 = dw0 - 1 - 3 * SQUISH_CONSTANT4
		attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
		if attn3 > 0:
			attn3 *= attn3
			value += attn3 * attn3 * extrapolate4(xsb + 1, ysb + 1, zsb + 0, wsb + 1, dx3, dy3, dz3, dw3)
		# Contribution (1,0,1,1)
		dx2 = dx4
		dy2 = dy0 - 3 * SQUISH_CONSTANT4
		dz2 = dz4
		dw2 = dw3
		attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
		if attn2 > 0:
			attn2 *= attn2
			value += attn2 * attn2 * extrapolate4(xsb + 1, ysb + 0, zsb + 1, wsb + 1, dx2, dy2, dz2, dw2)
		# Contribution (0,1,1,1)
		dx1 = dx0 - 3 * SQUISH_CONSTANT4
		dz1 = dz4
		dy1 = dy4
		dw1 = dw3
		attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
		if attn1 > 0:
			attn1 *= attn1
			value += attn1 * attn1 * extrapolate4(xsb + 0, ysb + 1, zsb + 1, wsb + 1, dx1, dy1, dz1, dw1)
		# Contribution (1,1,0,0)
		dx5 = dx0 - 1 - 2 * SQUISH_CONSTANT4
		dy5 = dy0 - 1 - 2 * SQUISH_CONSTANT4
		dz5 = dz0 - 0 - 2 * SQUISH_CONSTANT4
		dw5 = dw0 - 0 - 2 * SQUISH_CONSTANT4
		attn5 = 2 - dx5 * dx5 - dy5 * dy5 - dz5 * dz5 - dw5 * dw5
		if attn5 > 0:
			attn5 *= attn5
			value += attn5 * attn5 * extrapolate4(xsb + 1, ysb + 1, zsb + 0, wsb + 0, dx5, dy5, dz5, dw5)
		# Contribution (1,0,1,0)
		dx6 = dx0 - 1 - 2 * SQUISH_CONSTANT4
		dy6 = dy0 - 0 - 2 * SQUISH_CONSTANT4
		dz6 = dz0 - 1 - 2 * SQUISH_CONSTANT4
		dw6 = dw0 - 0 - 2 * SQUISH_CONSTANT4
		attn6 = 2 - dx6 * dx6 - dy6 * dy6 - dz6 * dz6 - dw6 * dw6
		if attn6 > 0:
			attn6 *= attn6
			value += attn6 * attn6 * extrapolate4(xsb + 1, ysb + 0, zsb + 1, wsb + 0, dx6, dy6, dz6, dw6)
		# Contribution (1,0,0,1)
		dx7 = dx0 - 1 - 2 * SQUISH_CONSTANT4
		dy7 = dy0 - 0 - 2 * SQUISH_CONSTANT4
		dz7 = dz0 - 0 - 2 * SQUISH_CONSTANT4
		dw7 = dw0 - 1 - 2 * SQUISH_CONSTANT4
		attn7 = 2 - dx7 * dx7 - dy7 * dy7 - dz7 * dz7 - dw7 * dw7
		if attn7 > 0:
			attn7 *= attn7
			value += attn7 * attn7 * extrapolate4(xsb + 1, ysb + 0, zsb + 0, wsb + 1, dx7, dy7, dz7, dw7)
		# Contribution (0,1,1,0)
		dx8 = dx0 - 0 - 2 * SQUISH_CONSTANT4
		dy8 = dy0 - 1 - 2 * SQUISH_CONSTANT4
		dz8 = dz0 - 1 - 2 * SQUISH_CONSTANT4
		dw8 = dw0 - 0 - 2 * SQUISH_CONSTANT4
		attn8 = 2 - dx8 * dx8 - dy8 * dy8 - dz8 * dz8 - dw8 * dw8
		if attn8 > 0:
			attn8 *= attn8
			value += attn8 * attn8 * extrapolate4(xsb + 0, ysb + 1, zsb + 1, wsb + 0, dx8, dy8, dz8, dw8)
		# Contribution (0,1,0,1)
		dx9 = dx0 - 0 - 2 * SQUISH_CONSTANT4
		dy9 = dy0 - 1 - 2 * SQUISH_CONSTANT4
		dz9 = dz0 - 0 - 2 * SQUISH_CONSTANT4
		dw9 = dw0 - 1 - 2 * SQUISH_CONSTANT4
		attn9 = 2 - dx9 * dx9 - dy9 * dy9 - dz9 * dz9 - dw9 * dw9
		if attn9 > 0:
			attn9 *= attn9
			value += attn9 * attn9 * extrapolate4(xsb + 0, ysb + 1, zsb + 0, wsb + 1, dx9, dy9, dz9, dw9)
		# Contribution (0,0,1,1)
		dx10 = dx0 - 0 - 2 * SQUISH_CONSTANT4
		dy10 = dy0 - 0 - 2 * SQUISH_CONSTANT4
		dz10 = dz0 - 1 - 2 * SQUISH_CONSTANT4
		dw10 = dw0 - 1 - 2 * SQUISH_CONSTANT4
		attn10 = 2 - dx10 * dx10 - dy10 * dy10 - dz10 * dz10 - dw10 * dw10
		if attn10 > 0:
			attn10 *= attn10
			value += attn10 * attn10 * extrapolate4(xsb + 0, ysb + 0, zsb + 1, wsb + 1, dx10, dy10, dz10, dw10)
	# First extra vertex
	attn_ext0 = 2 - dx_ext0 * dx_ext0 - dy_ext0 * dy_ext0 - dz_ext0 * dz_ext0 - dw_ext0 * dw_ext0
	if attn_ext0 > 0:
		attn_ext0 *= attn_ext0
		value += (
			attn_ext0
			* attn_ext0
			* extrapolate4(xsv_ext0, ysv_ext0, zsv_ext0, wsv_ext0, dx_ext0, dy_ext0, dz_ext0, dw_ext0)
		)
	# Second extra vertex
	attn_ext1 = 2 - dx_ext1 * dx_ext1 - dy_ext1 * dy_ext1 - dz_ext1 * dz_ext1 - dw_ext1 * dw_ext1
	if attn_ext1 > 0:
		attn_ext1 *= attn_ext1
		value += (
			attn_ext1
			* attn_ext1
			* extrapolate4(xsv_ext1, ysv_ext1, zsv_ext1, wsv_ext1, dx_ext1, dy_ext1, dz_ext1, dw_ext1)
		)
	# Third extra vertex
	attn_ext2 = 2 - dx_ext2 * dx_ext2 - dy_ext2 * dy_ext2 - dz_ext2 * dz_ext2 - dw_ext2 * dw_ext2
	if attn_ext2 > 0:
		attn_ext2 *= attn_ext2
		value += (
			attn_ext2
			* attn_ext2
			* extrapolate4(xsv_ext2, ysv_ext2, zsv_ext2, wsv_ext2, dx_ext2, dy_ext2, dz_ext2, dw_ext2)
		)
	return value / NORM_CONSTANT4
