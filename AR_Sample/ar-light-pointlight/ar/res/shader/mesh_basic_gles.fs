
uniform vec3 diffuse; 
uniform float opacity; 
varying vec3 vViewPosition;
  
#ifndef FLAT_SHADED 
    varying vec3 vNormal; 
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

#ifdef USE_COLOR 
 
    varying vec3 vColor; 
 
#endif

#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP ) || defined( USE_ALPHAMAP ) || defined( USE_EMISSIVEMAP ) || defined( USE_ROUGHNESSMAP ) || defined( USE_METALNESSMAP ) 

varying vec2 vUv; 

#endif
#if defined( USE_LIGHTMAP ) || defined( USE_AOMAP ) 
 
    varying vec2 vUv2; 
 
#endif

#ifdef USE_MAP 
 
    uniform sampler2D map; 
 
#endif

#ifdef USE_BUMPMAP 
 
    uniform sampler2D bumpMap; 
    uniform float bumpScale; 
 
    // Derivative maps - bump mapping unparametrized surfaces by Morten Mikkelsen 
    // http://mmikkelsen3d.blogspot.sk/2011/07/derivative-maps.html 
 
    // Evaluate the derivative of the height w.r.t. screen-space using forward differencing (listing 2) 
 
    vec2 dHdxy_fwd() { 
 
        vec2 dSTdx = dFdx( vUv ); 
        vec2 dSTdy = dFdy( vUv ); 
 
        float Hll = bumpScale * texture2D( bumpMap, vUv ).x; 
        float dBx = bumpScale * texture2D( bumpMap, vUv + dSTdx ).x - Hll; 
        float dBy = bumpScale * texture2D( bumpMap, vUv + dSTdy ).x - Hll; 
 
        return vec2( dBx, dBy ); 
 
    } 
 
    vec3 perturbNormalArb( vec3 surf_pos, vec3 surf_norm, vec2 dHdxy ) { 
 
        vec3 vSigmaX = dFdx( surf_pos ); 
        vec3 vSigmaY = dFdy( surf_pos ); 
        vec3 vN = surf_norm;        // normalized 
 
        vec3 R1 = cross( vSigmaY, vN ); 
        vec3 R2 = cross( vN, vSigmaX ); 
 
        float fDet = dot( vSigmaX, R1 ); 
 
        vec3 vGrad = sign( fDet ) * ( dHdxy.x * R1 + dHdxy.y * R2 ); 
        return normalize( abs( fDet ) * surf_norm - vGrad ); 
 
    } 
 
#endif

#ifdef USE_ALPHAMAP 
 
    uniform sampler2D alphaMap; 
 
#endif

#ifdef USE_AOMAP 
 
    uniform sampler2D aoMap; 
    uniform float aoMapIntensity; 
 
#endif

#ifdef USE_LIGHTMAP 
 
    uniform sampler2D lightMap; 
    uniform float lightMapIntensity; 
 
#endif
#if defined( USE_ENVMAP ) || defined( PHYSICAL ) 
    uniform float reflectivity; 
    uniform float envMapIntensity; 
#endif 
 
#ifdef USE_ENVMAP 
 
    #if ! defined( PHYSICAL ) && ( defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) ) 
        varying vec3 vWorldPosition; 
    #endif 
 
    #ifdef ENVMAP_TYPE_CUBE 
        uniform samplerCube envMap; 
    #else 
        uniform sampler2D envMap; 
    #endif 
    uniform float flipEnvMap; 
 
    #if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( PHYSICAL ) 
        uniform float refractionRatio; 
    #else 
        varying vec3 vReflect; 
    #endif 
 
#endif

#ifdef USE_FOG 
 
    uniform vec3 fogColor; 
    varying float fogDepth; 
 
    #ifdef FOG_EXP2 
 
        uniform float fogDensity; 
 
    #else 
 
        uniform float fogNear; 
        uniform float fogFar; 
 
    #endif 
 
#endif

#ifdef USE_SPECULARMAP 
 
    uniform sampler2D specularMap; 
 
#endif

