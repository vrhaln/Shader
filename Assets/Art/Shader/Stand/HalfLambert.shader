// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/HalfLambert"
{
	Properties
	{
		[Toggle(_ACES_ON)] _ACES("ACES", Float) = 0
		_Tiling("Tiling", Float) = 0
		_DiffuseTex("DiffuseTex", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalScale("NormalScale", Range( 0 , 1)) = 1
		_AO("AO", 2D) = "white" {}
		_AOIntensity("AOIntensity", Range( 0 , 1.5)) = 0
		_Height("Height", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_ShaowColor("ShaowColor", Color) = (0,0,0,0)
		_Mul("Mul", Float) = 1
		_Power("Power", Float) = 0
		[Toggle(_HIGHTLINGHT_ON)] _HightLinght("HightLinght", Float) = 0
		[Toggle(_KK_ON)] _KK("KK", Float) = 0
		_HighlightColor("HighlightColor", Color) = (1,1,1,1)
		_HighlightIntensity("HighlightIntensity", Range( 0 , 1)) = 0.5
		_Shininess("Shininess", Range( 0.01 , 1)) = 0.5
		_RefSmoothness("RefSmoothness", Range( 0 , 1)) = 1
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_FresnelScale("FresnelScale", Float) = 1
		_FresnelPower("FresnelPower", Float) = 0.5
		_Occlusion("Occlusion", Range( 0 , 1)) = 0
		_Scale("Scale", Float) = 1
		_RefPlane("RefPlane", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ACES_ON
		#pragma shader_feature_local _HIGHTLINGHT_ON
		#pragma shader_feature_local _KK_ON
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float3 viewDir;
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

		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform float _Tiling;
		uniform sampler2D _Height;
		uniform float _Scale;
		uniform float _RefPlane;
		uniform float4 _Height_ST;
		uniform float _RefSmoothness;
		uniform float _Occlusion;
		uniform sampler2D _DiffuseTex;
		uniform float4 _ShaowColor;
		uniform float4 _BaseColor;
		uniform float4 _HighlightColor;
		uniform float _Shininess;
		uniform float _HighlightIntensity;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform float _Power;
		uniform float _Mul;
		uniform float _AOIntensity;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _FresnelColor;


		inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
		{
			float3 result = 0;
			int stepIndex = 0;
			int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
			float layerHeight = 1.0 / numSteps;
			float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
			uvs += refPlane * plane;
			float2 deltaTex = -plane * layerHeight;
			float2 prevTexOffset = 0;
			float prevRayZ = 1.0f;
			float prevHeight = 0.0f;
			float2 currTexOffset = deltaTex;
			float currRayZ = 1.0f - layerHeight;
			float currHeight = 0.0f;
			float intersection = 0;
			float2 finalTexOffset = 0;
			while ( stepIndex < numSteps + 1 )
			{
				currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r;
				if ( currHeight > currRayZ )
				{
					stepIndex = numSteps + 1;
				}
				else
				{
					stepIndex++;
					prevTexOffset = currTexOffset;
					prevRayZ = currRayZ;
					prevHeight = currHeight;
					currTexOffset += deltaTex;
					currRayZ -= layerHeight;
				}
			}
			int sectionSteps = 5;
			int sectionIndex = 0;
			float newZ = 0;
			float newHeight = 0;
			while ( sectionIndex < sectionSteps )
			{
				intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				finalTexOffset = prevTexOffset + intersection * deltaTex;
				newZ = prevRayZ - intersection * layerHeight;
				newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
				if ( newHeight > newZ )
				{
					currTexOffset = finalTexOffset;
					currHeight = newHeight;
					currRayZ = newZ;
					deltaTex = intersection * deltaTex;
					layerHeight = intersection * layerHeight;
				}
				else
				{
					prevTexOffset = finalTexOffset;
					prevHeight = newHeight;
					prevRayZ = newZ;
					deltaTex = ( 1 - intersection ) * deltaTex;
					layerHeight = ( 1 - intersection ) * layerHeight;
				}
				sectionIndex++;
			}
			return uvs + finalTexOffset;
		}


		float3 ACESTonemap120( float3 LinearColor )
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
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_71_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 temp_cast_0 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch84 = temp_cast_0;
			#else
				float3 staticSwitch84 = temp_output_71_0;
			#endif
			float3 LightColor78 = staticSwitch84;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult252 = (float2(ase_worldPos.x , ase_worldPos.z));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 OffsetPOM262 = POM( _Height, ( appendResult252 * _Tiling ), ddx(( appendResult252 * _Tiling )), ddy(( appendResult252 * _Tiling )), ase_worldNormal, ase_worldViewDir, i.viewDir, 8, 8, ( _Scale * 0.1 ), _RefPlane, _Height_ST.xy, float2(0,0), 0 );
			float3 WorldNormal22 = normalize( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _NormalMap, OffsetPOM262 ), ( _NormalScale * 0.2 ) ) )) );
			float3 indirectNormal241 = WorldNormal22;
			Unity_GlossyEnvironmentData g241 = UnityGlossyEnvironmentSetup( _RefSmoothness, data.worldViewDir, indirectNormal241, float3(0,0,0));
			float3 indirectSpecular241 = UnityGI_IndirectSpecular( data, _Occlusion, indirectNormal241, g241 );
			float4 tex2DNode62 = tex2D( _DiffuseTex, OffsetPOM262 );
			float Smoothness234 = tex2DNode62.a;
			float4 ShaowColor93 = ( _ShaowColor * tex2D( _DiffuseTex, OffsetPOM262 ) );
			float4 BaseColor96 = ( _BaseColor * tex2DNode62 );
			float4 temp_cast_3 = (0.0).xxxx;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 temp_output_128_0 = ( ase_worldViewDir + ase_worldlightDir );
			float dotResult129 = dot( temp_output_128_0 , WorldNormal22 );
			float NdotH144 = dotResult129;
			float temp_output_221_0 = max( NdotH144 , 0.0 );
			float saferPower220 = max( temp_output_221_0 , 0.0001 );
			float Shininess192 = _Shininess;
			float HightLight226 = saturate( pow( saferPower220 , ( Shininess192 * 128.0 ) ) );
			float saferPower279 = max( temp_output_221_0 , 0.0001 );
			float HightLight2281 = saturate( pow( saferPower279 , ( Shininess192 * 10.0 ) ) );
			float lerpResult282 = lerp( HightLight226 , HightLight2281 , Smoothness234);
			float3 half_dir147 = temp_output_128_0;
			float dotResult150 = dot( half_dir147 , i.viewDir );
			float TdotH151 = dotResult150;
			float KKHightLinght184 = pow( ( 1.0 - ( TdotH151 * TdotH151 ) ) , ( Shininess192 * 128.0 ) );
			#ifdef _KK_ON
				float staticSwitch196 = KKHightLinght184;
			#else
				float staticSwitch196 = lerpResult282;
			#endif
			#ifdef _HIGHTLINGHT_ON
				float4 staticSwitch204 = ( ( _HighlightColor * BaseColor96 * saturate( staticSwitch196 ) ) * _HighlightIntensity );
			#else
				float4 staticSwitch204 = temp_cast_3;
			#endif
			float4 HightLightColor142 = max( staticSwitch204 , float4( 0,0,0,0 ) );
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float3 break72 = temp_output_71_0;
			float LightAtten56 = max( max( break72.x , break72.y ) , break72.z );
			float dotResult5_g1 = dot( WorldNormal22 , ase_worldlightDir );
			float blendOpSrc199 = tex2D( _AO, uv_AO ).r;
			float blendOpDest199 = ( LightAtten56 * ( pow( (dotResult5_g1*0.5 + 0.5) , _Power ) * _Mul ) );
			float lerpBlendMode199 = lerp(blendOpDest199,min( blendOpSrc199 , blendOpDest199 ),_AOIntensity);
			float4 lerpResult5 = lerp( ShaowColor93 , ( BaseColor96 + HightLightColor142 ) , ( saturate( lerpBlendMode199 )));
			float3 ViewDir37 = ase_worldViewDir;
			float fresnelNdotV6 = dot( WorldNormal22, ViewDir37 );
			float fresnelNode6 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV6, _FresnelPower ) );
			float4 FresnelColor99 = max( ( fresnelNode6 * _FresnelColor ) , float4( 0,0,0,0 ) );
			float4 blendOpSrc247 = float4( ( indirectSpecular241 * Smoothness234 ) , 0.0 );
			float4 blendOpDest247 = ( lerpResult5 + FresnelColor99 );
			float4 temp_output_105_0 = max( saturate( ( float4( LightColor78 , 0.0 ) * ( saturate( ( 1.0 - ( 1.0 - blendOpSrc247 ) * ( 1.0 - blendOpDest247 ) ) )) ) ) , float4( 0,0,0,0 ) );
			float3 LinearColor120 = ( temp_output_105_0 * temp_output_105_0 ).rgb;
			float3 localACESTonemap120 = ACESTonemap120( LinearColor120 );
			#ifdef _ACES_ON
				float4 staticSwitch122 = float4( sqrt( localACESTonemap120 ) , 0.0 );
			#else
				float4 staticSwitch122 = temp_output_105_0;
			#endif
			c.rgb = staticSwitch122.rgb;
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
-1353;30;1338;857;-704.7335;322.1475;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;251;-6012.229,-2002.065;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;254;-5730.919,-1548.878;Inherit;False;Property;_Scale;Scale;22;0;Create;True;0;0;False;0;False;1;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;260;-5779.807,-1852.965;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;103;-4792.316,-1984.747;Inherit;False;1300.417;431.639;WorldNormal&ViewDir;7;244;243;37;36;22;21;106;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;252;-5814.862,-1976.776;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;263;-5714.649,-1278.757;Inherit;False;Property;_RefPlane;RefPlane;23;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;-5565.707,-1543.386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;264;-5730.729,-1751.414;Inherit;True;Property;_Height;Height;7;0;Create;True;0;0;False;0;False;None;aa0c8066bb0e0224fa76417e576650bc;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-4755.567,-1905.575;Inherit;False;Property;_NormalScale;NormalScale;4;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;250;-5746.563,-1448.423;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;-5577.335,-1875.549;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;262;-5145.246,-1640.668;Inherit;False;0;8;False;-1;16;False;-1;5;0.02;0;False;1,1;False;0,0;Texture2D;7;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;-4466.093,-1899.134;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;-4290.708,-1937.33;Inherit;True;Property;_NormalMap;NormalMap;3;0;Create;True;0;0;False;0;False;-1;None;9be34251ede9c574fa658055445ff320;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;143;-5664,704;Inherit;False;962.4656;525.8445;NdotH;6;144;147;124;126;129;125;NdotH;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;124;-5635,910.8315;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;21;-3949.697,-1928.37;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;126;-5600,750;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-3719.939,-1934.747;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;-5393,843;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-5525.122,1071.353;Inherit;False;22;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-5213,822;Inherit;False;half_dir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;152;-5653.622,1384.725;Inherit;False;847.5986;349.1815;TdotH;4;149;148;150;151;TdotH;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;225;-4546.493,1933.413;Inherit;False;570.8898;149.7429;Shininess;2;192;218;Shininess;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-4499.493,1983.413;Float;False;Property;_Shininess;Shininess;16;0;Create;True;0;0;False;0;False;0.5;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;129;-5205.636,924.1481;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;149;-5604.683,1542.762;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;148;-5599.428,1434.725;Inherit;False;147;half_dir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;227;-4547.084,1214.475;Inherit;False;1140.05;490.2875;HightLight;10;222;226;219;220;221;188;279;280;281;290;HightLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;-4189.835,1983.238;Inherit;False;Shininess;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-4936.721,910.5317;Inherit;True;NdotH;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;150;-5361.062,1461.363;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;195;-5655.414,2295.191;Inherit;False;1378.293;385.4607;KKHightLinght;7;171;184;182;181;172;224;223;KKHightLinght;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-5175.476,1449.029;Inherit;True;TdotH;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-4513.984,1261.875;Inherit;True;144;NdotH;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;-4517.338,1504.626;Inherit;False;192;Shininess;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-5591.196,2371.26;Inherit;False;151;TdotH;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-4317.487,1568.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;221;-4273.79,1271.108;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-4316.353,1453.066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;128;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;220;-4092.788,1270.108;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;-5268.816,2519.642;Inherit;False;192;Shininess;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;279;-4072.579,1536.283;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-3519.517,-1368.414;Inherit;False;919.8992;568.5779;BaseColor;5;96;234;63;3;62;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-5398.876,2374.168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-5057.484,2512.773;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;128;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-3477.179,-1102.064;Inherit;True;Property;_DiffuseTex;DiffuseTex;2;0;Create;True;0;0;False;0;False;-1;None;f294a5633ea10aa41863fb2b6c647779;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;290;-3899.915,1543.844;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;289;-3911.615,1298.144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;181;-5227.477,2387.953;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;123;-4584.706,105.3501;Inherit;False;1882.216;1049.337;HightLightColor;16;142;204;194;205;141;236;232;134;231;196;228;185;276;235;285;282;HightLightColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-3118.218,-1030.23;Inherit;True;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;281;-3748.792,1535.93;Inherit;False;HightLight2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;226;-3765.749,1266.717;Inherit;False;HightLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;182;-4885.001,2380.435;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;-4705.365,623.9559;Inherit;False;234;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-4612.57,2376.215;Inherit;True;KKHightLinght;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;228;-4691.715,457.7208;Inherit;False;226;HightLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;283;-4692.926,529.7925;Inherit;False;281;HightLight2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-3443.39,-1318.414;Inherit;False;Property;_BaseColor;BaseColor;8;0;Create;True;0;0;False;0;False;0,0,0,0;0.4716981,0.4716981,0.4716981,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3118.807,-1183.998;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;282;-4486.926,501.7925;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-4502.813,748.0063;Inherit;False;184;KKHightLinght;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;70;-4575.276,-423.8817;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-2889.51,-1170.921;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;69;-4558.988,-219.0229;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;196;-4291.296,503.6661;Inherit;False;Property;_KK;KK;13;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;134;-4299.899,230.5461;Inherit;False;Property;_HighlightColor;HighlightColor;14;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;276;-4138.948,503.5458;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;-4280.902,415.1497;Inherit;False;96;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-4305.532,-353.3372;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-3972.155,634.3737;Inherit;True;Property;_HighlightIntensity;HighlightIntensity;15;0;Create;True;0;0;False;0;False;0.5;0.348;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;72;-4038.714,-325.3215;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;36;-3928.031,-1736.249;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-3878.128,391.2686;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-3529.147,332.657;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-3648.648,422.752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-3715.898,-1732.909;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;98;-2465.664,-1364.181;Inherit;False;1307.631;444.3648;FresnelColor;8;99;101;8;6;40;26;44;39;FresnelColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;74;-3798.812,-346.4293;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-2190.948,-59.39069;Inherit;False;22;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;1;-1981.792,-56.18768;Inherit;True;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;92;-4814.305,-1376.906;Inherit;False;1009.513;513.5418;ShaowColor;4;93;61;4;60;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2457.264,-1130.71;Inherit;False;Property;_FresnelScale;FresnelScale;19;0;Create;True;0;0;False;0;False;1;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2455.644,-1228.676;Inherit;False;37;ViewDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;73;-3643.863,-314.1125;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-1758.055,66.76774;Inherit;False;Property;_Power;Power;11;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;204;-3364.677,399.6485;Inherit;False;Property;_HightLinght;HightLinght;12;0;Create;True;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2455.602,-1050.382;Inherit;False;Property;_FresnelPower;FresnelPower;20;0;Create;True;0;0;False;0;False;0.5;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-2457.418,-1320.043;Inherit;False;22;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;6;-2197.005,-1322.963;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-4636.372,-1328.907;Inherit;False;Property;_ShaowColor;ShaowColor;9;0;Create;True;0;0;False;0;False;0,0,0,0;0.3867925,0.3867925,0.3867925,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;177;-1549.383,62.94986;Inherit;False;Property;_Mul;Mul;10;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;176;-1597.734,-46.47422;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;194;-3082.125,417.4191;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;8;-2081.441,-1104.524;Inherit;False;Property;_FresnelColor;FresnelColor;18;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;-4700.372,-1136.907;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;62;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-3336.138,-321.4012;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1767.27,-1319.32;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-4316.372,-1152.907;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-1417.055,-38.84019;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1418.717,-139.2886;Inherit;False;56;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-2929.005,409.6888;Inherit;True;HightLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1102.341,-55.21618;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;197;-1338.746,167.0038;Inherit;True;Property;_AO;AO;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;198;-1328.473,373.8586;Inherit;False;Property;_AOIntensity;AOIntensity;6;0;Create;True;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-4108.372,-1152.907;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;245;-1539.168,-1317.168;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-884.2965,-134.4405;Inherit;False;142;HightLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-875.1385,-227.7497;Inherit;False;96;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;239;-1048.578,583.9221;Inherit;False;Property;_Occlusion;Occlusion;21;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-1050.636,502.1865;Inherit;False;Property;_RefSmoothness;RefSmoothness;17;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-4144.927,-589.435;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-626.4885,-195.1315;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-1378.179,-1317.755;Inherit;True;FresnelColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-989.1428,391.2958;Inherit;False;22;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-816.9041,-339.6485;Inherit;False;93;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;199;-777.4692,79.96255;Inherit;False;Darken;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;84;-3903.346,-607.9892;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;5;-428.1598,-224.5454;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectSpecularLight;241;-701.6403,397.7621;Inherit;False;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-419.0069,21.09732;Inherit;True;99;FresnelColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;242;-655.7168,533.2663;Inherit;False;234;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-3548.329,-611.1083;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-147.7503,-132.8135;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-437.4224,366.5414;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;247;-24.71517,-8.93697;Inherit;False;Screen;True;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-256.2949,-436.5502;Inherit;True;78;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;200.8521,-168.6673;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;203;458.3549,-143.576;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;105;691.7501,-150.8702;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;854.6929,-39.04373;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;120;1004.095,-27.12364;Inherit;False;float a = 2.51f@$float b = 0.03f@$float c = 2.43f@$float d = 0.59f@$float e = 0.14f@$return$saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e))@;3;False;1;True;LinearColor;FLOAT3;0,0,0;In;;Inherit;False;ACESTonemap;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;121;1225.412,-21.87335;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;160;-5654.601,1824.565;Inherit;False;859.9165;375.1273;NdotV;1;159;NdotV;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;1452.592,156.8418;Inherit;False;285;debug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;156;-5359.538,1959.48;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-5604.601,2086.371;Inherit;False;22;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;154;-5585.17,1874.565;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;107;-5570.818,-2000.022;Inherit;False;0;106;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-5007.915,1960.234;Inherit;True;NdotV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;285;-4260.687,714.3225;Inherit;False;debug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;122;1400.375,-105.2421;Inherit;False;Property;_ACES;ACES;0;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;291;1170.734,166.8525;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1592.325,-333.763;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/HalfLambert;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;89;-4625.276,-714.6766;Inherit;False;1513.141;690.5745;LightAtten;0;LightAtten;1,1,1,1;0;0
WireConnection;252;0;251;1
WireConnection;252;1;251;3
WireConnection;265;0;254;0
WireConnection;257;0;252;0
WireConnection;257;1;260;0
WireConnection;262;0;257;0
WireConnection;262;1;264;0
WireConnection;262;2;265;0
WireConnection;262;3;250;0
WireConnection;262;4;263;0
WireConnection;244;0;243;0
WireConnection;106;1;262;0
WireConnection;106;5;244;0
WireConnection;21;0;106;0
WireConnection;22;0;21;0
WireConnection;128;0;126;0
WireConnection;128;1;124;0
WireConnection;147;0;128;0
WireConnection;129;0;128;0
WireConnection;129;1;125;0
WireConnection;192;0;218;0
WireConnection;144;0;129;0
WireConnection;150;0;148;0
WireConnection;150;1;149;0
WireConnection;151;0;150;0
WireConnection;280;0;222;0
WireConnection;221;0;188;0
WireConnection;219;0;222;0
WireConnection;220;0;221;0
WireConnection;220;1;219;0
WireConnection;279;0;221;0
WireConnection;279;1;280;0
WireConnection;172;0;171;0
WireConnection;172;1;171;0
WireConnection;224;0;223;0
WireConnection;62;1;262;0
WireConnection;290;0;279;0
WireConnection;289;0;220;0
WireConnection;181;0;172;0
WireConnection;234;0;62;4
WireConnection;281;0;290;0
WireConnection;226;0;289;0
WireConnection;182;0;181;0
WireConnection;182;1;224;0
WireConnection;184;0;182;0
WireConnection;63;0;3;0
WireConnection;63;1;62;0
WireConnection;282;0;228;0
WireConnection;282;1;283;0
WireConnection;282;2;235;0
WireConnection;96;0;63;0
WireConnection;196;1;282;0
WireConnection;196;0;185;0
WireConnection;276;0;196;0
WireConnection;71;0;70;0
WireConnection;71;1;69;1
WireConnection;72;0;71;0
WireConnection;141;0;134;0
WireConnection;141;1;236;0
WireConnection;141;2;276;0
WireConnection;232;0;141;0
WireConnection;232;1;231;0
WireConnection;37;0;36;0
WireConnection;74;0;72;0
WireConnection;74;1;72;1
WireConnection;1;3;24;0
WireConnection;73;0;74;0
WireConnection;73;1;72;2
WireConnection;204;1;205;0
WireConnection;204;0;232;0
WireConnection;6;0;44;0
WireConnection;6;4;26;0
WireConnection;6;2;39;0
WireConnection;6;3;40;0
WireConnection;176;0;1;0
WireConnection;176;1;175;0
WireConnection;194;0;204;0
WireConnection;60;1;262;0
WireConnection;56;0;73;0
WireConnection;101;0;6;0
WireConnection;101;1;8;0
WireConnection;61;0;4;0
WireConnection;61;1;60;0
WireConnection;178;0;176;0
WireConnection;178;1;177;0
WireConnection;142;0;194;0
WireConnection;77;0;57;0
WireConnection;77;1;178;0
WireConnection;93;0;61;0
WireConnection;245;0;101;0
WireConnection;91;0;97;0
WireConnection;91;1;90;0
WireConnection;99;0;245;0
WireConnection;199;0;197;1
WireConnection;199;1;77;0
WireConnection;199;2;198;0
WireConnection;84;1;71;0
WireConnection;84;0;85;0
WireConnection;5;0;94;0
WireConnection;5;1;91;0
WireConnection;5;2;199;0
WireConnection;241;0;238;0
WireConnection;241;1;246;0
WireConnection;241;2;239;0
WireConnection;78;0;84;0
WireConnection;104;0;5;0
WireConnection;104;1;100;0
WireConnection;248;0;241;0
WireConnection;248;1;242;0
WireConnection;247;0;248;0
WireConnection;247;1;104;0
WireConnection;86;0;79;0
WireConnection;86;1;247;0
WireConnection;203;0;86;0
WireConnection;105;0;203;0
WireConnection;119;0;105;0
WireConnection;119;1;105;0
WireConnection;120;0;119;0
WireConnection;121;0;120;0
WireConnection;156;0;154;0
WireConnection;156;1;155;0
WireConnection;159;0;156;0
WireConnection;285;0;282;0
WireConnection;122;1;105;0
WireConnection;122;0;121;0
WireConnection;0;13;122;0
ASEEND*/
//CHKSM=81673ADAE083A955BEAB9593C7EC0FCAD417589C