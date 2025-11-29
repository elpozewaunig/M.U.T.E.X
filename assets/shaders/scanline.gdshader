shader_type canvas_item;
//vibe (shader)coding macht sowasvon GAR KAN bock


uniform float scanline_count : hint_range(0, 1800) = 50.0;
uniform float scanline_speed = 0.5;
uniform float scanline_strength : hint_range(0.0, 1.0) = 1.0;

// horizontal RGB offset in UV space (default ~1 pixel at 1024px wide -> 1.0/1024 ~= 0.00098)
uniform float rgb_offset_uv = 0.003; 
uniform float curvature = 1.0;     // 0 = none, 1 = default

vec2 uv_curve(vec2 uv)
{
    if (curvature == 0.0) return uv;
    uv = (uv - 0.5) * 2.0;

    uv.x *= 1.0 + pow(abs(uv.y) / 3.0 * curvature, 2.0);
    uv.y *= 1.0 + pow(abs(uv.x) / 3.0 * curvature, 2.0);

    uv /= 1.2;
    uv = (uv / 2.0) + 0.5;
    return uv;
}

void fragment() {
    // curve UV and clamp so we don't sample outside the texture
    vec2 curved = clamp(uv_curve(UV), vec2(0.0), vec2(1.0));

    // RGB subpixel sampling (offset in UV units)
    float r = texture(TEXTURE, curved + vec2(0.0, 0.0)).r;
    float g = texture(TEXTURE, curved + vec2(rgb_offset_uv, 0.0)).g;
    float b = texture(TEXTURE, curved + vec2(-rgb_offset_uv, 0.0)).b;
    vec3 col = vec3(r, g, b);

    // animated scanline (scrolling)
    float phase = TIME * scanline_speed;
    float scan_y = curved.y + phase;
    float s = sin(scan_y * scanline_count * PI*2.0f);

    // normalize and shape like the original
    float s_norm = (s * 0.5 + 0.5) * 0.9 + 0.1;
    float scan_brightness = pow(s_norm, 0.25);

    // blend scanline in/out by strength
    float final_scan = mix(1.0, scan_brightness, clamp(scanline_strength, 0.0, 1.0));
    col *= final_scan;

    COLOR = vec4(col, 1.0);
}
