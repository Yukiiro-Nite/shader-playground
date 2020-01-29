#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_tex0;
const float PI = 3.14159265359;

void main() {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    vec4 color = texture2D(u_tex0, pos);
    color = mix(color, vec4(pos.x, 0.0, pos.y, 1.0), 0.5);

    gl_FragColor = color;
}
