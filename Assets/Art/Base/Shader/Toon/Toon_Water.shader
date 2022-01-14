// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Toon_Water"
{
	Properties
	{
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 700
		_ShallowColor("ShallowColor", Color) = (0,0,0,0)
		_DeepColor("DeepColor", Color) = (0,0,0,0)
		_DeepRange("DeepRange", Float) = 1
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_FresnelPower("FresnelPower", Float) = 1
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		_NormalSpeed("NormalSpeed", Vector) = (0,0,0,0)
		_ReflectionTex("ReflectionTex", 2D) = "white" {}
		_ReflectIntensity("Reflect Intensity", Float) = 0
		_ReflectPower("Reflect Power", Float) = 0
		_ReflectDistort("ReflectDistort", Float) = 0
		_UnderWaterDistort("UnderWaterDistort", Float) = 0
		_TimeSpeed("TimeSpeed", Float) = 1
		_ShoreColor("ShoreColor", Color) = (1,1,1,0)
		_ShoreRange("Shore Range", Float) = 1
		_ShoreEdgeWidth("Shore Edge Width", Range( 0 , 1)) = 0
		_ShoreEdgeIntensity("Shore Edge Intensity", Float) = 0
		_FoamColor("FoamColor", Color) = (1,1,1,0)
		_FoamRange("Foam Range", Float) = 0
		_FoamSpeed("Foam Speed", Float) = 1
		_NoiseSpeed("Noise Speed", Float) = 1
		_FoamFrequency("Foam Frequency", Float) = 0
		_FoamWidth("Foam Width", Float) = 0
		_FoamDissolve("FoamDissolve", Float) = 0
		_FoamNoiseSize("FoamNoise Size", Vector) = (0,0,0,0)
		_FoamNoiseSize2("FoamNoise Size2", Vector) = (0,0,0,0)
		_FoamBlend("Foam Blend", Range( 0 , 1)) = 0
		_WaveColor("WaveColor", Color) = (0,0,0,0)
		_WaveASpeedXYSteepnesswavelength("WaveA(SpeedXY,Steepness,wavelength)", Vector) = (1,1,2,50)
		_WaveB("WaveB", Vector) = (1,1,2,50)
		_WaveC("WaveC", Vector) = (1,1,2,50)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float4 _WaveASpeedXYSteepnesswavelength;
		uniform float4 _WaveB;
		uniform float4 _WaveC;
		uniform float4 _DeepColor;
		uniform float4 _ShallowColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float _DeepRange;
		uniform float4 _FresnelColor;
		uniform float _FresnelPower;
		uniform float4 _WaveColor;
		uniform sampler2D _ReflectionTex;
		uniform sampler2D _NormalMap;
		uniform float _NormalScale;
		uniform float2 _NormalSpeed;
		uniform float _TimeSpeed;
		uniform float _ReflectDistort;
		uniform float _ReflectIntensity;
		uniform float _ReflectPower;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _UnderWaterDistort;
		uniform float4 _ShoreColor;
		uniform float _ShoreRange;
		uniform float _FoamBlend;
		uniform float _FoamRange;
		uniform float _FoamWidth;
		uniform float _FoamFrequency;
		uniform float _FoamSpeed;
		uniform float _NoiseSpeed;
		uniform float2 _FoamNoiseSize;
		uniform float2 _FoamNoiseSize2;
		uniform float _FoamDissolve;
		uniform float4 _FoamColor;
		uniform float _ShoreEdgeWidth;
		uniform float _ShoreEdgeIntensity;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;


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


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
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


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
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
			v.vertex.xyz = WaveVertexPos194;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
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
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV238 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode238 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV238 , 0.0001 ), _FresnelPower ) );
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
			float2 temp_output_246_0 = ( ( (ase_worldPos).xz * -0.1 ) / _NormalScale );
			float2 temp_output_250_0 = ( _NormalSpeed * _Time.y * _TimeSpeed );
			float3 SurfaceNormal254 = BlendNormals( UnpackNormal( tex2D( _NormalMap, ( temp_output_246_0 + temp_output_250_0 ) ) ) , UnpackNormal( tex2D( _NormalMap, ( ( temp_output_246_0 * 1.0 ) + ( temp_output_250_0 * 1.0 ) ) ) ) );
			float fresnelNdotV295 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode295 = ( 0.0 + _ReflectIntensity * pow( 1.0 - fresnelNdotV295, _ReflectPower ) );
			float clampResult298 = clamp( fresnelNode295 , 0.0 , 1.0 );
			float4 ReflectColor272 = ( tex2D( _ReflectionTex, ( (ase_screenPosNorm).xy + ( (SurfaceNormal254).xy * ( _ReflectDistort * 0.01 ) ) ) ) * clampResult298 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor281 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( ( SurfaceNormal254 * _UnderWaterDistort * 0.01 ) , 0.0 ) ).xy);
			float4 SceneColor332 = screenColor281;
			float3 ShoreColor344 = (( SceneColor332 * _ShoreColor )).rgb;
			float clampResult338 = clamp( exp( ( -WaterDepth222 / _ShoreRange ) ) , 0.0 , 1.0 );
			float WaterShore339 = clampResult338;
			float4 lerpResult346 = lerp( ( WaterColor234 + WaveColor212 + ReflectColor272 ) , float4( ShoreColor344 , 0.0 ) , WaterShore339);
			float clampResult361 = clamp( ( WaterDepth222 / _FoamRange ) , 0.0 , 1.0 );
			float smoothstepResult371 = smoothstep( _FoamBlend , 1.0 , ( clampResult361 + 0.1 ));
			float temp_output_362_0 = ( 1.0 - clampResult361 );
			float temp_output_366_0 = ( _NoiseSpeed * _Time.y );
			float2 temp_cast_6 = (temp_output_366_0).xx;
			float2 uv_TexCoord378 = i.uv_texcoord + temp_cast_6;
			float simplePerlin2D377 = snoise( ( uv_TexCoord378 * _FoamNoiseSize ) );
			simplePerlin2D377 = simplePerlin2D377*0.5 + 0.5;
			float2 temp_cast_7 = (-temp_output_366_0).xx;
			float2 uv_TexCoord416 = i.uv_texcoord + temp_cast_7;
			float simplePerlin3D415 = snoise( float3( ( uv_TexCoord416 * _FoamNoiseSize2 ) ,  0.0 ) );
			simplePerlin3D415 = simplePerlin3D415*0.5 + 0.5;
			float4 FoamColor389 = ( ( ( 1.0 - smoothstepResult371 ) * step( ( temp_output_362_0 - _FoamWidth ) , ( ( temp_output_362_0 + ( sin( ( ( temp_output_362_0 * _FoamFrequency ) + -_FoamSpeed ) ) + ( 1.0 - ( simplePerlin2D377 * simplePerlin3D415 ) ) ) ) - _FoamDissolve ) ) ) * _FoamColor );
			float4 lerpResult399 = lerp( lerpResult346 , ( lerpResult346 + float4( (FoamColor389).rgb , 0.0 ) ) , (FoamColor389).a);
			float smoothstepResult349 = smoothstep( ( 1.0 - _ShoreEdgeWidth ) , 1.1 , WaterShore339);
			float ShoreEdge354 = ( smoothstepResult349 * _ShoreEdgeIntensity );
			o.Emission = max( ( lerpResult399 + ShoreEdge354 ) , float4( 0,0,0,0 ) ).rgb;
			float temp_output_11_0_g6 = _FogDistanceEnd;
			float clampResult7_g6 = clamp( ( ( temp_output_11_0_g6 - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( temp_output_11_0_g6 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance411 = ( 1.0 - clampResult7_g6 );
			o.Alpha = ( 1.0 - FogDistance411 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
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
-912;193;1048;732;5105.528;-2327.721;10.19654;True;False
Node;AmplifyShaderEditor.CommentaryNode;223;-295.633,14.36626;Inherit;False;1498.574;364.1545;Water Depth;7;215;217;218;216;219;220;222;Water Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;215;-245.633,264.0587;Inherit;False;Reconstruct World Position From Depth;0;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;262;-275.8737,1578.427;Inherit;False;1894.374;713.6802; Surface Normal;20;253;251;252;249;247;256;258;259;257;248;260;255;250;246;261;245;244;254;276;278;Surface Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;217;109.2573,257.9084;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;277.0713,262.5208;Inherit;False;PositionFormDepth;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;244;-259.748,1635.427;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;278;-119.6764,1799.222;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;219;563.4895,256.2407;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;216;519.7551,64.36636;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;245;-83.548,1637.527;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;61.32362,1673.222;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;251;-202.8736,2062.539;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-166.8737,2138.539;Inherit;False;Property;_TimeSpeed;TimeSpeed;18;0;Create;True;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;249;-225.8737,1912.539;Inherit;False;Property;_NormalSpeed;NormalSpeed;12;0;Create;True;0;0;False;0;False;0,0;-4,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;247;53.55202,1797.927;Inherit;False;Property;_NormalScale;NormalScale;11;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;394;-252.4193,5872.397;Inherit;False;2615.178;1885.723;Foam Color;37;389;396;374;395;386;391;384;393;385;392;383;388;377;367;379;363;382;378;370;368;366;365;369;362;414;364;361;360;358;359;415;416;417;418;419;421;422;Foam Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;220;749.2384,166.8571;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;246;251.952,1703.227;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;414;-234.7977,6833.247;Inherit;False;Property;_NoiseSpeed;Noise Speed;31;0;Create;True;0;0;False;0;False;1;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;364;-241.4774,6922.198;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;268.6466,1970.108;Inherit;False;Constant;_Float1;Float1;10;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;54.12639,1971.54;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;978.9417,188.0061;Inherit;False;WaterDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;262.6466,2176.107;Inherit;False;Constant;_Float2;Float2;11;0;Create;True;0;0;False;0;False;1;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;480.6468,2114.107;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;366;-5.738538,6871.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;476.6468,1951.108;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;359;-194.0279,6362.452;Inherit;False;Property;_FoamRange;Foam Range;29;0;Create;True;0;0;False;0;False;0;2.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;358;-202.4193,6241.613;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;677.2573,2052.337;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;248;463.4604,1747.691;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;419;88.96753,7149.407;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;360;33.97223,6278.452;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;378;259.0854,6885.646;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;418;264.5443,7382.462;Inherit;False;Property;_FoamNoiseSize2;FoamNoise Size2;36;0;Create;True;0;0;False;0;False;0,0;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;416;257.4451,7250.97;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;361;187.972,6290.452;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;253;679.049,1737.228;Inherit;True;Property;_NormalMap;NormalMap;10;0;Create;True;0;0;False;0;False;-1;None;2aab2b9fb283e6646ad7f1df2f799dc1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;193;-266.5414,8002.799;Inherit;False;2542.907;761.6924;Wave Vertex Animation ;21;203;196;189;200;194;192;199;191;198;197;188;202;190;204;207;206;208;209;210;211;212;Wave Vertex Animation ;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;255;842.1161,2009.69;Inherit;True;Global;NormalMap;NormalMap;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Instance;253;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;382;266.1846,7017.138;Inherit;False;Property;_FoamNoiseSize;FoamNoise Size;35;0;Create;True;0;0;False;0;False;0,0;80,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BlendNormalsNode;261;1164.734,1933.858;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;369;232.3647,6582.167;Inherit;False;Property;_FoamFrequency;Foam Frequency;32;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;379;501.0858,6909.646;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;362;354.9722,6311.452;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;499.4453,7274.97;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;365;78.28913,6714.943;Inherit;False;Property;_FoamSpeed;Foam Speed;30;0;Create;True;0;0;False;0;False;1;3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;190;-188.1175,8382.523;Inherit;False;Property;_WaveASpeedXYSteepnesswavelength;WaveA(SpeedXY,Steepness,wavelength);39;0;Create;True;0;0;False;0;False;1,1,2,50;0,1,5,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;189;-146.118,8084.524;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;370;257.0082,6720.85;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;496.1612,6573.397;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;188;213.0561,8281.253;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;254;1394.501,1935.122;Inherit;False;SurfaceNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;233;-284.1874,451.121;Inherit;False;1834.943;988.1354;Water Color;17;240;241;234;236;238;237;232;224;231;225;239;230;228;229;227;226;294;Water Color;0,0.6139736,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;289;-265.8185,3302.814;Inherit;False;1529.173;642.4973;UnderWater Color;11;288;331;330;281;286;287;285;284;282;283;332;UnderWater Color;1,0.5430125,0,1;0;0
Node;AmplifyShaderEditor.Vector4Node;202;225.1112,8454.948;Inherit;False;Property;_WaveB;WaveB;40;0;Create;True;0;0;False;0;False;1,1,2,50;0.5,1,3,20;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;415;677.5104,7235.747;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;377;671.8861,6891.463;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;286;-206.8185,3740.201;Inherit;False;Property;_UnderWaterDistort;UnderWaterDistort;17;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-234.1875,903.7088;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-215.8184,3611.201;Inherit;False;254;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;196;549.0386,8281.34;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.RangedFloatNode;287;-157.8185,3827.201;Inherit;False;Constant;_Float4;Float 4;15;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;204;643.9191,8471.736;Inherit;False;Property;_WaveC;WaveC;41;0;Create;True;0;0;False;0;False;1,1,2,50;-20,-20,1,10;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;279;-273.9378,2413.428;Inherit;False;1787.203;800.783;Reflect Color;16;272;263;266;265;269;264;271;267;280;268;270;295;296;297;298;299;Reflect Color;0,0.1204236,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;363;656.0904,6595.584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;983.8406,7053.849;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;282;-124.5738,3355.503;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;229;-73.18737,1054.709;Inherit;False;Property;_DeepRange;DeepRange;7;0;Create;True;0;0;False;0;False;1;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;203;889.371,8256.53;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.RangedFloatNode;270;-208.0243,2740.764;Inherit;False;Property;_ReflectDistort;ReflectDistort;16;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;280;-186.511,2823.656;Inherit;False;Constant;_Float3;Float 3;15;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;422;1236.587,7067.936;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;367;803.3106,6614.418;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;285;74.18135,3680.201;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;227;-33.18733,931.7088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;-223.9377,2660.203;Inherit;False;254;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;283;304.681,3555.532;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;345;-253.9496,4937.894;Inherit;False;2178.411;672.0933;Water Shore;18;339;344;343;338;342;337;340;336;341;335;334;333;349;350;351;352;353;354;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;267;-6.633277,2664.421;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;207;1174.049,8317.267;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;2.889302,2757.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;1144.256,8073.758;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;228;95.8127,958.7088;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;264;-66.05795,2463.428;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;383;1044.193,6684.025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;388;542.7315,5922.397;Inherit;False;904.8021;338.9004;Foam Mask;4;373;372;371;387;Foam Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.ExpOpNode;230;218.8584,956.8228;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;214.9757,2718.764;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;333;-203.9496,4987.894;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;385;1147.706,6794.566;Inherit;False;Property;_FoamDissolve;FoamDissolve;34;0;Create;True;0;0;False;0;False;0;1.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;206;1392.049,8285.268;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;373;679.5933,5972.397;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;372;592.7315,6145.298;Inherit;False;Property;_FoamBlend;Foam Blend;37;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;265;203.0616,2555.406;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;297;332.8408,3036.239;Inherit;False;Property;_ReflectPower;Reflect Power;15;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;991.7711,6452.836;Inherit;False;Property;_FoamWidth;Foam Width;33;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;296;333.8408,2947.239;Inherit;False;Property;_ReflectIntensity;Reflect Intensity;14;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;393;1220.886,6585.955;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;281;483.0916,3540.469;Inherit;False;Global;_GrabScreen0;Grab Screen 0;15;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;391;1216.059,6335.831;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;295;588.6945,2859.89;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;208;1564.049,8293.268;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;332;679.9974,3561.691;Inherit;False;SceneColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;266;383.942,2641.428;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;384;1346.237,6697.584;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;334;-16.14925,5012.727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;224;86.09047,501.1209;Inherit;False;Property;_DeepColor;DeepColor;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0.4978522,0.972549,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;335;-45.14925,5120.727;Inherit;False;Property;_ShoreRange;Shore Range;25;0;Create;True;0;0;False;0;False;1;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;239;337.997,1274.051;Inherit;False;Property;_FresnelPower;FresnelPower;9;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;231;324.8585,957.8228;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;225;87.09047,693.1208;Inherit;False;Property;_ShallowColor;ShallowColor;5;0;Create;True;0;0;False;0;False;0,0,0,0;0,0.9431779,1,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;371;1028.035,6070.28;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;238;557.9724,1164.565;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;341;55.18487,5374.089;Inherit;False;Property;_ShoreColor;ShoreColor;24;0;Create;True;0;0;False;0;False;1,1,1,0;1,0.9606918,0.9292453,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;237;586.8942,954.5559;Inherit;False;Property;_FresnelColor;FresnelColor;8;0;Create;True;0;0;False;0;False;0,0,0,0;0.3607843,0.6039216,0.9921569,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;211;1604.111,8377.38;Inherit;False;Property;_WaveColor;WaveColor;38;0;Create;True;0;0;False;0;False;0,0,0,0;0.1270915,0.1838478,0.2264151,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;386;1522.055,6468.294;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;263;650.2175,2521.863;Inherit;True;Property;_ReflectionTex;ReflectionTex;13;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;340;65.67393,5258.6;Inherit;False;332;SceneColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;387;1268.533,6088.345;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;608.2343,716.2168;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;209;1742.341,8234.713;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;336;157.8507,5047.727;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;298;873.2429,2855.517;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;236;857.3265,848.5934;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;1910.752,8303.713;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;1060.083,2618.521;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;395;1693.684,6447.207;Inherit;False;Property;_FoamColor;FoamColor;28;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;338.1849,5288.089;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ExpOpNode;337;318.8507,5051.727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;1741.349,6285.588;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;2066.678,8224.138;Inherit;False;WaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;343;490.1849,5280.089;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;338;480.8508,5057.727;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;1048.997,850.7395;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;350;582.8604,5175.859;Inherit;False;Property;_ShoreEdgeWidth;Shore Edge Width;26;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;1221.174,2538.547;Inherit;False;ReflectColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;396;1921.877,6352.852;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;403;2882.175,1493.654;Inherit;False;212;WaveColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;351;883.8604,5204.859;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;344;673.1849,5284.089;Inherit;False;ShoreColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;2885.889,1567.913;Inherit;False;272;ReflectColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;2880.427,1405.823;Inherit;False;234;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;404;1859.111,51.58124;Inherit;False;1146.603;531.9068;Fog Distance;7;411;410;409;408;407;406;405;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;339;676.8507,5050.727;Inherit;False;WaterShore;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;389;2067.972,6355.937;Inherit;False;FoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;3463.439,2020.973;Inherit;False;389;FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;406;1902.618,279.1322;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;347;3242.369,1790.858;Inherit;False;344;ShoreColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;3118.017,1442.368;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;349;1063.86,5077.859;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;405;1904.829,106.1809;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;348;3260.369,1878.858;Inherit;False;339;WaterShore;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;1064.86,5248.859;Inherit;False;Property;_ShoreEdgeIntensity;Shore Edge Intensity;27;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;401;3683.206,1924.257;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;407;2220.885,445.4521;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;3;0;Create;True;0;0;False;0;False;700;85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;409;2221.153,342.4093;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;2;0;Create;True;0;0;False;0;False;0;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;346;3573.349,1737.088;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;408;2240.291,231.2066;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;1337.86,5075.859;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;410;2499.334,248.6297;Inherit;False;Fog Linear;-1;;6;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;398;3709.125,2021.92;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;354;1523.412,5079.257;Inherit;False;ShoreEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;400;3861.287,1833.146;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;356;4247.177,1878.613;Inherit;False;354;ShoreEdge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;399;4084.852,1753.247;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformPositionNode;192;1376.933,8074.052;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;411;2805.502,322.662;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;1680.413,8084.128;Inherit;False;WaveVertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;316;-268.1855,4045.413;Inherit;False;1991.84;814.0728;Caustics Color;24;323;322;320;319;321;318;312;315;324;313;329;314;325;328;305;306;327;303;311;310;308;302;304;301;Caustics Color;1,0,0.9896069,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;412;4232.764,1966.121;Inherit;False;411;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;355;4433.358,1762.438;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;198;1423.579,8563.131;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;199;1608.579,8562.13;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;402;4452.445,2090.543;Inherit;False;194;WaveVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;413;4487.689,1939.469;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;357;4593.946,1753.768;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;1873.579,8558.13;Inherit;False;WaveVertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMinOpNode;329;1001.468,4277.502;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;2891.963,1760.302;Inherit;False;241;WaterOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;2887.114,1642.444;Inherit;False;288;UnderWaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;312;673.8708,4208.549;Inherit;True;Property;_CausticsTex;CausticsTex;19;0;Create;True;0;0;False;0;False;-1;None;72417ee6f632e4e4aabc8c81143957bf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;320;747.7798,4691.207;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;325;672.845,4454.505;Inherit;True;Property;_TextureSample0;Texture Sample 0;19;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;312;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;308;-36.28928,4451.285;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;240;1036.123,970.8198;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;291;3256.901,1647.122;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;318;391.7907,4642.424;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;304;0.9738665,4195.776;Inherit;False;Property;_CausticsScale;Caustics Scale;20;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;303;210.3141,4181.259;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;196.2039,4399.848;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ExpOpNode;322;863.9638,4698.157;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;313;1206.635,4310.739;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NegateNode;327;390.491,4358.946;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;288;1049.843,3553.064;Inherit;False;UnderWaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;311;-114.2406,4328.118;Inherit;False;Property;_CausticsSpeed;Caustics Speed;21;0;Create;True;0;0;False;0;False;-8,0;-8,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;1348.882,4412.738;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;241;1327.843,973.2048;Inherit;False;WaterOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;331;902.0977,3625.788;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;314;985.8496,4407.782;Inherit;False;Property;_CausticsIntensity;Caustics Intensity;22;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;294;1182.103,1040.275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;197;1224.579,8529.13;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;323;987.9637,4698.157;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;1515.074,4405.292;Inherit;False;CausticsColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-218.1856,4095.413;Inherit;False;218;PositionFormDepth;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;302;15.31411,4100.259;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;319;580.3332,4662.202;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;328;527.5989,4426.354;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-10.28927,4533.285;Inherit;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;305;387.7598,4208.871;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;321;538.0593,4751.953;Inherit;False;Property;_CausticsRange;Caustics Range;23;0;Create;True;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;575.8408,3726.028;Inherit;False;315;CausticsColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4785.291,1647.043;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Toon_Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;4;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;217;0;215;0
WireConnection;218;0;217;0
WireConnection;219;0;218;0
WireConnection;245;0;244;0
WireConnection;276;0;245;0
WireConnection;276;1;278;0
WireConnection;220;0;216;2
WireConnection;220;1;219;0
WireConnection;246;0;276;0
WireConnection;246;1;247;0
WireConnection;250;0;249;0
WireConnection;250;1;251;0
WireConnection;250;2;252;0
WireConnection;222;0;220;0
WireConnection;257;0;250;0
WireConnection;257;1;259;0
WireConnection;366;0;414;0
WireConnection;366;1;364;0
WireConnection;256;0;246;0
WireConnection;256;1;258;0
WireConnection;260;0;256;0
WireConnection;260;1;257;0
WireConnection;248;0;246;0
WireConnection;248;1;250;0
WireConnection;419;0;366;0
WireConnection;360;0;358;0
WireConnection;360;1;359;0
WireConnection;378;1;366;0
WireConnection;416;1;419;0
WireConnection;361;0;360;0
WireConnection;253;1;248;0
WireConnection;255;1;260;0
WireConnection;261;0;253;0
WireConnection;261;1;255;0
WireConnection;379;0;378;0
WireConnection;379;1;382;0
WireConnection;362;0;361;0
WireConnection;417;0;416;0
WireConnection;417;1;418;0
WireConnection;370;0;365;0
WireConnection;368;0;362;0
WireConnection;368;1;369;0
WireConnection;188;0;189;0
WireConnection;188;3;190;0
WireConnection;254;0;261;0
WireConnection;415;0;417;0
WireConnection;377;0;379;0
WireConnection;196;0;189;0
WireConnection;196;1;188;2
WireConnection;196;2;188;3
WireConnection;196;3;202;0
WireConnection;363;0;368;0
WireConnection;363;1;370;0
WireConnection;421;0;377;0
WireConnection;421;1;415;0
WireConnection;203;0;189;0
WireConnection;203;1;196;2
WireConnection;203;2;196;3
WireConnection;203;3;204;0
WireConnection;422;0;421;0
WireConnection;367;0;363;0
WireConnection;285;0;284;0
WireConnection;285;1;286;0
WireConnection;285;2;287;0
WireConnection;227;0;226;0
WireConnection;283;0;282;0
WireConnection;283;1;285;0
WireConnection;267;0;268;0
WireConnection;271;0;270;0
WireConnection;271;1;280;0
WireConnection;191;0;189;0
WireConnection;191;1;188;0
WireConnection;191;2;196;0
WireConnection;191;3;203;0
WireConnection;228;0;227;0
WireConnection;228;1;229;0
WireConnection;383;0;367;0
WireConnection;383;1;422;0
WireConnection;230;0;228;0
WireConnection;269;0;267;0
WireConnection;269;1;271;0
WireConnection;206;0;191;0
WireConnection;206;1;207;0
WireConnection;373;0;361;0
WireConnection;265;0;264;0
WireConnection;393;0;362;0
WireConnection;393;1;383;0
WireConnection;281;0;283;0
WireConnection;391;0;362;0
WireConnection;391;1;392;0
WireConnection;295;2;296;0
WireConnection;295;3;297;0
WireConnection;208;0;206;0
WireConnection;332;0;281;0
WireConnection;266;0;265;0
WireConnection;266;1;269;0
WireConnection;384;0;393;0
WireConnection;384;1;385;0
WireConnection;334;0;333;0
WireConnection;231;0;230;0
WireConnection;371;0;373;0
WireConnection;371;1;372;0
WireConnection;238;3;239;0
WireConnection;386;0;391;0
WireConnection;386;1;384;0
WireConnection;263;1;266;0
WireConnection;387;0;371;0
WireConnection;232;0;224;0
WireConnection;232;1;225;0
WireConnection;232;2;231;0
WireConnection;209;0;208;0
WireConnection;336;0;334;0
WireConnection;336;1;335;0
WireConnection;298;0;295;0
WireConnection;236;0;232;0
WireConnection;236;1;237;0
WireConnection;236;2;238;0
WireConnection;210;0;209;0
WireConnection;210;1;211;0
WireConnection;299;0;263;0
WireConnection;299;1;298;0
WireConnection;342;0;340;0
WireConnection;342;1;341;0
WireConnection;337;0;336;0
WireConnection;374;0;387;0
WireConnection;374;1;386;0
WireConnection;212;0;210;0
WireConnection;343;0;342;0
WireConnection;338;0;337;0
WireConnection;234;0;236;0
WireConnection;272;0;299;0
WireConnection;396;0;374;0
WireConnection;396;1;395;0
WireConnection;351;0;350;0
WireConnection;344;0;343;0
WireConnection;339;0;338;0
WireConnection;389;0;396;0
WireConnection;300;0;273;0
WireConnection;300;1;403;0
WireConnection;300;2;235;0
WireConnection;349;0;339;0
WireConnection;349;1;351;0
WireConnection;401;0;397;0
WireConnection;346;0;300;0
WireConnection;346;1;347;0
WireConnection;346;2;348;0
WireConnection;408;0;405;0
WireConnection;408;1;406;0
WireConnection;352;0;349;0
WireConnection;352;1;353;0
WireConnection;410;13;408;0
WireConnection;410;12;409;0
WireConnection;410;11;407;0
WireConnection;398;0;397;0
WireConnection;354;0;352;0
WireConnection;400;0;346;0
WireConnection;400;1;401;0
WireConnection;399;0;346;0
WireConnection;399;1;400;0
WireConnection;399;2;398;0
WireConnection;192;0;191;0
WireConnection;411;0;410;0
WireConnection;194;0;192;0
WireConnection;355;0;399;0
WireConnection;355;1;356;0
WireConnection;198;0;197;0
WireConnection;199;0;198;0
WireConnection;413;0;412;0
WireConnection;357;0;355;0
WireConnection;200;0;199;0
WireConnection;329;0;312;0
WireConnection;329;1;325;0
WireConnection;312;1;305;0
WireConnection;320;0;319;0
WireConnection;320;1;321;0
WireConnection;325;1;328;0
WireConnection;240;0;236;0
WireConnection;291;1;290;0
WireConnection;291;2;292;0
WireConnection;303;0;302;0
WireConnection;303;1;304;0
WireConnection;306;0;311;0
WireConnection;306;1;308;0
WireConnection;306;2;310;0
WireConnection;322;0;320;0
WireConnection;313;0;329;0
WireConnection;313;1;314;0
WireConnection;327;0;303;0
WireConnection;288;0;331;0
WireConnection;324;0;313;0
WireConnection;324;1;323;0
WireConnection;241;0;294;0
WireConnection;331;0;332;0
WireConnection;331;1;330;0
WireConnection;294;0;240;0
WireConnection;197;0;203;3
WireConnection;197;1;203;2
WireConnection;323;0;322;0
WireConnection;315;0;324;0
WireConnection;302;0;301;0
WireConnection;319;0;318;0
WireConnection;328;0;327;0
WireConnection;328;1;306;0
WireConnection;305;0;303;0
WireConnection;305;1;306;0
WireConnection;0;2;357;0
WireConnection;0;9;413;0
WireConnection;0;11;402;0
ASEEND*/
//CHKSM=1406C63855A8D301C1133EED96365EC62CDC4D03