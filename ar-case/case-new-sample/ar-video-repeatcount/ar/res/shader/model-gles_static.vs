
precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec2 texcoord;

uniform mat4 lightView;
uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

varying vec3 frag_normal;
varying vec3 frag_position;
varying vec3 light_position;
varying vec2 frag_texCoord;
varying vec4 frag_lightView;

void main()
{
    mat4 mvp = Proj * View * World;

    gl_Position = mvp * vec4(position, 1.0);
    
    frag_normal = vec3(normalize(World * vec4(normal,0.0)));
    frag_texCoord = texcoord;
    frag_position = vec3(World *  vec4(position, 1.0));
    
    frag_lightView = lightView  * World  * vec4(position, 1.0);
}
