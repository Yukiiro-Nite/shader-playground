uniform vec2 resolution;
uniform float time;
uniform sampler2D  texture;

const mat3 outline = mat3(
  vec3(-1.0, -1.0, -1.0),
  vec3(-1.0,  8.0, -1.0),
  vec3(-1.0, -1.0, -1.0)
);

float luminosity(vec4 color) {
  return 0.2126*color.r + 0.7152*color.g + 0.0722*color.b;
}

float getGray(sampler2D tex, vec2 pos) {
  return luminosity(texture2D(tex, pos));
}

float sum(vec3 vec) {
  return vec.x + vec.y + vec.z;
}

float sum(mat3 matrix) {
  return sum(matrix[0]) + sum(matrix[1]) + sum(matrix[2]);
}

vec4 applyKernel(vec2 pos, vec2 ratio, sampler2D tex, mat3 kernel) {
  mat3 lumSample = mat3(
    vec3(
      getGray(tex, pos + vec2(-1.0, 1.0) * ratio),
      getGray(tex, pos + vec2(0.0, 1.0) * ratio),
      getGray(tex, pos + vec2(1.0, 1.0) * ratio)
    ),
    vec3(
      getGray(tex, pos + vec2(-1.0, 0.0) * ratio),
      getGray(tex, pos + vec2(0.0, 0.0) * ratio),
      getGray(tex, pos + vec2(1.0, 0.0) * ratio)
    ),
    vec3(
      getGray(tex, pos + vec2(-1.0, -1.0) * ratio),
      getGray(tex, pos + vec2(0.0, -1.0) * ratio),
      getGray(tex, pos + vec2(1.0, -1.0) * ratio)
    )
  );
  mat3 conv = mat3(
    vec3(
      lumSample[0][0] * kernel[0][0],
      lumSample[0][1] * kernel[0][1],
      lumSample[0][2] * kernel[0][2]
    ),
    vec3(
      lumSample[1][0] * kernel[1][0],
      lumSample[1][1] * kernel[1][1],
      lumSample[1][2] * kernel[1][2]
    ),
    vec3(
      lumSample[2][0] * kernel[2][0],
      lumSample[2][1] * kernel[2][1],
      lumSample[2][2] * kernel[2][2]
    )
  );

  float sum = sum(conv);
  return vec4(vec3(sum), 1.0);
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec2 ratio = vec2(1.0) / resolution.xy;
  vec4 color = applyKernel(pos, ratio, texture, outline);

  gl_FragColor = color;
}