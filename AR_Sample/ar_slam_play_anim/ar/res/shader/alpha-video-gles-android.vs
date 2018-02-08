attribute vec3 position;
attribute vec2 aTextureCoord;
varying vec2 vRealTextureCoord;
varying vec2 vMaskTextureCoord;
uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

void main() {
    gl_Position = Proj * View * World * vec4(position, 1.0);
    vRealTextureCoord = vec2(aTextureCoord.x * 0.5, aTextureCoord.y);
    vMaskTextureCoord = vec2(0.5 + aTextureCoord.x * 0.5, aTextureCoord.y);
}
