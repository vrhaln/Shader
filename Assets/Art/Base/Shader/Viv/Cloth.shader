// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Cloth"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,1)
		_SmoothnessTex("SmoothnessTex", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_IORTex("IORTex", 2D) = "white" {}
		[HDR]_IORColor("IORColor", Color) = (1,1,1,1)
		_IOR("IOR", Float) = 3
		[HDR]_FreColor("FreColor", Color) = (1,1,1,1)
		_Fresnel("Fresnel", Vector) = (0,1,5,0)
		_NoiseTiling1("NoiseTiling1", Vector) = (1.2,1,0,0)
		_NoiseTiling2("NoiseTiling2", Vector) = (1,1.75,0,0)
		_AEmisStr("AEmisStr", Float) = 1
		_BEmisStr("BEmisStr", Float) = 1
		_MainEmisStr("MainEmisStr", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
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
			float2 uv_texcoord;
			float3 viewDir;
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

		uniform float3 _Fresnel;
		uniform sampler2D _IORTex;
		uniform float2 _NoiseTiling1;
		uniform float _IOR;
		uniform float _AEmisStr;
		uniform float2 _NoiseTiling2;
		uniform float _BEmisStr;
		uniform float _MainEmisStr;
		uniform float _Opacity;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _MainColor;
		uniform float4 _FreColor;
		uniform float4 _IORColor;
		uniform sampler2D _SmoothnessTex;
		uniform float4 _SmoothnessTex_ST;
		uniform float _Smoothness;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV41 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode41 = ( _Fresnel.x + _Fresnel.y * pow( 1.0 - fresnelNdotV41, _Fresnel.z ) );
			float3 normalizeResult21 = normalize( i.viewDir );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentPos19 = mul( ase_worldToTangent, ase_worldNormal);
			float3 normalizeResult22 = normalize( worldToTangentPos19 );
			float3 break24 = refract( normalizeResult21 , normalizeResult22 , ( 1.0 / _IOR ) );
			float2 appendResult26 = (float2(break24.x , break24.y));
			float2 temp_output_30_0 = ( appendResult26 / break24.z );
			float temp_output_43_0 = ( ( tex2D( _IORTex, ( (i.uv_texcoord*_NoiseTiling1 + 0.0) + temp_output_30_0 ) ).r * _AEmisStr ) * ( tex2D( _IORTex, ( (i.uv_texcoord*_NoiseTiling2 + 0.0) + temp_output_30_0 ) ).r * _BEmisStr ) * _MainEmisStr );
			float lerpResult51 = lerp( 1.0 , ( fresnelNode41 * temp_output_43_0 ) , _Opacity);
			SurfaceOutputStandard s2 = (SurfaceOutputStandard ) 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			s2.Albedo = ( tex2D( _MainTex, uv_MainTex ) * _MainColor ).rgb;
			s2.Normal = ase_worldNormal;
			s2.Emission = ( ( temp_output_43_0 + ( fresnelNode41 * _FreColor ) ) * _IORColor ).rgb;
			s2.Metallic = 0.0;
			float2 uv_SmoothnessTex = i.uv_texcoord * _SmoothnessTex_ST.xy + _SmoothnessTex_ST.zw;
			s2.Smoothness = ( tex2D( _SmoothnessTex, uv_SmoothnessTex ).r * _Smoothness );
			s2.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi2 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g2 = UnityGlossyEnvironmentSetup( s2.Smoothness, data.worldViewDir, s2.Normal, float3(0,0,0));
			gi2 = UnityGlobalIllumination( data, s2.Occlusion, s2.Normal, g2 );
			#endif

			float3 surfResult2 = LightingStandard ( s2, viewDir, gi2 ).rgb;
			surfResult2 += s2.Emission;

			#ifdef UNITY_PASS_FORWARDADD//2
			surfResult2 -= s2.Emission;
			#endif//2
			c.rgb = surfResult2;
			c.a = lerpResult51;
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
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
Version=18935
126;376;1278;763;3458.841;151.4531;1.6;True;False
Node;AmplifyShaderEditor.WorldNormalVector;15;-5807.692,355.2187;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;18;-5592.683,198.6113;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;17;-5622.396,808.3799;Inherit;False;Property;_IOR;IOR;8;0;Create;True;0;0;0;False;0;False;3;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-5623.898,705.9991;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;19;-5526.309,410.5119;Inherit;False;World;Tangent;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;22;-5260.308,418.5119;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;21;-5280.444,262.5255;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-5343.897,725.9991;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RefractOpVec;23;-5030.517,391.0233;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-4745.26,399.7382;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-4175.855,-42.98489;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;25;-4154.133,122.536;Inherit;False;Property;_NoiseTiling1;NoiseTiling1;11;0;Create;True;0;0;0;False;0;False;1.2,1;1.2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;27;-4147.861,268.8954;Inherit;False;Property;_NoiseTiling2;NoiseTiling2;12;0;Create;True;0;0;0;False;0;False;1,1.75;1,1.75;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;26;-4404.125,382.4391;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-4154.226,462.7116;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;29;-3821.894,42.40241;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;31;-3843.358,221.1504;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-3545.891,439.787;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-3553.964,243.3549;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2782.334,497.3921;Inherit;False;Property;_BEmisStr;BEmisStr;14;0;Create;True;0;0;0;False;0;False;1;5.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-3161.688,156.2872;Inherit;True;Property;_IORTex;IORTex;6;0;Create;True;0;0;0;False;0;False;-1;None;21c21b70a3522a54f9fca75e5f9ddec2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-2779.459,337.1234;Inherit;False;Property;_AEmisStr;AEmisStr;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;38;-2778.787,805.3399;Inherit;False;Property;_Fresnel;Fresnel;10;0;Create;True;0;0;0;False;0;False;0,1,5;0,0.43,1.84;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;36;-3158.79,405.4872;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;37;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;-2393.449,1037.672;Inherit;False;Property;_FreColor;FreColor;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-2549.075,365.791;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;41;-2425.094,786.9514;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2826.772,612.7557;Inherit;False;Property;_MainEmisStr;MainEmisStr;15;0;Create;True;0;0;0;False;0;False;1;0.112;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2555.311,231.5609;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2055.559,884.4258;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2295.398,289.6974;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1278.304,634.9493;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-1918.794,466.3717;Inherit;False;Property;_IORColor;IORColor;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1053.627,105.598;Inherit;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.3951584,0.6966943,0.754717,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1329.304,430.9505;Inherit;True;Property;_SmoothnessTex;SmoothnessTex;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1401.122,-52.54438;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1853.408,333.5747;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1569.787,314.739;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1538.044,915.2351;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-719.9856,43.09465;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-757.6818,386.8896;Inherit;False;Constant;_Metallic;Metallic;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-956.3033,446.9505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1832.723,1133.743;Inherit;False;Property;_Opacity;Opacity;5;0;Create;True;0;0;0;False;0;False;1;0.809;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1540.267,653.548;Inherit;True;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;51;-1236.201,840.7163;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;2;-180.0968,302.199;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;258.9589,159.5795;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Cloth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;15;0
WireConnection;22;0;19;0
WireConnection;21;0;18;0
WireConnection;20;0;16;0
WireConnection;20;1;17;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;23;2;20;0
WireConnection;24;0;23;0
WireConnection;26;0;24;0
WireConnection;26;1;24;1
WireConnection;30;0;26;0
WireConnection;30;1;24;2
WireConnection;29;0;28;0
WireConnection;29;1;25;0
WireConnection;31;0;28;0
WireConnection;31;1;27;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;33;0;29;0
WireConnection;33;1;30;0
WireConnection;37;1;33;0
WireConnection;36;1;32;0
WireConnection;42;0;36;1
WireConnection;42;1;35;0
WireConnection;41;1;38;1
WireConnection;41;2;38;2
WireConnection;41;3;38;3
WireConnection;39;0;37;1
WireConnection;39;1;34;0
WireConnection;44;0;41;0
WireConnection;44;1;40;0
WireConnection;43;0;39;0
WireConnection;43;1;42;0
WireConnection;43;2;56;0
WireConnection;47;0;43;0
WireConnection;47;1;44;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;14;0;41;0
WireConnection;14;1;43;0
WireConnection;50;0;1;0
WireConnection;50;1;3;0
WireConnection;13;0;12;1
WireConnection;13;1;11;0
WireConnection;51;0;52;0
WireConnection;51;1;14;0
WireConnection;51;2;45;0
WireConnection;2;0;50;0
WireConnection;2;2;49;0
WireConnection;2;3;8;0
WireConnection;2;4;13;0
WireConnection;0;9;51;0
WireConnection;0;13;2;0
ASEEND*/
//CHKSM=3135239BB98596F42E9773AD2BC1F0723B55DEA5