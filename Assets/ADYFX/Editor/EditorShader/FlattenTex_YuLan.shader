
Shader "ADYFX/Editer/FlattenTex_YuLan"
{
	Properties
	{
		_Tex0("Tex0", 2D) = "black" {}
		_Tex1("Tex1", 2D) = "black" {}
		_Tex2("Tex2", 2D) = "black" {}
		_Tex3("Tex3", 2D) = "white" {}
		_Tex0RGBA("Tex0RGBA", Vector) = (1,0,0,0)
		_Tex1RGBA("Tex1RGBA", Vector) = (1,0,0,0)
		_Tex2RGBA("Tex2RGBA", Vector) = (1,0,0,0)
		_Tex3RGBA("Tex3RGBA", Vector) = (1,0,0,0)
		_QuSe("QuSe", Float) = 0
		_A_MulA("A_MulA", Int) = 0
		_B_MulA("B_MulA", Int) = 0
		_G_MulA("G_MulA", Int) = 0
		_R_MulA("R_MulA", Int) = 0
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

			uniform float _ColorSpaceValue;
			uniform sampler2D _Tex0;
			uniform float4 _Tex0_ST;
			uniform int _R_MulA;
			uniform float4 _Tex0RGBA;
			uniform sampler2D _Tex1;
			uniform float4 _Tex1_ST;
			uniform int _G_MulA;
			uniform float4 _Tex1RGBA;
			uniform sampler2D _Tex2;
			uniform float4 _Tex2_ST;
			uniform int _B_MulA;
			uniform float4 _Tex2RGBA;
			uniform sampler2D _Tex3;
			uniform float4 _Tex3_ST;
			uniform int _A_MulA;
			uniform float4 _Tex3RGBA;
			uniform float _QuSe;

			
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
				float2 uv_Tex0 = i.ase_texcoord1.xy * _Tex0_ST.xy + _Tex0_ST.zw;
				float4 tex2DNode78 = tex2D( _Tex0, uv_Tex0 );
				float4 lerpResult131 = lerp( tex2DNode78 , ( tex2DNode78 * tex2DNode78.a ) , (float)_R_MulA);
				float4 break107 = lerpResult131;
				float2 uv_Tex1 = i.ase_texcoord1.xy * _Tex1_ST.xy + _Tex1_ST.zw;
				float4 tex2DNode79 = tex2D( _Tex1, uv_Tex1 );
				float4 lerpResult132 = lerp( tex2DNode79 , ( tex2DNode79.a * tex2DNode79 ) , (float)_G_MulA);
				float4 break109 = lerpResult132;
				float2 uv_Tex2 = i.ase_texcoord1.xy * _Tex2_ST.xy + _Tex2_ST.zw;
				float4 tex2DNode80 = tex2D( _Tex2, uv_Tex2 );
				float4 lerpResult133 = lerp( tex2DNode80 , ( tex2DNode80 * tex2DNode80.a ) , (float)_B_MulA);
				float4 break111 = lerpResult133;
				float2 uv_Tex3 = i.ase_texcoord1.xy * _Tex3_ST.xy + _Tex3_ST.zw;
				float4 tex2DNode81 = tex2D( _Tex3, uv_Tex3 );
				float4 lerpResult134 = lerp( tex2DNode81 , ( tex2DNode81 * tex2DNode81.a ) , (float)_A_MulA);
				float4 break113 = lerpResult134;
				float temp_output_101_0 = ( ( break113.r * _Tex3RGBA.x ) + ( break113.g * _Tex3RGBA.y ) + ( break113.b * _Tex3RGBA.z ) + ( break113.a * _Tex3RGBA.w ) );
				float4 appendResult76 = (float4(( ( break107.r * _Tex0RGBA.x ) + ( break107.g * _Tex0RGBA.y ) + ( break107.b * _Tex0RGBA.z ) + ( break107.a * _Tex0RGBA.w ) ) , ( ( break109.r * _Tex1RGBA.x ) + ( break109.g * _Tex1RGBA.y ) + ( break109.b * _Tex1RGBA.z ) + ( break109.a * _Tex1RGBA.w ) ) , ( ( break111.r * _Tex2RGBA.x ) + ( break111.g * _Tex2RGBA.y ) + ( break111.b * _Tex2RGBA.z ) + ( break111.a * _Tex2RGBA.w ) ) , temp_output_101_0));
				float3 desaturateInitialColor125 = appendResult76.xyz;
				float desaturateDot125 = dot( desaturateInitialColor125, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar125 = lerp( desaturateInitialColor125, desaturateDot125.xxx, _QuSe );
				float4 appendResult126 = (float4(desaturateVar125 , temp_output_101_0));
				
				
				finalColor = appendResult126;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
