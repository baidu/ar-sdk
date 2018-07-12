precision mediump float;

varying vec3 frag_normal;
varying vec3 frag_position;
varying vec3 light_position;
varying vec2 frag_texCoord;

varying vec4 frag_lightView;

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

uniform vec3 eyePos;

uniform sampler2D normalMap;
uniform sampler2D specularMap;

uniform sampler2D diffuseMap;

uniform sampler2D shadowMap;

uniform mat4 lightView;

float ShadowCalculation(vec4 fragPosLightSpace, float bias)
{
    // bias = 0.005;
    
    // 执行透视除法
    vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
    // 变换到[0,1]的范围
    projCoords = projCoords * 0.5 + 0.5;
    // 取得最近点的深度(使用[0,1]范围下的fragPosLight当坐标)
    
    float closestDepth = texture2D(shadowMap, projCoords.xy).r;
    // 取得当前片元在光源视角下的深度
    float currentDepth = projCoords.z;
    // 检查当前片元是否在阴影中
    float shadow = (currentDepth - bias)  > closestDepth ? 1.0 : 0.0;
    
    return shadow;
}

vec3 calculateDirectionalLight(DirectionalLight light) {
    float ambient = light.base.lightWeight.ambientStrength;
    
    vec3 norm = normalize(frag_normal);
    vec3 lightDirection = light.direction;
    vec3 light_dir = normalize(lightDirection);
    
    float diff = max(dot(light_dir, norm), 0.0);
    float diffuse = diff * light.base.lightWeight.diffuseStrength;
    
    
    vec3 viewDir = normalize(eyePos - frag_position);
    vec3 reflectDir = reflect(-light_dir, norm);
    
    float test1 = max(dot(viewDir, reflectDir), 0.0);
    float testpow = 1.0;
    float spec = pow(test1, testpow);
    float specular = light.base.lightWeight.specularStrength * spec;
    
    vec3 ambientColor = ambient * vec3(texture2D(diffuseMap, frag_texCoord));
    //vec3 diffuseColor = (1.0 - shadow) * diffuse * vec3(texture2D(diffuseMap, frag_texCoord));
    //vec3 specularColor = (1.0 - shadow) * specular * vec3(texture2D(specularMap, frag_texCoord));
    vec3 diffuseColor = 1.0 * diffuse * vec3(texture2D(diffuseMap, frag_texCoord));
    vec3 specularColor = 1.0 * specular * vec3(texture2D(specularMap, frag_texCoord));
    
    
    vec3 out_color = (ambientColor + diffuseColor + specularColor) *
    light.base.color * light.base.intensity;
    
    return out_color;
}

vec3 calculatePointLight(PointLight light) {
    float ambient = light.base.lightWeight.ambientStrength;
    
    vec3 norm = normalize(frag_normal);
    vec3 lightDirection = light.position - frag_position;
    float distanceToPoint = length(lightDirection);
    
    vec3 light_dir = normalize(lightDirection);
    //vec3 light_dir = normalize(directionalLight.direction);
    float diff = max(dot(light_dir, norm), 0.0);
    float diffuse = diff * light.base.lightWeight.diffuseStrength;
    
    
    vec3 viewDir = normalize(eyePos - frag_position);
    vec3 reflectDir = reflect(-light_dir, norm);
    
    float test1 = max(dot(viewDir, reflectDir), 0.0);
    float testpow = 1.0;
    float spec = pow(test1, testpow);
    float specular = light.base.lightWeight.specularStrength * spec;
    
    float attenuation = light.attenuation.constant
    + light.attenuation.linear * distanceToPoint
    + light.attenuation.exponent * distanceToPoint * distanceToPoint
    + 0.0001;
    
    vec3 ambientColor = ambient * vec3(texture2D(diffuseMap, frag_texCoord));
    vec3 diffuseColor = diffuse *  vec3(texture2D(diffuseMap, frag_texCoord));
    vec3 specularColor = specular *  vec3(texture2D(specularMap, frag_texCoord));
    vec3 out_color = (ambientColor + diffuseColor + specularColor) * light.base.color * light.base.intensity / attenuation;
    
    return out_color;
}

vec3 calculateSpotLight(SpotLight light) {
    float ambient = light.base.lightWeight.ambientStrength;
    
    vec3 norm = normalize(frag_normal);
    vec3 lightDirection = light.position - frag_position;
    float distanceToPoint = length(lightDirection);
    
    vec3 light_dir = normalize(lightDirection);
    
    float diff = max(dot(light_dir, norm), 0.0);
    float diffuse = diff * light.base.lightWeight.diffuseStrength;
    
    vec3 viewDir = normalize(eyePos - frag_position);
    vec3 reflectDir = reflect(-light_dir, norm);
    
    float test1 = max(dot(viewDir, reflectDir), 0.0);
    float testpow = 1.0;
    float spec = pow(test1, testpow);
    float specular = light.base.lightWeight.specularStrength * spec;
    
    float attenuation = light.attenuation.constant
    + light.attenuation.linear * distanceToPoint
    + light.attenuation.exponent * distanceToPoint * distanceToPoint
    + 0.0001;
    
    
    float theta = dot(light_dir, normalize(light.direction));
    
    float epsilon = light.cutoff - light.outerCutoff;
    float spotIntensity = clamp((theta - light.outerCutoff) / epsilon,0.0, 1.0);
    
    vec3 ambientColor = ambient * vec3(texture2D(diffuseMap, frag_texCoord));
    vec3 diffuseColor = diffuse * spotIntensity * vec3(texture2D(diffuseMap, frag_texCoord));
    vec3 specularColor = specular * spotIntensity * vec3(texture2D(specularMap, frag_texCoord));

    
    vec3 out_color = (ambientColor + diffuseColor + specularColor) * light.base.color * light.base.intensity / attenuation;
    
    return out_color;
}
void main() {
    if ((directionalLightCount + pointLightCount + spotLightCount) > 0) {
        vec3 output_color = vec3(0);
        for (int i = 0; i < directionalLightCount; i++)
            output_color += calculateDirectionalLight(directionalLight[i]);
        
        for (int i = 0; i < pointLightCount; i++)
            output_color += calculatePointLight(pointLight[i]);
        
        for (int i = 0; i < spotLightCount; i++)
            output_color += calculateSpotLight(spotLight[i]);
        
        gl_FragColor = vec4(vec3(output_color), frag_texCoord);
    } else {
        gl_FragColor = texture2D(diffuseMap, frag_texCoord);
    }
    
}

