shader_type canvas_item;

// Number of discrete brightness steps for toon shading.
uniform int TOON_STEPS_9 : hint_range(1, 8) = 2;

// Extra multiplier for color “amplification”.
uniform float COLOR_BOOST_5 : hint_range(0.0, 5.0) = 1;

// The usual fragment function if you need to do something in the color pass.
// If you don't need custom fragment code, you can omit it entirely.
void fragment() {
    // The base color pipeline, default pass.
    // In a typical sprite shader, you might do something like:
    // COLOR = texture(TEXTURE, UV) * COLOR;
    // but here, we'll just pass whatever the base color is for demonstration.

    // If you just want the final color from the light pass, you can also set:
    // render_mode light_only;
    // to see only the results of the toon shading in the light pass.
}

// The light function modifies how each Light2D or DirectionalLight2D
// interacts with the fragment. This is where we create the toon effect.
void light() {
    // Dot product between the surface normal and the light direction
    float NdotL = max(dot(NORMAL, LIGHT_DIRECTION), 0.0);

    // Quantize (step) the dot product to produce discrete lighting bands.
    float stepSize = 1.0 / float(TOON_STEPS_9);
    // We move NdotL into a range of [0, TOON_STEPS_9], floor it, then re-normalize.
    float toonValue = floor(NdotL / stepSize) * stepSize;

    // Combine all colors:
    // 1. COLOR (the base color from the fragment pass),
    // 2. LIGHT_COLOR (the color of the Light2D itself),
    // 3. LIGHT_ENERGY (the intensity of the Light2D).
    // 4. Multiply by the stepped toonValue and optional COLOR_BOOST_5.
    vec3 litColor = COLOR.rgb * LIGHT_COLOR.rgb * LIGHT_ENERGY * toonValue * COLOR_BOOST_5;

    // Assign the final light color.
    // LIGHT_COLOR.a is typically 1.0 (alpha for the Light2D).
    LIGHT = vec4(litColor, LIGHT_COLOR.a);
}
