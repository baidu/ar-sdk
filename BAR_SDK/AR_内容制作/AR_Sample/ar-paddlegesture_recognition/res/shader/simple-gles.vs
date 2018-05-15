attribute vec3 position;

uniform vec4 Color;
uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;
varying vec4 outcolor;
void main()
{
    gl_Position = Proj * View * World * vec4(position, 1.0);
    outcolor = Color;
}
