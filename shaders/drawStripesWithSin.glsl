#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float PI = 3.14159265359;

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float waveCount = 6.0 + sin(u_time);
    float t = (st.x * PI * waveCount) - (PI * 0.5);
    float value = 0.0;
    float coeff = 0.0;
    for(float i = 0.0; i < 10.0; i += 1.0) {
        coeff = i * 2.0 + 1.0;
        value = value + sin(t*coeff)/coeff;
    }
    vec3 color = vec3((value+1.0) / 2.0);

    gl_FragColor = vec4(color,1.0);
}