
#define LAMBERT 
 
varying vec3 vLightFront; 
 
#ifdef DOUBLE_SIDED 
 
    varying vec3 vLightBack; 
 
#endif 
 
#define PI 3.14159265359 
#define PI2 6.28318530718 
#define PI_HALF 1.5707963267949 
#define RECIPROCAL_PI 0.31830988618 
#define RECIPROCAL_PI2 0.15915494 
#define LOG2 1.442695 
#define EPSILON 1e-6 
 
#define saturate(a) clamp( a, 0.0, 1.0 ) 
#define whiteCompliment(a) ( 1.0 - saturate( a ) ) 
 
float pow2( const in float x ) { return x*x; } 
float pow3( const in float x ) { return x*x*x; } 
float pow4( const in float x ) { float x2 = x*x; return x2*x2; } 
float average( const in vec3 color ) { return dot( color, vec3( 0.3333 ) ); } 
// expects values in the range of [0,1]x[0,1], returns values in the [0,1] range. 
// do not collapse into a single function per: http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/ 
highp float rand( const in vec2 uv ) { 
    const highp float a = 12.9898, b = 78.233, c = 43758.5453; 
    highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI ); 
    return fract(sin(sn) * c); 
} 
 
struct IncidentLight { 
    vec3 color; 
    vec3 direction; 
    bool visible; 
}; 
 
struct ReflectedLight { 
    vec3 directDiffuse; 
    vec3 directSpecular; 
    vec3 indirectDiffuse; 
    vec3 indirectSpecular; 
}; 
 
struct GeometricContext { 
    vec3 position; 
    vec3 normal; 
    vec3 viewDir; 
}; 
 
vec3 transformDirection( in vec3 dir, in mat4 matrix ) { 
 
    return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz ); 
 
} 
 
// http://en.wikibooks.org/wiki/GLSL_Programming/Applying_Matrix_Transformations 
vec3 inverseTransformDirection( in vec3 dir, in mat4 matrix ) { 
 
    return normalize( ( vec4( dir, 0.0 ) * matrix ).xyz ); 
 
} 
 
vec3 projectOnPlane(in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) { 
 
    float distance = dot( planeNormal, point - pointOnPlane ); 
 
    return - distance * planeNormal + point; 
 
} 
 
float sideOfPlane( in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) { 
 
    return sign( dot( point - pointOnPlane, planeNormal ) ); 
 
} 
 
vec3 linePlaneIntersect( in vec3 pointOnLine, in vec3 lineDirection, in vec3 pointOnPlane, in vec3 planeNormal ) { 
 
    return lineDirection * ( dot( planeNormal, pointOnPlane - pointOnLine ) / dot( planeNormal, lineDirection ) ) + pointOnLine; 
 
} 
 
mat3 transpose( in mat3 v ) { 
 
    mat3 tmp; 
    tmp[0] = vec3(v[0].x, v[1].x, v[2].x); 
    tmp[1] = vec3(v[0].y, v[1].y, v[2].y); 
    tmp[2] = vec3(v[0].z, v[1].z, v[2].z); 
 
    return tmp; 
 
}

#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP ) || defined( USE_ALPHAMAP ) || defined( USE_EMISSIVEMAP ) || defined( USE_ROUGHNESSMAP ) || defined( USE_METALNESSMAP ) 
 
    varying vec2 vUv; 
    uniform vec4 offsetRepeat; 
 
#endif
#if defined( USE_LIGHTMAP ) || defined( USE_AOMAP ) 
 
    attribute vec2 uv2; 
    varying vec2 vUv2; 
 
#endif

#ifdef USE_ENVMAP 
 
    #if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) 
        varying vec3 vWorldPosition; 
 
    #else 
 
        varying vec3 vReflect; 
        uniform float refractionRatio; 
 
    #endif 
 
#endif
float punctualLightIntensityToIrradianceFactor( const in float lightDistance, const in float cutoffDistance, const in float decayExponent ) { 
 
        if( decayExponent > 0.0 ) { 
 
#if defined ( PHYSICALLY_CORRECT_LIGHTS ) 
 
            // based upon Frostbite 3 Moving to Physically-based Rendering 
            // page 32, equation 26: E[window1] 
            // http://www.frostbite.com/wp-content/uploads/2014/11/course_notes_moving_frostbite_to_pbr_v2.pdf 
            // this is intended to be used on spot and point lights who are represented as luminous intensity 
            // but who must be converted to luminous irradiance for surface lighting calculation 
            float distanceFalloff = 1.0 / max( pow( lightDistance, decayExponent ), 0.01 ); 
            float maxDistanceCutoffFactor = pow2( saturate( 1.0 - pow4( lightDistance / cutoffDistance ) ) ); 
            return distanceFalloff * maxDistanceCutoffFactor; 
 
#else 
 
            return pow( saturate( -lightDistance / cutoffDistance + 1.0 ), decayExponent ); 
 
#endif 
 
        } 
 
        return 1.0; 
} 
 
vec3 BRDF_Diffuse_Lambert( const in vec3 diffuseColor ) { 
 
    return RECIPROCAL_PI * diffuseColor; 
 
} // validated 
 
 
vec3 F_Schlick( const in vec3 specularColor, const in float dotLH ) { 
 
    // Original approximation by Christophe Schlick '94 
    //;float fresnel = pow( 1.0 - dotLH, 5.0 ); 
 
    // Optimized variant (presented by Epic at SIGGRAPH '13) 
    float fresnel = exp2( ( -5.55473 * dotLH - 6.98316 ) * dotLH ); 
 
    return ( 1.0 - specularColor ) * fresnel + specularColor; 
 
} // validated 
 
 
// Microfacet Models for Refraction through Rough Surfaces - equation (34) 
// http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html 
// alpha is "roughness squared" in Disney’s reparameterization 
float G_GGX_Smith( const in float alpha, const in float dotNL, const in float dotNV ) { 
 
    // geometry term = G(l)*G(v) / 4(n*l)(n*v) 
 
    float a2 = pow2( alpha ); 
 
    float gl = dotNL + sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) ); 
    float gv = dotNV + sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) ); 
 
    return 1.0 / ( gl * gv ); 
 
} // validated 
 
