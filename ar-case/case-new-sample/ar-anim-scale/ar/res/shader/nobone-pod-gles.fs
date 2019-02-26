uniform sampler2D sTexture;

varying mediump vec2  TexCoord;
varying mediump vec3 vWorldNormal;
varying mediump vec3 vLightDir;
varying mediump float vOneOverAttenuation;

void main()
{
    gl_FragColor = texture2D(sTexture, TexCoord);
}
