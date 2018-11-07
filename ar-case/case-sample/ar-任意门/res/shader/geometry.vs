attribute vec3 position;
attribute vec2 uv;
attribute vec4 color;
attribute vec3 normal;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 Modle;

varying vec4 Color; 
varying vec2 TextureCoord; 
varying vec3 Normal; 

void main() {
    
    gl_Position = Proj * View * vec4(position, 1.0);
    Color = color;
    TextureCoord = uv;
    Normal = normal;
}