// from page 12, listing 2 of http://www.frostbite.com/wp-content/uploads/2014/11/course_notes_moving_frostbite_to_pbr_v2.pdf 
float G_GGX_SmithCorrelated( const in float alpha, const in float dotNL, const in float dotNV ) { 
 
    float a2 = pow2( alpha ); 
 
    // dotNL and dotNV are explicitly swapped. This is not a mistake. 
    float gv = dotNL * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) ); 
    float gl = dotNV * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) ); 
 
    return 0.5 / max( gv + gl, EPSILON ); 
} 
 
 
 
// Microfacet Models for Refraction through Rough Surfaces - equation (33) 
// http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html 
// alpha is "roughness squared" in Disney’s reparameterization 
float D_GGX( const in float alpha, const in float dotNH ) { 
 
    float a2 = pow2( alpha ); 
 
    float denom = pow2( dotNH ) * ( a2 - 1.0 ) + 1.0; // avoid alpha = 0 with dotNH = 1 
 
    return RECIPROCAL_PI * a2 / pow2( denom ); 
 
} 
 
 
// GGX Distribution, Schlick Fresnel, GGX-Smith Visibility 
vec3 BRDF_Specular_GGX( const in IncidentLight incidentLight, const in GeometricContext geometry, const in vec3 specularColor, const in float roughness ) { 
 
    float alpha = pow2( roughness ); // UE4's roughness 
 
    vec3 halfDir = normalize( incidentLight.direction + geometry.viewDir ); 
 
    float dotNL = saturate( dot( geometry.normal, incidentLight.direction ) ); 
    float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) ); 
    float dotNH = saturate( dot( geometry.normal, halfDir ) ); 
    float dotLH = saturate( dot( incidentLight.direction, halfDir ) ); 
 
    vec3 F = F_Schlick( specularColor, dotLH ); 
 
    float G = G_GGX_SmithCorrelated( alpha, dotNL, dotNV ); 
 
    float D = D_GGX( alpha, dotNH ); 
 
    return F * ( G * D ); 
 
} // validated 
 
// 
// Rect Area Light BRDF Approximations 
// 
 
// Area light computation code adapted from: 
// http://blog.selfshadow.com/sandbox/ltc.html 
// 
// Based on paper: 
// Real-Time Polygonal-Light Shading with Linearly Transformed Cosines 
// By: Eric Heitz, Jonathan Dupuy, Stephen Hill and David Neubelt 
// https://eheitzresearch.wordpress.com/415-2/ 
 
vec2 ltcTextureCoords( const in GeometricContext geometry, const in float roughness ) { 
 
    const float LUT_SIZE  = 64.0; 
    const float LUT_SCALE = (LUT_SIZE - 1.0)/LUT_SIZE; 
    const float LUT_BIAS  = 0.5/LUT_SIZE; 
 
    vec3 N = geometry.normal; 
    vec3 V = geometry.viewDir; 
    vec3 P = geometry.position; 
 
    // view angle on surface determines which LTC BRDF values we use 
    float theta = acos( dot( N, V ) ); 
 
    // Parameterization of texture: 
    // sqrt(roughness) -> [0,1] 
    // theta -> [0, PI/2] 
    vec2 uv = vec2( 
        sqrt( saturate( roughness ) ), 
        saturate( theta / ( 0.5 * PI ) ) ); 
 
    // Ensure we don't have nonlinearities at the look-up table's edges 
    // see: http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter24.html 
    //      "Shader Analysis" section 
    uv = uv * LUT_SCALE + LUT_BIAS; 
 
    return uv; 
 
} 
 