#ifdef USE_LOGDEPTHBUF 
 
    uniform float logDepthBufFC; 
 
    #ifdef USE_LOGDEPTHBUF_EXT 
 
        varying float vFragDepth; 
 
    #endif 
 
#endif
#if NUM_CLIPPING_PLANES > 0 
 
    #if ! defined( PHYSICAL ) && ! defined( PHONG ) 
        varying vec3 vViewPosition; 
    #endif 
 
    uniform vec4 clippingPlanes[ NUM_CLIPPING_PLANES ]; 
 
#endif
 
void main() { 
 
#if NUM_CLIPPING_PLANES > 0 
 
    for ( int i = 0; i < UNION_CLIPPING_PLANES; ++ i ) { 
 
        vec4 plane = clippingPlanes[ i ]; 
        if ( dot( vViewPosition, plane.xyz ) > plane.w ) discard; 
 
    } 
         
    #if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES 
 
        bool clipped = true; 
        for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; ++ i ) { 
            vec4 plane = clippingPlanes[ i ]; 
            clipped = ( dot( vViewPosition, plane.xyz ) > plane.w ) && clipped; 
        } 
 
        if ( clipped ) discard; 
     
    #endif 
 
#endif

    vec4 diffuseColor = vec4( diffuse, opacity ); 
 
#if defined(USE_LOGDEPTHBUF) && defined(USE_LOGDEPTHBUF_EXT) 
 
    gl_FragDepthEXT = log2(vFragDepth) * logDepthBufFC * 0.5; 
 
#endif

#ifdef USE_MAP 
 
    vec4 texelColor = texture2D( map, vUv ); 
 
    texelColor = mapTexelToLinear( texelColor ); 
    diffuseColor *= texelColor; 
 
#endif

#ifdef USE_COLOR 
 
    diffuseColor.rgb *= vColor; 
 
#endif

#ifdef USE_ALPHAMAP 
 
    diffuseColor.a *= texture2D( alphaMap, vUv ).g; 
 
#endif

#ifdef ALPHATEST 
 
    if ( diffuseColor.a < ALPHATEST ) discard; 
 
#endif
float specularStrength; 
 
#ifdef USE_SPECULARMAP 
 
    vec4 texelSpecular = texture2D( specularMap, vUv ); 
    specularStrength = texelSpecular.r; 
 
#else 
 
    specularStrength = 1.0; 
 
#endif

    ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) ); 
 
    // accumulation (baked indirect lighting only) 
    #ifdef USE_LIGHTMAP 
 
        reflectedLight.indirectDiffuse += texture2D( lightMap, vUv2 ).xyz * lightMapIntensity; 
 
    #else 
 
        reflectedLight.indirectDiffuse += vec3( 1.0 ); 
 
    #endif 
 
    // modulation 

#ifdef USE_AOMAP 
 
    float ambientOcclusion = ( texture2D( aoMap, vUv2 ).r - 1.0 ) * aoMapIntensity + 1.0; 
 
    reflectedLight.indirectDiffuse *= ambientOcclusion; 
 
    #if defined( USE_ENVMAP ) && defined( PHYSICAL ) 
 
        float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) ); 
 
        reflectedLight.indirectSpecular *= computeSpecularOcclusion( dotNV, ambientOcclusion, material.specularRoughness ); 
 
    #endif 
 
#endif

    reflectedLight.indirectDiffuse *= diffuseColor.rgb; 
 
    vec3 outgoingLight = reflectedLight.indirectDiffuse; 
 

#ifdef DOUBLE_SIDED 
    float flipNormal = ( float( gl_FrontFacing ) * 2.0 - 1.0 ); 
#else 
    float flipNormal = 1.0; 
#endif

#if defined( USE_ENVMAP )

#ifdef FLAT_SHADED 
 
    // Workaround for Adreno/Nexus5 not able able to do dFdx( vViewPosition ) ... 
 
    vec3 fdx = vec3( dFdx( vViewPosition.x ), dFdx( vViewPosition.y ), dFdx( vViewPosition.z ) ); 
    vec3 fdy = vec3( dFdy( vViewPosition.x ), dFdy( vViewPosition.y ), dFdy( vViewPosition.z ) ); 
    vec3 normal = normalize( cross( fdx, fdy ) ); 
 
