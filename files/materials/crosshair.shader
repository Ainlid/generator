shader_type canvas_item;
render_mode unshaded;

uniform vec4 col : hint_color = vec4(1.0);

void fragment()
{
	vec2 uvs = UV;
	uvs -= vec2(0.5);
	uvs = abs(uvs);
	uvs = floor(uvs * 32.0) / 32.0;
	float tunnel = max(uvs.x, uvs.y);
	float anim = sin(TIME * 8.0) / 4.0;
	tunnel = tunnel * (2.0 + anim);
	tunnel = floor(tunnel * 2.0) / 2.0;
	tunnel = ceil(tunnel);
	COLOR.rgb = col.rgb;
	COLOR.a = tunnel;
}