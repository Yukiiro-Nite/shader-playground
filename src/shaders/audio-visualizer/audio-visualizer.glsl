uniform float time;
uniform vec2 resolution;
uniform float loading;
uniform sampler2D texture;
uniform vec2 textureResolution;
uniform sampler2D fft;
uniform float fftResolution;

vec4 visualize(vec2 pos) {
  vec4 value = texture2D(fft, pos);

  return vec4(1.0) * float(pos.y <= value.x / 4.0);
}

void main()	{
  vec2 scaleCamToWindow = resolution / textureResolution;
  vec2 adjustedCam = textureResolution * min(scaleCamToWindow.x, scaleCamToWindow.y);
  vec2 offset = (resolution - adjustedCam) / 2.0;
  vec2 pos = (gl_FragCoord.xy - offset)/adjustedCam.xy;
  float inFrame = float(pos.x >= 0.0 && pos.x <= 1.0 && pos.y >= 0.0 && pos.y <= 1.0);
  float loadingMask = 1.0 - loading;
  vec4 videoColor = texture2D(texture, pos);
  vec4 visColor = visualize(pos) * vec4(vec3(1.0) - videoColor.rgb, 1.0);
  gl_FragColor = mix(videoColor, visColor, visColor.a) * inFrame;
}