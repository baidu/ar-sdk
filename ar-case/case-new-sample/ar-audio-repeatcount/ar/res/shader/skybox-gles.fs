precision highp float;
precision highp int;

uniform samplerCube tCube;

varying vec3 vWorldPosition;

void main() {

	gl_FragColor = textureCube( tCube, vec3( vWorldPosition.x, vWorldPosition.yz ) );

}
