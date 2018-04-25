#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 vRealTextureCoord;
varying vec2 vMaskTextureCoord;
uniform samplerExternalOES uDiffuseTexture;
void main() {
    vec4 maskColor = texture2D(uDiffuseTexture, vMaskTextureCoord);
    vec4 texColor = texture2D(uDiffuseTexture, vRealTextureCoord);
    vec4 color = vec4(texColor.r, texColor.g, texColor.b, maskColor.r);
    
    gl_FragColor = color;
    
}




