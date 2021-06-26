tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeGerstnerWaves


func _get_name():
	return "GerstnerWaves"


func _get_category():
	return "Displacement"


func _get_description():
	return "Generates Gerstner wave displacement vector and normal information"


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR


func _get_input_port_count():
	return 8


func _get_input_port_name(port):
	match port:
		0:
			return "time"
		1:
			return "wavelength"
		2:
			return "wave_vector"
		3:
			return "speed"
		4:
			return "amplitude"
		5:
			return "steepness"
		6:
			return "vertex"
		7:
			return "normal"



func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SCALAR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_VECTOR
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR
		4:
			return VisualShaderNode.PORT_TYPE_SCALAR
		5:
			return VisualShaderNode.PORT_TYPE_SCALAR
		6:
			return VisualShaderNode.PORT_TYPE_VECTOR
		7:
			return VisualShaderNode.PORT_TYPE_VECTOR



func _get_output_port_count():
	return 3


func _get_output_port_name(port):
	match port:
		0:
			return "vertex"
		1:
			return "normal"
		2:
			return "peak"

func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_global_code(mode):
	return """
		
		mat3 displace_normals(float t, float wl, vec3 wv, float ws, float amp, float steep, vec3 p, vec3 n) {
			
			float k = 2.0 * 3.14159 / wl;
			float a = steep / k;
			float c = sqrt(9.8 / k);
			vec2 wavec = normalize(vec2(wv.x, wv.z));
			float f = k * dot(wavec, p.xz) - c * t * ws;
			p.x += wavec.x * (a * cos(f));
			p.y += a * sin(f) * amp;
			p.z += wavec.y * (a * cos(f));
			
			vec3 tangent = vec3(
				1.0 - wavec.x * wavec.x * (steep * sin(f)),
				wavec.x * (steep * cos(f)),
				-wavec.x * wavec.y * (steep * sin(f))
			);
			
			vec3 binormal = vec3(
				-wavec.x * wavec.y * ( steep * sin(f)),
				wavec.y * (steep * cos(f)),
				1.0 - wavec.y * wavec.y * (steep * sin(f))
			);
			
			float peak = (sin(f) * a);
			
			vec3 norm = normalize(cross(binormal, tangent));
			vec3 normsum = normalize(n + norm);
			mat3 remat = mat3(p, normsum, vec3(peak, 0,0));
			return remat;
		}
	"""

func _get_code(input_vars, output_vars, mode, type):
	return  """
	mat3 disp = displace_normals(%s, %s, %s, %s, %s, %s, %s, %s);
	%s = disp[0];
	%s = disp[1];
	%s = disp[2].x;

	""" % [input_vars[0], input_vars[1], input_vars[2], input_vars[3], input_vars[4], input_vars[5], input_vars[6], input_vars[7], output_vars[0], output_vars[1], output_vars[2]]
		#/*%s = disp[1].xyz;*/
