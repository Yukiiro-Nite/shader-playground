uniform vec2 resolution;
uniform float time;
uniform sampler2D  texture;

uniform sampler2D  palette;
uniform float paletteWidth;
const float maxPaletteWidth = 64.0;

// Requires palette and paletteWidth uniforms to be set
vec4 closestColor(vec4 color) {
  float newMin = 0.0;
  vec4 currentColor = texture2D(palette, vec2(0.0));
  float currentDist = distance(color, currentColor);

  vec4 outColor = currentColor;
  float minDistance = currentDist;

  for(float i = 1.0; i < maxPaletteWidth; i += 1.0) {
    if(i >= paletteWidth) return outColor;
    currentColor = texture2D(palette, vec2(i / paletteWidth, 0.0));
    currentDist = distance(color, currentColor);
    newMin = float(currentDist < minDistance);

    outColor = mix(outColor, currentColor, newMin);
    minDistance = (minDistance * (1.0 - newMin)) + (currentDist * newMin);
  }

  return outColor;
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec4 color = closestColor(texture2D(texture, pos));

  gl_FragColor = color;
}