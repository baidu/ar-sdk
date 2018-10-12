precision highp float;
varying highp vec2 vMaskTextureCoord;
varying highp vec2 vRealTextureCoord;
uniform sampler2D uDiffuseTexture;
void main() {
    vec4 maskColor = texture2D(uDiffuseTexture, vMaskTextureCoord);
    vec4 texColor = texture2D(uDiffuseTexture, vRealTextureCoord);
    vec4 color = vec4(texColor.b, texColor.g, texColor.r, maskColor.r);
    
    gl_FragColor = color;
}
