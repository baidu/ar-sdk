precision mediump float;
uniform sampler2D TextureID;
varying vec4 Color; 
varying vec2 TextureCoord; 
varying vec3 Normal; 

void main() {

 // gl_FragColor = vec4(TextureCoord, 0.0, 1.0) * Color; 
// gl_FragColor = texture2D(TextureID, TextureCoord.xy) * Color;
     gl_FragColor = Color;    
  //gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);   
}
