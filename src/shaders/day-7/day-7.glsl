uniform vec2 resolution;
uniform float time;
uniform sampler2D texture;
const float PI = 3.14159265359;
const float TAU = PI * 2.0;

float greaterThan(float a, float b) {
  return ceil((sign(a - b) + 1.0) / 2.0);
}

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

float luminosity(vec4 color) {
  return 0.2126*color.r + 0.7152*color.g + 0.0722*color.b;
}

void main() {
    vec2 pos = gl_FragCoord.xy/resolution.xy;
    vec2 center = vec2(0.5) - pos;
    float angle = ((atan(center.y, center.x) / TAU) + 1.0) / 2.0;
    float radius = length(center) * 2.0;
    vec2 polarPos = vec2(angle, radius);

    float brightness = luminosity(texture2D(texture, vec2(polarPos.x, fract(time * 0.05))));

    vec4 color = vec4(vec3(0.8), 1.0);

    gl_FragColor = color * greaterThan(polarPos.y, 0.25) * lessThan(polarPos.y, (brightness * 0.5) + 0.25);
}