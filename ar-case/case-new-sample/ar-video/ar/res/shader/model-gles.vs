precision mediump float;

attribute vec3 position;
attribute vec3 normal;
attribute vec2 texcoord;
attribute vec4 bones;
attribute vec4 weights;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

uniform mat4 skinningMatrix[60];

varying vec3 object_position;
varying vec3 object_normal;
varying vec2 object_texcoord;

void main()
{
    mat4 mvp = Proj * View * World;
    
    mat4 BoneTransform = skinningMatrix[int(bones[0])] * weights[0];
    if (int(bones[1]) > -1) {
        BoneTransform += skinningMatrix[int(bones[1])] * weights[1];
    }
    if (int(bones[2]) > -1) {
        BoneTransform += skinningMatrix[int(bones[2])] * weights[2];
    }
    if (int(bones[3]) > -1) {
        BoneTransform += skinningMatrix[int(bones[3])] * weights[3];
    }
    gl_Position = mvp * BoneTransform * vec4(position, 1.0);
    
    object_normal = vec3(normalize(World * BoneTransform * vec4(normal,0.0)));
    object_texcoord = texcoord;
    object_position = vec3(World * BoneTransform * vec4(position, 1.0));
    
}
