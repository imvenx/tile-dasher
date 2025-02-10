shader_type canvas_item;

// The number on the final of the name variable is due to a godot bug that
// caches the varable name to a value so we need to change var name to fix this
// 4.3stable 01/2025 (V3r4)
uniform vec2 shadow_offset14 = vec2(-3.0, -3.0); // Shadow offset in pixels
uniform float shadow_opacity14 : hint_range(0.0, 1.0) = 0.3; // Shadow transparency

void fragment() {
    // Normalize shadow offset using screen space
    vec2 pixel_offset = shadow_offset14 * TEXTURE_PIXEL_SIZE;

    // Sample the original texture for the sprite
    vec4 original_color = texture(TEXTURE, UV);

    // Calculate shadow color by sampling neighboring pixels
    vec4 shadow_color = vec4(0.0);

    vec2 offset_uv = UV + (pixel_offset + vec2(0, 0) * TEXTURE_PIXEL_SIZE);
    shadow_color += texture(TEXTURE, offset_uv);

    // Apply shadow transparency
    shadow_color.rgb = vec3(0.0); // Black shadow
    shadow_color.a *= shadow_opacity14;

    // Combine shadow and original sprite
    vec4 final_color = mix(shadow_color, original_color, original_color.a);

    // Output the final color
    COLOR = final_color;
}
