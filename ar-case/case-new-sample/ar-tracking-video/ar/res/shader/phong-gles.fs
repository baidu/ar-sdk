precision mediump float;

varying vec3 object_position;
varying vec3 object_normal;
varying vec2 object_texcoord;

uniform vec3 eyePos;

struct Materal 
{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
};

struct Attenuation 
{
    float constant;
    float linear;
    float exponent;
};

struct LightWeight
{
    float ambientStrength;
    float diffuseStrength;
    float specularStrength;
};

struct BaseLight
{
    vec3 color;
    float intensity;
    LightWeight lightWeight;
};

struct DirectionalLight
{
    vec3 direction;
    BaseLight base;
};

struct PointLight
{
    BaseLight base;
    Attenuation attenuation;
    vec3 position;
    float range;
};

struct SpotLight
{
    BaseLight base;
    Attenuation attenuation;
    vec3 position;
    float range;
    vec3 direction;
    float cutoff;
    float outerCutoff;
};

uniform int directionalLightCount;
uniform DirectionalLight directionalLight[2];
uniform int pointLightCount;
uniform PointLight pointLight[2];
uniform int spotLightCount;
uniform SpotLight spotLight[2];
uniform Materal materialNature;

uniform sampler2D normalMap;
uniform sampler2D specularMap;
uniform sampler2D diffuseMap;

vec3 calculateDirectionalLight(DirectionalLight light, vec3 ambientNature, vec3 diffuseNature, vec3 specularNature) {
    //calculate ambient light
    float ambient = light.base.lightWeight.ambientStrength;
    vec3 ambientColor = ambient * ambientNature;
    
    //calculate diffuse light
    vec3 normal = normalize(object_normal);
    vec3 light_dir = normalize(light.direction);
    float light_projection = max(dot(light_dir, normal), 0.0);
    float diffuse = light_projection * light.base.lightWeight.diffuseStrength;
    vec3 diffuseColor = 1.0 * diffuse * diffuseNature;
    
    //calculate specular light
    vec3 view_dir = normalize(eyePos - object_position);
    vec3 reflect_dir = reflect(-light_dir, normal);
    float light_project_view = max(dot(view_dir, reflect_dir), 0.0);
    float shininess = pow(light_project_view, materialNature.shininess);
    float specular = light.base.lightWeight.specularStrength * shininess;
    vec3 specularColor = 1.0 * specular * specularNature;
    
    //sum all
    vec3 out_color = (ambientColor + diffuseColor + specularColor) *
    light.base.color * light.base.intensity;
    
    return out_color;
}

vec3 calculatePointLight(PointLight light, vec3 ambientNature, vec3 diffuseNature, vec3 specularNature) {
    //calculate ambient light
    float ambient = light.base.lightWeight.ambientStrength;
    vec3 ambientColor = ambient * ambientNature;
    
    //calculate diffuse light
    vec3 normal = normalize(object_normal);
    vec3 light_dir = normalize(light.position - object_position);
    float light_projection = max(dot(light_dir, normal), 0.0);
    float diffuse = light_projection * light.base.lightWeight.diffuseStrength;
    vec3 diffuseColor = 1.0 * diffuse * diffuseNature;
    
    //calculate specular light
    vec3 view_dir = normalize(eyePos - object_position);
    vec3 reflect_dir = reflect(-light_dir, normal);
    float light_project_view = max(dot(view_dir, reflect_dir), 0.0);
    float shininess = pow(light_project_view, materialNature.shininess);
    float specular = light.base.lightWeight.specularStrength * shininess;
    vec3 specularColor = 1.0 * specular * specularNature;
    
    float distance_to_point = length(light_dir);
    float attenuation = light.attenuation.constant
    + light.attenuation.linear * distance_to_point
    + light.attenuation.exponent * distance_to_point * distance_to_point
    + 0.0001;
    
    //sum all
    vec3 out_color = (ambientColor + diffuseColor + specularColor) *
    light.base.color * light.base.intensity / attenuation;

    return out_color;
}

vec3 calculateSpotLight(SpotLight light, vec3 ambientNature, vec3 diffuseNature, vec3 specularNature) {

    //calculate ambient light
    float ambient = light.base.lightWeight.ambientStrength;
    vec3 ambientColor = ambient * ambientNature;
    
    //calculate diffuse light
    vec3 normal = normalize(object_normal);
    vec3 light_dir = normalize(light.position - object_position);
    float light_projection = max(dot(light_dir, normal), 0.0);
    float diffuse = light_projection * light.base.lightWeight.diffuseStrength;
    vec3 diffuseColor = 1.0 * diffuse * diffuseNature;
    
    //calculate specular light
    vec3 view_dir = normalize(eyePos - object_position);
    vec3 reflect_dir = reflect(-light_dir, normal);
    float light_project_view = max(dot(view_dir, reflect_dir), 0.0);
    float shininess = pow(light_project_view, materialNature.shininess);
    float specular = light.base.lightWeight.specularStrength * shininess;
    vec3 specularColor = 1.0 * specular * specularNature;
    
    float distance_to_point = length(light_dir);
    float attenuation = light.attenuation.constant
    + light.attenuation.linear * distance_to_point
    + light.attenuation.exponent * distance_to_point * distance_to_point
    + 0.0001;
    
    //sum all

    float theta = dot(light_dir, normalize(light.direction));
    float epsilon = light.cutoff - light.outerCutoff;
    float spotIntensity = clamp((theta - light.outerCutoff) / epsilon,0.0, 1.0);    
    
    vec3 out_color = (ambientColor + diffuseColor * spotIntensity + specularColor * spotIntensity) * light.base.color * light.base.intensity / attenuation;
    
    return out_color;
    //gl_FragColor = vec4(out_color , 1.0);
    //gl_FragColor = vec4(vec3(spotIntensity,0, 0), 1.0);
}
void main() {
    vec3 output_color = vec3(0);
    
    // vec3 diffuseNature = vec3(texture2D(diffuseMap, object_texcoord));
    // vec3 specularNature = vec3(texture2D(specularMap, object_texcoord));
     vec3 diffuseNature = materialNature.diffuse;
     vec3 specularNature = materialNature.specular;

    for (int i = 0; i < directionalLightCount; i++)
    output_color += calculateDirectionalLight(directionalLight[i], diffuseNature, diffuseNature, specularNature);
    
    for (int i = 0; i < pointLightCount; i++)
    output_color += calculatePointLight(pointLight[i], diffuseNature, diffuseNature, specularNature);
    
    for (int i = 0; i < spotLightCount; i++)
    output_color += calculateSpotLight(spotLight[i], diffuseNature, diffuseNature, specularNature);
    
    gl_FragColor = vec4(vec3(output_color), 1.0);
    //gl_FragColor = vec4(vec3(materialNature.shininess), 1.0);
}

