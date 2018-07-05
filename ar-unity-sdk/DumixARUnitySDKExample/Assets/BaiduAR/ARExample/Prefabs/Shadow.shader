Shader "BaiduAR/2DShadow"
{
	Properties
	{
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_2DShadowColor ("2DShadowColor", Color) = (0.16, 0.16, 0.16, 0.64)
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Geometry+1"}
		Blend SrcAlpha OneMinusSrcAlpha 

		Pass
		{
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc" 
            #include "Lighting.cginc"

            uniform sampler2D _MainTex;
			struct a2f
			{
				float4 vertex : POSITION;
                float2 texcoord:TEXCOORD1;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
                float2 uv : TEXCOORD1;
				SHADOW_COORDS(2)
			};

			fixed4 _2DShadowColor;
			
			v2f vert (a2f v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
				TRANSFER_SHADOW(o);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                float3 lightColor = _LightColor0.rgb;
                float3 lightDir = _WorldSpaceLightPos0;
                float4 colorTex = tex2D(_MainTex, i.uv);

                float3 N = float3(0.0f, 1.0f, 0.0f);
                float NL = saturate(dot(N, lightDir));

				fixed atten = SHADOW_ATTENUATION(i);

                float3 color = colorTex.rgb * lightColor * NL * atten;

				return fixed4(color.rgb,saturate(1-atten)*_2DShadowColor.a);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}