// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Toon_InteractiveWater"
{
	Properties
	{
		_Tessellation("Tessellation", Float) = 1
		_TessellationMinMax("TessellationMinMax", Vector) = (1,10,0,0)
		_ShallowColor("ShallowColor", Color) = (0,0,0,0)
		_DeepColor("DeepColor", Color) = (0,0,0,0)
		_DeepRange("DeepRange", Float) = 1
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_FresnelPower("FresnelPower", Float) = 1
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalStr("NormalStr", Range( 0 , 1)) = 1
		_NormalScale("NormalScale", Float) = 1
		_NormalSpeed("NormalSpeed", Vector) = (0,0,0,0)
		_RefSmoothness("RefSmoothness", Range( 0 , 1)) = 1
		_Occlusion("Occlusion", Range( 0 , 1)) = 0
		_TimeSpeed("TimeSpeed", Float) = 1
		_WaveASpeedXYSteepnesswavelength("WaveA(SpeedXY,Steepness,wavelength)", Vector) = (1,1,2,50)
		_WaveB("WaveB", Vector) = (1,1,2,50)
		_WaveC("WaveC", Vector) = (1,1,2,50)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoisePanner("NoisePanner", Vector) = (0,0,1,0)
		_DistorStr("DistorStr", Float) = 0.1
		_Wave1Tex("Wave1Tex", 2D) = "black" {}
		_WaveBaseColor("WaveBaseColor", Color) = (1,1,1,1)
		_Wave2Tex("Wave2Tex", 2D) = "black" {}
		_WaveDIstorStr("WaveDIstorStr", Float) = 1
		_WaveRange("WaveRange", Float) = 1
		_WaveHardness("WaveHardness", Float) = 0.1
		_WaveVertexOffsetStr("WaveVertexOffsetStr", Float) = 1
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
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
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
			float4 screenPos;
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

		uniform float4 _WaveASpeedXYSteepnesswavelength;
		uniform float4 _WaveB;
		uniform float4 _WaveC;
		uniform sampler2D _Wave2Tex;
		uniform float4 _Wave2Tex_ST;
		uniform float _WaveVertexOffsetStr;
		uniform float4 _DeepColor;
		uniform float4 _ShallowColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DeepRange;
		uniform float4 _FresnelColor;
		uniform sampler2D _NormalMap;
		uniform float _NormalScale;
		uniform float2 _NormalSpeed;
		uniform float _TimeSpeed;
		uniform sampler2D _NoiseTex;
		uniform float3 _NoisePanner;
		uniform float4 _NoiseTex_ST;
		uniform float _DistorStr;
		uniform float _NormalStr;
		uniform float _WaveDIstorStr;
		uniform float _FresnelPower;
		uniform float _RefSmoothness;
		uniform float _Occlusion;
		uniform float4 _WaveBaseColor;
		uniform float _WaveRange;
		uniform float _WaveHardness;
		uniform sampler2D _Wave1Tex;
		uniform float4 _Wave1Tex_ST;
		uniform float2 _TessellationMinMax;
		uniform float _Tessellation;


		float3 GerstnerWave188( float3 position, inout float3 tangent, inout float3 binormal, float4 wave )
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


		float3 GerstnerWave196( float3 position, inout float3 tangent, inout float3 binormal, float4 wave )
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


		float3 GerstnerWave203( float3 position, inout float3 tangent, inout float3 binormal, float4 wave )
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


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		float3 InvertDepthDir72_g1( float3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessellationMinMax.x,_TessellationMinMax.y,_Tessellation);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
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
			float3 worldToObj192 = mul( unity_WorldToObject, float4( temp_output_191_0, 1 ) ).xyz;
			float3 WaveVertexPos194 = worldToObj192;
			float2 uv_Wave2Tex = v.texcoord * _Wave2Tex_ST.xy + _Wave2Tex_ST.zw;
			float WaveStr462 = tex2Dlod( _Wave2Tex, float4( uv_Wave2Tex, 0, 0.0) ).r;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 WaveVertexOffset476 = ( WaveStr462 * ase_vertexNormal );
			v.vertex.xyz = ( WaveVertexPos194 + ( WaveVertexOffset476 * _WaveVertexOffsetStr ) );
			v.vertex.w = 1;
			v.normal = ( ase_vertexNormal + WaveStr462 );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s443 = (SurfaceOutputStandard ) 0;
			float3 ase_worldPos = i.worldPos;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 UV22_g3 = ase_screenPosNorm.xy;
			float2 localUnStereo22_g3 = UnStereo( UV22_g3 );
			float2 break64_g1 = localUnStereo22_g3;
			float clampDepth69_g1 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g1 = ( 1.0 - clampDepth69_g1 );
			#else
				float staticSwitch38_g1 = clampDepth69_g1;
			#endif
			float3 appendResult39_g1 = (float3(break64_g1.x , break64_g1.y , staticSwitch38_g1));
			float4 appendResult42_g1 = (float4((appendResult39_g1*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g1 = mul( unity_CameraInvProjection, appendResult42_g1 );
			float3 temp_output_46_0_g1 = ( (temp_output_43_0_g1).xyz / (temp_output_43_0_g1).w );
			float3 In72_g1 = temp_output_46_0_g1;
			float3 localInvertDepthDir72_g1 = InvertDepthDir72_g1( In72_g1 );
			float4 appendResult49_g1 = (float4(localInvertDepthDir72_g1 , 1.0));
			float3 PositionFormDepth218 = (mul( unity_CameraToWorld, appendResult49_g1 )).xyz;
			float WaterDepth222 = ( ase_worldPos.y - (PositionFormDepth218).y );
			float clampResult231 = clamp( exp( ( -WaterDepth222 / _DeepRange ) ) , 0.0 , 1.0 );
			float4 lerpResult232 = lerp( _DeepColor , _ShallowColor , clampResult231);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 temp_output_246_0 = ( ( (ase_worldPos).xz * -0.1 ) / _NormalScale );
			float mulTime251 = _Time.y * _TimeSpeed;
			float2 temp_output_250_0 = ( _NormalSpeed * mulTime251 );
			float mulTime451 = _Time.y * _NoisePanner.z;
			float2 appendResult452 = (float2(_NoisePanner.x , _NoisePanner.y));
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner448 = ( mulTime451 * appendResult452 + uv_NoiseTex);
			float temp_output_446_0 = ( tex2D( _NoiseTex, panner448 ).r * _DistorStr * 0.1 );
			float2 uv_Wave2Tex = i.uv_texcoord * _Wave2Tex_ST.xy + _Wave2Tex_ST.zw;
			float WaveStr462 = tex2D( _Wave2Tex, uv_Wave2Tex ).r;
			float temp_output_456_0 = ( WaveStr462 * _WaveDIstorStr );
			float3 lerpResult483 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _NormalMap, ( temp_output_246_0 + temp_output_250_0 + temp_output_446_0 ) ), _NormalStr ) , UnpackScaleNormal( tex2D( _NormalMap, ( ( temp_output_246_0 * 1.0 ) + ( temp_output_250_0 * 0.5 ) + temp_output_446_0 ) ), _NormalStr ) ) , UnpackNormal( tex2D( _NormalMap, ( temp_output_246_0 + temp_output_456_0 ) ) ) , temp_output_456_0);
			float3 SurfaceNormal254 = lerpResult483;
			float fresnelNdotV238 = dot( normalize( SurfaceNormal254 ), ase_worldViewDir );
			float fresnelNode238 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV238 , 0.0001 ), _FresnelPower ) );
			float4 lerpResult236 = lerp( lerpResult232 , _FresnelColor , fresnelNode238);
			float4 WaterColor234 = lerpResult236;
			float3 indirectNormal441 = SurfaceNormal254;
			Unity_GlossyEnvironmentData g441 = UnityGlossyEnvironmentSetup( _RefSmoothness, data.worldViewDir, indirectNormal441, float3(0,0,0));
			float3 indirectSpecular441 = UnityGI_IndirectSpecular( data, _Occlusion, indirectNormal441, g441 );
			float4 ReflectColor272 = ( float4( indirectSpecular441 , 0.0 ) * WaterColor234 );
			float2 uv_Wave1Tex = i.uv_texcoord * _Wave1Tex_ST.xy + _Wave1Tex_ST.zw;
			float smoothstepResult463 = smoothstep( _WaveRange , ( _WaveRange + ( _WaveHardness * 0.1 ) ) , tex2D( _Wave1Tex, uv_Wave1Tex ).r);
			float WaveColor212 = smoothstepResult463;
			float4 lerpResult491 = lerp( ( WaterColor234 + ReflectColor272 ) , ( _WaveBaseColor * WaveColor212 ) , ( _WaveBaseColor.a * WaveColor212 ));
			s443.Albedo = lerpResult491.rgb;
			s443.Normal = WorldNormalVector( i , SurfaceNormal254 );
			s443.Emission = float3( 0,0,0 );
			s443.Metallic = 0.0;
			s443.Smoothness = 0.0;
			s443.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi443 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g443 = UnityGlossyEnvironmentSetup( s443.Smoothness, data.worldViewDir, s443.Normal, float3(0,0,0));
			gi443 = UnityGlobalIllumination( data, s443.Occlusion, s443.Normal, g443 );
			#endif

			float3 surfResult443 = LightingStandard ( s443, viewDir, gi443 ).rgb;
			surfResult443 += s443.Emission;

			#ifdef UNITY_PASS_FORWARDADD//443
			surfResult443 -= s443.Emission;
			#endif//443
			c.rgb = surfResult443;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
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
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v );
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
-1653;38;1599;862;-3508.937;-1430.962;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;223;-295.633,14.36626;Inherit;False;1498.574;364.1545;Water Depth;7;215;217;218;216;219;220;222;Water Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;262;-275.8737,1578.427;Inherit;False;2813.041;748.6448; Surface Normal;21;260;461;254;261;255;253;248;257;256;250;258;246;259;251;247;276;249;278;245;244;483;Surface Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;215;-245.633,264.0587;Inherit;False;Reconstruct World Position From Depth;-1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;450;-729.2817,2407.059;Inherit;False;Property;_NoisePanner;NoisePanner;20;0;Create;True;0;0;0;False;0;False;0,0,1;0.1,0.1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;244;-259.748,1635.427;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;458;-2140.185,2791.918;Inherit;False;1453.014;754.8735;WaveColor;10;212;455;462;463;464;466;467;468;469;481;WaveColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;449;-599.2817,2294.059;Inherit;False;0;445;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;252;-301.8737,2052.539;Inherit;False;Property;_TimeSpeed;TimeSpeed;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;452;-525.2817,2433.059;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;278;-119.6764,1799.222;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;245;-83.548,1637.527;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;217;109.2573,257.9084;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;451;-542.2817,2551.059;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;481;-2080.393,2851;Inherit;True;Property;_Wave2Tex;Wave2Tex;24;0;Create;True;0;0;0;False;0;False;-1;None;dd4060ea9e617b1428e696e0d59f5509;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;247;53.55202,1797.927;Inherit;False;Property;_NormalScale;NormalScale;10;0;Create;True;0;0;0;False;0;False;1;1.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;61.32362,1673.222;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;448;-287.2817,2355.059;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;249;-225.8737,1912.539;Inherit;False;Property;_NormalSpeed;NormalSpeed;11;0;Create;True;0;0;0;False;0;False;0,0;0.01,-0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;251;-146.8736,2054.539;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;298.0713,259.5208;Inherit;False;PositionFormDepth;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;462;-1645.779,2882.036;Inherit;False;WaveStr;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;262.6466,2176.107;Inherit;False;Constant;_Float2;Float2;11;0;Create;True;0;0;0;False;0;False;0.5;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;219;563.4895,256.2407;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;445;-80.19338,2329.085;Inherit;True;Property;_NoiseTex;NoiseTex;19;0;Create;True;0;0;0;False;0;False;-1;None;35858763e05da9d4a8b77560217d7992;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;246;251.952,1703.227;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;454;54.45699,2638.598;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;447;51.98492,2537.122;Inherit;False;Property;_DistorStr;DistorStr;21;0;Create;True;0;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;268.6466,1970.108;Inherit;False;Constant;_Float1;Float1;10;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;216;519.7551,64.36636;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;54.12639,1971.54;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;439.1576,1967.938;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;460;505.7994,2768.382;Inherit;False;462;WaveStr;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;457;507.5345,2857.706;Inherit;False;Property;_WaveDIstorStr;WaveDIstorStr;25;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;332.8578,2342.398;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;220;749.2384,166.8571;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;435.1469,2108.907;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;248;584.2917,1744.814;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;978.9417,188.0061;Inherit;False;WaterDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;461;641.1357,1934.37;Inherit;False;Property;_NormalStr;NormalStr;9;0;Create;True;0;0;0;False;0;False;1;0.154;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;714.4864,2101.16;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;233;-284.1874,451.121;Inherit;False;1834.943;988.1354;Water Color;18;240;241;234;236;238;237;232;224;231;225;239;230;228;229;227;226;294;442;Water Color;0,0.6139736,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;456;733.3125,2730.085;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;488;870.2461,2447.65;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;255;1014.061,1992.386;Inherit;True;Global;NormalMap;NormalMap;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Instance;253;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;253;981.7409,1667.455;Inherit;True;Property;_NormalMap;NormalMap;8;0;Create;True;0;0;0;False;0;False;-1;None;5c838891c42224d48ae85c3bafba02ff;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;226;-234.1875,903.7088;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;227;-33.18733,931.7088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-73.18737,1054.709;Inherit;False;Property;_DeepRange;DeepRange;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;261;1449.751,1824.117;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;487;1120.84,2287.304;Inherit;True;Global;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Instance;253;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;483;2020.022,2195.277;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;228;95.8127,958.7088;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;254;2331.888,1864.849;Inherit;False;SurfaceNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ExpOpNode;230;218.8584,956.8228;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;239;267.7292,1334.892;Inherit;False;Property;_FresnelPower;FresnelPower;7;0;Create;True;0;0;0;False;0;False;1;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;442;296.2494,1216.335;Inherit;False;254;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;225;87.09047,693.1208;Inherit;False;Property;_ShallowColor;ShallowColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;224;86.09047,501.1209;Inherit;False;Property;_DeepColor;DeepColor;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.4733589,0.5377358,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;231;344.9095,954.9584;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;193;-274.9528,3911.295;Inherit;False;2640.318;879.2573;Wave Vertex Animation ;19;200;197;199;198;194;192;210;211;209;208;206;191;207;203;204;196;188;202;190;Wave Vertex Animation ;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;279;-272.1215,2973.747;Inherit;False;1787.203;800.783;Reflect Color;8;272;438;440;436;437;439;441;189;Reflect Color;0,0.1204236,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;232;608.2343,716.2168;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;237;586.8942,954.5559;Inherit;False;Property;_FresnelColor;FresnelColor;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.2918684,0.4339623,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;238;553.0042,1221.157;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;236;857.3265,848.5934;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;466;-1868.986,3240.902;Inherit;False;Property;_WaveHardness;WaveHardness;27;0;Create;True;0;0;0;False;0;False;0.1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;189;431.618,3548.351;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;190;-196.5289,4291.019;Inherit;False;Property;_WaveASpeedXYSteepnesswavelength;WaveA(SpeedXY,Steepness,wavelength);16;0;Create;True;0;0;0;False;0;False;1,1,2,50;1,1,0,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;188;204.6448,4189.749;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;Create;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.RangedFloatNode;436;359.3147,3309.57;Inherit;False;Property;_Occlusion;Occlusion;13;0;Create;True;0;0;0;False;0;False;0;0.185;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;439;344.2567,3199.834;Inherit;False;Property;_RefSmoothness;RefSmoothness;12;0;Create;True;0;0;0;False;0;False;1;0.718;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;464;-1860.986,3136.902;Inherit;False;Property;_WaveRange;WaveRange;26;0;Create;True;0;0;0;False;0;False;1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;1063.319,836.4175;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;202;216.6999,4363.444;Inherit;False;Property;_WaveB;WaveB;17;0;Create;True;0;0;0;False;0;False;1,1,2,50;1,1,0,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;468;-1678.986,3260.902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;437;417.7498,3117.944;Inherit;False;254;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;467;-1515.986,3221.902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;196;540.6271,4189.835;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;Create;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.SamplerNode;455;-2079.357,3041.306;Inherit;True;Property;_Wave1Tex;Wave1Tex;22;0;Create;True;0;0;0;False;0;False;-1;None;87c44ea6fa1e5d64491e6e2024686a7d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;441;674.3666,3123.41;Inherit;False;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;440;706.9188,3289.959;Inherit;False;234;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;204;635.5078,4380.232;Inherit;False;Property;_WaveC;WaveC;18;0;Create;True;0;0;0;False;0;False;1,1,2,50;1,1,0,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;474;850.8204,5113.953;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;463;-1367.986,3103.902;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;473;870.219,5016.023;Inherit;False;462;WaveStr;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;203;880.9597,4165.026;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;Create;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;438;1020.281,3103.437;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;475;1144.82,5052.953;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;-937.1969,3100.929;Inherit;False;WaveColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;1222.99,3098.866;Inherit;False;ReflectColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;1135.845,3982.254;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;3998.396,1554.736;Inherit;False;234;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;476;1350.242,5049.435;Inherit;False;WaveVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;192;1368.522,3982.548;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;235;3978.684,1646.374;Inherit;False;272;ReflectColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;403;4067.419,2006.854;Inherit;False;212;WaveColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;492;3995.026,1798.383;Inherit;False;Property;_WaveBaseColor;WaveBaseColor;23;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,0.6156863;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;480;4375.882,2273.156;Inherit;False;Property;_WaveVertexOffsetStr;WaveVertexOffsetStr;28;0;Create;True;0;0;0;False;0;False;1;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;493;4340.036,1919.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;477;4376.882,2169.156;Inherit;False;476;WaveVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;4331.687,1643.864;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;1715.251,3977.361;Inherit;False;WaveVertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;499;4288.938,1787.962;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;472;4669.533,2569.786;Inherit;False;Property;_TessellationMinMax;TessellationMinMax;1;0;Create;True;0;0;0;False;0;False;1,10;100,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;497;5267.222,2309.205;Inherit;False;462;WaveStr;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;494;5279.9,2142.497;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;402;4650.134,2093.44;Inherit;False;194;WaveVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;470;4809.136,2483.958;Inherit;False;Property;_Tessellation;Tessellation;0;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;444;4527.604,1893.876;Inherit;False;254;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;479;4670.882,2204.156;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;491;4579.976,1758.857;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;207;1158.006,4312.258;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;211;1588.068,4372.372;Inherit;False;Property;_WaveColor;WaveColor;15;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;208;1548.006,4288.259;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;1894.709,4298.706;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;1857.536,4553.124;Inherit;False;WaveVertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;469;-1104.323,3246.371;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;498;5578.419,2145.028;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;241;1327.843,973.2048;Inherit;False;WaterOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;294;1182.103,1040.275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;478;4902.861,2113.532;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;198;1407.536,4558.125;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;206;1376.006,4280.259;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;199;1592.536,4557.124;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;209;1726.298,4229.707;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;197;1208.536,4524.124;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;240;1036.123,970.8198;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;471;4998.533,2545.786;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomStandardSurface;443;4853.903,1883.476;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5959.291,1752.043;Float;False;True;-1;7;ASEMaterialInspector;0;0;CustomLighting;ASE/Toon_InteractiveWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;452;0;450;1
WireConnection;452;1;450;2
WireConnection;245;0;244;0
WireConnection;217;0;215;0
WireConnection;451;0;450;3
WireConnection;276;0;245;0
WireConnection;276;1;278;0
WireConnection;448;0;449;0
WireConnection;448;2;452;0
WireConnection;448;1;451;0
WireConnection;251;0;252;0
WireConnection;218;0;217;0
WireConnection;462;0;481;1
WireConnection;219;0;218;0
WireConnection;445;1;448;0
WireConnection;246;0;276;0
WireConnection;246;1;247;0
WireConnection;250;0;249;0
WireConnection;250;1;251;0
WireConnection;256;0;246;0
WireConnection;256;1;258;0
WireConnection;446;0;445;1
WireConnection;446;1;447;0
WireConnection;446;2;454;0
WireConnection;220;0;216;2
WireConnection;220;1;219;0
WireConnection;257;0;250;0
WireConnection;257;1;259;0
WireConnection;248;0;246;0
WireConnection;248;1;250;0
WireConnection;248;2;446;0
WireConnection;222;0;220;0
WireConnection;260;0;256;0
WireConnection;260;1;257;0
WireConnection;260;2;446;0
WireConnection;456;0;460;0
WireConnection;456;1;457;0
WireConnection;488;0;246;0
WireConnection;488;1;456;0
WireConnection;255;1;260;0
WireConnection;255;5;461;0
WireConnection;253;1;248;0
WireConnection;253;5;461;0
WireConnection;227;0;226;0
WireConnection;261;0;253;0
WireConnection;261;1;255;0
WireConnection;487;1;488;0
WireConnection;483;0;261;0
WireConnection;483;1;487;0
WireConnection;483;2;456;0
WireConnection;228;0;227;0
WireConnection;228;1;229;0
WireConnection;254;0;483;0
WireConnection;230;0;228;0
WireConnection;231;0;230;0
WireConnection;232;0;224;0
WireConnection;232;1;225;0
WireConnection;232;2;231;0
WireConnection;238;0;442;0
WireConnection;238;3;239;0
WireConnection;236;0;232;0
WireConnection;236;1;237;0
WireConnection;236;2;238;0
WireConnection;188;0;189;0
WireConnection;188;3;190;0
WireConnection;234;0;236;0
WireConnection;468;0;466;0
WireConnection;467;0;464;0
WireConnection;467;1;468;0
WireConnection;196;0;189;0
WireConnection;196;1;188;2
WireConnection;196;2;188;3
WireConnection;196;3;202;0
WireConnection;441;0;437;0
WireConnection;441;1;439;0
WireConnection;441;2;436;0
WireConnection;463;0;455;1
WireConnection;463;1;464;0
WireConnection;463;2;467;0
WireConnection;203;0;189;0
WireConnection;203;1;196;2
WireConnection;203;2;196;3
WireConnection;203;3;204;0
WireConnection;438;0;441;0
WireConnection;438;1;440;0
WireConnection;475;0;473;0
WireConnection;475;1;474;0
WireConnection;212;0;463;0
WireConnection;272;0;438;0
WireConnection;191;0;189;0
WireConnection;191;1;188;0
WireConnection;191;2;196;0
WireConnection;191;3;203;0
WireConnection;476;0;475;0
WireConnection;192;0;191;0
WireConnection;493;0;492;4
WireConnection;493;1;403;0
WireConnection;300;0;273;0
WireConnection;300;1;235;0
WireConnection;194;0;192;0
WireConnection;499;0;492;0
WireConnection;499;1;403;0
WireConnection;479;0;477;0
WireConnection;479;1;480;0
WireConnection;491;0;300;0
WireConnection;491;1;499;0
WireConnection;491;2;493;0
WireConnection;208;0;206;0
WireConnection;210;0;209;0
WireConnection;210;1;211;0
WireConnection;200;0;199;0
WireConnection;498;0;494;0
WireConnection;498;1;497;0
WireConnection;241;0;294;0
WireConnection;294;0;240;0
WireConnection;478;0;402;0
WireConnection;478;1;479;0
WireConnection;198;0;197;0
WireConnection;206;0;191;0
WireConnection;206;1;207;0
WireConnection;199;0;198;0
WireConnection;209;0;208;0
WireConnection;197;0;203;3
WireConnection;197;1;203;2
WireConnection;240;0;236;0
WireConnection;471;0;470;0
WireConnection;471;1;472;1
WireConnection;471;2;472;2
WireConnection;443;0;491;0
WireConnection;443;1;444;0
WireConnection;0;13;443;0
WireConnection;0;11;478;0
WireConnection;0;12;498;0
WireConnection;0;14;471;0
ASEEND*/
//CHKSM=300B90B3215D1D91809C4D5ADF0076F2D45AF708