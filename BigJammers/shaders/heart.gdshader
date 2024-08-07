shader_type canvas_item;

uniform vec4 color : source_color;
uniform float cutoff : hint_range(0.0, 1.0);

void fragment() {
    float cutoff_position = cutoff * TEXTURE_PIXEL_SIZE.y;
	vec4 col = color;
    if (UV.y < cutoff) {
        col = vec4(1,1,1,1);
    } 
	
	COLOR = texture(TEXTURE, UV) * col;
}