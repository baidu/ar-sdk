precision highp float;

uniform float time;
uniform vec2 point;
uniform vec2 resolution;

uniform sampler2D uDiffuseTexture;

varying vec2 texCoordOut;
varying vec4 colorOut;

#define time 0.5*time

float hash(float x){return fract(sin(x*133.3)*13.13);}

void main(void){
    vec2 uv=(gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x,resolution.y);
    vec3 c=vec3(.6,.7,.8);
    
    float a=-.4;
    float si=sin(a),co=cos(a);
    uv*=mat2(co,-si,si,co);
    uv*=length(uv+vec2(0,4.1))*.3+1.;
    
    float v=1.-sin(hash(floor(uv.x*100.))*2.);
    float b=clamp(abs(sin(20.*time*v+uv.y*(5./(2.+v))))-.95,0.,1.)*20.;
    c*=v*b;
    
    vec4 texColor = vec4(c , 1.0);
    
    gl_FragColor = vec4(texColor.rgb,(texColor.r+texColor.g+texColor.b)/3.0);
}
