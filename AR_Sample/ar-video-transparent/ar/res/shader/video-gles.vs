attribute vec3 position;
attribute vec2 aTextureCoord;
varying vec2 vTextureCoord;
uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;
void main() {
     gl_Position = Proj * View * World * vec4(position, 1.0);
     vTextureCoord = aTextureCoord;
}