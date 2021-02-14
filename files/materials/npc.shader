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
	float anim = sin(TIME * 2.0);
	anim /= 64.0;
	noise *= 1.0 - uvs.x + anim;
	noise *= 1.0 - uvs.y + anim;
	noise = floor(noise * 2.0) / 2.0;
	noise = ceil(noise);
	ALBEDO = col.rgb;
	float glow_anim = sin(TIME * 2.0) * 0.5 + 0.5;
	EMISSION = mix(vec3(0.0), col.rgb, glow_anim);
	ALPHA_SCISSOR = 0.5;
	ALPHA = noise;
}