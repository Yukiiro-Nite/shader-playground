uniform vec2 resolution;  // Width and height of the shader
uniform float time;  // Time elapsed
 
// Constants
#define PI 3.1415925359
#define TAU 6.2831852
#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURFACE_DIST .01
#define PETAL_COUNT 6.0

// https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sphere(vec3 pos, float radius) {
  return length(pos) - radius;
}

float plane(vec3 pos, vec3 norm, float h) {
  return dot(pos, norm) + h;
}

float capsule(vec3 pos, vec3 start, vec3 end, float radius) {
  vec3 posToStart = pos - start;
  vec3 startToEnd = end - start;

  float h = clamp(dot(posToStart, startToEnd) / dot(startToEnd, startToEnd), 0.0, 1.0);

  return length(posToStart - startToEnd * h) - radius;
}

float opUnion(float d1, float d2) {
  return min(d1, d2);
}

float addPetals(vec3 p, vec3 offset, float petalSize, float currentDist) {
  float section = TAU / PETAL_COUNT;
  vec3 petalSpace = p
    * vec3(1.0, 2.0, 1.0)
    - vec3(0.0, pow(length(vec2(p.xz - offset.xz)), 2.0), 0.0);

  vec3 petalPos;
  float petalDist;
  for(float i = 0.0; i < PETAL_COUNT; i += 1.0) {
    petalPos = vec3(cos(section * i + time) * petalSize + offset.x, offset.y, sin(section * i + time) * petalSize + offset.z);
    petalDist = sphere(petalSpace - petalPos, petalSize);
    currentDist = opUnion(currentDist, petalDist);
  }

  return currentDist;
}

float GetDist(vec3 p)
{
  float floorDist = plane(p, vec3(0.0, 1.0, 0.0), 0.0);

  float d = floorDist;
  d = addPetals(p, vec3(0, 1.0, 2.0), 0.25, d);

  return d;
}
 
float RayMarch(vec3 ro, vec3 rd) 
{
    float dO = 0.; //Distane Origin
    for(int i=0;i<MAX_STEPS;i++)
    {
        vec3 p = ro + rd * dO;
        float ds = GetDist(p); // ds is Distance Scene
        dO += ds;
        if(dO > MAX_DIST || ds < SURFACE_DIST) break;
    }
    return dO;
}
 
void main()
{
    vec2 uv = (gl_FragCoord.xy-.5*resolution.xy)/resolution.y;
    vec3 ro = vec3(0,1,0); // Ray Origin/ Camera
    vec3 rd = normalize(vec3(uv.x,uv.y,1));
    float d = RayMarch(ro,rd); // Distance
    d/= 10.;
    vec3 color = vec3(d);
     
    // Set the output color
    gl_FragColor = vec4(color,1.0);
}