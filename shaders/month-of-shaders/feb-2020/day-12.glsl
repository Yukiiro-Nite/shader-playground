// bouncing ball

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float PI = 3.14159265359;
const float TAU = PI * 2.0;
const float flex = 0.15;

float isInElipse(vec2 pos, vec2 c1, vec2 c2, float radius) {
    float dist1 = distance(c1, pos);
    float dist2 = distance(c2, pos);
    
    return float((dist1 + dist2) < radius);
}

void main() {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    float bounceArc = abs(sin(u_time));
    float squashX = step(bounceArc, flex) * (flex - bounceArc);
    vec2 squashVecL = vec2(-squashX, -flex * 0.5);
    vec2 squashVecR = vec2(squashX, -flex * 0.5);
    vec2 ballPos = vec2(pos.x, pos.y - bounceArc * 0.5);
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

    gl_FragColor = color * isInElipse(ballPos, vec2(0.5, 0.2) + squashVecL, vec2(0.5, 0.2) + squashVecR, 0.4);
}
