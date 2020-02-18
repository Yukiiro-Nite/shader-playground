uniform vec2 resolution;
uniform float time;
const float PI = 3.14159265359;

vec4 fillCircle(vec2 pos, vec2 center, float radius, vec4 color) {
    float dist = distance(center, pos);
    
    return color * float(dist < radius);
}

void main() {
    vec2 pos = gl_FragCoord.xy/resolution.xy;
    vec4 outerCircle = fillCircle(pos, vec2(0.5), 0.5, vec4(1.0));
    vec4 innerCircle = fillCircle(
        pos,
        (vec2(sin(time), cos(time)) * 0.25) + vec2(0.5),
        0.1,
        vec4(1.0, 0.0, 0.0, 1.0)
    );

    gl_FragColor = mix(outerCircle, innerCircle, innerCircle.a);
}
