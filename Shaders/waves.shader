shader_type spatial;

render_mode cull_disabled;

uniform float frequency = 1;
uniform float wavelength = 1;
uniform vec2 wave_vector = vec2(1,0);
uniform float wave_speed = 1;
uniform float amplitude = 1;
uniform float steepness = 1;

vec3 displacement()
{
	
	return vec3(0,0,0);
}

vec3 normal_calc()
{
	
	return vec3(0,0,0);
}

void vertex()
{
	float wl = 1.0 / frequency;
	vec3 p = VERTEX;
	float k = 2.0 * 3.14159 / wavelength;
	float a = steepness / k;
	float c = sqrt(9.8 / k);
	vec2 wavec = normalize(wave_vector);
	float f = k * dot(wavec, p.xz) - c * TIME * wave_speed;
	p.x += wavec.x * (a * cos(f));
	p.y += a * sin(f) * amplitude;
	p.z += wavec.y * (a * cos(f));
	
	
	vec3 tangent = vec3(
		1.0 - wavec.x * wavec.x * (steepness * sin(f)),
		wavec.x * (steepness * cos(f)),
		-wavec.x * wavec.y * (steepness * sin(f))
	);
	
	vec3 binormal = vec3(
		-wavec.x * wavec.y * ( steepness * sin(f)),
		wavec.y * (steepness * cos(f)),
		1.0 - wavec.y * wavec.y * (steepness * sin(f))
	);
	
	VERTEX = p;
	NORMAL += normalize(cross(binormal, tangent));
}

void fragment()
{
	
}