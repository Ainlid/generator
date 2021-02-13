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
	uvs = floor(uvs * 24.0) / 24.0;
	float noise = hash(uvs);
	noise *= 1.0 - uvs.x;
	noise *= 1.0 - uvs.y;
	noise = floor(noise * 2.0) / 2.0;
	noise = ceil(noise);
	ALBEDO = col.rgb;
	ALPHA_SCISSOR = 0.5;
	ALPHA = noise;
}