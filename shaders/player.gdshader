shader_type canvas_item;

uniform vec3 targetColor = vec3(0.0, 1, 0.0);
uniform vec3 replacementColor = vec3(0, 0.5, 1);
uniform float tolerance : hint_range(0.0, 1.0) = 0.8;

void fragment() {
    vec4 texColor = texture(TEXTURE, UV);

    // Compute color difference
    float diff = distance(texColor.rgb, targetColor);

    // If within tolerance, replace with new color
    if (diff < tolerance) {
        texColor.rgb = replacementColor;
    }

    COLOR = texColor;
}

// Number of discrete brightness steps for toon shading.
uniform int TOON_STEPS_12 : hint_range(1, 8) = 2;

// Extra multiplier for color “amplification”.
uniform float COLOR_BOOST_5 : hint_range(0.0, 5.0) = 1;


// The light function modifies how each Light2D or DirectionalLight2D
// interacts with the fragment. This is where we create the toon effect.
void light() {
    // Dot product between the surface normal and the light direction
    float NdotL = max(dot(NORMAL, LIGHT_DIRECTION), 0.0);

    // Quantize (step) the dot product to produce discrete lighting bands.
    float stepSize = 1.0 / float(TOON_STEPS_12);
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
