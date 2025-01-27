shader_type canvas_item;

uniform float wave_speed_6 : hint_range(0.0, 10.0) = 0.3;
uniform float wave_amplitude_5 : hint_range(0.0, 50.0) = 2;
uniform float wave_frequency_6 : hint_range(0.0, 50.0) = 5;

uniform vec4 lava_color_7 = vec4(0.8, 0.1, 0, 1.0); // Fiery red color
uniform float glow_intensity_5 : hint_range(0.0, 2.0) = 3.0;

void fragment() {
    vec2 uv = UV;

    // Add wave distortion
    float wave = sin(uv.y * wave_frequency_6 + TIME * wave_speed_6) * wave_amplitude_5;
    uv.x += wave / 100.0;

    // Sample the texture with distorted UV
    vec4 tex_color = texture(TEXTURE, uv);

    // Create localized glow effect
    float glow = sin(uv.x * 10.0 + uv.y * 10.0 + TIME * wave_speed_6 * 2.0) * 0.5 + 1.0;
    glow *= sin(uv.y * 5.0 + TIME * wave_speed_6) * 0.5 + 1.0; // Adds complexity to the glow
    vec4 glow_color = lava_color_7 * glow * glow_intensity_5;

    // Blend lava color with texture and force alpha to 1.0
    vec4 final_color = mix(tex_color, glow_color, 2);
    final_color.a = .8; // Ensure the alpha is always fully opaque

    COLOR = final_color;
}
