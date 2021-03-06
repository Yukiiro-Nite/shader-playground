#define PI 3.14159265359

uniform vec2 resolution;
uniform float time;

const float maxNumberWidth = 20.0;

// START Utils
float greaterThan(float a, float b) {
  return ceil((sign(a - b) + 1.0) / 2.0);
}

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

float inRange(float min, float max, float val) {
  return greaterThan(val, min) * lessThan(val, max);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

// END Utils

float inCone(vec2 from, vec2 to) {
    vec2 pos = gl_FragCoord.xy/resolution.xy;
    vec2 diff = to - from;
    float angle = atan(diff.y, diff.x);
    
    vec2 offset = pos - from;
    offset = rotate2d(angle - (PI / 4.0)) * offset;
    
    return greaterThan(offset.x, 0.0) * greaterThan(offset.y, 0.0);
}

vec4 drawSpindle(vec2 start, vec2 end, float size, vec4 color) {
  // need to get the distance to the line from the point
  // if the distance is less than the size, draw the line
  // this will result in round line caps, but i want pointed line caps
  // can do math to find out if the point is within the line cap
  vec2 pos = gl_FragCoord.xy/resolution.xy;

  float distanceToLine = abs((end.y - start.y) * pos.x - (end.x - start.x) * pos.y + end.x * start.y - end.y * start.x) / distance(start, end);
  float inLine = lessThan(distanceToLine, size);
	float inStartCap = inCone(start, end);
  float inEndCap = inCone(end, start);

  return color * inLine * inStartCap * inEndCap;
}

vec4 drawSevenSegmentDisplay(float display, vec2 pos, float size, vec4 color) {
  float total = 0.0;
  float seg_1_display = sign(floor(display / 64.0));
  total = total + (64.0 * seg_1_display);
  float seg_2_display = sign(floor((display - total) / 32.0));
  total = total + (32.0 * seg_2_display);
  float seg_3_display = sign(floor((display - total) / 16.0));
  total = total + (16.0 * seg_3_display);
  float seg_4_display = sign(floor((display - total) / 8.0));
  total = total + (8.0 * seg_4_display);
  float seg_5_display = sign(floor((display - total) / 4.0));
  total = total + (4.0 * seg_5_display);
  float seg_6_display = sign(floor((display - total) / 2.0));
  total = total + (2.0 * seg_6_display);
  float seg_7_display = sign(floor((display - total) / 1.0));
  total = total + (1.0 * seg_7_display);
  float segmentWidth = size / 10.;

  vec4 seg_1 = drawSpindle(vec2(pos.x, pos.y), vec2(pos.x + size, pos.y), segmentWidth, color) * seg_1_display;
  vec4 seg_2 = drawSpindle(vec2(pos.x + size, pos.y), vec2(pos.x + size, pos.y - size), segmentWidth, color) * seg_2_display;
  vec4 seg_3 = drawSpindle(vec2(pos.x + size, pos.y - size), vec2(pos.x + size, pos.y - (size * 2.)), segmentWidth, color) * seg_3_display;
  vec4 seg_4 = drawSpindle(vec2(pos.x + size, pos.y - (size * 2.)), vec2(pos.x, pos.y - (size * 2.)), segmentWidth, color) * seg_4_display;
  vec4 seg_5 = drawSpindle(vec2(pos.x, pos.y - (size * 2.)), vec2(pos.x, pos.y - size), segmentWidth, color) * seg_5_display;
  vec4 seg_6 = drawSpindle(vec2(pos.x, pos.y - size), vec2(pos.x, pos.y), segmentWidth, color) * seg_6_display;
  vec4 seg_7 = drawSpindle(vec2(pos.x, pos.y - size), vec2(pos.x + size, pos.y - size), segmentWidth, color) * seg_7_display;
  
  color = mix(seg_1, seg_2, seg_2.a);
  color = mix(color, seg_3, seg_3.a);
  color = mix(color, seg_4, seg_4.a);
  color = mix(color, seg_5, seg_5.a);
  color = mix(color, seg_6, seg_6.a);
  color = mix(color, seg_7, seg_7.a);

  return color;
}

vec4 drawDigit(float digit, vec2 pos, float size, vec4 color) {
  digit = floor(digit);
  float seg_1_display = sign(float(digit == 0.0) + float(digit == 2.0) + float(digit == 3.0) + float(digit == 5.0) + float(digit == 6.0) + float(digit == 7.0) + float(digit == 8.0) + float(digit == 9.0));
  float seg_2_display = sign(float(digit == 0.0) + float(digit == 1.0) + float(digit == 2.0) + float(digit == 3.0) + float(digit == 4.0) + float(digit == 7.0) + float(digit == 8.0) + float(digit == 9.0));
  float seg_3_display = sign(float(digit == 0.0) + float(digit == 1.0) + float(digit == 3.0) + float(digit == 4.0) + float(digit == 5.0) + float(digit == 6.0) + float(digit == 7.0) + float(digit == 8.0) + float(digit == 9.0));
  float seg_4_display = sign(float(digit == 0.0) + float(digit == 2.0) + float(digit == 3.0) + float(digit == 5.0) + float(digit == 6.0) + float(digit == 8.0) + float(digit == 9.0));
  float seg_5_display = sign(float(digit == 0.0) + float(digit == 2.0) + float(digit == 6.0) + float(digit == 8.0));
  float seg_6_display = sign(float(digit == 0.0) + float(digit == 4.0) + float(digit == 5.0) + float(digit == 6.0) + float(digit == 8.0) + float(digit == 9.0));
  float seg_7_display = sign(float(digit == 2.0) + float(digit == 3.0) + float(digit == 4.0) + float(digit == 5.0) + float(digit == 6.0) + float(digit == 8.0) + float(digit == 9.0));

  float total = 0.0;
  total = total + (64.0 * seg_1_display);
  total = total + (32.0 * seg_2_display);
  total = total + (16.0 * seg_3_display);
  total = total + (8.0 * seg_4_display);
  total = total + (4.0 * seg_5_display);
  total = total + (2.0 * seg_6_display);
  total = total + (1.0 * seg_7_display);

  return drawSevenSegmentDisplay(total, pos, size, color);
}

float logBase(float base, float num) {
  return log(num) / log(base);
}

float getDigit(float number, float index) {
  return (
      floor(number/pow(10.0, index - 1.0))*pow(10.0, index - 1.0) -
      floor(number/pow(10.0, index))*pow(10.0, index)
    ) / pow(10.0, index-1.0); 
}

vec4 drawNumber(float num, vec2 pos, float size, vec4 color) {
  float digitCount = floor(logBase(10.0, num)) + 1.0;
  float padding = size / 2.0;
  vec4 digits = vec4(0.0);

  for(float count = 1.0; count < maxNumberWidth; count += 1.0) {
    if(count > digitCount) return digits;
    float digit = getDigit(num, count);
    vec2 offset =  vec2(size * (digitCount - count) + padding * (digitCount - count), 0.0);
    vec4 digitColor = drawDigit(digit, pos + offset, size, color);
    digits = mix(digits, digitColor, digitColor.a);
  }
  
  return digits;
}

void main() {
  vec4 mainColor = vec4(1.0);
  vec4 color = drawNumber(time, vec2(0.1, 0.9), 0.05, mainColor);
	// vec4 color = drawSevenSegmentDisplay(1., vec2(0.1, 0.9), 0.1, mainColor);

  gl_FragColor = color;
}