void clipQuadToHorizon( inout vec3 L[5], out int n ) { 
 
    // detect clipping config 
    int config = 0; 
    if ( L[0].z > 0.0 ) config += 1; 
    if ( L[1].z > 0.0 ) config += 2; 
    if ( L[2].z > 0.0 ) config += 4; 
    if ( L[3].z > 0.0 ) config += 8; 
 
    // clip 
    n = 0; 
 
    if ( config == 0 ) { 
 
        // clip all 
 
    } else if ( config == 1 ) { 
 
        // V1 clip V2 V3 V4 
        n = 3; 
        L[1] = -L[1].z * L[0] + L[0].z * L[1]; 
        L[2] = -L[3].z * L[0] + L[0].z * L[3]; 
 
    } else if ( config == 2 ) { 
 
        // V2 clip V1 V3 V4 
        n = 3; 
        L[0] = -L[0].z * L[1] + L[1].z * L[0]; 
        L[2] = -L[2].z * L[1] + L[1].z * L[2]; 
 
    } else if ( config == 3 ) { 
 
        // V1 V2 clip V3 V4 
        n = 4; 
        L[2] = -L[2].z * L[1] + L[1].z * L[2]; 
        L[3] = -L[3].z * L[0] + L[0].z * L[3]; 
 
    } else if ( config == 4 ) { 
 
        // V3 clip V1 V2 V4 
        n = 3; 
        L[0] = -L[3].z * L[2] + L[2].z * L[3]; 
        L[1] = -L[1].z * L[2] + L[2].z * L[1]; 
 
    } else if ( config == 5 ) { 
 
        // V1 V3 clip V2 V4) impossible 
        n = 0; 
 
    } else if ( config == 6 ) { 
 
        // V2 V3 clip V1 V4 
        n = 4; 
        L[0] = -L[0].z * L[1] + L[1].z * L[0]; 
        L[3] = -L[3].z * L[2] + L[2].z * L[3]; 
 
    } else if ( config == 7 ) { 
 
        // V1 V2 V3 clip V4 
        n = 5; 
        L[4] = -L[3].z * L[0] + L[0].z * L[3]; 
        L[3] = -L[3].z * L[2] + L[2].z * L[3]; 
 
    } else if ( config == 8 ) { 
 
        // V4 clip V1 V2 V3 
        n = 3; 
        L[0] = -L[0].z * L[3] + L[3].z * L[0]; 
        L[1] = -L[2].z * L[3] + L[3].z * L[2]; 
        L[2] =  L[3]; 
 
    } else if ( config == 9 ) { 
 
        // V1 V4 clip V2 V3 
        n = 4; 
        L[1] = -L[1].z * L[0] + L[0].z * L[1]; 
        L[2] = -L[2].z * L[3] + L[3].z * L[2]; 
 
    } else if ( config == 10 ) { 
 
        // V2 V4 clip V1 V3) impossible 
        n = 0; 
 
    } else if ( config == 11 ) { 
 
        // V1 V2 V4 clip V3 
        n = 5; 
        L[4] = L[3]; 
        L[3] = -L[2].z * L[3] + L[3].z * L[2]; 
        L[2] = -L[2].z * L[1] + L[1].z * L[2]; 
 
    } else if ( config == 12 ) { 
 
        // V3 V4 clip V1 V2 
        n = 4; 
        L[1] = -L[1].z * L[2] + L[2].z * L[1]; 
        L[0] = -L[0].z * L[3] + L[3].z * L[0]; 
 
    } else if ( config == 13 ) { 
 
        // V1 V3 V4 clip V2 
        n = 5; 
        L[4] = L[3]; 
        L[3] = L[2]; 
        L[2] = -L[1].z * L[2] + L[2].z * L[1]; 
        L[1] = -L[1].z * L[0] + L[0].z * L[1]; 
 
    } else if ( config == 14 ) { 
 
        // V2 V3 V4 clip V1 
        n = 5; 
        L[4] = -L[0].z * L[3] + L[3].z * L[0]; 
        L[0] = -L[0].z * L[1] + L[1].z * L[0]; 
 
    } else if ( config == 15 ) { 
 
        // V1 V2 V3 V4 
        n = 4; 
 
    } 
 
    if ( n == 3 ) 
        L[3] = L[0]; 
    if ( n == 4 ) 
        L[4] = L[0]; 
 
} 
 
// Equation (11) of "Real - Time Polygonal - Light Shading with Linearly Transformed Cosines" 
float integrateLtcBrdfOverRectEdge( vec3 v1, vec3 v2 ) { 
 
    float cosTheta = dot( v1, v2 ); 
    float theta = acos( cosTheta ); 
    float res = cross( v1, v2 ).z * ( ( theta > 0.001 ) ? theta / sin( theta ) : 1.0 ); 
 
    return res; 
 
} 
 
void initRectPoints( const in vec3 pos, const in vec3 halfWidth, const in vec3 halfHeight, out vec3 rectPoints[4] ) { 
 
    rectPoints[0] = pos - halfWidth - halfHeight; 
    rectPoints[1] = pos + halfWidth - halfHeight; 
    rectPoints[2] = pos + halfWidth + halfHeight; 
    rectPoints[3] = pos - halfWidth + halfHeight; 
 
} 
 
vec3 integrateLtcBrdfOverRect( const in GeometricContext geometry, const in mat3 brdfMat, const in vec3 rectPoints[4] ) { 
 
    vec3 N = geometry.normal; 
    vec3 V = geometry.viewDir; 
    vec3 P = geometry.position; 
 
    // construct orthonormal basis around N 
    vec3 T1, T2; 
    T1 = normalize(V - N * dot( V, N )); 
    // TODO (abelnation): I had to negate this cross product to get proper light.  Curious why sample code worked without negation 
    T2 = - cross( N, T1 ); 
 
    // rotate area light in (T1, T2, N) basis 
    mat3 brdfWrtSurface = brdfMat * transpose( mat3( T1, T2, N ) ); 
 
    // transformed rect relative to surface point 
    vec3 clippedRect[5]; 
    clippedRect[0] = brdfWrtSurface * ( rectPoints[0] - P ); 
    clippedRect[1] = brdfWrtSurface * ( rectPoints[1] - P ); 
    clippedRect[2] = brdfWrtSurface * ( rectPoints[2] - P ); 
    clippedRect[3] = brdfWrtSurface * ( rectPoints[3] - P ); 
 
    // clip light rect to horizon, resulting in at most 5 points 
    // we do this because we are integrating the BRDF over the hemisphere centered on the surface points normal 
    int n; 
    clipQuadToHorizon(clippedRect, n); 
 
    // light is completely below horizon 
    if ( n == 0 ) 
        return vec3( 0, 0, 0 ); 
 
    // project clipped rect onto sphere 
    clippedRect[0] = normalize( clippedRect[0] ); 
    clippedRect[1] = normalize( clippedRect[1] ); 
    clippedRect[2] = normalize( clippedRect[2] ); 
    clippedRect[3] = normalize( clippedRect[3] ); 
    clippedRect[4] = normalize( clippedRect[4] ); 
 
    // integrate 
    // simplified integration only needs to be evaluated for each edge in the polygon 
    float sum = 0.0; 
    sum += integrateLtcBrdfOverRectEdge( clippedRect[0], clippedRect[1] ); 
    sum += integrateLtcBrdfOverRectEdge( clippedRect[1], clippedRect[2] ); 
    sum += integrateLtcBrdfOverRectEdge( clippedRect[2], clippedRect[3] ); 
    if (n >= 4) 
        sum += integrateLtcBrdfOverRectEdge( clippedRect[3], clippedRect[4] ); 
    if (n == 5) 
        sum += integrateLtcBrdfOverRectEdge( clippedRect[4], clippedRect[0] ); 
 
    // TODO (abelnation): two-sided area light 
    // sum = twoSided ? abs(sum) : max(0.0, sum); 
    sum = max( 0.0, sum ); 
    // sum = abs( sum ); 
 
    vec3 Lo_i = vec3( sum, sum, sum ); 
 
    return Lo_i; 
 
} 
 
