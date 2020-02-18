uniform vec2 resolution;
uniform float time;
uniform sampler2D texture;

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

float luminosity(vec4 color) {
  return 0.2126*color.r + 0.7152*color.g + 0.0722*color.b;
}

void main() {
    vec2 pos = gl_FragCoord.xy/resolution.xy;
    float brightness = luminosity(texture2D(texture, vec2(pos.x * 0.1, fract(time * 0.05))));
    float brightness2 = luminosity(texture2D(texture, vec2(pos.x * 0.1, fract((time * 0.05) + 0.02))));
    float brightness3 = luminosity(texture2D(texture, vec2(pos.x * 0.1, fract((time * 0.05) + 0.04))));
    float brightness4 = luminosity(texture2D(texture, vec2(pos.x * 0.1, fract((time * 0.05) + 0.06))));

    vec4 color = vec4(1.0) * float(lessThan(pos.y, brightness));
    vec4 color2 = vec4(0.75) * float(lessThan(pos.y, brightness2));
    vec4 color3 = vec4(0.5) * float(lessThan(pos.y, brightness3));
    vec4 color4 = vec4(0.25) * float(lessThan(pos.y, brightness4));

    vec4 mixColor = mix(color2, color, color.a);
    mixColor = mix(color3, mixColor, mixColor.a);
    mixColor = mix(color4, mixColor, mixColor.a);

    gl_FragColor = mixColor;
}