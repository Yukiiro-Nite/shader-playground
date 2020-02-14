#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_tex0;
uniform sampler2D u_self;
const float PI = 3.14159265359;

void main() {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    vec4 color = texture2D(u_tex0, pos);
    vec4 newColor = texture2D(u_self, pos);
    newColor.r = newColor.r + sin(u_time) * 0.1;

    gl_FragColor = color * (1.0 - float(sign(u_time))) + newColor * float(sign(u_time));
}