vec3 Rect_Area_Light_Specular_Reflectance( 
        const in GeometricContext geometry, 
        const in vec3 lightPos, const in vec3 lightHalfWidth, const in vec3 lightHalfHeight, 
        const in float roughness, 
        const in sampler2D ltcMat, const in sampler2D ltcMag ) { 
 
    vec3 rectPoints[4]; 
    initRectPoints( lightPos, lightHalfWidth, lightHalfHeight, rectPoints ); 
 
    vec2 uv = ltcTextureCoords( geometry, roughness ); 
 
    vec4 brdfLtcApproxParams, t; 
 
    brdfLtcApproxParams = texture2D( ltcMat, uv ); 
    t = texture2D( ltcMat, uv ); 
 
    float brdfLtcScalar = texture2D( ltcMag, uv ).a; 
 
    // inv(M) matrix referenced by equation (6) in paper 
    mat3 brdfLtcApproxMat = mat3( 
        vec3(   1,   0, t.y ), 
        vec3(   0, t.z,   0 ), 
        vec3( t.w,   0, t.x ) 
    ); 
 
    vec3 specularReflectance = integrateLtcBrdfOverRect( geometry, brdfLtcApproxMat, rectPoints ); 
    specularReflectance *= brdfLtcScalar; 
 
    return specularReflectance; 
 
} 
 
vec3 Rect_Area_Light_Diffuse_Reflectance( 
        const in GeometricContext geometry, 
        const in vec3 lightPos, const in vec3 lightHalfWidth, const in vec3 lightHalfHeight ) { 
 
    vec3 rectPoints[4]; 
    initRectPoints( lightPos, lightHalfWidth, lightHalfHeight, rectPoints ); 
 
    mat3 diffuseBrdfMat = mat3(1); 
    vec3 diffuseReflectance = integrateLtcBrdfOverRect( geometry, diffuseBrdfMat, rectPoints ); 
 
    return diffuseReflectance; 
 
} 
// End RectArea BRDF 
 
// ref: https://www.unrealengine.com/blog/physically-based-shading-on-mobile - environmentBRDF for GGX on mobile 
vec3 BRDF_Specular_GGX_Environment( const in GeometricContext geometry, const in vec3 specularColor, const in float roughness ) { 
 
    float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) ); 
 
    const vec4 c0 = vec4( - 1, - 0.0275, - 0.572, 0.022 ); 
 
    const vec4 c1 = vec4( 1, 0.0425, 1.04, - 0.04 ); 
 
    vec4 r = roughness * c0 + c1; 
 
    float a004 = min( r.x * r.x, exp2( - 9.28 * dotNV ) ) * r.x + r.y; 
 
    vec2 AB = vec2( -1.04, 1.04 ) * a004 + r.zw; 
 
    return specularColor * AB.x + AB.y; 
 
} // validated 
 
 
float G_BlinnPhong_Implicit( /* const in float dotNL, const in float dotNV */ ) { 
 
    // geometry term is (n dot l)(n dot v) / 4(n dot l)(n dot v) 
    return 0.25; 
 
} 
 
float D_BlinnPhong( const in float shininess, const in float dotNH ) { 
 
    return RECIPROCAL_PI * ( shininess * 0.5 + 1.0 ) * pow( dotNH, shininess ); 
 
} 
 
vec3 BRDF_Specular_BlinnPhong( const in IncidentLight incidentLight, const in GeometricContext geometry, const in vec3 specularColor, const in float shininess ) { 
 
    vec3 halfDir = normalize( incidentLight.direction + geometry.viewDir ); 
 
    //float dotNL = saturate( dot( geometry.normal, incidentLight.direction ) ); 
    //float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) ); 
    float dotNH = saturate( dot( geometry.normal, halfDir ) ); 
    float dotLH = saturate( dot( incidentLight.direction, halfDir ) ); 
 
    vec3 F = F_Schlick( specularColor, dotLH ); 
 
    float G = G_BlinnPhong_Implicit( /* dotNL, dotNV */ ); 
 
    float D = D_BlinnPhong( shininess, dotNH ); 
 
    return F * ( G * D ); 
 
} // validated 
 
// source: http://simonstechblog.blogspot.ca/2011/12/microfacet-brdf.html 
float GGXRoughnessToBlinnExponent( const in float ggxRoughness ) { 
    return ( 2.0 / pow2( ggxRoughness + 0.0001 ) - 2.0 ); 
} 
 
float BlinnExponentToGGXRoughness( const in float blinnExponent ) { 
    return sqrt( 2.0 / ( blinnExponent + 2.0 ) ); 
}uniform vec3 ambientLightColor; 
 
vec3 getAmbientLightIrradiance( const in vec3 ambientLightColor ) { 
 
    vec3 irradiance = ambientLightColor; 
 
    #ifndef PHYSICALLY_CORRECT_LIGHTS 
 
        irradiance *= PI; 
 
    #endif 
 
    return irradiance; 
 
} 
 
