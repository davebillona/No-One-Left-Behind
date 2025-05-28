shader_type canvas_item;

uniform float scroll_speed : hint_range(0.0,500.0) = 100.0;
uniform float time_passed = 0.0;

void fragment() {
    vec2 uv = UV;
    uv.y -= time_passed * scroll_speed / TEXTURE_PIXEL_SIZE.y;
    COLOR = texture(TEXTURE, uv);
}
