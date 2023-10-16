shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D noise_texture : repeat_enable, filter_nearest;
uniform float time24 = 1.0;
uniform float static = 0.0;
uniform float fade = 1.0;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    vec4 color = textureLod(TEXTURE, UV, 0.0);
	//float randr = random(UV * vec2(time24 / 2.0 * (UV.x * 5.0), time24 / 2.0 * 13.0)) * max(1.0 - color.r * 1.2, 0.0);
	//float randg = random(UV * vec2(time24 / 2.0 * (UV.y * 5.0), time24 / 2.0 * 13.0)) * max(1.0 - color.r * 1.2, 0.0);
	//float randb = random(UV * vec2(time24 / 2.0 * (UV.x * 13.0), time24 / 2.0 * 7.0)) * max(1.0 - color.r * 1.2, 0.0);
	vec4 noise = textureLod(noise_texture, SCREEN_UV + vec2(sin(TIME / 10000.0) * 2.5, -mod(time24, 50.0)), 0.0);
	noise = noise * max(1.0 - color.r * 1.2, 0.0);
	vec4 col = color + vec4(min(noise.r, 0.5), min(noise.g, 0.5), min(noise.b, 0.5), color.a) * fade;
	
	float stat = random(UV * vec2(TIME, TIME * 13.0));
	stat *= 0.5;
	
	COLOR = col + vec4(stat, stat, stat, color.a * 0.5) * static; //+ vec4(randr, randg, randb, color.a);
}