#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float PI = 3.14159265359;

vec4 fillSphere(vec2 center, float radius, vec4 color) {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    float dist = distance(center, pos);
    float clampedDist = clamp(dist, 0.0, radius);
    float distRange = mix(PI / 2.0, 0.0, clampedDist / radius);
    
    return color * sin(distRange);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    
    vec4 color = fillSphere(
        vec2(0.25, 0.25),
        0.1,
        vec4(1.0, 1.0, 1.0, 1.0)
    );

    gl_FragColor = color;
}
