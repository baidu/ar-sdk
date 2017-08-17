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
varying mediump vec3 vWorldNormal;
varying mediump vec3 vLightDir;
varying mediump float vOneOverAttenuation;

void main()
{
    mat4 MVPMatrix =  Proj * View * World;
	gl_Position = MVPMatrix * ModelMatrix  * vec4(position, 1.0);

	vec3 worldPos = (ModelMatrix * vec4(position, 1.0)).xyz;
	//vLightDir = LightPos - worldPos;
    vLightDir = vec3(1.0) - worldPos;
    
    
    float light_distance = length(vLightDir);
	vLightDir /= light_distance;

	vOneOverAttenuation = 1. / (1. + .00005*light_distance*light_distance);

	vWorldNormal = ModelWorldIT3x3 * normal;
	// Pass through texcoords
	TexCoord = texcoord;
}
 
