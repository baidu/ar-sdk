#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 vTextureCoord;
uniform samplerExternalOES uDiffuseTexture;
void main() {
    vec4 color = texture2D(uDiffuseTexture, vTextureCoord);
    //if(color.g > 0.5 && color.g > (color.r + color.b) * 0.75){
    //    color.a = 0.0;
    //} else if(color.r < 0.02 && color.g < 0.02 && color.b < 0.02) {
    //    color.a = 0.0;
    //}
    // %SHADER_PLACE_HOLDER%

    //if(color.g > 0.15 && color.g > (color.r + color.b) * 0.75) {
      //  color.a = 0.5 - color.g;
    //}
    gl_FragColor = color;
    // gl_FragColor = vec4(0.5);
    
}
