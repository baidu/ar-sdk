uniform sampler2D sTexture;

varying mediump vec2  TexCoord;
uniform mediump vec4 Alpha;
void main()
{
    gl_FragColor =  texture2D(sTexture, vec2(TexCoord.x, 1.0 - TexCoord.y));
   
}
