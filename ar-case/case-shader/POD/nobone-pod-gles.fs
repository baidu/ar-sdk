uniform sampler2D sTexture;


varying mediump vec2  TexCoord;
uniform mediump vec4 Alpha;
void main()
{
	vec4 diffuseColor = texture2D(sTexture, vec2(TexCoord.x, 1.0 - TexCoord.y));

	 if ( diffuseColor.a < 0.01 ) discard;
    gl_FragColor =  mix( Alpha, diffuseColor,Alpha.a);
   
}
