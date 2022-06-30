// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Toon_River_CS19"
{
	Properties
	{
		_ShallowColor("ShallowColor", Color) = (0,0,0,0)
		_DeepColor("DeepColor", Color) = (0,0,0,0)
		_DeepRange("DeepRange", Float) = 1
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_FresnelBias("FresnelBias", Float) = 0
		_FresnelScale("FresnelScale", Float) = 1
		_FresnelPower("FresnelPower", Float) = 1
		_NormalMap("NormalMap", 2D) = "white" {}
		_NormalScale("NormalScale", Float) = 1
		_NormalSpeed("NormalSpeed", Vector) = (0,0,0,0)
		_ReflectIntensity("Reflect Intensity", Float) = 0
		_ReflectPower("Reflect Power", Float) = 0
		_ReflectDistort("Reflect Distort", Range( 0 , 1)) = 0
		_UnderWaterDistort("UnderWaterDistort", Float) = 0
		_TimeSpeed("TimeSpeed", Float) = 1
		_CausticsTex("CausticsTex", 2D) = "white" {}
		_CausticsScale("Caustics Scale", Float) = 0
		_CausticsSpeed("Caustics Speed", Vector) = (-8,0,0,0)
		_CausticsIntensity("Caustics Intensity", Float) = 0
		_CausticsRange("Caustics Range", Float) = 0
		_FoamColor("FoamColor", Color) = (1,1,1,0)
		_WaveColor("WaveColor", Color) = (0,0,0,0)
		_WaveASpeedXYSteepnesswavelength("WaveA(SpeedXY,Steepness,wavelength)", Vector) = (1,1,2,50)
		_WaveB("WaveB", Vector) = (1,1,2,50)
		_WaveC("WaveC", Vector) = (1,1,2,50)
		_FoamNoise("FoamNoise", 2D) = "white" {}
		_FoamRange("FoamRange", Float) = 0
		_FoamContrast("FoamContrast", Float) = 0
		_FoamSpeed1("FoamSpeed1", Vector) = (1,0,1,0)
		_FoamSpeed2("FoamSpeed2", Vector) = (1,0,0.5,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
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
			float4 vertexColor : COLOR;
			float3 worldPos;
			float4 screenPos;
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

		uniform float4 _DeepColor;
		uniform float4 _ShallowColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float _DeepRange;
		uniform float4 _FresnelColor;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _WaveASpeedXYSteepnesswavelength;
		uniform float4 _WaveB;
		uniform float4 _WaveC;
		uniform float4 _WaveColor;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float2 _NormalSpeed;
		uniform float _TimeSpeed;
		uniform float _NormalScale;
		uniform float _ReflectDistort;
		uniform float _ReflectIntensity;
		uniform float _ReflectPower;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _UnderWaterDistort;
		uniform sampler2D _CausticsTex;
		uniform float _CausticsScale;
		uniform float2 _CausticsSpeed;
		uniform float _CausticsIntensity;
		uniform float _CausticsRange;
		uniform float4 _FoamColor;
		uniform float _FoamContrast;
		uniform sampler2D _FoamNoise;
		uniform float3 _FoamSpeed1;
		uniform float4 _FoamNoise_ST;
		uniform float3 _FoamSpeed2;
		uniform float _FoamRange;


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		float3 GerstnerWave188( float3 position , inout float3 tangent , inout float3 binormal , float4 wave )
		{
			float steepness = wave.z * 0.01;
			float wavelength = wave.w;
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, position.xz) - c * _Time.y);
			float a = steepness / k;
						
			tangent += float3(
			-d.x * d.x * (steepness * sin(f)),
			d.x * (steepness * cos(f)),
			-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
			-d.x * d.y * (steepness * sin(f)),
			d.y * (steepness * cos(f)),
			-d.y * d.y * (steepness * sin(f))
			);
			return float3(
			d.x * (a * cos(f)),
			a * sin(f),
			d.y * (a * cos(f))
			);
		}


		float3 GerstnerWave196( float3 position , inout float3 tangent , inout float3 binormal , float4 wave )
		{
			float steepness = wave.z * 0.01;
			float wavelength = wave.w;
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, position.xz) - c * _Time.y);
			float a = steepness / k;
						
			tangent += float3(
			-d.x * d.x * (steepness * sin(f)),
			d.x * (steepness * cos(f)),
			-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
			-d.x * d.y * (steepness * sin(f)),
			d.y * (steepness * cos(f)),
			-d.y * d.y * (steepness * sin(f))
			);
			return float3(
			d.x * (a * cos(f)),
			a * sin(f),
			d.y * (a * cos(f))
			);
		}


		float3 GerstnerWave203( float3 position , inout float3 tangent , inout float3 binormal , float4 wave )
		{
			float steepness = wave.z * 0.01;
			float wavelength = wave.w;
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, position.xz) - c * _Time.y);
			float a = steepness / k;
						
			tangent += float3(
			-d.x * d.x * (steepness * sin(f)),
			d.x * (steepness * cos(f)),
			-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
			-d.x * d.y * (steepness * sin(f)),
			d.y * (steepness * cos(f)),
			-d.y * d.y * (steepness * sin(f))
			);
			return float3(
			d.x * (a * cos(f)),
			a * sin(f),
			d.y * (a * cos(f))
			);
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 UV22_g3 = ase_screenPosNorm.xy;
			float2 localUnStereo22_g3 = UnStereo( UV22_g3 );
			float2 break64_g1 = localUnStereo22_g3;
			float4 tex2DNode36_g1 = tex2D( _CameraDepthTexture, ase_screenPosNorm.xy );
			#ifdef UNITY_REVERSED_Z
				float4 staticSwitch38_g1 = ( 1.0 - tex2DNode36_g1 );
			#else
				float4 staticSwitch38_g1 = tex2DNode36_g1;
			#endif
			float3 appendResult39_g1 = (float3(break64_g1.x , break64_g1.y , staticSwitch38_g1.r));
			float4 appendResult42_g1 = (float4((appendResult39_g1*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g1 = mul( unity_CameraInvProjection, appendResult42_g1 );
			float4 appendResult49_g1 = (float4(( ( (temp_output_43_0_g1).xyz / (temp_output_43_0_g1).w ) * float3( 1,1,-1 ) ) , 1.0));
			float3 PositionFormDepth218 = (mul( unity_CameraToWorld, appendResult49_g1 )).xyz;
			float WaterDepth222 = ( ase_worldPos.y - (PositionFormDepth218).y );
			float clampResult231 = clamp( exp( ( -WaterDepth222 / _DeepRange ) ) , 0.0 , 1.0 );
			float4 lerpResult232 = lerp( _DeepColor , _ShallowColor , clampResult231);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float fresnelNdotV238 = dot( ase_normWorldNormal, ase_worldViewDir );
			float fresnelNode238 = ( _FresnelBias + _FresnelScale * pow( max( 1.0 - fresnelNdotV238 , 0.0001 ), _FresnelPower ) );
			float4 lerpResult236 = lerp( lerpResult232 , _FresnelColor , fresnelNode238);
			float4 WaterColor234 = lerpResult236;
			float3 position188 = ase_worldPos;
			float3 tangent188 = float3( 1,0,0 );
			float3 binormal188 = float3( 0,0,1 );
			float4 wave188 = _WaveASpeedXYSteepnesswavelength;
			float3 localGerstnerWave188 = GerstnerWave188( position188 , tangent188 , binormal188 , wave188 );
			float3 position196 = ase_worldPos;
			float3 tangent196 = tangent188;
			float3 binormal196 = binormal188;
			float4 wave196 = _WaveB;
			float3 localGerstnerWave196 = GerstnerWave196( position196 , tangent196 , binormal196 , wave196 );
			float3 position203 = ase_worldPos;
			float3 tangent203 = tangent196;
			float3 binormal203 = binormal196;
			float4 wave203 = _WaveC;
			float3 localGerstnerWave203 = GerstnerWave203( position203 , tangent203 , binormal203 , wave203 );
			float3 temp_output_191_0 = ( ase_worldPos + localGerstnerWave188 + localGerstnerWave196 + localGerstnerWave203 );
			float clampResult209 = clamp( (( temp_output_191_0 - ase_worldPos )).y , 0.0 , 1.0 );
			float4 WaveColor212 = ( clampResult209 * _WaveColor );
			float2 uv0_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float2 temp_output_250_0 = ( _NormalSpeed * _Time.y * _TimeSpeed );
			float3 SurfaceNormal254 = BlendNormals( tex2D( _NormalMap, ( uv0_NormalMap + temp_output_250_0 ) ).rgb , UnpackScaleNormal( tex2D( _NormalMap, ( ( uv0_NormalMap * 2.0 ) + ( temp_output_250_0 * 0.5 ) ) ), _NormalScale ) );
			float3 lerpResult428 = lerp( float3(0,0,1) , SurfaceNormal254 , _ReflectDistort);
			float3 indirectNormal424 = WorldNormalVector( i , lerpResult428 );
			float fresnelNdotV295 = dot( SurfaceNormal254, ase_worldViewDir );
			float fresnelNode295 = ( 0.0 + _ReflectIntensity * pow( 1.0 - fresnelNdotV295, _ReflectPower ) );
			float clampResult298 = clamp( fresnelNode295 , 0.0 , 1.0 );
			Unity_GlossyEnvironmentData g424 = UnityGlossyEnvironmentSetup( 0.95, data.worldViewDir, indirectNormal424, float3(0,0,0));
			float3 indirectSpecular424 = UnityGI_IndirectSpecular( data, clampResult298, indirectNormal424, g424 );
			float3 ReflectColor272 = indirectSpecular424;
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor281 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( ( SurfaceNormal254 * _UnderWaterDistort * 0.01 ) , 0.0 ) ).xy);
			float4 SceneColor332 = screenColor281;
			float2 temp_output_303_0 = ( (PositionFormDepth218).xz / _CausticsScale );
			float2 temp_output_306_0 = ( _CausticsSpeed * _Time.y * 0.01 );
			float clampResult323 = clamp( exp( ( -WaterDepth222 / _CausticsRange ) ) , 0.0 , 1.0 );
			float4 CausticsColor315 = ( ( min( tex2D( _CausticsTex, ( temp_output_303_0 + temp_output_306_0 ) ) , tex2D( _CausticsTex, ( -temp_output_303_0 + temp_output_306_0 ) ) ) * _CausticsIntensity ) * clampResult323 );
			float4 UnderWaterColor288 = ( SceneColor332 + CausticsColor315 );
			float WaterOpacity241 = ( 1.0 - (lerpResult236).a );
			float4 lerpResult291 = lerp( ( WaterColor234 + WaveColor212 + float4( ReflectColor272 , 0.0 ) ) , UnderWaterColor288 , WaterOpacity241);
			float temp_output_7_0_g4 = _FoamContrast;
			float2 appendResult468 = (float2(_FoamSpeed1.x , _FoamSpeed1.y));
			float2 uv0_FoamNoise = i.uv_texcoord * _FoamNoise_ST.xy + _FoamNoise_ST.zw;
			float2 panner439 = ( ( _FoamSpeed1.z * _Time.y ) * appendResult468 + uv0_FoamNoise);
			float2 appendResult470 = (float2(_FoamSpeed2.x , _FoamSpeed2.y));
			float2 panner449 = ( ( _FoamSpeed2.z * _Time.y ) * appendResult470 + uv0_FoamNoise);
			float lerpResult450 = lerp( tex2D( _FoamNoise, panner439 ).r , tex2D( _FoamNoise, panner449 ).r , i.vertexColor.r);
			float clampResult457 = clamp( exp( ( -WaterDepth222 / _FoamRange ) ) , 0.0 , 1.0 );
			float clampResult463 = clamp( ( clampResult457 * i.vertexColor.g ) , 0.0 , 1.0 );
			float clampResult6_g4 = clamp( ( ( lerpResult450 - 1.0 ) + ( clampResult463 * 2.0 ) ) , 0.0 , 1.0 );
			float lerpResult11_g4 = lerp( ( 0.0 - temp_output_7_0_g4 ) , ( temp_output_7_0_g4 + 1.0 ) , clampResult6_g4);
			float clampResult12_g4 = clamp( lerpResult11_g4 , 0.0 , 1.0 );
			float4 FoamColor389 = ( _FoamColor * clampResult12_g4 );
			float4 lerpResult399 = lerp( lerpResult291 , ( lerpResult291 + float4( (FoamColor389).rgb , 0.0 ) ) , (FoamColor389).a);
			c.rgb = max( lerpResult399 , float4( 0,0,0,0 ) ).rgb;
			c.a = i.vertexColor.a;
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
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
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
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
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
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
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
158;334;1296;767;-3913.199;-1494.346;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;223;-295.633,14.36626;Inherit;False;1498.574;364.1545;Water Depth;7;215;217;218;216;219;220;222;Water Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;215;-245.633,264.0587;Inherit;False;Reconstruct World Position From Depth;0;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;217;109.2573,257.9084;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;262;-275.8737,1578.427;Inherit;False;1894.374;713.6802; Surface Normal;16;253;251;252;249;256;258;259;257;248;260;255;250;261;254;435;436;Surface Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;251;-202.8736,2062.539;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;249;-173.8737,1925.539;Inherit;False;Property;_NormalSpeed;NormalSpeed;12;0;Create;True;0;0;False;0;False;0,0;20,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;316;-268.1855,4045.413;Inherit;False;1991.84;814.0728;Caustics Color;24;323;322;320;319;321;318;312;315;324;313;329;314;325;328;305;306;327;303;311;310;308;302;304;301;Caustics Color;1,0,0.9896069,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-166.8737,2138.539;Inherit;False;Property;_TimeSpeed;TimeSpeed;17;0;Create;True;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;277.0713,262.5208;Inherit;False;PositionFormDepth;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;436;-90.14073,1712.336;Inherit;False;0;253;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;258;268.6466,1970.108;Inherit;False;Constant;_Float1;Float1;10;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;219;563.4895,256.2407;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;54.12639,1971.54;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-218.1856,4095.413;Inherit;False;218;PositionFormDepth;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;216;519.7551,64.36636;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;259;262.6466,2176.107;Inherit;False;Constant;_Float2;Float2;11;0;Create;True;0;0;False;0;False;0.5;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;302;15.31411,4100.259;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;480.6468,2114.107;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;220;749.2384,166.8571;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;304;0.9738665,4195.776;Inherit;False;Property;_CausticsScale;Caustics Scale;19;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;193;-266.5414,8002.799;Inherit;False;2542.907;761.6924;Wave Vertex Animation ;21;203;196;189;200;194;192;199;191;198;197;188;202;190;204;207;206;208;209;210;211;212;Wave Vertex Animation ;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;476.6468,1951.108;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;233;-284.1874,451.121;Inherit;False;1834.943;988.1354;Water Color;19;240;241;234;236;238;237;232;224;231;225;239;230;228;229;227;226;294;430;431;Water Color;0,0.6139736,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;248;463.4604,1747.691;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;978.9417,188.0061;Inherit;False;WaterDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;311;-114.2406,4328.118;Inherit;False;Property;_CausticsSpeed;Caustics Speed;20;0;Create;True;0;0;False;0;False;-8,0;-8,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;394;-252.4193,5872.397;Inherit;False;2574.624;1700.335;Foam Color;30;389;396;395;437;438;439;442;443;444;445;448;449;450;451;452;453;454;455;456;457;458;459;460;461;463;464;466;468;469;470;Foam Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;435;429.9054,1864.075;Inherit;False;Property;_NormalScale;NormalScale;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;677.2573,2052.337;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;308;-36.28928,4451.285;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-10.28927,4533.285;Inherit;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;189;-146.118,8084.524;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;303;210.3141,4181.259;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;190;-188.1175,8382.523;Inherit;False;Property;_WaveASpeedXYSteepnesswavelength;WaveA(SpeedXY,Steepness,wavelength);29;0;Create;True;0;0;False;0;False;1,1,2,50;1,1,2,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;327;390.491,4358.946;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;253;780.049,1734.228;Inherit;True;Property;_NormalMap;NormalMap;10;0;Create;True;0;0;False;0;False;-1;None;878d6a7060c28664db052574adefd009;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;188;213.0561,8281.253;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.GetLocalVarNode;318;391.7907,4642.424;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-234.1875,903.7088;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;255;831.6403,2015.976;Inherit;True;Global;NormalMap;NormalMap;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Instance;253;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;202;225.1112,8454.948;Inherit;False;Property;_WaveB;WaveB;30;0;Create;True;0;0;False;0;False;1,1,2,50;1,1,2,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;196.2039,4399.848;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;452;261.0413,6772.68;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;453;471.1776,6792.245;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;196;549.0386,8281.34;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.SimpleAddOpNode;328;527.5989,4426.354;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;305;387.7598,4208.871;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;261;1164.734,1933.858;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;455;418.5127,6915.761;Inherit;False;Property;_FoamRange;FoamRange;33;0;Create;True;0;0;False;0;False;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-73.18737,1054.709;Inherit;False;Property;_DeepRange;DeepRange;5;0;Create;True;0;0;False;0;False;1;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;227;-33.18733,931.7088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;319;580.3332,4662.202;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;321;538.0593,4751.953;Inherit;False;Property;_CausticsRange;Caustics Range;22;0;Create;True;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;204;643.9191,8471.736;Inherit;False;Property;_WaveC;WaveC;31;0;Create;True;0;0;False;0;False;1,1,2,50;1,1,2,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;466;-175.5788,6190.681;Inherit;False;Property;_FoamSpeed1;FoamSpeed1;35;0;Create;True;0;0;False;0;False;1,0,1;1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;254;1394.501,1935.122;Inherit;False;SurfaceNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;469;-163.3788,6474.182;Inherit;False;Property;_FoamSpeed2;FoamSpeed2;36;0;Create;True;0;0;False;0;False;1,0,0.5;1,0,0.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;442;-76.83307,6397.505;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;325;672.845,4454.505;Inherit;True;Property;_TextureSample0;Texture Sample 0;18;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;312;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;228;95.8127,958.7088;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;454;629.1198,6823.7;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;289;-265.8185,3302.814;Inherit;False;1529.173;642.4973;UnderWater Color;11;288;331;330;281;286;287;285;284;282;283;332;UnderWater Color;1,0.5430125,0,1;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;203;889.371,8256.53;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.SamplerNode;312;673.8708,4208.549;Inherit;True;Property;_CausticsTex;CausticsTex;18;0;Create;True;0;0;False;0;False;-1;None;be4393e7066bb43478000358384e2cbf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;444;-81.64972,6693.578;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;320;747.7798,4691.207;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;207;1174.049,8317.267;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;286;-206.8185,3740.201;Inherit;False;Property;_UnderWaterDistort;UnderWaterDistort;16;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;438;-56.03313,6034.805;Inherit;False;0;437;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ExpOpNode;456;769.0508,6837.072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;329;1001.468,4277.502;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-157.8185,3827.201;Inherit;False;Constant;_Float4;Float 4;15;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-215.8184,3611.201;Inherit;False;254;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;314;985.8496,4407.782;Inherit;False;Property;_CausticsIntensity;Caustics Intensity;21;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;230;218.8584,956.8228;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;443;112.9668,6327.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;1144.256,8073.758;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;445;108.1502,6623.377;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;468;60.62122,6171.182;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;279;-273.9378,2413.428;Inherit;False;1787.203;800.783;Reflect Color;12;272;268;295;296;297;298;424;425;426;427;428;434;Reflect Color;0,0.1204236,1,1;0;0
Node;AmplifyShaderEditor.ExpOpNode;322;863.9638,4698.157;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;470;66.69441,6490.896;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;231;324.8585,957.8228;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;323;987.9637,4698.157;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;-152.0849,2649.534;Inherit;False;254;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;285;74.18135,3680.201;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;313;1206.635,4310.739;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;431;177.1434,1234.819;Inherit;False;Property;_FresnelScale;FresnelScale;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;457;907.0507,6825.284;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;224;86.09047,501.1209;Inherit;False;Property;_DeepColor;DeepColor;4;0;Create;True;0;0;False;0;False;0,0,0,0;0.06666608,0.3450973,0.356862,0.8509804;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;297;84.7787,3090.444;Inherit;False;Property;_ReflectPower;Reflect Power;14;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;434;-30.87024,2838.155;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;439;333.9669,6099.803;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;206;1392.049,8285.268;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;449;333.1481,6450.067;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;430;182.1434,1159.819;Inherit;False;Property;_FresnelBias;FresnelBias;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;282;-124.5738,3355.503;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;239;334.997,1305.051;Inherit;False;Property;_FresnelPower;FresnelPower;9;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;460;645.2956,7001.645;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;225;87.09047,693.1208;Inherit;False;Property;_ShallowColor;ShallowColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.2627444,0.8666667,0.7803922,0.4901961;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;296;85.7787,3001.444;Inherit;False;Property;_ReflectIntensity;Reflect Intensity;13;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;237;586.8942,954.5559;Inherit;False;Property;_FresnelColor;FresnelColor;6;0;Create;True;0;0;False;0;False;0,0,0,0;0.01960784,0.1490188,0.2313718,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;283;304.681,3555.532;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;427;290.7989,2474.04;Inherit;False;Constant;_Vector0;Vector 0;37;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;426;224.6975,2701.249;Inherit;False;Property;_ReflectDistort;Reflect Distort;15;0;Create;True;0;0;False;0;False;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;451;682.7336,6524.247;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;437;589.463,6103.452;Inherit;True;Property;_FoamNoise;FoamNoise;32;0;Create;True;0;0;False;0;False;-1;None;d0e6201a295f8b245b902036747816ba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;208;1564.049,8293.268;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;608.2343,716.2168;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;295;364.404,2907.453;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;1348.882,4412.738;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;464;1113.096,6786.843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;238;557.9724,1164.565;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;448;573.0945,6318.618;Inherit;True;Property;_TextureSample1;Texture Sample 1;32;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;437;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;463;1293.338,6671.128;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;236;857.3265,848.5934;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;209;1742.341,8234.713;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;281;483.0916,3540.469;Inherit;False;Global;_GrabScreen0;Grab Screen 0;15;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;428;578.7576,2559.737;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;425;265.7079,2785.843;Inherit;False;Constant;_Float3;Float 3;37;0;Create;True;0;0;False;0;False;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;459;920.7271,7147.478;Inherit;False;Property;_FoamContrast;FoamContrast;34;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;211;1604.111,8377.38;Inherit;False;Property;_WaveColor;WaveColor;28;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;1515.074,4405.292;Inherit;False;CausticsColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;450;941.2947,6288.264;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;298;665.181,2864.722;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;240;1036.123,970.8198;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;458;1515.34,6599.782;Inherit;False;HeightLerp;-1;;4;906f35bed44319e49ab06a6a458c5346;0;3;4;FLOAT;0;False;1;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;395;1582.67,6343.128;Inherit;False;Property;_FoamColor;FoamColor;27;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;424;899.6342,2659.134;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;332;679.9974,3561.691;Inherit;False;SceneColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;575.8408,3726.028;Inherit;False;315;CausticsColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;1910.752,8303.713;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;2066.678,8224.138;Inherit;False;WaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;331;902.0977,3625.788;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;396;1871.625,6374.853;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;1048.997,850.7395;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;294;1175.103,1037.275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;1221.174,2538.547;Inherit;False;ReflectColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;403;2882.175,1493.654;Inherit;False;212;WaveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;2885.889,1567.913;Inherit;False;272;ReflectColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;241;1337.843,1108.205;Inherit;False;WaterOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;389;2057.708,6384.141;Inherit;False;FoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;2880.427,1405.823;Inherit;False;234;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;288;1049.843,3553.064;Inherit;False;UnderWaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;3422.439,1998.973;Inherit;False;389;FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;3118.017,1442.368;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;2887.114,1642.444;Inherit;False;288;UnderWaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;2891.963,1760.302;Inherit;False;241;WaterOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;401;3683.206,1924.257;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;291;3315.901,1600.122;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;398;3709.125,2021.92;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;400;3867.787,1830.546;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;399;4084.852,1753.247;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;345;-253.9496,4937.894;Inherit;False;2178.411;672.0933;ShoreEdge;18;339;344;343;338;342;337;340;336;341;335;334;333;349;350;351;352;353;354;ShoreEdge;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;334;-16.14925,5012.727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;1873.579,8558.13;Inherit;False;WaveVertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;429;4604.826,2157.889;Inherit;False;272;ReflectColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ExpOpNode;337;318.8507,5051.727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;343;490.1849,5280.089;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;341;55.18487,5374.089;Inherit;False;Property;_ShoreColor;ShoreColor;24;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;338.1849,5288.089;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;1680.413,8084.128;Inherit;False;WaveVertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;333;-203.9496,4987.894;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;340;65.67393,5258.6;Inherit;False;332;SceneColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;338;480.8508,5057.727;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;349;1063.86,5077.859;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;351;883.8604,5204.859;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;350;582.8604,5175.859;Inherit;False;Property;_ShoreEdgeWidth;Shore Edge Width;25;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;199;1608.579,8562.13;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;357;4365.946,1780.768;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;354;1524.547,5078.122;Inherit;False;ShoreEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;336;157.8507,5047.727;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;192;1376.933,8074.052;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;339;676.8507,5050.727;Inherit;False;WaterShore;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;197;1224.579,8529.13;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;198;1423.579,8563.131;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-45.14925,5120.727;Inherit;False;Property;_ShoreRange;Shore Range;23;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;1064.86,5248.859;Inherit;False;Property;_ShoreEdgeIntensity;Shore Edge Intensity;26;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;461;828.2956,7026.645;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;1337.86,5075.859;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;344;673.1849,5284.089;Inherit;False;ShoreColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;471;4576.199,1624.346;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4861.291,1648.043;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Toon_River_CS19;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;217;0;215;0
WireConnection;218;0;217;0
WireConnection;219;0;218;0
WireConnection;250;0;249;0
WireConnection;250;1;251;0
WireConnection;250;2;252;0
WireConnection;302;0;301;0
WireConnection;257;0;250;0
WireConnection;257;1;259;0
WireConnection;220;0;216;2
WireConnection;220;1;219;0
WireConnection;256;0;436;0
WireConnection;256;1;258;0
WireConnection;248;0;436;0
WireConnection;248;1;250;0
WireConnection;222;0;220;0
WireConnection;260;0;256;0
WireConnection;260;1;257;0
WireConnection;303;0;302;0
WireConnection;303;1;304;0
WireConnection;327;0;303;0
WireConnection;253;1;248;0
WireConnection;188;0;189;0
WireConnection;188;3;190;0
WireConnection;255;1;260;0
WireConnection;255;5;435;0
WireConnection;306;0;311;0
WireConnection;306;1;308;0
WireConnection;306;2;310;0
WireConnection;453;0;452;0
WireConnection;196;0;189;0
WireConnection;196;1;188;2
WireConnection;196;2;188;3
WireConnection;196;3;202;0
WireConnection;328;0;327;0
WireConnection;328;1;306;0
WireConnection;305;0;303;0
WireConnection;305;1;306;0
WireConnection;261;0;253;0
WireConnection;261;1;255;0
WireConnection;227;0;226;0
WireConnection;319;0;318;0
WireConnection;254;0;261;0
WireConnection;325;1;328;0
WireConnection;228;0;227;0
WireConnection;228;1;229;0
WireConnection;454;0;453;0
WireConnection;454;1;455;0
WireConnection;203;0;189;0
WireConnection;203;1;196;2
WireConnection;203;2;196;3
WireConnection;203;3;204;0
WireConnection;312;1;305;0
WireConnection;320;0;319;0
WireConnection;320;1;321;0
WireConnection;456;0;454;0
WireConnection;329;0;312;0
WireConnection;329;1;325;0
WireConnection;230;0;228;0
WireConnection;443;0;466;3
WireConnection;443;1;442;0
WireConnection;191;0;189;0
WireConnection;191;1;188;0
WireConnection;191;2;196;0
WireConnection;191;3;203;0
WireConnection;445;0;469;3
WireConnection;445;1;444;0
WireConnection;468;0;466;1
WireConnection;468;1;466;2
WireConnection;322;0;320;0
WireConnection;470;0;469;1
WireConnection;470;1;469;2
WireConnection;231;0;230;0
WireConnection;323;0;322;0
WireConnection;285;0;284;0
WireConnection;285;1;286;0
WireConnection;285;2;287;0
WireConnection;313;0;329;0
WireConnection;313;1;314;0
WireConnection;457;0;456;0
WireConnection;439;0;438;0
WireConnection;439;2;468;0
WireConnection;439;1;443;0
WireConnection;206;0;191;0
WireConnection;206;1;207;0
WireConnection;449;0;438;0
WireConnection;449;2;470;0
WireConnection;449;1;445;0
WireConnection;283;0;282;0
WireConnection;283;1;285;0
WireConnection;437;1;439;0
WireConnection;208;0;206;0
WireConnection;232;0;224;0
WireConnection;232;1;225;0
WireConnection;232;2;231;0
WireConnection;295;0;268;0
WireConnection;295;4;434;0
WireConnection;295;2;296;0
WireConnection;295;3;297;0
WireConnection;324;0;313;0
WireConnection;324;1;323;0
WireConnection;464;0;457;0
WireConnection;464;1;460;2
WireConnection;238;1;430;0
WireConnection;238;2;431;0
WireConnection;238;3;239;0
WireConnection;448;1;449;0
WireConnection;463;0;464;0
WireConnection;236;0;232;0
WireConnection;236;1;237;0
WireConnection;236;2;238;0
WireConnection;209;0;208;0
WireConnection;281;0;283;0
WireConnection;428;0;427;0
WireConnection;428;1;268;0
WireConnection;428;2;426;0
WireConnection;315;0;324;0
WireConnection;450;0;437;1
WireConnection;450;1;448;1
WireConnection;450;2;451;1
WireConnection;298;0;295;0
WireConnection;240;0;236;0
WireConnection;458;4;463;0
WireConnection;458;1;450;0
WireConnection;458;7;459;0
WireConnection;424;0;428;0
WireConnection;424;1;425;0
WireConnection;424;2;298;0
WireConnection;332;0;281;0
WireConnection;210;0;209;0
WireConnection;210;1;211;0
WireConnection;212;0;210;0
WireConnection;331;0;332;0
WireConnection;331;1;330;0
WireConnection;396;0;395;0
WireConnection;396;1;458;0
WireConnection;234;0;236;0
WireConnection;294;0;240;0
WireConnection;272;0;424;0
WireConnection;241;0;294;0
WireConnection;389;0;396;0
WireConnection;288;0;331;0
WireConnection;300;0;273;0
WireConnection;300;1;403;0
WireConnection;300;2;235;0
WireConnection;401;0;397;0
WireConnection;291;0;300;0
WireConnection;291;1;290;0
WireConnection;291;2;292;0
WireConnection;398;0;397;0
WireConnection;400;0;291;0
WireConnection;400;1;401;0
WireConnection;399;0;291;0
WireConnection;399;1;400;0
WireConnection;399;2;398;0
WireConnection;334;0;333;0
WireConnection;200;0;199;0
WireConnection;337;0;336;0
WireConnection;343;0;342;0
WireConnection;342;0;340;0
WireConnection;342;1;341;0
WireConnection;194;0;192;0
WireConnection;338;0;337;0
WireConnection;349;0;339;0
WireConnection;349;1;351;0
WireConnection;351;0;350;0
WireConnection;199;0;198;0
WireConnection;357;0;399;0
WireConnection;354;0;352;0
WireConnection;336;0;334;0
WireConnection;336;1;335;0
WireConnection;192;0;191;0
WireConnection;339;0;338;0
WireConnection;197;0;203;3
WireConnection;197;1;203;2
WireConnection;198;0;197;0
WireConnection;461;0;460;2
WireConnection;352;0;349;0
WireConnection;352;1;353;0
WireConnection;344;0;343;0
WireConnection;0;9;471;4
WireConnection;0;13;357;0
ASEEND*/
//CHKSM=EAD6398E2439AEA043B56C3F83B8B21603E3B559