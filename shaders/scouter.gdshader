shader_type canvas_item;

uniform float amount : hint_range(0.0,1.0) = 0.2;
uniform float speed = 1.0;
uniform vec4 color : source_color;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap; // why does this have to be so hard

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec4 tex = texture(SCREEN_TEXTURE, UV);

	float brightness = (tex.r + tex.g + tex.b) / 3.0;

	float n = mix(
		1.0,
		random(UV + TIME * speed),
		amount
	);

	COLOR = vec4(
		vec3(brightness * n),
		tex.a
	) * color;
}