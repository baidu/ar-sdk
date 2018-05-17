precision mediump float;
varying vec2 vTextureCoord;
uniform sampler2D uDiffuseTexture;
void main() {
    gl_FragColor = texture2D(uDiffuseTexture, vTextureCoord);
    // gl_FragColor = vec4(0.5);
    
}
