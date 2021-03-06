// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Outline"
{
	Properties
	{
		[HDR]_OutlineColor("OutlineColor", Color) = (1,1,1,1)
		_OutlineWith("OutlineWith", Float) = 0.05
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZtestMode("ZtestMode", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Front
		ColorMask RGBA
		ZWrite Off
		ZTest [_ZtestMode]
		Offset 0 , 0
		Stencil
		{
			Ref 1
			Comp Equal
			Pass Keep
			Fail Keep
			ZFail Keep
		}
		
		
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			uniform float _ZtestMode;
			uniform float _OutlineWith;
			uniform float4 _OutlineColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( v.ase_normal * _OutlineWith );
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
				
				
				finalColor = _OutlineColor;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	

	
}
/*ASEBEGIN
Version=18100
37;494;1213;650;1613.817;704.2884;2.384217;True;False
Node;AmplifyShaderEditor.NormalVertexDataNode;3;-355.1751,80.27631;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-341.6452,243.6701;Inherit;False;Property;_OutlineWith;OutlineWith;1;0;Create;True;0;0;False;0;False;0.05;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-438.4917,-133.808;Inherit;False;Property;_OutlineColor;OutlineColor;0;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-120.6343,119.5621;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-403.4872,-274.9962;Inherit;False;Property;_ZtestMode;ZtestMode;2;1;[Enum];Create;True;1;Option1;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;33.81598,18.21178;Float;False;True;-1;2;ASEMaterialInspector;100;1;Whl/Outline;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;1;False;-1;True;True;True;True;True;0;False;-1;True;True;1;False;-1;255;False;-1;255;False;-1;5;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;True;6;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;1;RenderType=;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;5;0;1;0
WireConnection;5;1;2;0
ASEEND*/
//CHKSM=8B41818E9002D9B942197133A6D0F806665EBD49