
Shader "ADYFX/Editer/JianCai_YuLan"
{
	Properties
	{
		_UVScale("UVScale", Range( 0 , 10)) = 1
		_Xoffset("Xoffset", Float) = 0
		_Xoffset_Save("Xoffset_Save", Float) = 0
		_Yoffset("Yoffset", Float) = 0
		_Yoffset_Save("Yoffset_Save", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_isJianCaiChaoJie("isJianCaiChaoJie", Int) = 0
		_isSave("isSave", Int) = 0
		_UVScale_Save_X("UVScale_Save_X", Float) = 1
		_UVScale_Save_Y("UVScale_Save_Y", Float) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform float _UVScale;
			float4 _MainTex_TexelSize;
			uniform float _Xoffset;
			uniform float _Yoffset;
			uniform float _UVScale_Save_X;
			uniform float _UVScale_Save_Y;
			uniform float _Xoffset_Save;
			uniform float _Yoffset_Save;
			uniform int _isSave;
			uniform int _isJianCaiChaoJie;
			uniform float _ColorSpaceValue;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord137 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_48_0_g1 = _UVScale;
				float2 appendResult144 = (float2(( _MainTex_TexelSize.x * _Xoffset ) , ( _MainTex_TexelSize.y * _Yoffset )));
				float2 temp_output_138_0 = (( ( texCoord137 * temp_output_48_0_g1 ) + -( temp_output_48_0_g1 * 0.5 ) + 0.5 )*1.0 + appendResult144);
				float2 appendResult196 = (float2(_UVScale_Save_X , _UVScale_Save_Y));
				float2 appendResult197 = (float2(_Xoffset_Save , ( ( 1.0 - _Yoffset_Save ) - _UVScale_Save_Y )));
				float temp_output_48_0_g3 = _UVScale;
				float2 lerpResult218 = lerp( (temp_output_138_0*appendResult196 + appendResult197) , (( ( (texCoord137*appendResult196 + appendResult197) * temp_output_48_0_g3 ) + -( temp_output_48_0_g3 * 0.5 ) + 0.5 )*1.0 + appendResult144) , (float)_isSave);
				float4 tex2DNode78 = tex2D( _MainTex, lerpResult218 );
				float2 break152 = temp_output_138_0;
				float4 lerpResult174 = lerp( tex2DNode78 , ( min( min( step( 0.0 , break152.y ) , step( 0.0 , break152.x ) ) , min( step( 0.0 , ( 1.0 - break152.x ) ) , step( 0.0 , ( 1.0 - break152.y ) ) ) ) * tex2DNode78 ) , (float)_isJianCaiChaoJie);
				float4 break200 = lerpResult174;
				float3 appendResult201 = (float3(break200.r , break200.g , break200.b));
				float3 temp_cast_2 = (_ColorSpaceValue).xxx;
				float4 appendResult126 = (float4(pow( appendResult201 , temp_cast_2 ) , saturate( break200.a )));
				
				
				finalColor = appendResult126;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback "False"
}