#if NUM_DIR_LIGHTS > 0 
 
    struct DirectionalLight { 
        vec3 direction; 
        vec3 color; 
 
        int shadow; 
        float shadowBias; 
        float shadowRadius; 
        vec2 shadowMapSize; 
    }; 
 
    uniform DirectionalLight directionalLights[ NUM_DIR_LIGHTS ]; 
 
    void getDirectionalDirectLightIrradiance( const in DirectionalLight directionalLight, const in GeometricContext geometry, out IncidentLight directLight ) { 
 
        directLight.color = directionalLight.color; 
        directLight.direction = directionalLight.direction; 
        directLight.visible = true; 
 
    } 
 
#endif 
 
 
#if NUM_POINT_LIGHTS > 0 
 
    struct PointLight { 
        vec3 position; 
        vec3 color; 
        float distance; 
        float decay; 
 
        int shadow; 
        float shadowBias; 
        float shadowRadius; 
        vec2 shadowMapSize; 
    }; 
 
    uniform PointLight pointLights[ NUM_POINT_LIGHTS ]; 
 
    // directLight is an out parameter as having it as a return value caused compiler errors on some devices 
    void getPointDirectLightIrradiance( const in PointLight pointLight, const in GeometricContext geometry, out IncidentLight directLight ) { 
 
        vec3 lVector = pointLight.position - geometry.position; 
        directLight.direction = normalize( lVector ); 
 
        float lightDistance = length( lVector ); 
 
        directLight.color = pointLight.color; 
        directLight.color *= punctualLightIntensityToIrradianceFactor( lightDistance, pointLight.distance, pointLight.decay ); 
        directLight.visible = ( directLight.color != vec3( 0.0 ) ); 
 
    } 
 
#endif 
 
 
#if NUM_SPOT_LIGHTS > 0 
 
    struct SpotLight { 
        vec3 position; 
        vec3 direction; 
        vec3 color; 
        float distance; 
        float decay; 
        float coneCos; 
        float penumbraCos; 
 
        int shadow; 
        float shadowBias; 
        float shadowRadius; 
        vec2 shadowMapSize; 
    }; 
 
    uniform SpotLight spotLights[ NUM_SPOT_LIGHTS ]; 
 
    // directLight is an out parameter as having it as a return value caused compiler errors on some devices 
    void getSpotDirectLightIrradiance( const in SpotLight spotLight, const in GeometricContext geometry, out IncidentLight directLight  ) { 
 
        vec3 lVector = spotLight.position - geometry.position; 
        directLight.direction = normalize( lVector ); 
 
        float lightDistance = length( lVector ); 
        float angleCos = dot( directLight.direction, spotLight.direction ); 
 
        if ( angleCos > spotLight.coneCos ) { 
 
            float spotEffect = smoothstep( spotLight.coneCos, spotLight.penumbraCos, angleCos ); 
 
            directLight.color = spotLight.color; 
            directLight.color *= spotEffect * punctualLightIntensityToIrradianceFactor( lightDistance, spotLight.distance, spotLight.decay ); 
            directLight.visible = true; 
 
        } else { 
 
            directLight.color = vec3( 0.0 ); 
            directLight.visible = false; 
 
        } 
    } 
 
#endif 
 
 
#if NUM_RECT_AREA_LIGHTS > 0 
 
    struct RectAreaLight { 

        vec3 color; 
        vec3 position; 
        vec3 halfWidth; 
        vec3 halfHeight; 
    }; 
 
    // Pre-computed values of LinearTransformedCosine approximation of BRDF 
    // BRDF approximation Texture is 64x64 
    uniform sampler2D ltcMat; // RGBA Float 
    uniform sampler2D ltcMag; // Alpha Float (only has w component) 
 
    uniform RectAreaLight rectAreaLights[ NUM_RECT_AREA_LIGHTS ]; 
 
#endif 
 
 
#if NUM_HEMI_LIGHTS > 0 
 
    struct HemisphereLight { 
        vec3 direction; 
        vec3 skyColor; 
        vec3 groundColor; 
    }; 
 
    uniform HemisphereLight hemisphereLights[ NUM_HEMI_LIGHTS ]; 
 
    vec3 getHemisphereLightIrradiance( const in HemisphereLight hemiLight, const in GeometricContext geometry ) { 
 
        float dotNL = dot( geometry.normal, hemiLight.direction ); 
        float hemiDiffuseWeight = 0.5 * dotNL + 0.5; 
 
        vec3 irradiance = mix( hemiLight.groundColor, hemiLight.skyColor, hemiDiffuseWeight ); 
 
        #ifndef PHYSICALLY_CORRECT_LIGHTS 
 
            irradiance *= PI; 
 
        #endif 
 
        return irradiance; 
 
    } 
 
