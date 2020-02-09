#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float PI = 3.14159265359;

float isInElipse(vec2 pos, vec2 c1, vec2 c2, float radius) {
    float dist1 = distance(c1, pos);
    float dist2 = distance(c2, pos);
    
    return float((dist1 + dist2) < radius);
}

void main() {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

    gl_FragColor = color * isInElipse(pos, vec2(0.25, 0.4), vec2(0.5, 0.6), 0.4);
}
