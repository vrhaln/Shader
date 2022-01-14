
Shader "ADYFX/Editer/GaussianBlur"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_BlurSpread("BlurSpread", Range( 0 , 0.1)) = 0.1
		_offset1("offset1", Vector) = (1,0,0,0)
		_offset2("offset2", Vector) = (-1,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
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
			uniform float2 _offset1;
			uniform float _BlurSpread;
			uniform float2 _offset2;

			
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
				float2 texCoord61 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV13 = texCoord61;
				
				
				finalColor = saturate( ( ( tex2D( _MainTex, UV13 ) * 0.4 ) + ( tex2D( _MainTex, ( ( ( _offset1 * 1.0 ) * _BlurSpread ) + UV13 ) ) * 0.15 ) + ( tex2D( _MainTex, ( ( ( _offset1 * 2.0 ) * _BlurSpread ) + UV13 ) ) * 0.1 ) + ( tex2D( _MainTex, ( UV13 + ( ( _offset2 * 1.0 ) * _BlurSpread ) ) ) * 0.15 ) + ( tex2D( _MainTex, ( UV13 + ( ( _offset2 * 2.0 ) * _BlurSpread ) ) ) * 0.1 ) + ( 0.05 * tex2D( _MainTex, ( ( ( _offset1 * 3.0 ) * _BlurSpread ) + UV13 ) ) ) + ( 0.05 * tex2D( _MainTex, ( UV13 + ( ( _offset2 * 3.0 ) * _BlurSpread ) ) ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
