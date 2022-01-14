
Shader "ADYFX/Editor/GlowPanner"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_MainTiling("MainTiling", Vector) = (0.55,0.7,0,0.15)
		_MainPanner("MainPanner", Vector) = (-1,0,0.5,0)
		_MainColor("MainColor", Color) = (1,1,1,1)
		_MainScale("MainScale", Float) = 1
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskScale("MaskScale", Float) = 1
		_Polar("Polar", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
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
			#include "UnityShaderVariables.cginc"


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
			uniform float4 _MainPanner;
			uniform float4 _MainTex_ST;
			uniform int _Polar;
			uniform float4 _MainTiling;
			uniform float4 _MainColor;
			uniform float _MainScale;
			uniform sampler2D _MaskTex;
			uniform float4 _MaskTex_ST;
			uniform float _MaskScale;
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
				float mulTime128 = _Time.y * _MainPanner.z;
				float2 appendResult126 = (float2(_MainPanner.x , _MainPanner.y));
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 temp_output_147_0 = (uv_MainTex*2.0 + -1.0);
				float2 break148 = temp_output_147_0;
				float2 appendResult154 = (float2((0.0 + (atan2( break148.y , break148.x ) - -3.141593) * (1.0 - 0.0) / (3.141593 - -3.141593)) , ( 1.0 - length( temp_output_147_0 ) )));
				float2 lerpResult158 = lerp( uv_MainTex , appendResult154 , (float)_Polar);
				float2 appendResult138 = (float2(_MainTiling.x , _MainTiling.y));
				float2 appendResult139 = (float2(_MainTiling.z , _MainTiling.w));
				float2 panner123 = ( mulTime128 * appendResult126 + (lerpResult158*appendResult138 + appendResult139));
				float2 uv_MaskTex = i.ase_texcoord1.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 temp_cast_1 = (_ColorSpaceValue).xxxx;
				
				
				finalColor = pow( ( ( tex2D( _MainTex, panner123 ) * _MainColor * _MainScale ) * ( tex2D( _MaskTex, uv_MaskTex ).r * _MaskScale ) ) , temp_cast_1 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
