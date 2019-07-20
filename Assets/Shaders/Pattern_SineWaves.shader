Shader "Pattern_SineWaves"
{
	Properties
	{
		_Texture("Texture Sample 0", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (1,1,1,0)
		_Rotation("Rotation", Float) = 0
		_LineWidth("LineWidth", Float) = 0.5
		_Tiling("Tiling", Float) = 3
		_Frequency("Frequency", Float) = 1
		_Amplitude("Amplitude", Float) = 0.25
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float4 _Color1;
		uniform float4 _Color0;
		uniform float _Frequency;
		uniform float _Rotation;
		uniform float _Amplitude;
		uniform float _Tiling;
		uniform float _LineWidth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float3 vertexPos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float cosRes = cos( _Rotation );
			float sinRes = sin( _Rotation );
			float2 rotator = mul( vertexPos.xy - float2( 0,0 ) , float2x2( cosRes , -sinRes , sinRes , cosRes )) + float2( 0,0 );
			float lerpResult = lerp( rotator.y , ( 1.0 - rotator.x ) , 0.0);
			float lerpResult2 = lerp( rotator.x , rotator.y , 0.0);
			float tempResult = ( ( sin( ( _Frequency * lerpResult * ( 2.0 * UNITY_PI ) ) ) * _Amplitude ) + ( lerpResult2 * _Tiling ) );
			float tempResult2 = ( tempResult * _Tiling );
			float4 lerpResult3 = lerp( _Color1 , _Color0 , floor( ( frac( tempResult2 ) + _LineWidth ) ));
			o.Albedo = ( tex2D( _Texture, uv_Texture ) * lerpResult3 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}