#endif 
 
 
#if defined( USE_ENVMAP ) && defined( PHYSICAL ) 
 
    vec3 getLightProbeIndirectIrradiance( /*const in SpecularLightProbe specularLightProbe,*/ const in GeometricContext geometry, const in int maxMIPLevel ) { 
 
        vec3 worldNormal = inverseTransformDirection( geometry.normal, viewMatrix ); 
 
        #ifdef ENVMAP_TYPE_CUBE 
 
            vec3 queryVec = vec3( flipEnvMap * worldNormal.x, worldNormal.yz ); 
 
            // TODO: replace with properly filtered cubemaps and access the irradiance LOD level, be it the last LOD level 
            // of a specular cubemap, or just the default level of a specially created irradiance cubemap. 
 
            #ifdef TEXTURE_LOD_EXT 
 
                vec4 envMapColor = textureCubeLodEXT( envMap, queryVec, float( maxMIPLevel ) ); 
 
            #else 
 
                // force the bias high to get the last LOD level as it is the most blurred. 
                vec4 envMapColor = textureCube( envMap, queryVec, float( maxMIPLevel ) ); 
 
            #endif 
 
            envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb; 
 
        #elif defined( ENVMAP_TYPE_CUBE_UV ) 
 
            vec3 queryVec = vec3( flipEnvMap * worldNormal.x, worldNormal.yz ); 
            vec4 envMapColor = textureCubeUV( queryVec, 1.0 ); 
 
        #else 
 
            vec4 envMapColor = vec4( 0.0 ); 
 
        #endif 
 
        return PI * envMapColor.rgb * envMapIntensity; 
 
    } 
 
    // taken from here: http://casual-effects.blogspot.ca/2011/08/plausible-environment-lighting-in-two.html 
    float getSpecularMIPLevel( const in float blinnShininessExponent, const in int maxMIPLevel ) { 
 
        //float envMapWidth = pow( 2.0, maxMIPLevelScalar ); 
        //float desiredMIPLevel = log2( envMapWidth * sqrt( 3.0 ) ) - 0.5 * log2( pow2( blinnShininessExponent ) + 1.0 ); 
 
        float maxMIPLevelScalar = float( maxMIPLevel ); 
        float desiredMIPLevel = maxMIPLevelScalar - 0.79248 - 0.5 * log2( pow2( blinnShininessExponent ) + 1.0 ); 
 
        // clamp to allowable LOD ranges. 
        return clamp( desiredMIPLevel, 0.0, maxMIPLevelScalar ); 
 
    } 
 
    vec3 getLightProbeIndirectRadiance( /*const in SpecularLightProbe specularLightProbe,*/ const in GeometricContext geometry, const in float blinnShininessExponent, const in int maxMIPLevel ) { 
 
        #ifdef ENVMAP_MODE_REFLECTION 
 
            vec3 reflectVec = reflect( -geometry.viewDir, geometry.normal ); 
 
        #else 
 
            vec3 reflectVec = refract( -geometry.viewDir, geometry.normal, refractionRatio ); 
 
        #endif 
 
        reflectVec = inverseTransformDirection( reflectVec, viewMatrix ); 
 
        float specularMIPLevel = getSpecularMIPLevel( blinnShininessExponent, maxMIPLevel ); 
 
        #ifdef ENVMAP_TYPE_CUBE 
 
            vec3 queryReflectVec = vec3( flipEnvMap * reflectVec.x, reflectVec.yz ); 
 
            #ifdef TEXTURE_LOD_EXT 
 
                vec4 envMapColor = textureCubeLodEXT( envMap, queryReflectVec, specularMIPLevel ); 
 
            #else 
 
                vec4 envMapColor = textureCube( envMap, queryReflectVec, specularMIPLevel ); 
 
            #endif 
 
            envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb; 
 
        #elif defined( ENVMAP_TYPE_CUBE_UV ) 
 
            vec3 queryReflectVec = vec3( flipEnvMap * reflectVec.x, reflectVec.yz ); 
            vec4 envMapColor = textureCubeUV(queryReflectVec, BlinnExponentToGGXRoughness(blinnShininessExponent)); 
 
        #elif defined( ENVMAP_TYPE_EQUIREC ) 
 
            vec2 sampleUV; 
            sampleUV.y = 1.0 - saturate( reflectVec.y * 0.5 + 0.5 ); 
            sampleUV.x = atan( reflectVec.z, reflectVec.x ) * RECIPROCAL_PI2 + 0.5; 
 
            #ifdef TEXTURE_LOD_EXT 
 
                vec4 envMapColor = texture2DLodEXT( envMap, sampleUV, specularMIPLevel ); 
 
            #else 
 
                vec4 envMapColor = texture2D( envMap, sampleUV, specularMIPLevel ); 
 
            #endif 
 
            envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb; 
 
        #elif defined( ENVMAP_TYPE_SPHERE ) 
 
            vec3 reflectView = normalize( ( viewMatrix * vec4( reflectVec, 0.0 ) ).xyz + vec3( 0.0,0.0,1.0 ) ); 
 
            #ifdef TEXTURE_LOD_EXT 
 
                vec4 envMapColor = texture2DLodEXT( envMap, reflectView.xy * 0.5 + 0.5, specularMIPLevel ); 
 
            #else 
 
                vec4 envMapColor = texture2D( envMap, reflectView.xy * 0.5 + 0.5, specularMIPLevel ); 
 
            #endif 
 
            envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb; 
 
        #endif 
 
        return envMapColor.rgb * envMapIntensity; 
 
    } 
 
#endif

#ifdef USE_COLOR 
 
    varying vec3 vColor; 
 
#endif

#ifdef USE_FOG 
 
  varying float fogDepth; 
 
#endif

#ifdef USE_MORPHTARGETS 
 
    #ifndef USE_MORPHNORMALS 
 
    uniform float morphTargetInfluences[ 8 ]; 
 
    #else 
 
    uniform float morphTargetInfluences[ 4 ]; 
 
    #endif 
 
#endif

#ifdef USE_SKINNING 
 
 
    #ifdef BONE_TEXTURE 
 
        uniform sampler2D boneTexture; 
        uniform int boneTextureWidth; 
        uniform int boneTextureHeight; 
 
        mat4 getBoneMatrix( const in float i ) { 
 
            float j = i * 4.0; 
            float x = mod( j, float( boneTextureWidth ) ); 
            float y = floor( j / float( boneTextureWidth ) ); 
 
            float dx = 1.0 / float( boneTextureWidth ); 
            float dy = 1.0 / float( boneTextureHeight ); 
 
            y = dy * ( y + 0.5 ); 
 
            vec4 v1 = texture2D( boneTexture, vec2( dx * ( x + 0.5 ), y ) ); 
            vec4 v2 = texture2D( boneTexture, vec2( dx * ( x + 1.5 ), y ) ); 
            vec4 v3 = texture2D( boneTexture, vec2( dx * ( x + 2.5 ), y ) ); 
            vec4 v4 = texture2D( boneTexture, vec2( dx * ( x + 3.5 ), y ) ); 
 
            mat4 bone = mat4( v1, v2, v3, v4 ); 
 
            return bone; 
 
        } 
 
    #else 
 
        uniform mat4 boneMatrices[ MAX_BONES ]; 
        uniform int boneCount;
 
        mat4 getBoneMatrix( const in float i ) { 
 
            mat4 bone = boneMatrices[ int(i) ]; 
            return bone; 
 
        } 
 
    #endif 
 
