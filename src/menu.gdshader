// Based of:
// Starfield shader by Brian Smith (steampunkdemon.itch.io)
// MIT licence

shader_type canvas_item;

const vec2 texture_dimensions = vec2(1600.0, 900.0);
const vec2 star_dimensions = vec2(1.5, 1.5);
const float stars = 400.0;
const vec3 star_color = vec3(0.95, 0.9, 0.7);
const float base_scroll_speed = 50.0;
const float additional_scroll_speed = 15.0;
const float preprocess = base_scroll_speed * (base_scroll_speed - additional_scroll_speed) * 3.0;
const vec2 adjusted_star_dimensions = vec2(
	1.0 / texture_dimensions.x * star_dimensions.x,
	1.0 / texture_dimensions.y * star_dimensions.y * stars
);

float greater_than(float x, float y) {
	return max(sign(x - y), 0.0);
}

void fragment() {
	float random_value = fract(sin(dot(floor(UV * vec2(1.0, stars)), vec2(12.9898,78.233))) * 43758.5453123);
	float first = mod(UV.x + (preprocess + TIME) / (base_scroll_speed - random_value * additional_scroll_speed), 1.0);
	float second = fract(UV.y * stars);
	float base_target = greater_than(adjusted_star_dimensions.x, first) * greater_than(adjusted_star_dimensions.y, second);
	float target = random_value * base_target;
	COLOR.rgb = mix(COLOR.rgb, star_color, target);
}