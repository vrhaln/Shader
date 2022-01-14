// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Fog/FogBasic"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (0,0,0,0)
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 0
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 700
		_FogHeightStart("Fog Height Start", Float) = 0
		_FogHeightEnd("Fog Height End", Float) = 700
		_SunFogColor("Sun Fog Color", Color) = (0,0,0,0)
		_SunFogRange("Sun Fog Range", Float) = 0
		_SunFogIntensity("Sun Fog Intensity", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float3 viewDir;
			float3 worldPos;
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

		uniform float4 _BaseColor;
		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		uniform float _SunFogRange;
		uniform float _SunFogIntensity;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _FogHeightEnd;
		uniform float _FogHeightStart;
		uniform float _FogIntensity;


		float3 ACESTonemap37( float3 LinearColor )
		{
			float a = 2.51f;
			float b = 0.03f;
			float c = 2.43f;
			float d = 0.59f;
			float e = 0.14f;
			return
			saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s69 = (SurfaceOutputStandard ) 0;
			s69.Albedo = _BaseColor.rgb;
			float3 ase_worldNormal = i.worldNormal;
			s69.Normal = ase_worldNormal;
			s69.Emission = float3( 0,0,0 );
			s69.Metallic = 0.0;
			s69.Smoothness = 0.0;
			s69.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi69 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g69 = UnityGlossyEnvironmentSetup( s69.Smoothness, data.worldViewDir, s69.Normal, float3(0,0,0));
			gi69 = UnityGlobalIllumination( data, s69.Occlusion, s69.Normal, g69 );
			#endif

			float3 surfResult69 = LightingStandard ( s69, viewDir, gi69 ).rgb;
			surfResult69 += s69.Emission;

			#ifdef UNITY_PASS_FORWARDADD//69
			surfResult69 -= s69.Emission;
			#endif//69
			float dotResult41 = dot( -i.viewDir , float3(0,0,1) );
			float clampResult47 = clamp( pow( (dotResult41*0.5 + 0.5) , _SunFogRange ) , 0.0 , 1.0 );
			float SunFog52 = ( clampResult47 * _SunFogIntensity );
			float4 lerpResult55 = lerp( _FogColor , _SunFogColor , SunFog52);
			float temp_output_11_0_g6 = _FogDistanceEnd;
			float3 ase_worldPos = i.worldPos;
			float clampResult7_g6 = clamp( ( ( temp_output_11_0_g6 - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( temp_output_11_0_g6 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance66 = ( 1.0 - clampResult7_g6 );
			float temp_output_11_0_g3 = _FogHeightEnd;
			float clampResult7_g3 = clamp( ( ( temp_output_11_0_g3 - ase_worldPos.y ) / ( temp_output_11_0_g3 - _FogHeightStart ) ) , 0.0 , 1.0 );
			float FogHight31 = ( 1.0 - ( 1.0 - clampResult7_g3 ) );
			float clampResult35 = clamp( ( ( FogDistance66 * FogHight31 ) * _FogIntensity ) , 0.0 , 1.0 );
			float4 lerpResult16 = lerp( float4( surfResult69 , 0.0 ) , lerpResult55 , clampResult35);
			float3 LinearColor37 = ( lerpResult16 * lerpResult16 ).rgb;
			float3 localACESTonemap37 = ACESTonemap37( LinearColor37 );
			c.rgb = max( sqrt( localACESTonemap37 ) , float3( 0,0,0 ) );
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
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1613;96;1239;779;1557.505;627.8765;2.366637;True;False
Node;AmplifyShaderEditor.CommentaryNode;51;-2866.092,1607.134;Inherit;False;1649.897;563.2485;Sun Fog;12;52;44;40;50;41;45;43;49;47;48;42;70;Sun Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;40;-2816.092,1672.495;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;50;-2640.732,1657.134;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;70;-2835.414,1829.944;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;24;-2876.349,876.0441;Inherit;False;1346.057;508.7882;Fog Hight;6;31;30;29;28;26;33;Fog Hight;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2795.912,-29.08578;Inherit;False;1346.057;508.7882;Fog Distance;7;66;65;64;63;62;61;60;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2627.702,20.91434;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-2565.239,1127.224;Inherit;False;Property;_FogHeightStart;Fog Height Start;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;61;-2745.912,226.8658;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-2565.507,1230.267;Inherit;False;Property;_FogHeightEnd;Fog Height End;7;0;Create;True;0;0;False;0;False;700;700;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;41;-2472.815,1775.237;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;26;-2836.737,989.4783;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;62;-2258.472,342.7025;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;5;0;Create;True;0;0;False;0;False;700;80;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;63;-2402.24,145.9402;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;43;-2306.815,1778.237;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;30;-2287.057,1033.444;Inherit;False;Fog Linear;-1;;3;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2322.815,1937.237;Inherit;False;Property;_SunFogRange;Sun Fog Range;9;0;Create;True;0;0;False;0;False;0;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2258.204,239.6599;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-2066.815,1863.237;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-2005.783,1034.68;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;65;-1980.022,145.8804;Inherit;False;Fog Linear;-1;;6;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-1073.047,39.22899;Inherit;False;922.4023;873.5225;Fog Combine;10;32;54;53;17;35;55;16;57;58;68;Fog Combine;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;47;-1888.815,1888.237;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1760.292,1066.042;Inherit;False;FogHight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1931.498,2043.59;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;10;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-1673.854,219.9126;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1633.598,1965.991;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1015.469,695.2589;Inherit;False;31;FogHight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1022.051,586.5389;Inherit;False;66;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-796.1034,833.5921;Inherit;False;Property;_FogIntensity;Fog Intensity;3;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1418.25,2016.493;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-723.0508,657.5389;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;-1023.047,282.3969;Inherit;False;Property;_SunFogColor;Sun Fog Color;8;0;Create;True;0;0;False;0;False;0,0,0,0;0.8018868,0.4406595,0.07943218,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-1008.872,89.22899;Inherit;False;Property;_FogColor;FogColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-931.7707,468.3118;Inherit;False;52;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-990.8453,-350.8585;Inherit;False;Property;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;False;0,0,0,0;0.3647059,0.05490196,0.0509804,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-507.0154,728.9041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-341.3781,705.7985;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-680.7711,359.912;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;69;-755.8934,-209.961;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;16;-332.6447,244.0863;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-82.00183,263.0327;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;37;67.40079,274.9528;Inherit;False;float a = 2.51f@$float b = 0.03f@$float c = 2.43f@$float d = 0.59f@$float e = 0.14f@$return$saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e))@;3;False;1;True;LinearColor;FLOAT3;0,0,0;In;;Inherit;False;ACESTonemap;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;39;288.718,280.2031;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;42;-2816.815,1984.237;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;71;443.8224,270.8782;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-706.4722,-389.0128;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1298.472,-505.0127;Inherit;False;Property;_Smoothness;Smoothness;1;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;2;-948.472,-506.0127;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;713.8127,-20.39465;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Fog/FogBasic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;50;0;40;0
WireConnection;41;0;50;0
WireConnection;41;1;70;0
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;43;0;41;0
WireConnection;30;13;26;2
WireConnection;30;12;28;0
WireConnection;30;11;29;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;33;0;30;0
WireConnection;65;13;63;0
WireConnection;65;12;64;0
WireConnection;65;11;62;0
WireConnection;47;0;44;0
WireConnection;31;0;33;0
WireConnection;66;0;65;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;52;0;48;0
WireConnection;68;0;67;0
WireConnection;68;1;32;0
WireConnection;58;0;68;0
WireConnection;58;1;57;0
WireConnection;35;0;58;0
WireConnection;55;0;17;0
WireConnection;55;1;53;0
WireConnection;55;2;54;0
WireConnection;69;0;4;0
WireConnection;16;0;69;0
WireConnection;16;1;55;0
WireConnection;16;2;35;0
WireConnection;38;0;16;0
WireConnection;38;1;16;0
WireConnection;37;0;38;0
WireConnection;39;0;37;0
WireConnection;71;0;39;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;2;1;5;0
WireConnection;0;13;71;0
ASEEND*/
//CHKSM=7A54828B175A280EEC9E187CE7364F68833A13F2