#endif

#ifdef USE_SHADOWMAP 
 
    #if NUM_DIR_LIGHTS > 0 
 
        uniform mat4 directionalShadowMatrix[ NUM_DIR_LIGHTS ]; 
        varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHTS ]; 
 
    #endif 
 
    #if NUM_SPOT_LIGHTS > 0 
 
        uniform mat4 spotShadowMatrix[ NUM_SPOT_LIGHTS ]; 
        varying vec4 vSpotShadowCoord[ NUM_SPOT_LIGHTS ]; 
 
    #endif 
 
    #if NUM_POINT_LIGHTS > 0 
 
        uniform mat4 pointShadowMatrix[ NUM_POINT_LIGHTS ]; 
        varying vec4 vPointShadowCoord[ NUM_POINT_LIGHTS ]; 
 
    #endif 
 
    /* 
    #if NUM_RECT_AREA_LIGHTS > 0 
 
        // TODO (abelnation): uniforms for area light shadows 
 
    #endif 
    */ 
 
#endif

#ifdef USE_LOGDEPTHBUF 
 
    #ifdef USE_LOGDEPTHBUF_EXT 
 
        varying float vFragDepth; 
 
    #endif 
 
    uniform float logDepthBufFC; 
 
#endif
#if NUM_CLIPPING_PLANES > 0 && ! defined( PHYSICAL ) && ! defined( PHONG ) 
    varying vec3 vViewPosition; 
#endif

void main() { 
 

#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP ) || defined( USE_ALPHAMAP ) || defined( USE_EMISSIVEMAP ) || defined( USE_ROUGHNESSMAP ) || defined( USE_METALNESSMAP ) 
 
    vUv = uv * offsetRepeat.zw + offsetRepeat.xy; 
 
#endif
#if defined( USE_LIGHTMAP ) || defined( USE_AOMAP ) 
 
    vUv2 = vec2(uv2.s, 1.0 - uv2.t); 
 
#endif

#ifdef USE_COLOR 
 
    vColor.xyz = color.xyz; 
 
#endif

 
vec3 objectNormal = vec3( normal );
#ifdef USE_MORPHNORMALS 
 
    objectNormal += ( morphNormal0 - normal ) * morphTargetInfluences[ 0 ]; 
    objectNormal += ( morphNormal1 - normal ) * morphTargetInfluences[ 1 ]; 
    objectNormal += ( morphNormal2 - normal ) * morphTargetInfluences[ 2 ]; 
    objectNormal += ( morphNormal3 - normal ) * morphTargetInfluences[ 3 ]; 
 
#endif

#ifdef USE_SKINNING 
 
    mat4 boneMatX = getBoneMatrix( skinIndex.x ); 
    mat4 boneMatY = getBoneMatrix( skinIndex.y ); 
    mat4 boneMatZ = getBoneMatrix( skinIndex.z ); 
    mat4 boneMatW = getBoneMatrix( skinIndex.w ); 
 
#endif

#ifdef USE_SKINNING 
 
    mat4 skinMatrix = mat4( 0.0 ); 
    skinMatrix += skinWeight.x * boneMatX; 
    if (boneCount > 1) skinMatrix += skinWeight.y * boneMatY; 
    if (boneCount > 2) skinMatrix += skinWeight.z * boneMatZ; 
    if (boneCount > 3) skinMatrix += skinWeight.w * boneMatW; 
 
    objectNormal = vec4( skinMatrix * vec4( objectNormal, 0.0 ) ).xyz; 
 
#endif

#ifdef FLIP_SIDED 
 
    objectNormal = -objectNormal; 
 
#endif 
 
vec3 transformedNormal = normalMatrix * objectNormal;
 
vec3 transformed = vec3( position );
#ifdef USE_MORPHTARGETS 
 
    transformed += ( morphTarget0 - position ) * morphTargetInfluences[ 0 ]; 
    transformed += ( morphTarget1 - position ) * morphTargetInfluences[ 1 ]; 
    transformed += ( morphTarget2 - position ) * morphTargetInfluences[ 2 ]; 
    transformed += ( morphTarget3 - position ) * morphTargetInfluences[ 3 ]; 
 
    #ifndef USE_MORPHNORMALS 
 
    transformed += ( morphTarget4 - position ) * morphTargetInfluences[ 4 ]; 
    transformed += ( morphTarget5 - position ) * morphTargetInfluences[ 5 ]; 
    transformed += ( morphTarget6 - position ) * morphTargetInfluences[ 6 ]; 
    transformed += ( morphTarget7 - position ) * morphTargetInfluences[ 7 ]; 
 
    #endif 
 
#endif

#ifdef USE_SKINNING 
 
    vec4 skinVertex = vec4( transformed, 1.0 ); 
 
    vec4 skinned = vec4( 0.0 ); 
    skinned += boneMatX * skinVertex * skinWeight.x; 
    if (boneCount > 1) skinned += boneMatY * skinVertex * skinWeight.y; 
    if (boneCount > 2) skinned += boneMatZ * skinVertex * skinWeight.z; 
    if (boneCount > 3) skinned += boneMatW * skinVertex * skinWeight.w; 
 
#endif

#ifdef USE_SKINNING 
 
    vec4 mvPosition = modelViewMatrix * skinned; 
 
#else 
 
    vec4 mvPosition = modelViewMatrix * vec4( transformed, 1.0 ); 
 
#endif 
 
gl_Position = projectionMatrix * mvPosition;
#ifdef USE_LOGDEPTHBUF 
 
    gl_Position.z = log2(max( EPSILON, gl_Position.w + 1.0 )) * logDepthBufFC; 
 
    #ifdef USE_LOGDEPTHBUF_EXT 
 
        vFragDepth = 1.0 + gl_Position.w; 
 
    #else 
 
        gl_Position.z = (gl_Position.z - 1.0) * gl_Position.w; 
 
    #endif 
 
#endif
#if NUM_CLIPPING_PLANES > 0 && ! defined( PHYSICAL ) && ! defined( PHONG ) 
    vViewPosition = - mvPosition.xyz; 
#endif

#if defined( USE_ENVMAP ) || defined( PHONG ) || defined( PHYSICAL ) || defined( LAMBERT ) || defined ( USE_SHADOWMAP ) 
 
    #ifdef USE_SKINNING 
 
        vec4 worldPosition = modelMatrix * skinned; 
 
    #else 
 
        vec4 worldPosition = modelMatrix * vec4( transformed, 1.0 ); 
 
    #endif 
 
#endif

#ifdef USE_ENVMAP 
 
    #if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) 
 
        vWorldPosition = worldPosition.xyz; 
 
    #else 
 
        vec3 cameraToVertex = normalize( worldPosition.xyz - cameraPosition ); 
 
        vec3 worldNormal = inverseTransformDirection( transformedNormal, viewMatrix ); 
 
        #ifdef ENVMAP_MODE_REFLECTION 
 
            vReflect = reflect( cameraToVertex, worldNormal ); 
 
        #else 
 
            vReflect = refract( cameraToVertex, worldNormal, refractionRatio ); 
 
        #endif 
 
    #endif 
 
#endif
vec3 diffuse = vec3( 1.0 ); 
 
GeometricContext geometry; 
geometry.position = mvPosition.xyz; 
geometry.normal = normalize( transformedNormal ); 
geometry.viewDir = normalize( -mvPosition.xyz ); 
 
GeometricContext backGeometry; 
backGeometry.position = geometry.position; 
backGeometry.normal = -geometry.normal; 
backGeometry.viewDir = geometry.viewDir; 
 
vLightFront = vec3( 0.0 ); 
 
#ifdef DOUBLE_SIDED 
    vLightBack = vec3( 0.0 ); 
#endif 
 
IncidentLight directLight; 
float dotNL; 
vec3 directLightColor_Diffuse; 
 
#if NUM_POINT_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) { 
 
        getPointDirectLightIrradiance( pointLights[ i ], geometry, directLight ); 
 
        dotNL = dot( geometry.normal, directLight.direction ); 
        directLightColor_Diffuse = PI * directLight.color; 
 
        vLightFront += saturate( dotNL ) * directLightColor_Diffuse; 
 
        #ifdef DOUBLE_SIDED 
 
            vLightBack += saturate( -dotNL ) * directLightColor_Diffuse; 
 
        #endif 
 
    } 
 
