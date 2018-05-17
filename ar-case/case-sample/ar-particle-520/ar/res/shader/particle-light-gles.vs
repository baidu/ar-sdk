precision mediump float;

attribute vec3 position;
attribute vec4 color;
attribute vec2 texcoord;

varying vec2 texCoordOut;
varying vec4 colorOut;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

void main() {
     gl_Position = Proj * View * World * vec4(position, 1.0);
     texCoordOut = texcoord;
     colorOut = color;

}
