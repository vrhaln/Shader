// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/LightningADD"
{
	Properties
	{
		[Toggle(_UV1_WCONTORLEMISSION_ON)] _UV1_WContorlEmission("UV1_WContorlEmission", Float) = 0
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_EmissionStr("EmissionStr", Float) = 1
		[Toggle(_RISALPHA_ON)] _RisAlpha("RisAlpha", Float) = 0
		_Panner("Panner", Vector) = (0,0,1,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_VertexOffsetNoiseTex("VertexOffsetNoiseTex", 2D) = "white" {}
		_VertexNoisePanner("VertexNoisePanner", Vector) = (0,0,1,0)
		_VerTexOffsetStr("VerTexOffsetStr", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Off
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _RISALPHA_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma shader_feature_local _UV1_WCONTORLEMISSION_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _ZTestMode;
		uniform sampler2D _VertexOffsetNoiseTex;
		uniform float3 _VertexNoisePanner;
		uniform float4 _VertexOffsetNoiseTex_ST;
		uniform float _VerTexOffsetStr;
		uniform sampler2D _MainTex;
		uniform float3 _Panner;
		uniform float4 _MainTex_ST;
		uniform float _Dissolution;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _EmissionStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float mulTime27 = _Time.y * _VertexNoisePanner.z;
			float2 appendResult26 = (float2(_VertexNoisePanner.x , _VertexNoisePanner.y));
			float4 uvs_VertexOffsetNoiseTex = v.texcoord;
			uvs_VertexOffsetNoiseTex.xy = v.texcoord.xy * _VertexOffsetNoiseTex_ST.xy + _VertexOffsetNoiseTex_ST.zw;
			float2 panner28 = ( mulTime27 * appendResult26 + uvs_VertexOffsetNoiseTex.xy);
			v.vertex.xyz += ( ase_vertexNormal * tex2Dlod( _VertexOffsetNoiseTex, float4( panner28, 0, 0.0) ).r * 0.01 * _VerTexOffsetStr );
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime15 = _Time.y * _Panner.z;
			float2 appendResult16 = (float2(_Panner.x , _Panner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner12 = ( mulTime15 * appendResult16 + uvs_MainTex.xy);
			float4 tex2DNode1 = tex2D( _MainTex, panner12 );
			#ifdef _RISALPHA_ON
				float staticSwitch5 = tex2DNode1.r;
			#else
				float staticSwitch5 = tex2DNode1.a;
			#endif
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch33 = i.uv_texcoord.w;
			#else
				float staticSwitch33 = _Dissolution;
			#endif
			float DissolutionControl34 = staticSwitch33;
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			#ifdef _UV1_WCONTORLEMISSION_ON
				float staticSwitch36 = i.uv_texcoord.z;
			#else
				float staticSwitch36 = 1.0;
			#endif
			float UV1_W37 = staticSwitch36;
			c.rgb = ( tex2DNode1 * _EmissionStr * i.vertexColor * UV1_W37 ).rgb;
			c.a = saturate( ( ( staticSwitch5 * i.vertexColor.a ) - step( ( DissolutionControl34 + tex2D( _NoiseTex, uv_NoiseTex ).r ) , 0.0 ) ) );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
-2393;312;1916;956;3583.208;237.7168;2.408478;True;True
Node;AmplifyShaderEditor.CommentaryNode;30;-2943.212,368.9904;Inherit;False;1252.226;378.732;Comment;7;37;36;35;34;33;32;31;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;14;-1549.204,140.5677;Inherit;False;Property;_Panner;Panner;6;0;Create;True;0;0;0;False;0;False;0,0,1;-1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-2893.212,445.7223;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-2620.25,682.1594;Inherit;False;Property;_Dissolution;Dissolution;12;0;Create;True;0;0;0;False;0;False;0.15;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1283.204,167.2677;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1386.904,9.367745;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1307.404,282.9678;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;33;-2247.623,583.2233;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1932.634,587.2845;Inherit;False;DissolutionControl;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1038.904,89.36774;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2629.694,418.9904;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-591.2811,687.1133;Inherit;False;34;DissolutionControl;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-749.816,800.7923;Inherit;True;Property;_NoiseTex;NoiseTex;7;0;Create;True;0;0;0;False;0;False;-1;None;b8599c4baec202142a92b88954aaf92e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;24;-1469.26,1093.675;Inherit;False;Property;_VertexNoisePanner;VertexNoisePanner;9;0;Create;True;0;0;0;False;0;False;0,0,1;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-805.3307,83.93;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;None;66e6c550aad1a7f4b884cdcb0e85b198;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1306.96,962.4748;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;7;-740.0716,-131.3434;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;26;-1203.26,1120.375;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-302.2911,694.1188;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;36;-2258.099,424.8914;Inherit;False;Property;_UV1_WContorlEmission;UV1_WContorlEmission;0;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;5;-351.1382,305.8076;Inherit;False;Property;_RisAlpha;RisAlpha;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-1227.46,1236.075;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;28;-958.9597,1042.475;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;19;-138.8143,696.4492;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-130.1718,358.1691;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-1921.294,423.5483;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-6.856863,1099.75;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-725.3863,1037.037;Inherit;True;Property;_VertexOffsetNoiseTex;VertexOffsetNoiseTex;8;0;Create;True;0;0;0;False;0;False;-1;None;0a4c77e4c2a232547856bd376a6b3a82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;39;-402.2314,211.4825;Inherit;False;37;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-749.8776,303.4655;Inherit;False;Property;_EmissionStr;EmissionStr;4;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;86.98376,529.8658;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-8.885181,1188.05;Inherit;False;Property;_VerTexOffsetStr;VerTexOffsetStr;10;0;Create;True;0;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;20;-85.62016,943.9661;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-81.32657,112.8095;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;328.0858,532.8314;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-755.1201,405.3042;Inherit;False;Property;_ZTestMode;ZTestMode;11;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;309.7068,998.3893;Inherit;True;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1012.871,202.8792;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/LightningADD;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;7;True;4;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;14;1
WireConnection;16;1;14;2
WireConnection;15;0;14;3
WireConnection;33;1;31;0
WireConnection;33;0;32;4
WireConnection;34;0;33;0
WireConnection;12;0;13;0
WireConnection;12;2;16;0
WireConnection;12;1;15;0
WireConnection;1;1;12;0
WireConnection;26;0;24;1
WireConnection;26;1;24;2
WireConnection;17;0;38;0
WireConnection;17;1;18;1
WireConnection;36;1;35;0
WireConnection;36;0;32;3
WireConnection;5;1;1;4
WireConnection;5;0;1;1
WireConnection;27;0;24;3
WireConnection;28;0;25;0
WireConnection;28;2;26;0
WireConnection;28;1;27;0
WireConnection;19;0;17;0
WireConnection;8;0;5;0
WireConnection;8;1;7;4
WireConnection;37;0;36;0
WireConnection;29;1;28;0
WireConnection;10;0;8;0
WireConnection;10;1;19;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;2;2;7;0
WireConnection;2;3;39;0
WireConnection;11;0;10;0
WireConnection;21;0;20;0
WireConnection;21;1;29;1
WireConnection;21;2;22;0
WireConnection;21;3;23;0
WireConnection;0;9;11;0
WireConnection;0;13;2;0
WireConnection;0;11;21;0
ASEEND*/
//CHKSM=93089CED1F906985F7C101376A3E3861160027B3