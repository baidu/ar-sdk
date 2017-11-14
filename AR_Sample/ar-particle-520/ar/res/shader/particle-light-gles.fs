precision highp float;

uniform float time;
uniform vec2 resolution;

#define TWO_PI 6.283185
#define NUMBALLS 50.0

float d = -TWO_PI/360.0;

void main( void ) {
    vec2 p = (2.0*gl_FragCoord.xy - resolution)/min(resolution.x, resolution.y);
    //P *= mat2(cos(time), -sin(time), sin(time), cos(time));
    
    vec3 c = vec3(0); //ftfy
    for(float i = 0.0; i < NUMBALLS; i++) {
        float t = TWO_PI * i/NUMBALLS + time;
        float x = cos(t);
        float y = sin(1.0 * t + d);
        vec2 q = 0.8*vec2(x, y);
        c += 0.01/distance(p, q) * vec3(.0* abs(x), 0, abs(y));
    }
    gl_FragColor = vec4(c, 1.0);
    
}
