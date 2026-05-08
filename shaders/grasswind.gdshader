shader_type canvas_item;

uniform float wind_dir_angle = 0.0;
uniform float wind_speed = 100.0;
uniform bool  use_wind_gusts = false;
uniform float patch_width_px = 300.0;
uniform float patch_height_px = 10.0;
uniform float pixel_size_px : hint_range(1.0, 64.0, 1.0) = 1.0;
uniform float rotation_degrees = -15.0;
uniform float threshold = 0.6;
uniform float opacity = 0.1;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x)
		 + (c - a) * u.y * (1.0 - u.x)
		 + (d - b) * u.x * u.y;
}

vec2 rotate(vec2 p, float angle_rad) {
	float c = cos(angle_rad);
	float s = sin(angle_rad);

	return vec2(
		p.x * c - p.y * s,
		p.x * s + p.y * c
	);
}

void fragment() {

	// WORLD SPACE POSITION
	vec2 p = world_pos;

	float wind_rad = radians(wind_dir_angle);
	vec2 wind_dir = -vec2(cos(wind_rad), sin(wind_rad));

	float wind_gust_speed = 1.0;
	float wind_gust_rate = 0.5;

	if (use_wind_gusts) {
		float phase = wind_gust_rate * TIME;

		float dist = wind_speed * TIME * (1.0 + 0.5 * wind_gust_speed)
				   - wind_speed * (0.5 * wind_gust_speed / wind_gust_rate)
					 * cos(phase);

		p += wind_dir * dist;
	} else {
		p += wind_dir * TIME * wind_speed;
	}

	float angle = radians(rotation_degrees);
	p = rotate(p, angle);

	p = floor(p / pixel_size_px) * pixel_size_px;

	float band = floor(p.y / patch_height_px);

	float x_noise = noise(vec2(p.x / patch_width_px, band * 0.25));
	float band_noise = hash(vec2(band, 19.0));
	float n = x_noise * 0.8 + band_noise * 0.2;

	float mask = step(threshold, n);

	vec4 base = texture(TEXTURE, UV) * COLOR;

	base.a *= mask * opacity;

	COLOR = base;
}