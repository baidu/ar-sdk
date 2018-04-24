precision highp float;

uniform float time;
uniform vec2 point;
uniform vec2 resolution;

uniform sampler2D uDiffuseTexture;

varying vec2 texCoordOut;
varying vec4 colorOut;

#define NUM_PARTICLES 80.

void main( void ) {
    float intensity = .027;
    vec2 fragPosition = gl_FragCoord.xy/resolution.y-vec2(0.5*resolution.x/resolution.y, 0.5);
    for (float i = 0.; i < NUM_PARTICLES; i++) {
        float angle = i / NUM_PARTICLES *6.14;
        float rotatedAngle = angle + time * 3.0;
        vec2 xy = vec2(cos(rotatedAngle), sin(rotatedAngle)) * 0.25;
        float amp = 0.008 * (1.0 + sin(angle * 3.0 * (sin(time)+2.0)));
        intensity += pow(0.1, 1.0 - (amp / length(xy - fragPosition)))*0.27;
    }
    vec4 texColor = vec4( clamp(intensity * vec3(0.077, 0.096, 0.67), vec3(0.), vec3(1.)), 1.0 );
    
    gl_FragColor = vec4(texColor.rgb,(texColor.r+texColor.g+texColor.b)/3.0);

}
