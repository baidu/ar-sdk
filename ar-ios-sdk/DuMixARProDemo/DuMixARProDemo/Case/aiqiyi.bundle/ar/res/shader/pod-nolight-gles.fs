precision mediump float;
uniform mediump vec4 Alpha;
varying vec3 object_position;
varying vec3 object_normal;
varying vec2 object_texcoord;

void main() {
    gl_FragColor = mix( Alpha, texture2D(sTexture, vec2(object_texcoord.x, 1.0 - object_texcoord.y)),Alpha.a);
}
