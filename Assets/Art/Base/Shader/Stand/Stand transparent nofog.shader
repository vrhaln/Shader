// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Stand transparent nofog"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (1,1,1,1)
		_BaseColorIntensity("BaseColorIntensity", Range( 0 , 1)) = 1
		_OpacityIntensity("OpacityIntensity", Range( 0 , 1)) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Smoothness("Smoothness", 2D) = "white" {}
		_SmoothIntensity("SmoothIntensity", Float) = 0
		_Occlusion("Occlusion", 2D) = "white" {}
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_Distance_Opacity("Distance_Opacity", Float) = 0
		_Hight_Opacity("Hight_Opacity", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 700
		_OpacityMin("OpacityMin", Float) = 0
		_OpacityMax("OpacityMax", Float) = 0
		_HightEmissionIntensity("HightEmissionIntensity", Float) = 0
		_HightEmissionColor("HightEmissionColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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
			float2 uv_texcoord;
			float3 worldPos;
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
		uniform float4 _BaseColor;
		uniform float _OpacityIntensity;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _OpacityMin;
		uniform float _OpacityMax;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _Distance_Opacity;
		uniform float _Hight_Opacity;
		uniform float _BaseColorIntensity;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _EmissionColor;
		uniform sampler2D _Smoothness;
		uniform float4 _Smoothness_ST;
		uniform float _SmoothIntensity;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;


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
			float temp_output_11_0_g8 = _FogDistanceEnd;
			float3 ase_worldPos = i.worldPos;
			float clampResult7_g8 = clamp( ( ( temp_output_11_0_g8 - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( temp_output_11_0_g8 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance114 = ( 1.0 - clampResult7_g8 );
			float smoothstepResult82 = smoothstep( _OpacityMin , _OpacityMax , max( ( FogDistance114 * _Distance_Opacity ) , ( FogDistance114 * _Hight_Opacity ) ));
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
			float3 LinearColor47 = ( surfResult1 * surfResult1 );
			float3 localACESTonemap47 = ACESTonemap47( LinearColor47 );
			c.rgb = sqrt( localACESTonemap47 );
			c.a = Opacity73;
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
			o.Emission = ( ( _HightEmissionColor * _HightEmissionIntensity ) * (0) ).rgb;
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
				float2 customPack1 : TEXCOORD1;
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
124;196;1048;732;1555.843;597.1901;2.05432;True;False
Node;AmplifyShaderEditor.CommentaryNode;109;-5847.7,-624.9165;Inherit;False;1146.603;531.9068;Fog Distance;7;116;115;114;113;112;111;110;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;116;-5814.193,-397.3653;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;110;-5691.982,-570.3168;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;115;-5451.52,-549.2911;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-5485.926,-231.0454;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;14;0;Create;True;0;0;False;0;False;700;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-5485.658,-334.0883;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;113;-5204.76,-509.3999;Inherit;False;Fog Linear;-1;;8;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-5858.01,-1879.337;Inherit;False;1990.206;945.2114;Albedo;20;89;88;81;58;55;83;2;57;92;82;56;86;75;79;77;73;76;84;80;93;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-4893.157,-351.1178;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-5732.402,-1114.501;Inherit;False;Property;_Hight_Opacity;Hight_Opacity;13;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-4960.01,-1205.337;Inherit;False;Property;_BaseColorIntensity;BaseColorIntensity;3;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-5808.01,-1381.337;Inherit;False;Property;_Distance_Opacity;Distance_Opacity;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;55;-5088.01,-1701.337;Inherit;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;False;0;False;1,1,1,1;0.8117648,0.9333334,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;117;-5743.515,-1462.4;Inherit;False;114;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-4848.01,-1829.337;Inherit;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-5552.01,-1221.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-4592.01,-1333.337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-5568.01,-1429.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-5364.738,-1050.126;Inherit;False;Property;_OpacityMax;OpacityMax;16;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-5376.01,-1173.337;Inherit;False;Property;_OpacityMin;OpacityMin;15;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-4336.011,-1365.337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;92;-5312.01,-1333.337;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;82;-5136.01,-1189.337;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1942.912,472.1404;Inherit;True;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-1765.826,673.2385;Inherit;False;Property;_SmoothIntensity;SmoothIntensity;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-4091.802,-1329.88;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;8;-1868.011,257.7664;Inherit;False;Property;_EmissionColor;EmissionColor;10;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1838.379,0.6936646;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-1919.882,791.9252;Inherit;True;Property;_Occlusion;Occlusion;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;94;-1295.389,109.893;Inherit;False;93;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;86;-4864.01,-1381.337;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1501.408,570.0721;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-5056.01,-1477.337;Inherit;False;Property;_OpacityIntensity;OpacityIntensity;4;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;1;-955.0894,491.656;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;79;-4672.01,-1413.337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;62;-1031.468,-363.5742;Inherit;False;Property;_HightEmissionColor;HightEmissionColor;18;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-659.4205,557.8544;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1012.468,-173.5736;Inherit;False;Property;_HightEmissionIntensity;HightEmissionIntensity;17;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-4512.011,-1541.337;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;47;-510.0179,569.7745;Inherit;False;float a = 2.51f@$float b = 0.03f@$float c = 2.43f@$float d = 0.59f@$float e = 0.14f@$return$saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e))@;3;False;1;True;LinearColor;FLOAT3;0,0,0;In;;Inherit;False;ACESTonemap;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-880.2761,-81.09937;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-722.9606,-284.2891;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-4320.011,-1541.337;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;49;-288.7007,575.0248;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-35.36698,104.8283;Inherit;False;73;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-5456.01,-1669.337;Inherit;True;Property;_Tex1;Cubemap (HDR);2;1;[NoScaleOffset];Create;False;0;0;False;0;False;-1;None;11d86fb583808674782c9d6ce4146c51;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-490.3627,-158.0544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;374.0395,17.09021;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Stand transparent nofog;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;115;0;110;0
WireConnection;115;1;116;0
WireConnection;113;13;115;0
WireConnection;113;12;111;0
WireConnection;113;11;112;0
WireConnection;114;0;113;0
WireConnection;81;0;117;0
WireConnection;81;1;80;0
WireConnection;57;0;55;0
WireConnection;57;1;58;0
WireConnection;88;0;117;0
WireConnection;88;1;89;0
WireConnection;56;0;2;0
WireConnection;56;1;57;0
WireConnection;92;0;88;0
WireConnection;92;1;81;0
WireConnection;82;0;92;0
WireConnection;82;1;83;0
WireConnection;82;2;84;0
WireConnection;93;0;56;0
WireConnection;86;0;82;0
WireConnection;52;0;4;0
WireConnection;52;1;54;0
WireConnection;1;0;94;0
WireConnection;1;1;3;0
WireConnection;1;2;8;0
WireConnection;1;4;52;0
WireConnection;1;5;59;0
WireConnection;79;0;86;0
WireConnection;46;0;1;0
WireConnection;46;1;1;0
WireConnection;76;0;55;4
WireConnection;76;1;75;0
WireConnection;76;2;2;4
WireConnection;76;3;79;0
WireConnection;47;0;46;0
WireConnection;63;0;62;0
WireConnection;63;1;64;0
WireConnection;73;0;76;0
WireConnection;49;0;47;0
WireConnection;61;0;63;0
WireConnection;61;1;60;0
WireConnection;0;2;61;0
WireConnection;0;9;74;0
WireConnection;0;13;49;0
ASEEND*/
//CHKSM=7D4205C98CF6A60027EB1C934D744EBFCE605F0E