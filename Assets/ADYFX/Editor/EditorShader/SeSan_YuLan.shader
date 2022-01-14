
Shader "ADYFX/Editer/SeSan_YuLan"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "black" {}
		_BscaleY("BscaleY", Float) = 1
		_BscaleX("BscaleX", Float) = 1
		_GscaleX("GscaleX", Float) = 1
		_GscaleY("GscaleY", Float) = 1
		_RscaleX("RscaleX", Float) = 1
		_RscaleY("RscaleY", Float) = 1
		_BoffsetY("BoffsetY", Float) = 0
		_BoffsetX("BoffsetX", Float) = 0
		_GoffsetX("GoffsetX", Float) = 0
		_GoffsetY("GoffsetY", Float) = 0
		_RoffsetX("RoffsetX", Float) = 0
		_Rrotate("Rrotate", Range( -2 , 2)) = 0
		_Grotate("Grotate", Range( -2 , 2)) = 0
		_Brotate("Brotate", Range( -2 , 2)) = 0
		_RoffsetY("RoffsetY", Float) = 0
		_Scale("Scale", Range( 0 , 1)) = 0.5144576
		_SclaeMod("SclaeMod", Int) = 0
		_SuoFang0("SuoFang0", Float) = 1
		_SuoFang1("SuoFang1", Float) = 1
		_SuoFang2("SuoFang2", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
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
			uniform float _SuoFang0;
			uniform int _SclaeMod;
			uniform float _RscaleX;
			uniform float _RscaleY;
			uniform float _RoffsetX;
			uniform float _RoffsetY;
			uniform float _Scale;
			uniform float _Rrotate;
			uniform float _SuoFang1;
			uniform float _GscaleX;
			uniform float _GscaleY;
			uniform float _GoffsetX;
			uniform float _GoffsetY;
			uniform float _Grotate;
			uniform float _SuoFang2;
			uniform float _BscaleX;
			uniform float _BscaleY;
			uniform float _BoffsetX;
			uniform float _BoffsetY;
			uniform float _Brotate;
			uniform float _ColorSpaceValue;
			uniform float4 _MainTex_ST;

			
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
				float2 texCoord130 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord176 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult182 = lerp( texCoord130 , ( ( texCoord176 * _SuoFang0 ) + -( _SuoFang0 * 0.5 ) + 0.5 ) , (float)_SclaeMod);
				float2 appendResult138 = (float2(_RscaleX , _RscaleY));
				float2 appendResult139 = (float2(_RoffsetX , _RoffsetY));
				float cos157 = cos( ( _Rrotate * UNITY_PI ) );
				float sin157 = sin( ( _Rrotate * UNITY_PI ) );
				float2 rotator157 = mul( (lerpResult182*appendResult138 + ( appendResult139 * _Scale )) - float2( 0.5,0.5 ) , float2x2( cos157 , -sin157 , sin157 , cos157 )) + float2( 0.5,0.5 );
				float2 lerpResult185 = lerp( texCoord130 , ( ( texCoord176 * _SuoFang1 ) + -( _SuoFang1 * 0.5 ) + 0.5 ) , (float)_SclaeMod);
				float2 appendResult140 = (float2(_GscaleX , _GscaleY));
				float2 appendResult141 = (float2(_GoffsetX , _GoffsetY));
				float cos158 = cos( ( _Grotate * UNITY_PI ) );
				float sin158 = sin( ( _Grotate * UNITY_PI ) );
				float2 rotator158 = mul( (lerpResult185*appendResult140 + ( appendResult141 * _Scale )) - float2( 0.5,0.5 ) , float2x2( cos158 , -sin158 , sin158 , cos158 )) + float2( 0.5,0.5 );
				float2 lerpResult186 = lerp( texCoord130 , ( ( texCoord176 * _SuoFang2 ) + -( _SuoFang2 * 0.5 ) + 0.5 ) , (float)_SclaeMod);
				float2 appendResult143 = (float2(_BscaleX , _BscaleY));
				float2 appendResult144 = (float2(_BoffsetX , _BoffsetY));
				float cos159 = cos( ( _Brotate * UNITY_PI ) );
				float sin159 = sin( ( _Brotate * UNITY_PI ) );
				float2 rotator159 = mul( (lerpResult186*appendResult143 + ( appendResult144 * _Scale )) - float2( 0.5,0.5 ) , float2x2( cos159 , -sin159 , sin159 , cos159 )) + float2( 0.5,0.5 );
				float3 appendResult199 = (float3(tex2D( _MainTex, rotator157 ).r , tex2D( _MainTex, rotator158 ).g , tex2D( _MainTex, rotator159 ).b));
				float3 temp_cast_3 = (_ColorSpaceValue).xxx;
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult129 = (float4(pow( appendResult199 , temp_cast_3 ) , tex2D( _MainTex, uv_MainTex ).a));
				
				
				finalColor = appendResult129;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
