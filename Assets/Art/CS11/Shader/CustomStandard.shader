// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/CustomStandard"
{
	Properties
	{
		_BaseMap("BaseMap", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_CompMask("CompMask", 2D) = "white" {}
		[HDR]_EmissColor("EmissColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
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

		uniform sampler2D _BaseMap;
		uniform float4 _BaseMap_ST;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float4 _EmissColor;
		uniform sampler2D _CompMask;
		uniform float4 _CompMask_ST;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float2 uv_BaseMap = i.uv_texcoord * _BaseMap_ST.xy + _BaseMap_ST.zw;
			float3 gammaToLinear3 = GammaToLinearSpace( tex2D( _BaseMap, uv_BaseMap ).rgb );
			s1.Albedo = gammaToLinear3;
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			s1.Normal = WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) );
			s1.Emission = _EmissColor.rgb;
			float2 uv_CompMask = i.uv_texcoord * _CompMask_ST.xy + _CompMask_ST.zw;
			float4 tex2DNode5 = tex2D( _CompMask, uv_CompMask );
			s1.Metallic = tex2DNode5.b;
			s1.Smoothness = ( 1.0 - tex2DNode5.g );
			s1.Occlusion = tex2DNode5.r;

			data.light = gi.light;

			UnityGI gi1 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g1 = UnityGlossyEnvironmentSetup( s1.Smoothness, data.worldViewDir, s1.Normal, float3(0,0,0));
			gi1 = UnityGlobalIllumination( data, s1.Occlusion, s1.Normal, g1 );
			#endif

			float3 surfResult1 = LightingStandard ( s1, viewDir, gi1 ).rgb;
			surfResult1 += s1.Emission;

			#ifdef UNITY_PASS_FORWARDADD//1
			surfResult1 -= s1.Emission;
			#endif//1
			float3 linearToGamma7 = LinearToGammaSpace( surfResult1 );
			c.rgb = linearToGamma7;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1217;284;1467;937;1570.869;145.0244;1.3;True;True
Node;AmplifyShaderEditor.SamplerNode;2;-1164.174,-39.58741;Inherit;True;Property;_BaseMap;BaseMap;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1167.374,405.2123;Inherit;True;Property;_CompMask;CompMask;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GammaToLinearNode;3;-765.7745,26.01261;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;4;-1175.375,187.6124;Inherit;True;Property;_NormalMap;NormalMap;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-805.7745,442.0124;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-879.2654,241.9498;Inherit;False;Property;_EmissColor;EmissColor;3;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,18.99748,21.36125,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomStandardSurface;1;-505.1965,111.1643;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LinearToGammaNode;7;-258.6855,119.8312;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/CustomStandard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;6;0;5;2
WireConnection;1;0;3;0
WireConnection;1;1;4;0
WireConnection;1;2;8;0
WireConnection;1;3;5;3
WireConnection;1;4;6;0
WireConnection;1;5;5;1
WireConnection;7;0;1;0
WireConnection;0;13;7;0
ASEEND*/
//CHKSM=7C686E8AB3FF3B16C26B516096B04CF77BFABE8C