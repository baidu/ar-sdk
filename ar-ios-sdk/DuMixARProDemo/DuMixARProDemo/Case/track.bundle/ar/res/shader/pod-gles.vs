#define MAX_BONE_COUNT 10

precision mediump float;

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

uniform mediump	int	 BoneCount;

uniform highp   mat4 BoneMatrixArray[MAX_BONE_COUNT];
uniform highp   mat3 BoneMatrixArrayIT[MAX_BONE_COUNT];

varying vec3 object_position;
varying vec3 object_normal;
varying vec2 object_texcoord;

void main()
{
    mat4 ViewProjMatrix = Proj * View * World;
    
    // On PowerVR SGX it is possible to index the components of a vector
    // with the [] operator. However this can cause trouble with PC
    // emulation on some hardware so we "rotate" the vectors instead.
    mediump ivec4 boneIndex = ivec4(inBoneIndex);
    
    mediump vec4 boneWeights = weights;
    
    highp mat4 boneMatrix = BoneMatrixArray[boneIndex.x];
    mediump mat3 normalMatrix = BoneMatrixArrayIT[boneIndex.x];
    
    highp vec4 position_out = boneMatrix * vec4(position, 1.0) * boneWeights.x;
    mediump vec3 worldNormal = normalMatrix * normal * boneWeights.x;
    
    for (lowp int i = 1; i < BoneCount; ++i)
    {
        // "rotate" the vector components
        boneIndex = boneIndex.yzwx;
        boneWeights = boneWeights.yzwx;
        
        boneMatrix = BoneMatrixArray[boneIndex.x];
        normalMatrix = BoneMatrixArrayIT[boneIndex.x];
        
        position_out += boneMatrix * vec4(position, 1.0) * boneWeights.x;
        worldNormal += normalMatrix * normal * boneWeights.x;
    }

    gl_Position = ViewProjMatrix * position_out;
    object_position = vec3(World * position_out);
    object_normal = vec3(World * vec4(normal, 0.0));
    object_texcoord = texcoord;
}

