precision mediump float;
varying vec2 vTextureCoord;
uniform sampler2D uDiffuseTexture;
void main() {
    vec4 color2 = texture2D(uDiffuseTexture, vTextureCoord);
    vec4 color = vec4(color2.b, color2.g, color2.r, color2.a);
    

     //%SHADER_PLACE_HOLDER%
    
     // if(color.g > 0.5 && color.g > (color.r + color.b) * 0.75){
    //      color.a = 0.0;
    //  }
    
    //  if(color.g > 0.15 && color.g > (color.r + color.b) * 0.75) {
    //      color.a = 0.5 - color.g;
    //      color.g = 0.0;
    //  }

    gl_FragColor = color;
}
