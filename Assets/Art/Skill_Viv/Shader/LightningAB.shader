// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/LightningAB"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_EmissionStr("EmissionStr", Float) = 1
		[Toggle(_RISALPHA_ON)] _RisAlpha("RisAlpha", Float) = 0
		_Panner("Panner", Vector) = (0,0,1,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_VertexOffsetNoiseTex("VertexOffsetNoiseTex", 2D) = "white" {}
		_VertexNoisePanner("VertexNoisePanner", Vector) = (0,0,1,0)
		_VerTexOffsetStr("VerTexOffsetStr", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Off
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _RISALPHA_ON
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
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _EmissionStr;
		uniform float _Cutoff = 0.5;

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
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			c.rgb = ( tex2DNode1 * _EmissionStr * i.vertexColor * i.uv_texcoord.w ).rgb;
			c.a = 1;
			clip( saturate( ( ( staticSwitch5 * i.vertexColor.a ) - step( ( i.uv_texcoord.z + tex2D( _NoiseTex, uv_NoiseTex ).r ) , 0.0 ) ) ) - _Cutoff );
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
-1688;327;1434;792;288.7441;36.08752;1.3;True;True
Node;AmplifyShaderEditor.Vector3Node;14;-1549.204,140.5677;Inherit;False;Property;_Panner;Panner;4;0;Create;True;0;0;0;False;0;False;0,0,1;-2,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1283.204,167.2677;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1386.904,9.367745;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1307.404,282.9678;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1038.904,89.36774;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-697.1693,567.4901;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-805.3307,83.93;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;150a2cf505852c4478e1391d9b26556b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-749.816,800.7923;Inherit;True;Property;_NoiseTex;NoiseTex;5;0;Create;True;0;0;0;False;0;False;-1;None;b8599c4baec202142a92b88954aaf92e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;24;-1469.26,1093.675;Inherit;False;Property;_VertexNoisePanner;VertexNoisePanner;7;0;Create;True;0;0;0;False;0;False;0,0,1;-10,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;27;-1227.46,1236.075;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-1203.26,1120.375;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1306.96,962.4748;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;5;-351.1382,305.8076;Inherit;False;Property;_RisAlpha;RisAlpha;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;7;-740.0716,-131.3434;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-302.2911,694.1188;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-130.1718,358.1691;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;19;-138.8143,696.4492;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;28;-958.9597,1042.475;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-749.8776,303.4655;Inherit;False;Property;_EmissionStr;EmissionStr;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-725.3863,1037.037;Inherit;True;Property;_VertexOffsetNoiseTex;VertexOffsetNoiseTex;6;0;Create;True;0;0;0;False;0;False;-1;None;119c8fd29058bf9479264b865f27dbda;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;20;-85.62016,943.9661;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-6.856863,1099.75;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;86.98376,529.8658;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-8.885181,1188.05;Inherit;False;Property;_VerTexOffsetStr;VerTexOffsetStr;8;0;Create;True;0;0;0;False;0;False;1;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;298.0858,528.8314;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-81.32657,112.8095;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;309.7068,998.3893;Inherit;True;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-755.1201,405.3042;Inherit;False;Property;_ZTestMode;ZTestMode;9;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1012.871,202.8792;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/LightningAB;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;7;True;4;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;14;1
WireConnection;16;1;14;2
WireConnection;15;0;14;3
WireConnection;12;0;13;0
WireConnection;12;2;16;0
WireConnection;12;1;15;0
WireConnection;1;1;12;0
WireConnection;27;0;24;3
WireConnection;26;0;24;1
WireConnection;26;1;24;2
WireConnection;5;1;1;4
WireConnection;5;0;1;1
WireConnection;17;0;6;3
WireConnection;17;1;18;1
WireConnection;8;0;5;0
WireConnection;8;1;7;4
WireConnection;19;0;17;0
WireConnection;28;0;25;0
WireConnection;28;2;26;0
WireConnection;28;1;27;0
WireConnection;29;1;28;0
WireConnection;10;0;8;0
WireConnection;10;1;19;0
WireConnection;11;0;10;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;2;2;7;0
WireConnection;2;3;6;4
WireConnection;21;0;20;0
WireConnection;21;1;29;1
WireConnection;21;2;22;0
WireConnection;21;3;23;0
WireConnection;0;10;11;0
WireConnection;0;13;2;0
WireConnection;0;11;21;0
ASEEND*/
//CHKSM=8FBDBD04D67E15D82C0900C2639DD54269329E80