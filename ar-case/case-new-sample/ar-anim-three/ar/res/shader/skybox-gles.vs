
attribute vec3 position;

uniform mat4 modelMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

varying vec3 vWorldPosition;

vec3 transformDirection( in vec3 dir, in mat4 matrix ) {
	return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );
}

void main() {

	vWorldPosition = position;

	vec4 mvPosition = modelViewMatrix * vec4( position.xyz, 1.0 );
    gl_Position = projectionMatrix * mvPosition;

}