#endif 
 
#if NUM_SPOT_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) { 
 
        getSpotDirectLightIrradiance( spotLights[ i ], geometry, directLight ); 
 
        dotNL = dot( geometry.normal, directLight.direction ); 
        directLightColor_Diffuse = PI * directLight.color; 
 
        vLightFront += saturate( dotNL ) * directLightColor_Diffuse; 
 
        #ifdef DOUBLE_SIDED 
 
            vLightBack += saturate( -dotNL ) * directLightColor_Diffuse; 
 
        #endif 
    } 
 
#endif 
 
/* 
#if NUM_RECT_AREA_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_RECT_AREA_LIGHTS; i ++ ) { 
 
        // TODO (abelnation): implement 
 
    } 
 
#endif 
*/ 
 
#if NUM_DIR_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) { 
 
        getDirectionalDirectLightIrradiance( directionalLights[ i ], geometry, directLight ); 
 
        dotNL = dot( geometry.normal, directLight.direction ); 
        directLightColor_Diffuse = PI * directLight.color; 
 
        vLightFront += saturate( dotNL ) * directLightColor_Diffuse; 
 
        #ifdef DOUBLE_SIDED 
 
            vLightBack += saturate( -dotNL ) * directLightColor_Diffuse; 
 
        #endif 
 
    } 
 
#endif 
 
#if NUM_HEMI_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_HEMI_LIGHTS; i ++ ) { 
 
        vLightFront += getHemisphereLightIrradiance( hemisphereLights[ i ], geometry ); 
 
        #ifdef DOUBLE_SIDED 
 
            vLightBack += getHemisphereLightIrradiance( hemisphereLights[ i ], backGeometry ); 
 
        #endif 
 
    } 
 
#endif

#ifdef USE_SHADOWMAP 
 
    #if NUM_DIR_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) { 
 
        vDirectionalShadowCoord[ i ] = directionalShadowMatrix[ i ] * worldPosition; 
 
    } 
 
    #endif 
 
    #if NUM_SPOT_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) { 
 
        vSpotShadowCoord[ i ] = spotShadowMatrix[ i ] * worldPosition; 
 
    } 
 
    #endif 
 
    #if NUM_POINT_LIGHTS > 0 
 
    for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) { 
 
        vPointShadowCoord[ i ] = pointShadowMatrix[ i ] * worldPosition; 
 
    } 
 
    #endif 
 
    /* 
    #if NUM_RECT_AREA_LIGHTS > 0 
 
        // TODO (abelnation): update vAreaShadowCoord with area light info 
 
    #endif 
    */ 
 
#endif
 
#ifdef USE_FOG 
fogDepth = -mvPosition.z; 
#endif

}
