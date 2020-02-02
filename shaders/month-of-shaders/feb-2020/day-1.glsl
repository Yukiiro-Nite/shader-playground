 #ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float PI = 3.14159265359;

vec4 fillCircle(vec2 center, float radius, vec4 color) {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    float dist = distance(center, pos);
    
    return color * float(dist < radius);
}

void main() {
    vec4 outerCircle = fillCircle(vec2(0.5), 0.5, vec4(1.0));
    vec4 innerCircle = fillCircle(
        (vec2(sin(u_time), cos(u_time)) * 0.25) + vec2(0.5),
        0.1,
        vec4(1.0, 0.0, 0.0, 1.0)
    );

    gl_FragColor = mix(outerCircle, innerCircle, innerCircle.a);
}
