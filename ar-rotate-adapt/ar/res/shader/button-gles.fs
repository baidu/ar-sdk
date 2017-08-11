precision mediump float;

varying vec3 object_position;
varying vec3 object_normal;
varying vec2 object_texcoord;

uniform sampler2D diffuseMap;

void main() {
    vec3 output_color = vec3(0);
    
    vec3 diffuseNature = vec3(texture2D(diffuseMap, object_texcoord));
    
    gl_FragColor = vec4(vec3(diffuseNature), 1.0);
    //gl_FragColor = vec4(vec3(materialNature.shininess), 1.0);
}

