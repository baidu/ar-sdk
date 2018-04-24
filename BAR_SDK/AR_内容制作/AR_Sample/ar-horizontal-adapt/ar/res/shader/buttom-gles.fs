precision mediump float;

varying vec2 object_texcoord;
uniform sampler2D uDiffuseTexture;
void main() {
    gl_FragColor = texture2D(uDiffuseTexture, vec2(object_texcoord.x, object_texcoord.y));
    
    //gl_FragColor = vec4(vec3(texture2D(uDiffuseTexture, object_texcoord)), 0.3);
}
