precision mediump float;
varying vec2 vTextureCoord;
uniform sampler2D uDiffuseTexture;
uniform mediump vec4 Alpha;
void main() {
    gl_FragColor = mix( Alpha, texture2D(uDiffuseTexture, vTextureCoord),Alpha.a);
    // gl_FragColor = vec4(0.5);
    
}
