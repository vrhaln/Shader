// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Particle/LightSmoke"
{
	Properties
	{
		_MainColor("MainColor", Color) = (0,0,0,0)
		_ShadowColor("ShadowColor", Color) = (0.5283019,0.5283019,0.5283019,0)
		_MainTex("MainTex", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.CompareFunction)]_Ztest("Ztest", Float) = 4
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		_Distance("Distance", Range( 0 , 3)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		ZWrite Off
		ZTest [_Ztest]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 screenPosition37;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform float _Ztest;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Distance;
		uniform float4 _ShadowColor;
		uniform float4 _MainColor;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalScale;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos37 = ase_vertex3Pos;
			float4 ase_screenPos37 = ComputeScreenPos( UnityObjectToClipPos( vertexPos37 ) );
			o.screenPosition37 = ase_screenPos37;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			float4 ase_screenPos37 = i.screenPosition37;
			float4 ase_screenPosNorm37 = ase_screenPos37 / ase_screenPos37.w;
			ase_screenPosNorm37.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm37.z : ase_screenPosNorm37.z * 0.5 + 0.5;
			float screenDepth37 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm37.xy ));
			float distanceDepth37 = abs( ( screenDepth37 - LinearEyeDepth( ase_screenPosNorm37.z ) ) / ( _Distance ) );
			float temp_output_40_0 = saturate( distanceDepth37 );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult9 = dot( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), _NormalScale ) )) , ase_worldlightDir );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_25_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 break28 = temp_output_25_0;
			float LightAtten31 = max( max( break28.x , break28.y ) , break28.z );
			float4 lerpResult57 = lerp( ( tex2DNode3.r * _ShadowColor ) , ( tex2DNode3.r * _MainColor ) , ( dotResult9 * saturate( LightAtten31 ) ));
			float3 temp_cast_0 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch26 = temp_cast_0;
			#else
				float3 staticSwitch26 = temp_output_25_0;
			#endif
			float3 LightColor27 = staticSwitch26;
			c.rgb = saturate( ( lerpResult57 * i.vertexColor * temp_output_40_0 * float4( LightColor27 , 0.0 ) ) ).rgb;
			c.a = saturate( ( ( tex2DNode3.r * i.vertexColor.a ) * temp_output_40_0 ) );
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
Version=18935
248;532;1427;657;2619.843;-959.9946;2.431387;True;True
Node;AmplifyShaderEditor.CommentaryNode;21;-2064.003,1086.721;Inherit;False;1525.385;680.1929;LightAtten;10;31;30;29;28;27;26;25;24;23;22;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;22;-2006.003,1434.517;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;23;-1988.715,1514.376;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1744.261,1448.062;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-1430.659,1467.022;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;29;-1190.755,1445.915;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;30;-1035.807,1478.231;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2659.439,344.9259;Inherit;False;Property;_NormalScale;NormalScale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-2455.229,295.1822;Inherit;True;Property;_NormalMap;NormalMap;5;0;Create;True;0;0;0;False;0;False;-1;None;272b65a8ab086a24194d8757063e7b1e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-771.6204,1479.997;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;8;-2101.233,494.1761;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1681.188,584.5538;Inherit;False;31;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1583.654,1211.963;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;7;-2097.54,300.3187;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;9;-1821.56,362.8936;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;41;-1098.838,693.3408;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1064.088,-312.4261;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;None;f9088ccbf03e56d4cbe05c99bef8c13a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;26;-1342.075,1193.408;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1152.384,879.4407;Inherit;False;Property;_Distance;Distance;7;0;Create;True;0;0;0;False;0;False;0.1;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;-1021.983,68.90672;Inherit;False;Property;_ShadowColor;ShadowColor;2;0;Create;True;0;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.3396226,0.3396226,0.3396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-1025.308,-105.7714;Inherit;False;Property;_MainColor;MainColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6415094,0.6415094,0.6415094,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;34;-1440,586.6206;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-985.0574,1192.289;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1234.775,369.9772;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;37;-746.3107,747.1944;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-534.3898,-32.32451;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-530.7817,-146.6653;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;4;-572.8492,278.4245;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;33;-274.6715,290.7315;Inherit;False;27;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-196.088,545.985;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;40;-453.7739,745.2971;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;-222.5301,-48.5369;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1;-1380.749,-637.0974;Inherit;False;214;166;Enum;1;2;Enum;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;85.79045,80.66695;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;7.73765,714.4333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;59;352.2744,120.6628;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2742.135,-279.0071;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2130.166,-70.67518;Inherit;False;Property;_Disturb;Disturb;9;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;-1512.425,-409.4492;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;18;198.3531,716.2273;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;-2115.944,-307.8627;Inherit;True;Property;_DisturbTex;DisturbTex;8;0;Create;True;0;0;0;False;0;False;-1;None;238e6e4135c4ef9449f33b9db6214149;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1330.749,-587.0975;Inherit;False;Property;_Ztest;Ztest;4;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-2813.392,-416.9629;Inherit;False;0;42;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;53;-2331.577,-417.0913;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-2496.414,-417.8651;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-1785.921,-279.408;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;56;-1216.395,-413.6483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;609.6318,72.69744;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Particle/LightSmoke;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;True;2;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;22;0
WireConnection;25;1;23;1
WireConnection;28;0;25;0
WireConnection;29;0;28;0
WireConnection;29;1;28;1
WireConnection;30;0;29;0
WireConnection;30;1;28;2
WireConnection;10;5;20;0
WireConnection;31;0;30;0
WireConnection;7;0;10;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;26;1;25;0
WireConnection;26;0;24;0
WireConnection;34;0;32;0
WireConnection;27;0;26;0
WireConnection;14;0;9;0
WireConnection;14;1;34;0
WireConnection;37;1;41;0
WireConnection;37;0;38;0
WireConnection;63;0;3;1
WireConnection;63;1;58;0
WireConnection;60;0;3;1
WireConnection;60;1;17;0
WireConnection;6;0;3;1
WireConnection;6;1;4;4
WireConnection;40;0;37;0
WireConnection;57;0;63;0
WireConnection;57;1;60;0
WireConnection;57;2;14;0
WireConnection;15;0;57;0
WireConnection;15;1;4;0
WireConnection;15;2;40;0
WireConnection;15;3;33;0
WireConnection;39;0;6;0
WireConnection;39;1;40;0
WireConnection;59;0;15;0
WireConnection;44;0;53;0
WireConnection;44;1;45;0
WireConnection;44;2;46;0
WireConnection;18;0;39;0
WireConnection;42;1;53;0
WireConnection;53;0;48;0
WireConnection;48;0;51;0
WireConnection;48;1;49;0
WireConnection;45;0;42;1
WireConnection;45;1;42;2
WireConnection;56;0;44;0
WireConnection;0;9;18;0
WireConnection;0;13;59;0
ASEEND*/
//CHKSM=ADBE512E6BE9D601EB012CFF06103067FCB3B086