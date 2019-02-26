/*
	If the current vertex is affected by bones then the vertex position and
	normal will be transformed by the bone matrices. Each vertex wil have up 
	to 4 bone indices (inBoneIndex) and bone weights (weights).
	
	The indices are used to index into the array of bone matrices 
	(BoneMatrixArray) to get the required bone matrix for transformation. The 
	amount of influence a particular bone has on a vertex is determined by the
	weights which should always total 1. So if a vertex is affected by 2 bones 
	the vertex position in world space is given by the following equation:

	position = (BoneMatrixArray[Index0] * position) * Weight0 + 
	           (BoneMatrixArray[Index1] * position) * Weight1

	The same proceedure is applied to the normals but the translation part of 
	the transformation is ignored.

	After this the position is multiplied by the view and projection matrices 
	only as the bone matrices already contain the model transform for this 
	particular mesh. The two-step transformation is required because lighting 
	will not work properly in clip space.
*/

#define MAX_BONE_COUNT 12

attribute highp   vec3 position;
attribute mediump vec3 normal;
attribute mediump vec3 tagent;
attribute mediump vec3 inBiNormal;
attribute mediump vec2 texcoord;
attribute highp vec4 inBoneIndex;
attribute highp vec4 weights;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;


uniform mediump vec3 LightPos;
uniform mediump	int	 BoneCount;
uniform highp   mat4 BoneMatrixArray[MAX_BONE_COUNT];
uniform highp   mat3 BoneMatrixArrayIT[MAX_BONE_COUNT];
uniform bool	bUseDot3;

varying mediump vec3 Light;
varying mediump vec2 TexCoord;


void main()
{
        mat4 ViewProjMatrix = Proj * View * World;


		// On PowerVR SGX it is possible to index the components of a vector
		// with the [] operator. However this can cause trouble with PC
		// emulation on some hardware so we "rotate" the vectors instead.
		mediump ivec4 boneIndex = ivec4(inBoneIndex);
        Light = vec3(boneIndex.x);

		mediump vec4 boneWeights = weights;
	
		highp mat4 boneMatrix = BoneMatrixArray[boneIndex.x];
		mediump mat3 normalMatrix = BoneMatrixArrayIT[boneIndex.x];
	
		highp vec4 position_out = boneMatrix * vec4(position, 1.0) * boneWeights.x;
		mediump vec3 worldNormal = normalMatrix * normal * boneWeights.x;
		
		mediump vec3 worldTangent;
		mediump vec3 worldBiNormal;
		
		worldTangent = normalMatrix * tagent * boneWeights.x;
		worldBiNormal = normalMatrix * inBiNormal * boneWeights.x;
        int bonec = 4;
        bool use = false;
//		for (lowp int i = 1; i < BoneCount; ++i)
//		{
//				// "rotate" the vector components
//				boneIndex = boneIndex.yzwx;
//				boneWeights = boneWeights.yzwx;
//			
//				boneMatrix = BoneMatrixArray[boneIndex.x];
//				normalMatrix = BoneMatrixArrayIT[boneIndex.x];
//
//				position_out += boneMatrix * vec4(position, 1.0) * boneWeights.x;
//				worldNormal += normalMatrix * normal * boneWeights.x;
//				
//				//if(bUseDot3)
//                if(use)
//				{
//					worldTangent += normalMatrix * tagent * boneWeights.x;
//					worldBiNormal += normalMatrix * inBiNormal * boneWeights.x;
//				}
//		}
    
		gl_Position = ViewProjMatrix * position_out;
		
		// lighting
		//mediump vec3 TmpLightDir = normalize(LightPos - position.xyz);
        mediump vec3 TmpLightDir = normalize(vec3(0, 10, 0) - position_out.xyz);
    
//		Light.x = dot(normalize(worldTangent), TmpLightDir);
//		Light.y = dot(normalize(worldBiNormal), TmpLightDir);
//		Light.z = dot(normalize(worldNormal), TmpLightDir);
		
	// Pass through texcoords
	TexCoord = texcoord;
}
 
