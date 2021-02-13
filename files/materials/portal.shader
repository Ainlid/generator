shader_type spatial;
render_mode cull_disabled;

uniform vec4 col : hint_color = vec4(1.0);

void fragment()
{
	vec2 uvs = UV;
	uvs -= vec2(0.5);
	uvs = abs(uvs);
	uvs = floor(uvs * 32.0) / 32.0;
	float tunnel = 1.0 - max(uvs.x, uvs.y);
	float pattern = fract(tunnel * 8.0 - TIME);
	ALBEDO = col.rgb;
	ALPHA_SCISSOR = 0.5;
	ALPHA = pattern;
	float glow = pow(tunnel, 4.0);
	EMISSION = col.rgb * glow;
}