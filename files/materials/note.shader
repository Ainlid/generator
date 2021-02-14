shader_type spatial;

uniform vec4 col : hint_color = vec4(1.0);
uniform float power = 1.0;

void fragment()
{
	EMISSION = mix(vec3(0.0), col.rgb, power);
}