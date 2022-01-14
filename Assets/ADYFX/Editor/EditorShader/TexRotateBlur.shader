
Shader "ADYFX/Editer/TexRotateBlur"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_XPoint("XPoint", Float) = 0.5
		_YPoint("YPoint", Float) = 0.5
		_Count("Count", Float) = 300

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

			uniform float _Count;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _XPoint;
			uniform float _YPoint;

			
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
				float localFSBlur71 = ( 0.0 );
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 UV71 = uv_MainTex;
				int Count71 = (int)_Count;
				sampler2D MainTex71 = _MainTex;
				float4 EndColor71 = float4( 0,0,0,0 );
				float2 appendResult65 = (float2(_XPoint , _YPoint));
				float2 Point71 = appendResult65;
				float Rotate71 = ( 0.01 * UNITY_PI );
				{
				float rrr = 0.5f ;
				float2 EndUV = UV71;
				for(int i = 0; i < Count71;i++)
				{
				rrr = lerp( 0.005, 0.0 , i/Count71);
				//rrr = (i/Count71)/Rotate71;
				EndUV =mul( EndUV-Point71,float2x2( cos(rrr),-sin(rrr),sin(rrr),cos(rrr) ))+Point71;
				EndColor71+= tex2D(MainTex71,EndUV);
				}
				//EndColor71 /= Count71;
				EndColor71 /= Count71;
				}
				float4 tex2DNode114 = tex2D( _MainTex, uv_MainTex );
				float4 ifLocalVar112 = 0;
				if( _Count <= 1.0 )
				ifLocalVar112 = tex2DNode114;
				else
				ifLocalVar112 = EndColor71;
				
				
				finalColor = ifLocalVar112;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
