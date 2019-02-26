attribute vec3 position;
attribute vec2 texCoord;
attribute vec3 normal;


varying vec3 frag_normal;
varying vec3 frag_position;
varying vec3 light_position;
varying vec2 frag_texCoord;
varying vec4 frag_lightView;


uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

uniform mat4 lightView;

void main()
{
    gl_Position = Proj * View * World * vec4(position, 1.0);
    frag_position = vec3(World * vec4(position, 1.0));
    frag_normal = vec3(World * vec4(normal, 1.0));
    frag_texCoord = texCoord;
    
    frag_lightView = lightView  * World  *  vec4(position, 1.0);
    
    
}
