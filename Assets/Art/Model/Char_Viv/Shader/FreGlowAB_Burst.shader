// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/FreGlowAB_Burst"
{
	Properties
	{
		[Toggle(_UV1_WCONTORLEMISSION_ON)] _UV1_WContorlEmission("UV1_WContorlEmission", Float) = 0
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		_FreColor("FreColor", Color) = (1,1,1,1)
		_Fre("Fre", Vector) = (0,1,5,0)
		[Toggle(_ONEMINUS_ON)] _OneMinus("OneMinus", Float) = 0
		_MainColor("MainColor", Color) = (0,0,0,0)
		_EmissStr("EmissStr", Float) = 1
		_InternalFlameRange("InternalFlameRange", Range( 0 , 1)) = 0.5
		_InternalFlameEdge("InternalFlameEdge", Range( 0 , 1)) = 0.3935294
		_DissolutionTex("DissolutionTex", 2D) = "white" {}
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		_DissolutionEdge("DissolutionEdge", Range( 0 , 1)) = 0.3935294
		_RampTex("RampTex", 2D) = "white" {}
		[Toggle(_FADE_ON)] _Fade("Fade", Float) = 0
		_FadeRange("FadeRange", Float) = 1
		_FadeHardnss("FadeHardnss", Float) = 1
		_MainOpacity("MainOpacity", Range( 0 , 1)) = 1
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		_VertexOffsetTexPanner("VertexOffsetTexPanner", Vector) = (0,0,1,0)
		_VertexOffsetStr("VertexOffsetStr", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _FADE_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma shader_feature_local _ONEMINUS_ON
		#pragma shader_feature_local _UV1_WCONTORLEMISSION_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
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

		uniform float _CullMode;
		uniform float _ZTestMode;
		uniform sampler2D _VertexOffsetTex;
		uniform float3 _VertexOffsetTexPanner;
		uniform float4 _VertexOffsetTex_ST;
		uniform float _VertexOffsetStr;
		uniform float _FadeRange;
		uniform float _FadeHardnss;
		uniform sampler2D _RampTex;
		uniform float _DissolutionEdge;
		uniform sampler2D _DissolutionTex;
		uniform float3 _DissolutionTexPanner;
		uniform float4 _DissolutionTex_ST;
		uniform float _Dissolution;
		uniform float3 _Fre;
		uniform float _MainOpacity;
		uniform float4 _MainColor;
		uniform float4 _FreColor;
		uniform float _InternalFlameEdge;
		uniform float _InternalFlameRange;
		uniform float _EmissStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float mulTime155 = _Time.y * _VertexOffsetTexPanner.z;
			float2 appendResult156 = (float2(_VertexOffsetTexPanner.x , _VertexOffsetTexPanner.y));
			float4 uvs_VertexOffsetTex = v.texcoord;
			uvs_VertexOffsetTex.xy = v.texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
			float2 panner158 = ( mulTime155 * appendResult156 + uvs_VertexOffsetTex.xy);
			float2 break159 = panner158;
			float2 appendResult160 = (float2(break159.x , break159.y));
			#ifdef _FADE_ON
				float staticSwitch111 = saturate( ( ( ( 1.0 - v.texcoord.xy.y ) - ( _FadeRange * 0.1 ) ) * _FadeHardnss ) );
			#else
				float staticSwitch111 = 1.0;
			#endif
			float UpFade161 = staticSwitch111;
			v.vertex.xyz += ( ase_vertexNormal * tex2Dlod( _VertexOffsetTex, float4( appendResult160, 0, 0.0) ).r * 0.1 * _VertexOffsetStr * ( 1.0 - UpFade161 ) );
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime84 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult85 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolutionTex = i.uv_texcoord;
			uvs_DissolutionTex.xy = i.uv_texcoord.xy * _DissolutionTex_ST.xy + _DissolutionTex_ST.zw;
			float2 panner86 = ( mulTime84 * appendResult85 + uvs_DissolutionTex.xy);
			float4 tex2DNode91 = tex2D( _DissolutionTex, panner86 );
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch70 = i.uv_texcoord.w;
			#else
				float staticSwitch70 = _Dissolution;
			#endif
			float DissolutionControl71 = staticSwitch70;
			float smoothstepResult189 = smoothstep( _DissolutionEdge , 1.0 , ( tex2DNode91.r + 1.0 + ( DissolutionControl71 * -2.0 ) ));
			float2 appendResult190 = (float2(smoothstepResult189 , 0.0));
			float4 tex2DNode191 = tex2D( _RampTex, appendResult190 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV27 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode27 = ( _Fre.x + _Fre.y * pow( 1.0 - fresnelNdotV27, _Fre.z ) );
			#ifdef _ONEMINUS_ON
				float staticSwitch47 = ( 1.0 - fresnelNode27 );
			#else
				float staticSwitch47 = fresnelNode27;
			#endif
			float FreFade176 = saturate( staticSwitch47 );
			#ifdef _FADE_ON
				float staticSwitch111 = saturate( ( ( ( 1.0 - i.uv_texcoord.xy.y ) - ( _FadeRange * 0.1 ) ) * _FadeHardnss ) );
			#else
				float staticSwitch111 = 1.0;
			#endif
			float UpFade161 = staticSwitch111;
			float lerpResult200 = lerp( 0.0 , ( tex2DNode191.r + ( 1.0 - FreFade176 ) + UpFade161 ) , tex2DNode191.r);
			float VertexColorA76 = i.vertexColor.a;
			float FinalOpacity143 = saturate( ( lerpResult200 * VertexColorA76 ) );
			#ifdef _UV1_WCONTORLEMISSION_ON
				float staticSwitch73 = i.uv_texcoord.z;
			#else
				float staticSwitch73 = 1.0;
			#endif
			float UV1_W74 = staticSwitch73;
			float4 VertexColorRGB77 = i.vertexColor;
			float smoothstepResult98 = smoothstep( _InternalFlameEdge , 1.0 , ( tex2DNode91.r + 1.0 + ( _InternalFlameRange * -2.0 ) ));
			float2 appendResult100 = (float2(smoothstepResult98 , 0.0));
			float FinalInSideOpacity119 = saturate( ( tex2D( _RampTex, appendResult100 ).r + ( 1.0 - FreFade176 ) + UpFade161 ) );
			float4 lerpResult134 = lerp( _MainColor , ( _FreColor * UV1_W74 * VertexColorRGB77 ) , ( ( 1.0 - FinalInSideOpacity119 ) * _EmissStr ));
			c.rgb = lerpResult134.rgb;
			c.a = ( FinalOpacity143 * _MainOpacity );
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
-2393;312;1916;956;251.372;468.641;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;67;-3000.674,-559.3351;Inherit;False;1252.226;378.732;Comment;7;74;73;72;71;70;69;68;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;81;-2795.324,1546.809;Inherit;False;5216.711;2546.331;Comment;55;91;163;177;39;164;40;35;36;42;41;143;178;161;111;119;105;107;104;102;101;99;100;97;96;98;95;94;92;93;90;89;88;86;87;85;84;83;82;182;183;185;186;195;191;189;190;196;197;198;199;200;201;202;203;204;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2675.713,-281.1662;Inherit;False;Property;_Dissolution;Dissolution;14;0;Create;True;0;0;0;False;0;False;0.15;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-2950.674,-482.6032;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-2682.57,3178.93;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;-2566.141,3355.124;Inherit;False;Property;_FadeRange;FadeRange;18;0;Create;True;0;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;82;-2672.666,2127.475;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;13;0;Create;True;0;0;0;False;0;False;0,0,1;-2,-5,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;29;-1531.012,60.48729;Inherit;False;Property;_Fre;Fre;4;0;Create;True;0;0;0;False;0;False;0,1,5;0,9,7;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;70;-2305.085,-345.1022;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;2;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;84;-2378.667,2242.475;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-2355.992,2126.186;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1986.447,-339.5562;Inherit;False;DissolutionControl;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;96;-2432.862,3242.937;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;27;-1363.922,42.99401;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-2386.308,3357.983;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-2441.679,1974.594;Inherit;False;0;91;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;87;-2008.331,2886.162;Inherit;False;71;DissolutionControl;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-2138.419,3499.987;Inherit;False;Property;_FadeHardnss;FadeHardnss;19;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1770.1,2366.12;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-1951.175,3018.906;Inherit;False;Constant;_Float0;Float 0;20;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;48;-913.0822,146.6449;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;86;-2070.284,1992.575;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-1845.241,2236.104;Inherit;False;Property;_InternalFlameRange;InternalFlameRange;10;0;Create;True;0;0;0;False;0;False;0.5;0.55;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;-2188.394,3262.421;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;91;-1822.252,1978.234;Inherit;True;Property;_DissolutionTex;DissolutionTex;12;0;Create;True;0;0;0;False;0;False;-1;None;b22543dc54d133a469b9919e0ad3ac07;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1889.188,3279.577;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1488,2240;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;-1669.075,2892.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1456,2096;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;47;-709.7913,42.26184;Inherit;False;Property;_OneMinus;OneMinus;5;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-1637.075,2748.786;Inherit;False;Constant;_Float5;Float 5;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;188;-1349.075,2700.786;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;195;-1546.092,3040.053;Inherit;False;Property;_DissolutionEdge;DissolutionEdge;15;0;Create;True;0;0;0;False;0;False;0.3935294;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-468.238,57.27625;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1672.894,3180.74;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;-1168,2048;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1365.017,2387.267;Inherit;False;Property;_InternalFlameEdge;InternalFlameEdge;11;0;Create;True;0;0;0;False;0;False;0.3935294;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;105;-1696.13,3285.58;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;98;-960,2032;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;111;-1420.209,3202.629;Inherit;False;Property;_Fade;Fade;17;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-198.5204,41.07212;Inherit;False;FreFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;189;-1171.375,2702.052;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-723.3159,3107.018;Inherit;True;176;FreFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;-664.5544,2327.468;Inherit;True;176;FreFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;78;-1348.471,-508.1169;Inherit;False;498.0005;281.3341;VertexColor;3;77;76;75;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;-672,2032;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;190;-760.1107,2690.903;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-1212.016,3211.358;Inherit;False;UpFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-453.2951,3237.634;Inherit;True;161;UpFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;191;-526.6824,2669.304;Inherit;True;Property;_TextureSample0;Texture Sample 0;16;0;Create;True;0;0;0;False;0;False;-1;None;da2150fdbd9743b4a9ce23c537eeb33b;True;0;False;white;Auto;False;Instance;104;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;75;-1298.471,-458.1169;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;182;-399.2355,2331.649;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;-480,2000;Inherit;True;Property;_RampTex;RampTex;16;0;Create;True;0;0;0;False;0;False;-1;None;da2150fdbd9743b4a9ce23c537eeb33b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;163;-394.5336,2458.084;Inherit;True;161;UpFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;197;-457.997,3111.199;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;-75.02392,2032.357;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-1079.796,-342.783;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;199;-120.0601,2845.53;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;154;352.7656,809.9346;Inherit;False;Property;_VertexOffsetTexPanner;VertexOffsetTexPanner;25;0;Create;True;0;0;0;False;0;False;0,0,1;-1,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;185;328.7588,2046.332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;155;709.7723,913.5855;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;200;179.534,2651.62;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;157;486.9496,660.6902;Inherit;False;0;153;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;156;684.7642,773.9346;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2687.156,-509.3351;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;226.4054,2946.136;Inherit;False;76;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;698.5418,2031.212;Inherit;True;FinalInSideOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;158;875.3455,673.6711;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;696.175,2643.717;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;73;-2315.561,-503.4341;Inherit;False;Property;_UV1_WContorlEmission;UV1_WContorlEmission;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-1964.756,-505.7772;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;159;1104.359,669.9542;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;201;868.9138,2650.239;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;331.8994,155.2851;Inherit;False;119;FinalInSideOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1081.471,-449.2109;Inherit;False;VertexColorRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;399.3326,-54.41108;Inherit;False;74;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;160;1388.122,669.7492;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;1811.323,1006.4;Inherit;False;161;UpFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;392.628,37.35898;Inherit;False;77;VertexColorRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;570.701,246.2206;Inherit;False;Property;_EmissStr;EmissStr;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;1008.034,2654.778;Inherit;False;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;140;587.8979,162.9863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;175;368.4196,-241.4433;Inherit;False;Property;_FreColor;FreColor;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;132;417.4702,-438.8912;Inherit;False;Property;_MainColor;MainColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;787.8714,168.8513;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-1699.63,-504.3889;Inherit;False;235;268.8913;Comment;2;43;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;153;1571.319,648.706;Inherit;True;Property;_VertexOffsetTex;VertexOffsetTex;24;0;Create;True;0;0;0;False;0;False;-1;None;6fda4a099411a18468456111546c16ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;150;1941.302,776.9967;Inherit;False;Constant;_Float6;Float 6;22;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;1604.87,215.1142;Inherit;True;143;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;1601.587,442.7254;Inherit;False;Property;_MainOpacity;MainOpacity;21;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;148;1891.825,508.4037;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;168;2024.323,1010.4;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;709.225,-208.1693;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;151;1913.825,871.9317;Inherit;False;Property;_VertexOffsetStr;VertexOffsetStr;26;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;-2021.627,1210.336;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;2199.382,640.6034;Inherit;False;5;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;42;-2557.289,3823.178;Inherit;False;Property;_DepthFadeRangeStr;DepthFadeRangeStr;20;0;Create;True;0;0;0;False;0;False;1,0.2,0;1,1.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;167;1934.323,1109.4;Inherit;False;164;DownFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-650.8779,1048.22;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-1343.278,966.4996;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-1305.648,3829.403;Inherit;False;DownFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;147.2303,3090.232;Inherit;False;Constant;_Float7;Float 7;26;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;40;-1665.187,3757.165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;204;-1623.112,2589.332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-2046.635,1070.685;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1676.967,-356.4976;Inherit;False;Property;_CullMode;CullMode;22;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-647.8779,936.22;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;36;-2513.891,3653.585;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;2065.603,226.0875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1499.735,3829.15;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;50;-2297.634,1117.685;Inherit;False;Property;_MainTexPanner;MainTexPanner;9;0;Create;True;0;0;0;False;0;False;0,0,1;-0.5,-5,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-639.8779,1144.22;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1667.077,-312.3974;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;57;-1144.993,941.5216;Inherit;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;0;False;0;False;-1;None;b22543dc54d133a469b9919e0ad3ac07;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;39;-1858.067,3748.672;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;35;-2119.252,3758.118;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;54;-1856.054,970.4216;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;134;1364.287,-31.72229;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;55;-1627.041,966.7046;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;-644.7971,1249.563;Inherit;True;MainTexA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-2244.45,957.4407;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;79;902.0367,-584.601;Inherit;False;77;VertexColorRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1678.63,-454.3889;Inherit;False;Property;_ZTestMode;ZTestMode;23;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2400.547,-119.234;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/FreGlowAB_Burst;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;1;68;0
WireConnection;70;0;69;4
WireConnection;84;0;82;3
WireConnection;85;0;82;1
WireConnection;85;1;82;2
WireConnection;71;0;70;0
WireConnection;96;0;93;2
WireConnection;27;1;29;1
WireConnection;27;2;29;2
WireConnection;27;3;29;3
WireConnection;97;0;92;0
WireConnection;48;0;27;0
WireConnection;86;0;83;0
WireConnection;86;2;85;0
WireConnection;86;1;84;0
WireConnection;99;0;96;0
WireConnection;99;1;97;0
WireConnection;91;1;86;0
WireConnection;102;0;99;0
WireConnection;102;1;101;0
WireConnection;89;0;186;0
WireConnection;89;1;88;0
WireConnection;193;0;87;0
WireConnection;193;1;194;0
WireConnection;47;1;27;0
WireConnection;47;0;48;0
WireConnection;188;0;91;1
WireConnection;188;1;192;0
WireConnection;188;2;193;0
WireConnection;31;0;47;0
WireConnection;94;0;91;1
WireConnection;94;1;90;0
WireConnection;94;2;89;0
WireConnection;105;0;102;0
WireConnection;98;0;94;0
WireConnection;98;1;95;0
WireConnection;111;1;107;0
WireConnection;111;0;105;0
WireConnection;176;0;31;0
WireConnection;189;0;188;0
WireConnection;189;1;195;0
WireConnection;100;0;98;0
WireConnection;190;0;189;0
WireConnection;161;0;111;0
WireConnection;191;1;190;0
WireConnection;182;0;177;0
WireConnection;104;1;100;0
WireConnection;197;0;196;0
WireConnection;183;0;104;1
WireConnection;183;1;182;0
WireConnection;183;2;163;0
WireConnection;76;0;75;4
WireConnection;199;0;191;1
WireConnection;199;1;197;0
WireConnection;199;2;198;0
WireConnection;185;0;183;0
WireConnection;155;0;154;3
WireConnection;200;1;199;0
WireConnection;200;2;191;1
WireConnection;156;0;154;1
WireConnection;156;1;154;2
WireConnection;119;0;185;0
WireConnection;158;0;157;0
WireConnection;158;2;156;0
WireConnection;158;1;155;0
WireConnection;202;0;200;0
WireConnection;202;1;203;0
WireConnection;73;1;72;0
WireConnection;73;0;69;3
WireConnection;74;0;73;0
WireConnection;159;0;158;0
WireConnection;201;0;202;0
WireConnection;77;0;75;0
WireConnection;160;0;159;0
WireConnection;160;1;159;1
WireConnection;143;0;201;0
WireConnection;140;0;139;0
WireConnection;145;0;140;0
WireConnection;145;1;32;0
WireConnection;153;1;160;0
WireConnection;168;0;166;0
WireConnection;205;0;175;0
WireConnection;205;1;125;0
WireConnection;205;2;206;0
WireConnection;51;0;50;3
WireConnection;147;0;148;0
WireConnection;147;1;153;1
WireConnection;147;2;150;0
WireConnection;147;3;151;0
WireConnection;147;4;168;0
WireConnection;121;0;57;2
WireConnection;56;0;55;0
WireConnection;56;1;55;1
WireConnection;164;0;41;0
WireConnection;40;0;39;0
WireConnection;52;0;50;1
WireConnection;52;1;50;2
WireConnection;122;0;57;1
WireConnection;129;0;144;0
WireConnection;129;1;113;0
WireConnection;41;0;40;0
WireConnection;41;1;42;2
WireConnection;123;0;57;3
WireConnection;57;1;56;0
WireConnection;39;0;35;0
WireConnection;35;1;36;0
WireConnection;35;0;42;1
WireConnection;54;0;53;0
WireConnection;54;2;52;0
WireConnection;54;1;51;0
WireConnection;134;0;132;0
WireConnection;134;1;205;0
WireConnection;134;2;145;0
WireConnection;55;0;54;0
WireConnection;172;0;57;4
WireConnection;0;9;129;0
WireConnection;0;13;134;0
WireConnection;0;11;147;0
ASEEND*/
//CHKSM=D1A085892F43860C5A4790DAD57C8AAA331C32BF