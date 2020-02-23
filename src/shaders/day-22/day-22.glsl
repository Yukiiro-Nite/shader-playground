uniform vec2 resolution;
uniform float time;
uniform sampler2D  texture;

vec4 desyncColor(vec2 pos, sampler2D tex, vec4 amount) {
  float displacedRed = texture2D(tex, vec2(pos.x + amount.r, pos.y)).r;
  float displacedGreen = texture2D(tex, vec2(pos.x + amount.g, pos.y)).g;
  float displacedBlue = texture2D(tex, vec2(pos.x + amount.b, pos.y)).b;
  float displacedAlpha = texture2D(tex, vec2(pos.x + amount.a, pos.y)).a;

  return vec4(displacedRed, displacedGreen, displacedBlue, displacedAlpha);
}

vec4 desyncColor(vec2 pos, sampler2D tex, vec4 amount, vec4 direction) {
  vec2 displacedRedPos = pos + vec2(cos(direction.r), sin(direction.r)) * amount.r;
  vec2 displacedGreenPos = pos + vec2(cos(direction.g), sin(direction.g)) * amount.g;
  vec2 displacedBluePos = pos + vec2(cos(direction.b), sin(direction.b)) * amount.b;
  vec2 displacedAlphaPos = pos + vec2(cos(direction.a), sin(direction.a)) * amount.a;

  float displacedRed = texture2D(tex, displacedRedPos).r;
  float displacedGreen = texture2D(tex, displacedGreenPos).g;
  float displacedBlue = texture2D(tex, displacedBluePos).b;
  float displacedAlpha = texture2D(tex, displacedAlphaPos).a;

  return vec4(displacedRed, displacedGreen, displacedBlue, displacedAlpha);
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec4 displacement = vec4(-1.0 / resolution.x, 0.0, 1.0 / resolution.x, 0.0) * sin(time) * 8.0;
  vec4 color = desyncColor(pos, texture, displacement, vec4(time / 2.0));

  gl_FragColor = color;
}