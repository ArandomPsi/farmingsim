shader_type canvas_item;

uniform vec4 col : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float tolerance = 0.01;
uniform float transparency : hint_range(0.0, 1.0, 0.1) = 1.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (
		abs(tex.r - 1.0) < tolerance &&
		abs(tex.g - 1.0) < tolerance &&
		abs(tex.b - 1.0) < tolerance
	) {
		tex.rgb = col.rgb;
	}

	COLOR = tex * transparency;
}