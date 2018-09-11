// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "BaiduAR/PlaneVideo"
{
	Properties
	{
		_MainTex("Texture", 2D) = "black" {}
	}

		SubShader
	{
		Pass
	{
		Lighting Off
		Cull off
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag 
#pragma multi_compile android iphone editor  androidfront iphonefront
#include "UnityCG.cginc"

		struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv,_MainTex);

		return o;
	}

	float4 frag(v2f i) : SV_Target
	{ 
		//float2 uv =i.uv;

//#ifdef SHADER_API_D3D11
//		uv = float2(1-i.uv.x,  1-i.uv.y);
//#endif
	   // uv = TRANSFORM_TEX(uv, _MainTex);

        float2 uv=i.uv;
         #ifdef editor
        uv=float2(uv.x, uv.y);
        #endif

      #ifdef iphone
        uv=float2(-uv.x, -uv.y);
        #endif
        #ifdef android
        uv=float2(1-uv.x, uv.y);
        #endif

        #ifdef androidfront
        uv=float2(uv.x, uv.y);
        #endif
        #ifdef iphonefront
        uv=float2(-uv.x, uv.y);
        #endif
     //   #endif
       // uv+=float2(0.5,0.5);
		fixed4 col = tex2D(_MainTex, uv);
		return col;
	}
		ENDCG
	}
	}
}
