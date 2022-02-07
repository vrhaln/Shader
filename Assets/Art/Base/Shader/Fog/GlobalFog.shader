// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Fog/GlobalFog"
{
	Properties
	{
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 0
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 700
		_FogHeightStart("Fog Height Start", Float) = 0
		_FogHeightEnd("Fog Height End", Float) = 700
		_SunFogColor("Sun Fog Color", Color) = (0,0,0,0)
		_SunFogRange("Sun Fog Range", Float) = 0
		_SunFogIntensity("Sun Fog Intensity", Float) = 0
		_BGTex("BGTex", 2D) = "white" {}
		_BGScale("BGScale", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform sampler2D _BGTex;
		uniform float _BGScale;
		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float _SunFogRange;
		uniform float _SunFogIntensity;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _FogHeightEnd;
		uniform float _FogHeightStart;
		uniform float _FogIntensity;


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult104 = (float2(ase_worldPos.x , ase_worldPos.z));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 UV22_g8 = ase_screenPosNorm.xy;
			float2 localUnStereo22_g8 = UnStereo( UV22_g8 );
			float2 break64_g7 = localUnStereo22_g8;
			float4 tex2DNode36_g7 = tex2D( _CameraDepthTexture, ase_screenPosNorm.xy );
			#ifdef UNITY_REVERSED_Z
				float4 staticSwitch38_g7 = ( 1.0 - tex2DNode36_g7 );
			#else
				float4 staticSwitch38_g7 = tex2DNode36_g7;
			#endif
			float3 appendResult39_g7 = (float3(break64_g7.x , break64_g7.y , staticSwitch38_g7.r));
			float4 appendResult42_g7 = (float4((appendResult39_g7*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g7 = mul( unity_CameraInvProjection, appendResult42_g7 );
			float4 appendResult49_g7 = (float4(( ( (temp_output_43_0_g7).xyz / (temp_output_43_0_g7).w ) * float3( 1,1,-1 ) ) , 1.0));
			float4 WorldPosFormDepth92 = mul( unity_CameraToWorld, appendResult49_g7 );
			float4 normalizeResult100 = normalize( ( WorldPosFormDepth92 - float4( _WorldSpaceCameraPos , 0.0 ) ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult41 = dot( normalizeResult100 , float4( ase_worldlightDir , 0.0 ) );
			float clampResult47 = clamp( pow( (dotResult41*0.5 + 0.5) , _SunFogRange ) , 0.0 , 1.0 );
			float SunFog52 = ( clampResult47 * _SunFogIntensity );
			float4 lerpResult55 = lerp( ( tex2D( _BGTex, ( appendResult104 * _BGScale ) ) * _FogColor ) , _SunFogColor , SunFog52);
			o.Emission = lerpResult55.rgb;
			float temp_output_11_0_g12 = _FogDistanceEnd;
			float clampResult7_g12 = clamp( ( ( temp_output_11_0_g12 - distance( WorldPosFormDepth92 , float4( float3(0,0,0) , 0.0 ) ) ) / ( temp_output_11_0_g12 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance66 = ( 1.0 - clampResult7_g12 );
			float temp_output_11_0_g11 = _FogHeightEnd;
			float clampResult7_g11 = clamp( ( ( temp_output_11_0_g11 - (WorldPosFormDepth92).y ) / ( temp_output_11_0_g11 - _FogHeightStart ) ) , 0.0 , 1.0 );
			float FogHight31 = ( 1.0 - ( 1.0 - clampResult7_g11 ) );
			float clampResult35 = clamp( ( ( FogDistance66 * FogHight31 ) * _FogIntensity ) , 0.0 , 1.0 );
			o.Alpha = clampResult35;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1583;19;1562;923;3468.817;380.3893;2.556643;True;False
Node;AmplifyShaderEditor.FunctionNode;91;-4294.293,764.1486;Inherit;False;Reconstruct World Position From Depth;0;;7;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;51;-3168.627,1529.742;Inherit;False;1938.36;561.4897;Sun Fog;13;99;98;96;52;48;47;49;44;43;45;41;42;100;Sun Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3931.516,766.3242;Inherit;False;WorldPosFormDepth;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;99;-3126.721,1689.222;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;96;-3119.07,1580.222;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2959.043,742.0298;Inherit;False;1346.057;508.7882;Fog Hight;7;31;30;29;28;33;95;94;Fog Hight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;98;-2845.517,1593.732;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;42;-2797.887,1824.845;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;100;-2670.384,1617.743;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2979.503,100.2627;Inherit;False;1346.057;508.7882;Fog Distance;8;66;65;64;63;62;61;93;101;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-2908.8,801.564;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;95;-2583.011,861.8793;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2647.933,993.2099;Inherit;False;Property;_FogHeightStart;Fog Height Start;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2648.201,1096.253;Inherit;False;Property;_FogHeightEnd;Fog Height End;7;0;Create;True;0;0;False;0;False;700;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;101;-2867.158,465.3011;Inherit;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;41;-2486.887,1697.845;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-2924.148,236.6291;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceOpNode;63;-2585.831,275.2888;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;43;-2320.887,1700.845;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2336.887,1859.845;Inherit;False;Property;_SunFogRange;Sun Fog Range;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;30;-2369.751,899.4299;Inherit;False;Fog Linear;-1;;11;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2488.273,373.9011;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2486.096,476.9437;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;5;0;Create;True;0;0;False;0;False;700;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-2088.477,900.6658;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-2080.887,1785.845;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;65;-2163.614,275.2289;Inherit;False;Fog Linear;-1;;12;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;103;-1914.305,-386.9286;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;56;-1073.047,39.22899;Inherit;False;922.4023;873.5225;Fog Combine;8;32;54;53;35;55;57;58;68;Fog Combine;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-1857.446,349.2613;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1692.406,-195.0421;Inherit;False;Property;_BGScale;BGScale;12;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1945.569,1966.198;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1842.986,932.028;Inherit;False;FogHight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;47;-1902.886,1810.845;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;-1663.63,-353.4238;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1022.051,586.5389;Inherit;False;66;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-1500.755,-280.9088;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1647.669,1888.599;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1027.469,722.2589;Inherit;False;31;FogHight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-763.0508,717.5389;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-796.1034,833.5921;Inherit;False;Property;_FogIntensity;Fog Intensity;3;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1432.321,1939.101;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;102;-1276.953,-281.9274;Inherit;True;Property;_BGTex;BGTex;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-1336.222,-54.13313;Inherit;False;Property;_FogColor;FogColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.1607843,0.1764706,0.1960784,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-507.0154,728.9041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-892.827,-72.76705;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;-1003.005,284.9021;Inherit;False;Property;_SunFogColor;Sun Fog Color;8;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-931.7707,468.3118;Inherit;False;52;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-341.3781,705.7985;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;61;-2941.734,320.7441;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;55;-680.7711,359.912;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;59.32795,284.5863;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Fog/GlobalFog;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;92;0;91;0
WireConnection;98;0;96;0
WireConnection;98;1;99;0
WireConnection;100;0;98;0
WireConnection;95;0;94;0
WireConnection;41;0;100;0
WireConnection;41;1;42;0
WireConnection;63;0;93;0
WireConnection;63;1;101;0
WireConnection;43;0;41;0
WireConnection;30;13;95;0
WireConnection;30;12;28;0
WireConnection;30;11;29;0
WireConnection;33;0;30;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;65;13;63;0
WireConnection;65;12;64;0
WireConnection;65;11;62;0
WireConnection;66;0;65;0
WireConnection;31;0;33;0
WireConnection;47;0;44;0
WireConnection;104;0;103;1
WireConnection;104;1;103;3
WireConnection;107;0;104;0
WireConnection;107;1;105;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;68;0;67;0
WireConnection;68;1;32;0
WireConnection;52;0;48;0
WireConnection;102;1;107;0
WireConnection;58;0;68;0
WireConnection;58;1;57;0
WireConnection;106;0;102;0
WireConnection;106;1;17;0
WireConnection;35;0;58;0
WireConnection;55;0;106;0
WireConnection;55;1;53;0
WireConnection;55;2;54;0
WireConnection;0;2;55;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=5A80EC9E3E2FA703F5DF6351DDE5D38CC0769513