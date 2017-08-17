attribute vec3 position;

uniform mat4 lightSpaceMatrix;
uniform mat4 modelMatrix;

attribute vec4 skinIndex;
attribute vec4 skinWeight;

uniform mat4 boneMatrices[12];
uniform int boneCount;

mat4 getBoneMatrix( const in float i ) {
    mat4 bone = boneMatrices[ int(i) ];
    return bone;
}

void main()
{
    if (boneCount > 0) {
        mat4 boneMatX = getBoneMatrix( skinIndex.x );
        mat4 boneMatY = getBoneMatrix( skinIndex.y );
        mat4 boneMatZ = getBoneMatrix( skinIndex.z );
        mat4 boneMatW = getBoneMatrix( skinIndex.w );
        
        vec4 skinVertex = vec4(position, 1.0 );
        
        vec4 skinned = vec4( 0.0 );
        skinned += boneMatX * skinVertex * skinWeight.x;
        if (boneCount > 1) skinned += boneMatY * skinVertex * skinWeight.y;
        if (boneCount > 2) skinned += boneMatZ * skinVertex * skinWeight.z;
        if (boneCount > 3) skinned += boneMatW * skinVertex * skinWeight.w;
        
        gl_Position = lightSpaceMatrix * modelMatrix * skinned;
    } else {
        gl_Position = lightSpaceMatrix * modelMatrix * vec4(position, 1.0);
    }
}
