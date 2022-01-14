// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/StandTransparent"
{
	Properties
	{
		_Skirt_Clip("Skirt_Clip", Range( 0 , 30)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_BaseColor("BaseColor", Color) = (1,1,1,1)
		_BaseColorIntensity("BaseColorIntensity", Range( 0 , 1)) = 1
		_OpacityIntensity("OpacityIntensity", Range( 0 , 1)) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Smoothness("Smoothness", 2D) = "white" {}
		_SmoothIntensity("SmoothIntensity", Float) = 0
		_Occlusion("Occlusion", 2D) = "white" {}
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 0
		_SunLightDir("SunLight Dir", Vector) = (0,0,1,0)
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 700
		_FogHeightStart("Fog Height Start", Float) = 0
		_FogHeightEnd("Fog Height End", Float) = 700
		_Distance_Opacity("Distance_Opacity", Float) = 0
		_Hight_Opacity("Hight_Opacity", Float) = 0
		_OpacityMin("OpacityMin", Float) = 0
		_OpacityMax("OpacityMax", Float) = 0
		_HightEmissionIntensity("HightEmissionIntensity", Float) = 0
		_HightEmissionColor("HightEmissionColor", Color) = (0,0,0,0)
		_FogHightEmissionStart("Fog Hight Emission Start", Float) = 0
		_FogHightEmissionEnd("Fog Hight Emission End", Float) = 700
		_SunFogColor("Sun Fog Color", Color) = (0,0,0,0)
		_SunFogRange("Sun Fog Range", Float) = 0
		_SunFogIntensity("Sun Fog Intensity", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
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
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform float4 _HightEmissionColor;
		uniform float _HightEmissionIntensity;
		uniform float _FogHightEmissionEnd;
		uniform float _FogHightEmissionStart;
		uniform float4 _BaseColor;
		uniform float _OpacityIntensity;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _OpacityMin;
		uniform float _OpacityMax;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _Distance_Opacity;
		uniform float _FogHeightEnd;
		uniform float _FogHeightStart;
		uniform float _Hight_Opacity;
		uniform float _Skirt_Clip;
		uniform float _BaseColorIntensity;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _EmissionColor;
		uniform sampler2D _Smoothness;
		uniform float4 _Smoothness_ST;
		uniform float _SmoothIntensity;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;
		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		uniform float3 _SunLightDir;
		uniform float _SunFogRange;
		uniform float _SunFogIntensity;
		uniform float _FogIntensity;
		uniform float _Cutoff = 0.5;


		float3 ACESTonemap47( float3 LinearColor )
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
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode2 = tex2D( _Albedo, uv_Albedo );
			float temp_output_11_0_g6 = _FogDistanceEnd;
			float3 ase_worldPos = i.worldPos;
			float clampResult7_g6 = clamp( ( ( temp_output_11_0_g6 - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( temp_output_11_0_g6 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance30 = ( 1.0 - clampResult7_g6 );
			float temp_output_11_0_g3 = _FogHeightEnd;
			float clampResult7_g3 = clamp( ( ( temp_output_11_0_g3 - ase_worldPos.y ) / ( temp_output_11_0_g3 - _FogHeightStart ) ) , 0.0 , 1.0 );
			float FogHight29 = ( 1.0 - ( 1.0 - clampResult7_g3 ) );
			float smoothstepResult82 = smoothstep( _OpacityMin , _OpacityMax , max( ( FogDistance30 * _Distance_Opacity ) , ( FogHight29 * _Hight_Opacity ) ));
			float clampResult86 = clamp( smoothstepResult82 , 0.0 , 1.0 );
			float Opacity73 = ( _BaseColor.a * _OpacityIntensity * tex2DNode2.a * ( 1.0 - clampResult86 ) );
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float4 Albedo93 = ( tex2DNode2 * ( _BaseColor * _BaseColorIntensity ) );
			s1.Albedo = Albedo93.rgb;
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			s1.Normal = WorldNormalVector( i , UnpackNormal( tex2D( _Normal, uv_Normal ) ) );
			s1.Emission = _EmissionColor.rgb;
			s1.Metallic = 0.0;
			float2 uv_Smoothness = i.uv_texcoord * _Smoothness_ST.xy + _Smoothness_ST.zw;
			s1.Smoothness = ( tex2D( _Smoothness, uv_Smoothness ) * _SmoothIntensity ).r;
			float2 uv_Occlusion = i.uv_texcoord * _Occlusion_ST.xy + _Occlusion_ST.zw;
			s1.Occlusion = tex2D( _Occlusion, uv_Occlusion ).r;

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
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult18 = dot( -ase_worldViewDir , _SunLightDir );
			float clampResult31 = clamp( pow( (dotResult18*0.5 + 0.5) , _SunFogRange ) , 0.0 , 1.0 );
			float SunFog37 = ( clampResult31 * _SunFogIntensity );
			float4 lerpResult44 = lerp( _FogColor , _SunFogColor , SunFog37);
			float clampResult43 = clamp( ( ( FogDistance30 * FogHight29 ) * _FogIntensity ) , 0.0 , 1.0 );
			float4 lerpResult45 = lerp( float4( surfResult1 , 0.0 ) , lerpResult44 , clampResult43);
			float3 LinearColor47 = ( lerpResult45 * lerpResult45 ).rgb;
			float3 localACESTonemap47 = ACESTonemap47( LinearColor47 );
			c.rgb = sqrt( localACESTonemap47 );
			c.a = Opacity73;
			clip( step( 0.0 , ( i.uv2_texcoord2.y + _Skirt_Clip + 0.0 ) ) - _Cutoff );
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
			float temp_output_11_0_g7 = _FogHightEmissionEnd;
			float3 ase_worldPos = i.worldPos;
			float clampResult7_g7 = clamp( ( ( temp_output_11_0_g7 - ase_worldPos.y ) / ( temp_output_11_0_g7 - _FogHightEmissionStart ) ) , 0.0 , 1.0 );
			float FogHightEmission72 = ( 1.0 - ( 1.0 - clampResult7_g7 ) );
			o.Emission = ( ( _HightEmissionColor * _HightEmissionIntensity ) * FogHightEmission72 ).rgb;
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
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
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
0;200;1270;801;914.1154;48.72729;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;9;-5936.055,2665.297;Inherit;False;1649.897;563.2485;Sun Fog;12;48;37;33;32;31;26;24;22;18;12;11;10;Sun Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-5853.383,1024.478;Inherit;False;1146.603;531.9068;Fog Distance;7;30;28;25;21;20;16;14;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-5946.313,1934.206;Inherit;False;1346.057;508.7882;Fog Hight;6;19;15;17;23;27;29;Fog Hight;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;10;-5886.055,2730.658;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-5697.665,1079.078;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;11;-5710.695,2715.297;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;12;-5905.378,2888.109;Inherit;False;Property;_SunLightDir;SunLight Dir;14;0;Create;True;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;16;-5815.876,1285.029;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-5906.701,2047.641;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;15;-5635.202,2185.387;Inherit;False;Property;_FogHeightStart;Fog Height Start;17;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-5635.471,2288.43;Inherit;False;Property;_FogHeightEnd;Fog Height End;18;0;Create;True;0;0;False;0;False;700;700;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;23;-5357.021,2091.606;Inherit;False;Fog Linear;-1;;3;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;21;-5472.203,1204.103;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-5491.341,1315.306;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;18;-5542.778,2833.402;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-5491.609,1418.349;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;16;0;Create;True;0;0;False;0;False;700;700;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-5858.01,-1879.337;Inherit;False;1990.206;945.2114;Albedo;22;89;78;87;88;81;58;55;83;2;57;92;82;56;86;75;79;77;73;76;84;80;93;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;28;-5213.161,1221.526;Inherit;False;Fog Linear;-1;;6;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-5075.748,2092.843;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;22;-5376.778,2836.402;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-5392.778,2995.403;Inherit;False;Property;_SunFogRange;Sun Fog Range;28;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-4830.256,2124.205;Inherit;False;FogHight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-4960.01,-1205.337;Inherit;False;Property;_BaseColorIntensity;BaseColorIntensity;4;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-4906.993,1295.559;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-5136.779,2921.402;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;55;-5088.01,-1701.337;Inherit;False;Property;_BaseColor;BaseColor;2;0;Create;True;0;0;False;0;False;1,1,1,1;0,1,0.08505559,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;31;-4958.779,2946.403;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-5732.402,-1114.501;Inherit;False;Property;_Hight_Opacity;Hight_Opacity;20;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-5001.463,3101.756;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;29;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-5808.01,-1477.337;Inherit;False;30;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-4848.01,-1829.337;Inherit;True;Property;_Albedo;Albedo;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-4592.01,-1333.337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-5808.01,-1381.337;Inherit;False;Property;_Distance_Opacity;Distance_Opacity;19;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-5792.01,-1237.337;Inherit;False;29;FogHight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-4703.563,3024.156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-5568.01,-1429.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-5552.01,-1221.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-4336.011,-1365.337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1599.388,983.5811;Inherit;False;29;FogHight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1619.797,874.861;Inherit;False;30;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-4488.213,3074.658;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1657.365,339.4191;Inherit;False;922.4023;873.5225;Fog Combine;1;41;Fog Combine;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1373.522,1128.414;Inherit;False;Property;_FogIntensity;Fog Intensity;13;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2244.542,73.20514;Inherit;False;Property;_SmoothIntensity;SmoothIntensity;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;66;-7718.947,1870.352;Inherit;False;1346.057;508.7882;Fog Hight Emission;6;72;71;70;69;68;67;Fog Hight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;92;-5312.01,-1333.337;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-4091.802,-1329.88;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-2421.628,-127.893;Inherit;True;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1300.47,952.3608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-5364.738,-1050.126;Inherit;False;Property;_OpacityMax;OpacityMax;22;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-5376.01,-1173.337;Inherit;False;Property;_OpacityMin;OpacityMin;21;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-1586.291,384.0507;Inherit;False;Property;_FogColor;FogColor;12;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;68;-7487.379,2229.107;Inherit;False;Property;_FogHightEmissionEnd;Fog Hight Emission End;26;0;Create;True;0;0;False;0;False;700;700;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-1600.466,577.2187;Inherit;False;Property;_SunFogColor;Sun Fog Color;27;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-2363.033,-323.2428;Inherit;False;Property;_EmissionColor;EmissionColor;11;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;94;-1643.654,-419.4795;Inherit;False;93;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1084.434,1023.726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-2398.598,191.8919;Inherit;True;Property;_Occlusion;Occlusion;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;82;-5136.01,-1189.337;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-1509.189,763.1337;Inherit;False;37;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;69;-7679.335,1983.787;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;3;-2439.392,-520.5256;Inherit;True;Property;_Normal;Normal;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1980.124,-29.96126;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-7493.905,2126.064;Inherit;False;Property;_FogHightEmissionStart;Fog Hight Emission Start;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;86;-4864.01,-1381.337;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;70;-7129.654,2027.752;Inherit;False;Fog Linear;-1;;7;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;-1258.19,654.7339;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;1;-1423.166,-238.7095;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;43;-918.7968,1000.62;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-6848.381,2028.988;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;45;-910.0634,538.908;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;79;-4672.01,-1413.337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-5056.01,-1477.337;Inherit;False;Property;_OpacityIntensity;OpacityIntensity;5;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-4512.011,-1541.337;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-341.3185,404.0777;Inherit;False;Constant;_Float0;Float 0;30;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1012.468,-173.5736;Inherit;False;Property;_HightEmissionIntensity;HightEmissionIntensity;23;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-480.0635,264.3301;Inherit;False;Property;_Skirt_Clip;Skirt_Clip;0;0;Create;True;0;0;False;0;False;0;3;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-534.929,42.5607;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-659.4205,557.8544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;62;-1031.468,-363.5742;Inherit;False;Property;_HightEmissionColor;HightEmissionColor;24;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-6602.89,2060.352;Inherit;False;FogHightEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;47;-510.0179,569.7745;Inherit;False;float a = 2.51f@$float b = 0.03f@$float c = 2.43f@$float d = 0.59f@$float e = 0.14f@$return$saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e))@;3;False;1;True;LinearColor;FLOAT3;0,0,0;In;;Inherit;False;ACESTonemap;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-722.9606,-284.2891;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-4320.011,-1541.337;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-880.2761,-81.09937;Inherit;False;72;FogHightEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-93.10809,253.2616;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-5456.01,-1669.337;Inherit;True;Property;_Tex1;Cubemap (HDR);3;1;[NoScaleOffset];Create;False;0;0;False;0;False;-1;None;11d86fb583808674782c9d6ce4146c51;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-490.3627,-158.0544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;103;67.97763,242.6055;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-35.36698,104.8283;Inherit;False;73;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;49;-288.7007,575.0248;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;48;-5886.778,3042.403;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;374.0395,17.09021;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/StandTransparent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;0
WireConnection;23;13;19;2
WireConnection;23;12;15;0
WireConnection;23;11;17;0
WireConnection;21;0;14;0
WireConnection;21;1;16;0
WireConnection;18;0;11;0
WireConnection;18;1;12;0
WireConnection;28;13;21;0
WireConnection;28;12;25;0
WireConnection;28;11;20;0
WireConnection;27;0;23;0
WireConnection;22;0;18;0
WireConnection;29;0;27;0
WireConnection;30;0;28;0
WireConnection;26;0;22;0
WireConnection;26;1;24;0
WireConnection;31;0;26;0
WireConnection;57;0;55;0
WireConnection;57;1;58;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;88;0;87;0
WireConnection;88;1;89;0
WireConnection;81;0;78;0
WireConnection;81;1;80;0
WireConnection;56;0;2;0
WireConnection;56;1;57;0
WireConnection;37;0;33;0
WireConnection;92;0;88;0
WireConnection;92;1;81;0
WireConnection;93;0;56;0
WireConnection;38;0;35;0
WireConnection;38;1;34;0
WireConnection;42;0;38;0
WireConnection;42;1;36;0
WireConnection;82;0;92;0
WireConnection;82;1;83;0
WireConnection;82;2;84;0
WireConnection;52;0;4;0
WireConnection;52;1;54;0
WireConnection;86;0;82;0
WireConnection;70;13;69;2
WireConnection;70;12;67;0
WireConnection;70;11;68;0
WireConnection;44;0;40;0
WireConnection;44;1;39;0
WireConnection;44;2;41;0
WireConnection;1;0;94;0
WireConnection;1;1;3;0
WireConnection;1;2;8;0
WireConnection;1;4;52;0
WireConnection;1;5;59;0
WireConnection;43;0;42;0
WireConnection;71;0;70;0
WireConnection;45;0;1;0
WireConnection;45;1;44;0
WireConnection;45;2;43;0
WireConnection;79;0;86;0
WireConnection;76;0;55;4
WireConnection;76;1;75;0
WireConnection;76;2;2;4
WireConnection;76;3;79;0
WireConnection;46;0;45;0
WireConnection;46;1;45;0
WireConnection;72;0;71;0
WireConnection;47;0;46;0
WireConnection;63;0;62;0
WireConnection;63;1;64;0
WireConnection;73;0;76;0
WireConnection;102;0;96;2
WireConnection;102;1;98;0
WireConnection;102;2;107;0
WireConnection;61;0;63;0
WireConnection;61;1;60;0
WireConnection;103;1;102;0
WireConnection;49;0;47;0
WireConnection;0;2;61;0
WireConnection;0;9;74;0
WireConnection;0;10;103;0
WireConnection;0;13;49;0
ASEEND*/
//CHKSM=478A461786422440313D09F3E582C3F18F8E6D2E