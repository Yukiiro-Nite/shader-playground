uniform vec2 resolution;
uniform float time;
uniform sampler2D texture;

vec3 rgb2xyz( vec3 c ) {
  vec3 tmp;
  tmp.x = ( c.r > 0.04045 ) ? pow( ( c.r + 0.055 ) / 1.055, 2.4 ) : c.r / 12.92;
  tmp.y = ( c.g > 0.04045 ) ? pow( ( c.g + 0.055 ) / 1.055, 2.4 ) : c.g / 12.92;
  tmp.z = ( c.b > 0.04045 ) ? pow( ( c.b + 0.055 ) / 1.055, 2.4 ) : c.b / 12.92;

  return 100.0 * tmp *
    mat3( 0.4124, 0.3576, 0.1805,
          0.2126, 0.7152, 0.0722,
          0.0193, 0.1192, 0.9505 );
}

vec3 xyz2lab( vec3 c ) {
  vec3 n = c / vec3( 95.047, 100, 108.883 );
  vec3 v;
  v.x = ( n.x > 0.008856 ) ? pow( n.x, 1.0 / 3.0 ) : ( 7.787 * n.x ) + ( 16.0 / 116.0 );
  v.y = ( n.y > 0.008856 ) ? pow( n.y, 1.0 / 3.0 ) : ( 7.787 * n.y ) + ( 16.0 / 116.0 );
  v.z = ( n.z > 0.008856 ) ? pow( n.z, 1.0 / 3.0 ) : ( 7.787 * n.z ) + ( 16.0 / 116.0 );
  return vec3(( 116.0 * v.y ) - 16.0, 500.0 * ( v.x - v.y ), 200.0 * ( v.y - v.z ));
}

vec3 lab2xyz( vec3 c ) {
    float fy = ( c.x + 16.0 ) / 116.0;
    float fx = c.y / 500.0 + fy;
    float fz = fy - c.z / 200.0;
    return vec3(
         95.047 * (( fx > 0.206897 ) ? fx * fx * fx : ( fx - 16.0 / 116.0 ) / 7.787),
        100.000 * (( fy > 0.206897 ) ? fy * fy * fy : ( fy - 16.0 / 116.0 ) / 7.787),
        108.883 * (( fz > 0.206897 ) ? fz * fz * fz : ( fz - 16.0 / 116.0 ) / 7.787)
    );
}

vec3 xyz2rgb( vec3 c ) {
    vec3 v =  c / 100.0 * mat3( 
        3.2406, -1.5372, -0.4986,
        -0.9689, 1.8758, 0.0415,
        0.0557, -0.2040, 1.0570
    );
    vec3 r;
    r.x = ( v.r > 0.0031308 ) ? (( 1.055 * pow( v.r, ( 1.0 / 2.4 ))) - 0.055 ) : 12.92 * v.r;
    r.y = ( v.g > 0.0031308 ) ? (( 1.055 * pow( v.g, ( 1.0 / 2.4 ))) - 0.055 ) : 12.92 * v.g;
    r.z = ( v.b > 0.0031308 ) ? (( 1.055 * pow( v.b, ( 1.0 / 2.4 ))) - 0.055 ) : 12.92 * v.b;
    return r;
}

vec3 rgb2lab(vec3 c) {
  vec3 lab = xyz2lab( rgb2xyz( c ) );
  return vec3( lab.x / 100.0, 0.5 + 0.5 * ( lab.y / 127.0 ), 0.5 + 0.5 * ( lab.z / 127.0 ));
}

vec3 lab2rgb(vec3 c) {
    return xyz2rgb( lab2xyz( vec3(100.0 * c.x, 2.0 * 127.0 * (c.y - 0.5), 2.0 * 127.0 * (c.z - 0.5)) ) );
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

vec4 blackWhiteDither(vec4 color) {
  vec4 white = vec4(1.0);
  vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
  vec3 labColor = rgb2lab(color.rgb);
  vec3 labWhite = rgb2lab(white.rgb);
  vec3 labBlack = rgb2lab(black.rgb);

  float distanceToWhite = distance(labWhite, labColor);
  float distanceToBlack = distance(labBlack, labColor);
  float totalDistance = distanceToWhite + distanceToBlack;
  float whitePercent = 1.0 - (distanceToWhite / totalDistance);
  float blackPercent = 1.0 - (distanceToBlack / totalDistance);
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  float r = random(pos + fract(time));

  float isWhite = float(r > 0.0 && r <= whitePercent);
  float isBlack = float(r > whitePercent && r <= 1.0);

  return (isWhite * white)
       + (isBlack * black);
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec4 tex = texture2D(texture, pos);

  vec4 color = blackWhiteDither(tex);

  gl_FragColor = color;
}