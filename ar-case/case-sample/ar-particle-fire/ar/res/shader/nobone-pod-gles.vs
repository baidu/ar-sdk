attribute highp   vec3  position;
attribute highp   vec3	normal;
attribute mediump vec2  texcoord;
attribute highp   vec3	tagent;
attribute highp   vec3	inBiNormal;

uniform highp   mat4 ModelMatrix;
uniform highp   mat3 ModelWorldIT3x3;
uniform highp	vec3 LightPos;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

varying mediump vec2  TexCoord;

void main()
{
    mat4 MVPMatrix =  Proj * View * World;
	gl_Position = MVPMatrix * ModelMatrix  * vec4(position, 1.0);

	// Pass through texcoords
	TexCoord = texcoord;
}
 
