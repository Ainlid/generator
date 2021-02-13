shader_type spatial;
render_mode cull_disabled;

uniform vec4 col : hint_color = vec4(1.0);
uniform vec2 seed = vec2(0.137, 0.519);

float hash(vec2 p) {
  return fract(sin(dot(p * 17.17, seed)) * 4791.9511);
}

void fragment()
{
	vec2 uvs = UV;
	uvs -= vec2(0.5);
	uvs = abs(uvs);
	uvs = floor(uvs * 32.0) / 32.0;
	float tunnel = 1.0 - max(uvs.x, uvs.y);
	tunnel = fract(tunnel * 8.0 - TIME);
	ALBEDO = col.rgb;
	ALPHA_SCISSOR = 0.5;
	ALPHA = tunnel;
}