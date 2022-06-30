// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Water"
{
	Properties
	{
		_ReflectionTex("ReflectionTex", 2D) = "white" {}
		_WaterNormal("WaterNormal", 2D) = "bump" {}
		_NormalTilling("NormalTilling", Float) = 0
		_NormalIntensity("NormalIntensity", Float) = 0
		_WaterSpeed("WaterSpeed", Float) = 1
		_WaterNoise("WaterNoise", Float) = 1
		_SpecSmothness("SpecSmothness", Range( 0.01 , 1)) = 0
		_SpecTint("SpecTint", Color) = (1,1,1,0)
		_SpecIntensity("SpecIntensity", Float) = 1
		_SpecStart("SpecStart", Float) = 0
		_SpecEnd("SpecEnd", Float) = 0
		_UnderWater("UnderWater", 2D) = "white" {}
		_UnderWaterTilling("UnderWaterTilling", Float) = 0
		_WaterDepth("WaterDepth", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float3 viewDir;
			float4 screenPos;
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

		uniform sampler2D _UnderWater;
		uniform float _UnderWaterTilling;
		uniform sampler2D _WaterNormal;
		uniform float _NormalTilling;
		uniform float _WaterSpeed;
		uniform float _NormalIntensity;
		uniform float _WaterDepth;
		uniform sampler2D _ReflectionTex;
		uniform float _WaterNoise;
		uniform float _SpecSmothness;
		uniform float4 _SpecTint;
		uniform float _SpecIntensity;
		uniform float _SpecEnd;
		uniform float _SpecStart;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_11_0 = ( (ase_worldPos).xz / _NormalTilling );
			float temp_output_15_0 = ( _Time.y * 0.1 * _WaterSpeed );
			float2 temp_output_29_0 = ( (( UnpackScaleNormal( tex2D( _WaterNormal, ( temp_output_11_0 + temp_output_15_0 ) ), _NormalIntensity ) + UnpackScaleNormal( tex2D( _WaterNormal, ( ( temp_output_11_0 * 1.5 ) + ( temp_output_15_0 * -1.0 ) ) ), _NormalIntensity ) )).xy * 0.5 );
			float dotResult31 = dot( temp_output_29_0 , temp_output_29_0 );
			float4 appendResult34 = (float4(temp_output_29_0 , sqrt( ( 1.0 - dotResult31 ) ) , 0.0));
			float3 WaterNormal36 = (WorldNormalVector( i , appendResult34.xyz ));
			float2 paralaxOffset103 = ParallaxOffset( 0 , _WaterDepth , i.viewDir );
			float4 UnderWaterColor89 = tex2D( _UnderWater, ( ( ( (ase_worldPos).xz / _UnderWaterTilling ) + ( (WaterNormal36).xy * 0.1 ) ) + paralaxOffset103 ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos42 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 ReflectColor48 = tex2D( _ReflectionTex, ( (ase_screenPosNorm).xy + ( ( (WaterNormal36).xz / ( 1.0 + unityObjectToClipPos42.w ) ) * _WaterNoise ) ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult93 = dot( ase_worldNormal , ase_worldViewDir );
			float clampResult94 = clamp( dotResult93 , 0.0 , 1.0 );
			float temp_output_95_0 = ( 1.0 - clampResult94 );
			float clampResult109 = clamp( ( temp_output_95_0 + 0.2 ) , 0.0 , 1.0 );
			float4 lerpResult96 = lerp( UnderWaterColor89 , ( ReflectColor48 * clampResult109 ) , saturate( temp_output_95_0 ));
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult53 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult54 = dot( WaterNormal36 , normalizeResult53 );
			float clampResult81 = clamp( ( ( _SpecEnd - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( _SpecEnd - _SpecStart ) ) , 0.0 , 1.0 );
			float4 SpecColor66 = ( ( ( pow( max( dotResult54 , 0.0 ) , ( _SpecSmothness * 256.0 ) ) * _SpecTint ) * _SpecIntensity ) * clampResult81 );
			c.rgb = ( lerpResult96 + SpecColor66 ).rgb;
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
				float4 screenPos : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
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
Version=18935
-1466;264;1378;648;752.8796;-583.2103;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;37;-4212.533,-1555.183;Inherit;False;3229.237;960.124;WaterNormal;27;36;35;34;32;31;30;29;17;28;21;26;22;23;6;12;11;15;14;13;9;10;8;33;25;24;16;111;WaterNormal;0,0.3326964,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-4072.292,-1312.281;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;14;-3958.292,-907.2816;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-3962.292,-804.2815;Inherit;False;Property;_WaterSpeed;WaterSpeed;8;0;Create;True;0;0;0;False;0;False;1;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;9;-3880.292,-1296.281;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-3960.292,-1008.282;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4056.292,-1120.281;Inherit;False;Property;_NormalTilling;NormalTilling;3;0;Create;True;0;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;11;-3752.292,-1264.281;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3592.292,-973.2816;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3591.292,-803.2815;Inherit;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3736.292,-992.2816;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-3446.292,-848.2816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-3448.292,-1024.282;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-3292.139,-1040.018;Inherit;False;Property;_NormalIntensity;NormalIntensity;5;0;Create;True;0;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-3240.293,-944.2816;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-3512.292,-1184.281;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;21;-3080.292,-912.2816;Inherit;True;Global;WaterNormal;WaterNormal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Instance;6;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-3080.292,-1200.281;Inherit;True;Property;_WaterNormal;WaterNormal;2;0;Create;True;0;0;0;False;0;False;-1;None;9f8332b722dfa604581ebcbcbe627b3d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-2712.293,-1024.282;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;17;-2568.294,-1008.282;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2552.294,-912.2816;Inherit;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2392.294,-960.2816;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;31;-2184.294,-896.2816;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-2040.295,-880.2816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;33;-1878.295,-864.2816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1726.17,-985.0597;Inherit;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldNormalVector;35;-1528.873,-992.8701;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;46;-4214.069,-396.4401;Inherit;False;1831.428;802.2573;ReflectColor;14;2;20;40;5;18;43;4;44;39;42;45;38;41;48;ReflectColor;0,1,0.02018213,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-4225.502,598.5687;Inherit;False;2049.217;960.0839;SpecColor;27;66;81;80;79;76;77;78;75;74;73;64;65;61;57;63;59;56;54;58;60;55;53;52;50;51;82;83;SpecColor;1,0.501811,0,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;50;-4110.83,659.9926;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;51;-4161.908,838.3834;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;41;-4169.791,114.1964;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-1268.753,-954.914;Inherit;False;WaterNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-4018.802,-145.6598;Inherit;False;36;WaterNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;107;-4223.688,1761.993;Inherit;False;1806.032;951.7758;UnderWaterColor;15;84;89;88;98;87;101;102;100;85;86;99;104;106;103;105;UnderWaterColor;1,0.8057229,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-3890.1,22.77841;Inherit;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-3898.906,760.3834;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;42;-3953.574,126.3043;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;84;-4110.884,1835.506;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;53;-3741.906,767.3834;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-4134.093,2154.103;Inherit;False;36;WaterNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-3720.755,45.90701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-3750.906,673.3834;Inherit;False;36;WaterNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;39;-3788.766,-143.5535;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-3914.214,2015.426;Inherit;False;Property;_UnderWaterTilling;UnderWaterTilling;16;0;Create;True;0;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;74;-3946.734,1340.544;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenPosInputsNode;4;-3527.181,-322.0749;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;54;-3546.906,737.3834;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;91;-1371.514,917.1376;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;73;-3881.757,1174.985;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;18;-3481.011,37.08091;Inherit;False;Property;_WaterNoise;WaterNoise;9;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-3570.906,980.3833;Inherit;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;0;False;0;False;256;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;86;-3849.52,1886.516;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;102;-3905.856,2154.921;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;90;-1369.514,715.1376;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;-3550.755,-108.093;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-3628.906,890.3834;Inherit;False;Property;_SpecSmothness;SpecSmothness;10;0;Create;True;0;0;0;False;0;False;0;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-3876.775,2279.337;Inherit;False;Constant;_Float6;Float 6;13;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3281.507,-91.25856;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-3418.109,1151.768;Inherit;False;Property;_SpecEnd;SpecEnd;14;0;Create;True;0;0;0;False;0;False;0;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;93;-1113.514,810.1376;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;5;-3279.966,-336.3626;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-3683.43,2158.436;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;87;-3678.475,1914.483;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;75;-3614.735,1250.544;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-3338.906,902.3834;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-3429.109,1416.768;Inherit;False;Property;_SpecStart;SpecStart;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;104;-4013.273,2510.617;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;105;-4028.273,2413.617;Inherit;False;Property;_WaterDepth;WaterDepth;17;0;Create;True;0;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;56;-3348.906,751.3834;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-3187.906,942.3834;Inherit;False;Property;_SpecTint;SpecTint;11;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.4150943,0.2138851,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;-3181.109,1207.768;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;79;-3179.109,1366.768;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;57;-3174.906,794.3834;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-3509.184,2033.422;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;103;-3773.273,2410.617;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-3040.66,-145.587;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;94;-872.6884,818.1531;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2905.906,990.3834;Inherit;False;Property;_SpecIntensity;SpecIntensity;12;0;Create;True;0;0;0;False;0;False;1;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;80;-2985.109,1284.768;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2890.757,-305.1192;Inherit;True;Property;_ReflectionTex;ReflectionTex;1;0;Create;True;0;0;0;False;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2965.906,834.3834;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-3308.205,2193.444;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;95;-697.4778,831.0217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2727.906,912.3834;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-377.5648,719.2355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-3091.412,2165.104;Inherit;True;Property;_UnderWater;UnderWater;15;0;Create;True;0;0;0;False;0;False;-1;None;671645573d382104abae3bf06cea8c02;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-2571.673,-280.9381;Inherit;False;ReflectColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;81;-2828.564,1277.849;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-276.6092,619.7477;Inherit;False;48;ReflectColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;109;-254.9464,717.5953;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-2570.316,1051.352;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-2687.783,2237.393;Inherit;False;UnderWaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;141;-340.3116,834.3381;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-74.94641,687.5953;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-215.4853,494.9799;Inherit;False;89;UnderWaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-2389.6,1044.386;Inherit;True;SpecColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;113;-9053.585,-1585.552;Inherit;False;3229.237;960.124;WaterNormalBlink;27;140;139;138;137;136;135;134;133;132;131;130;129;128;127;126;125;124;123;122;121;120;119;118;117;116;115;114;WaterNormalBlink;1,0.7118233,0,1;0;0
Node;AmplifyShaderEditor.LerpOp;96;110.6298,667.4445;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-86.90848,874.4373;Inherit;True;66;SpecColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;262.8989,752.9349;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-8433.343,-1003.651;Inherit;False;Constant;_Float16;Float 16;3;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;133;-7409.345,-1038.652;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;221.0491,1015.933;Inherit;False;83;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;-8081.345,-974.6512;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-8432.343,-833.6511;Inherit;False;Constant;_Float15;Float 15;3;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-7393.345,-942.6512;Inherit;False;Constant;_Float17;Float 17;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;136;-6881.346,-910.6512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-8289.343,-1054.652;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SqrtOpNode;137;-6719.346,-894.6512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;129;-7921.342,-1230.651;Inherit;True;Global;TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Instance;6;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;119;-8721.343,-1326.651;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;115;-8801.343,-1038.652;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;127;-8353.343,-1214.651;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-8897.343,-1150.651;Inherit;False;Property;_Float19;Float 19;4;0;Create;True;0;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-6109.804,-985.2836;Inherit;False;WaterNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;135;-7025.345,-926.6512;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-2594.007,1324.342;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;130;-7921.342,-942.6512;Inherit;True;Global;TextureSample3;Texture Sample 3;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Instance;6;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-8577.343,-1022.651;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-8133.19,-1070.387;Inherit;False;Property;_Float18;Float 18;6;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;139;-6369.924,-1023.24;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;138;-6567.221,-1015.429;Inherit;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;121;-8593.343,-1294.651;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-8287.343,-878.6512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-7233.345,-990.6512;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;131;-7553.344,-1054.652;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-8803.343,-834.6511;Inherit;False;Property;_Float20;Float 20;7;0;Create;True;0;0;0;False;0;False;1;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;114;-8913.343,-1342.651;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;116;-8799.343,-937.6512;Inherit;False;Constant;_Float14;Float 14;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;518.8001,624.3997;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;15;2;16;0
WireConnection;24;0;15;0
WireConnection;24;1;25;0
WireConnection;22;0;11;0
WireConnection;22;1;23;0
WireConnection;26;0;22;0
WireConnection;26;1;24;0
WireConnection;12;0;11;0
WireConnection;12;1;15;0
WireConnection;21;1;26;0
WireConnection;21;5;111;0
WireConnection;6;1;12;0
WireConnection;6;5;111;0
WireConnection;28;0;6;0
WireConnection;28;1;21;0
WireConnection;17;0;28;0
WireConnection;29;0;17;0
WireConnection;29;1;30;0
WireConnection;31;0;29;0
WireConnection;31;1;29;0
WireConnection;32;0;31;0
WireConnection;33;0;32;0
WireConnection;34;0;29;0
WireConnection;34;2;33;0
WireConnection;35;0;34;0
WireConnection;36;0;35;0
WireConnection;52;0;50;0
WireConnection;52;1;51;0
WireConnection;42;0;41;0
WireConnection;53;0;52;0
WireConnection;44;0;45;0
WireConnection;44;1;42;4
WireConnection;39;0;38;0
WireConnection;54;0;55;0
WireConnection;54;1;53;0
WireConnection;86;0;84;0
WireConnection;102;0;99;0
WireConnection;43;0;39;0
WireConnection;43;1;44;0
WireConnection;40;0;43;0
WireConnection;40;1;18;0
WireConnection;93;0;90;0
WireConnection;93;1;91;0
WireConnection;5;0;4;0
WireConnection;101;0;102;0
WireConnection;101;1;100;0
WireConnection;87;0;86;0
WireConnection;87;1;85;0
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;56;0;54;0
WireConnection;76;0;77;0
WireConnection;76;1;75;0
WireConnection;79;0;77;0
WireConnection;79;1;78;0
WireConnection;57;0;56;0
WireConnection;57;1;59;0
WireConnection;98;0;87;0
WireConnection;98;1;101;0
WireConnection;103;1;105;0
WireConnection;103;2;104;0
WireConnection;20;0;5;0
WireConnection;20;1;40;0
WireConnection;94;0;93;0
WireConnection;80;0;76;0
WireConnection;80;1;79;0
WireConnection;2;1;20;0
WireConnection;61;0;57;0
WireConnection;61;1;63;0
WireConnection;106;0;98;0
WireConnection;106;1;103;0
WireConnection;95;0;94;0
WireConnection;64;0;61;0
WireConnection;64;1;65;0
WireConnection;108;0;95;0
WireConnection;88;1;106;0
WireConnection;48;0;2;0
WireConnection;81;0;80;0
WireConnection;109;0;108;0
WireConnection;82;0;64;0
WireConnection;82;1;81;0
WireConnection;89;0;88;0
WireConnection;141;0;95;0
WireConnection;110;0;49;0
WireConnection;110;1;109;0
WireConnection;66;0;82;0
WireConnection;96;0;97;0
WireConnection;96;1;110;0
WireConnection;96;2;141;0
WireConnection;71;0;96;0
WireConnection;71;1;72;0
WireConnection;133;0;131;0
WireConnection;128;0;124;0
WireConnection;128;1;125;0
WireConnection;136;0;135;0
WireConnection;124;0;121;0
WireConnection;124;1;123;0
WireConnection;137;0;136;0
WireConnection;129;1;127;0
WireConnection;129;5;126;0
WireConnection;119;0;114;0
WireConnection;127;0;121;0
WireConnection;127;1;122;0
WireConnection;140;0;139;0
WireConnection;135;0;134;0
WireConnection;135;1;134;0
WireConnection;83;0;81;0
WireConnection;130;1;128;0
WireConnection;130;5;126;0
WireConnection;122;0;115;0
WireConnection;122;1;116;0
WireConnection;122;2;117;0
WireConnection;139;0;138;0
WireConnection;138;0;134;0
WireConnection;138;2;137;0
WireConnection;121;0;119;0
WireConnection;121;1;118;0
WireConnection;125;0;122;0
WireConnection;125;1;120;0
WireConnection;134;0;133;0
WireConnection;134;1;132;0
WireConnection;131;0;129;0
WireConnection;131;1;130;0
WireConnection;3;13;71;0
ASEEND*/
//CHKSM=01B7A63FDA7209FA07E2305693A2834CA71F206A