#else 
 
    vec3 normal = normalize( vNormal ) * flipNormal; 
 
#endif 
 
#ifdef USE_NORMALMAP 
 
    normal = perturbNormal2Arb( -vViewPosition, normal ); 
 
#elif defined( USE_BUMPMAP ) 
 
    normal = perturbNormalArb( -vViewPosition, normal, dHdxy_fwd() ); 
 
#endif

#endif

#ifdef USE_ENVMAP 
 
    #if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) 
 
        vec3 cameraToVertex = normalize( vWorldPosition - cameraPosition ); 
 
        // Transforming Normal Vectors with the Inverse Transformation 
        vec3 worldNormal = inverseTransformDirection( normal, viewMatrix ); 
 
        #ifdef ENVMAP_MODE_REFLECTION 
 
            vec3 reflectVec = reflect( cameraToVertex, worldNormal ); 
 
        #else 
 
            vec3 reflectVec = refract( cameraToVertex, worldNormal, refractionRatio ); 
 
        #endif 
 
    #else 
 
        vec3 reflectVec = vReflect; 
 
    #endif 
 
    #ifdef ENVMAP_TYPE_CUBE 
 
        vec4 envColor = textureCube( envMap, flipNormal * vec3( flipEnvMap * reflectVec.x, reflectVec.yz ) ); 
 
    #elif defined( ENVMAP_TYPE_EQUIREC ) 
 
        vec2 sampleUV; 
        sampleUV.y = 1.0 - saturate( flipNormal * reflectVec.y * 0.5 + 0.5 ); 
        sampleUV.x = atan( flipNormal * reflectVec.z, flipNormal * reflectVec.x ) * RECIPROCAL_PI2 + 0.5; 
        vec4 envColor = texture2D( envMap, sampleUV ); 
 
    #elif defined( ENVMAP_TYPE_SPHERE ) 
 
        vec3 reflectView = flipNormal * normalize( ( viewMatrix * vec4( reflectVec, 0.0 ) ).xyz + vec3( 0.0, 0.0, 1.0 ) ); 
        vec4 envColor = texture2D( envMap, reflectView.xy * 0.5 + 0.5 ); 
 
    #else 
 
        vec4 envColor = vec4( 0.0 ); 
 
    #endif 
 
    envColor = envMapTexelToLinear( envColor ); 
 
    #ifdef ENVMAP_BLENDING_MULTIPLY 
 
        outgoingLight = mix( outgoingLight, outgoingLight * envColor.xyz, specularStrength * reflectivity ); 
 
    #elif defined( ENVMAP_BLENDING_MIX ) 
 
        outgoingLight = mix( outgoingLight, envColor.xyz, specularStrength * reflectivity ); 
 
    #elif defined( ENVMAP_BLENDING_ADD ) 
 
        outgoingLight += envColor.xyz * specularStrength * reflectivity; 
 
    #endif 
 
#endif

    gl_FragColor = vec4( outgoingLight, diffuseColor.a ); 
 

#ifdef PREMULTIPLIED_ALPHA 
 
    // Get get normal blending with premultipled, use with CustomBlending, OneFactor, OneMinusSrcAlphaFactor, AddEquation. 
    gl_FragColor.rgb *= gl_FragColor.a; 
 
#endif
#if defined( TONE_MAPPING ) 
 
  gl_FragColor.rgb = toneMapping( gl_FragColor.rgb ); 
 
#endif
gl_FragColor = linearToOutputTexel( gl_FragColor );
#ifdef USE_FOG 
 
    #ifdef FOG_EXP2 
 
        float fogFactor = whiteCompliment( exp2( - fogDensity * fogDensity * fogDepth * fogDepth * LOG2 ) ); 
 
    #else 
 
        float fogFactor = smoothstep( fogNear, fogFar, fogDepth ); 
 
    #endif 
 
    gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor ); 
 
#endif

    gl_FragColor.rgba = mix( Alpha, gl_FragColor.rgba, Alpha.a );

}
