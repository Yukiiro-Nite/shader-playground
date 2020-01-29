#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float PI = 3.14159265359;

vec4 fillSphere(vec2 center, float radius, vec4 color) {
  vec2 pos = gl_FragCoord.xy/u_resolution.xy;
  float dist = distance(center, pos);
  
  return color * float(dist < radius);
}

vec4 drawLine(vec2 start, vec2 end, float size, vec4 color) {
  // need to draw this line better.
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;

  float distanceToLine = abs((end.y - start.y) * pos.x - (end.x - start.x) * pos.y + end.x * start.y - end.y * start.x) / distance(start, end);
    float inLine = float(distanceToLine < size)
        * float(pos.x > start.x)
        * float(pos.y > start.y)
        * float(pos.x < end.x)
        * float(pos.y < end.y);
    vec4 startCap = fillSphere(start, size, color);
    vec4 endCap = fillSphere(end, size, color);
    vec4 returnColor = mix(color * inLine, startCap, startCap.a);
    returnColor = mix(returnColor, endCap, endCap.a);
    
    return returnColor;
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec2 timeTransform = vec2(cos(u_time), sin(u_time)) * 0.25;
    vec4 color = drawLine(vec2(0.5, 0.5), vec2(0.5, 0.5) + timeTransform, 0.01, vec4(1.0));

    gl_FragColor = color;
}