precision mediump float;

varying vec2 frag_texCoord;
varying vec3 v_normal;

uniform samplerCube  uDiffuseTexture;

void main() {
   
    gl_FragColor = textureCube(uDiffuseTexture, frag_texCoord);
}

