attribute vec3 position;
attribute vec2 texCoord;
attribute vec3 normal;

varying vec2 frag_texCoord;
varying vec3 v_normal;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

void main()
{
    gl_Position = Proj * View * World * vec4(position, 1.0);
    v_normal = normal;
    frag_texCoord = texCoord;
}
