precision mediump float;

attribute vec3 position;
attribute vec4 color;
attribute vec2 texcoord;

varying vec2 texCoordOut;
varying vec4 colorOut;

void main() {
     gl_Position = vec4(position, 1.0);
     texCoordOut = texcoord;
     colorOut = color;

}
