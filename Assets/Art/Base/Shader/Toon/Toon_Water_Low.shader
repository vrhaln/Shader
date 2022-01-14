// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Toon_Water_Low"
{
	Properties
	{
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 700
		_Exp("Exp", Float) = 0
		_ShallowColor("ShallowColor", Color) = (0,0,0,0)
		_DeepColor("DeepColor", Color) = (0,0,0,0)
		_DeepRange("DeepRange", Float) = 1
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_FresnelPower("FresnelPower", Float) = 1
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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float4 _DeepColor;
		uniform float4 _ShallowColor;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _Exp;
		uniform float _DeepRange;
		uniform float4 _FresnelColor;
		uniform float _FresnelPower;
		uniform float4 _ShoreColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
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


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_11_0_g6 = _FogDistanceEnd;
			float3 ase_worldPos = i.worldPos;
			float clampResult7_g6 = clamp( ( ( temp_output_11_0_g6 - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( temp_output_11_0_g6 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance411 = ( 1.0 - clampResult7_g6 );
			float clampResult231 = clamp( exp( ( -pow( FogDistance411 , _Exp ) / _DeepRange ) ) , 0.0 , 1.0 );
			float4 lerpResult232 = lerp( _DeepColor , _ShallowColor , clampResult231);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV238 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode238 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV238 , 0.0001 ), _FresnelPower ) );
			float4 lerpResult236 = lerp( lerpResult232 , _FresnelColor , fresnelNode238);
			float4 WaterColor234 = lerpResult236;
			float3 ShoreColor344 = (_ShoreColor).rgb;
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
			float clampResult338 = clamp( exp( ( -WaterDepth222 / _ShoreRange ) ) , 0.0 , 1.0 );
			float WaterShore339 = clampResult338;
			float4 lerpResult346 = lerp( WaterColor234 , float4( ShoreColor344 , 0.0 ) , WaterShore339);
			float clampResult361 = clamp( ( WaterDepth222 / _FoamRange ) , 0.0 , 1.0 );
			float smoothstepResult371 = smoothstep( _FoamBlend , 1.0 , ( clampResult361 + 0.1 ));
			float temp_output_362_0 = ( 1.0 - clampResult361 );
			float temp_output_366_0 = ( _NoiseSpeed * _Time.y );
			float2 temp_cast_4 = (temp_output_366_0).xx;
			float2 uv_TexCoord378 = i.uv_texcoord + temp_cast_4;
			float simplePerlin2D377 = snoise( ( uv_TexCoord378 * _FoamNoiseSize ) );
			simplePerlin2D377 = simplePerlin2D377*0.5 + 0.5;
			float2 temp_cast_5 = (-temp_output_366_0).xx;
			float2 uv_TexCoord416 = i.uv_texcoord + temp_cast_5;
			float simplePerlin3D415 = snoise( float3( ( uv_TexCoord416 * _FoamNoiseSize2 ) ,  0.0 ) );
			simplePerlin3D415 = simplePerlin3D415*0.5 + 0.5;
			float4 FoamColor389 = ( ( ( 1.0 - smoothstepResult371 ) * step( ( temp_output_362_0 - _FoamWidth ) , ( ( temp_output_362_0 + ( sin( ( ( temp_output_362_0 * _FoamFrequency ) + -_FoamSpeed ) ) + ( 1.0 - ( simplePerlin2D377 * simplePerlin3D415 ) ) ) ) - _FoamDissolve ) ) ) * _FoamColor );
			float4 lerpResult399 = lerp( lerpResult346 , ( lerpResult346 + float4( (FoamColor389).rgb , 0.0 ) ) , (FoamColor389).a);
			float smoothstepResult349 = smoothstep( ( 1.0 - _ShoreEdgeWidth ) , 1.1 , WaterShore339);
			float ShoreEdge354 = ( smoothstepResult349 * _ShoreEdgeIntensity );
			o.Emission = max( ( lerpResult399 + ShoreEdge354 ) , float4( 0,0,0,0 ) ).rgb;
			o.Alpha = ( 1.0 - FogDistance411 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
-1331;90;1048;732;4065.192;1334.908;9.794585;True;False
Node;AmplifyShaderEditor.CommentaryNode;223;-279.079,-101.5117;Inherit;False;1498.574;364.1545;Water Depth;7;215;217;218;216;219;220;222;Water Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;215;-229.079,148.1807;Inherit;False;Reconstruct World Position From Depth;0;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;217;125.8113,142.0304;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;293.6253,146.6428;Inherit;False;PositionFormDepth;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;219;580.0435,140.3627;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;216;536.3091,-51.51162;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;220;765.7924,50.97911;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;394;-299.6473,2652.521;Inherit;False;2615.178;1885.723;Foam Color;37;389;396;374;395;386;391;384;393;385;392;383;388;377;367;379;363;382;378;370;368;366;365;369;362;414;364;361;360;358;359;415;416;417;418;419;421;422;Foam Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;364;-288.7055,3702.322;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;995.4957,72.12811;Inherit;False;WaterDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;414;-282.0258,3613.371;Inherit;False;Property;_NoiseSpeed;Noise Speed;18;0;Create;True;0;0;False;0;False;1;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;359;-241.2559,3142.576;Inherit;False;Property;_FoamRange;Foam Range;16;0;Create;True;0;0;False;0;False;0;2.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;366;-52.96658,3651.504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;358;-249.6474,3021.736;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;404;1859.111,51.58124;Inherit;False;1146.603;531.9068;Fog Distance;7;411;410;409;408;407;406;405;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;406;1902.618,279.1322;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;405;1904.829,106.1809;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;360;-13.25581,3058.576;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;419;41.73949,3929.531;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;407;2220.885,445.4521;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;3;0;Create;True;0;0;False;0;False;700;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;418;217.3163,4162.585;Inherit;False;Property;_FoamNoiseSize2;FoamNoise Size2;23;0;Create;True;0;0;False;0;False;0,0;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;378;211.8573,3665.77;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;416;210.2171,4031.093;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;382;218.9566,3797.262;Inherit;False;Property;_FoamNoiseSize;FoamNoise Size;22;0;Create;True;0;0;False;0;False;0,0;80,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;361;140.744,3070.576;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;409;2221.153,342.4093;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;408;2240.291,231.2066;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;410;2499.334,248.6297;Inherit;False;Fog Linear;-1;;6;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;362;307.7441,3091.576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;379;453.8577,3689.77;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;369;185.1367,3362.29;Inherit;False;Property;_FoamFrequency;Foam Frequency;19;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;365;31.06109,3495.067;Inherit;False;Property;_FoamSpeed;Foam Speed;17;0;Create;True;0;0;False;0;False;1;3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;452.2173,4055.093;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;411;2805.502,322.662;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;415;630.2825,4015.87;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;377;624.6583,3671.587;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;448.9331,3353.52;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;370;209.7802,3500.974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;233;-284.1874,451.121;Inherit;False;1834.943;988.1354;Water Color;17;240;241;234;236;238;237;232;224;231;225;239;230;228;229;227;294;424;Water Color;0,0.6139736,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;936.6127,3833.973;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;425;-568.7773,1026.531;Inherit;False;Property;_Exp;Exp;4;0;Create;True;0;0;False;0;False;0;1.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;363;608.8625,3375.707;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-599.7429,830.5736;Inherit;True;411;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;422;1189.359,3848.06;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;424;-349.7775,905.5309;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0.66;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;367;756.0828,3394.541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;388;495.5035,2702.521;Inherit;False;904.8021;338.9004;Foam Mask;4;373;372;371;387;Foam Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;383;996.9651,3464.149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-123.7429,1097.574;Inherit;False;Property;_DeepRange;DeepRange;8;0;Create;True;0;0;False;0;False;1;0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;227;-107.8422,932.601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;345;-301.1776,1718.018;Inherit;False;2178.411;672.0933;Water Shore;16;339;344;343;338;337;336;341;335;334;333;349;350;351;352;353;354;Water Shore;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;333;-251.1777,1768.018;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;228;18.25718,977.5736;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;393;1173.658,3366.078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;385;1100.478,3574.69;Inherit;False;Property;_FoamDissolve;FoamDissolve;21;0;Create;True;0;0;False;0;False;0;1.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;944.5433,3232.96;Inherit;False;Property;_FoamWidth;Foam Width;20;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;373;632.3655,2752.52;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;372;545.5037,2925.421;Inherit;False;Property;_FoamBlend;Foam Blend;24;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;230;162.3618,972.5288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;391;1168.831,3115.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;384;1299.009,3477.708;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-92.37729,1900.851;Inherit;False;Property;_ShoreRange;Shore Range;12;0;Create;True;0;0;False;0;False;1;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;371;980.8072,2850.403;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;334;-63.37729,1792.851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;387;1221.305,2868.469;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;336;110.6227,1827.851;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;225;87.09047,693.1208;Inherit;False;Property;_ShallowColor;ShallowColor;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0.4785249,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;239;337.997,1254.051;Inherit;False;Property;_FresnelPower;FresnelPower;10;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;231;310.8585,965.8228;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;386;1474.827,3248.417;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;224;86.09047,501.1209;Inherit;False;Property;_DeepColor;DeepColor;7;0;Create;True;0;0;False;0;False;0,0,0,0;0.4198113,0.8879061,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;232;608.2343,716.2168;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;238;557.9724,1164.565;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;341;221.8304,2069.849;Inherit;False;Property;_ShoreColor;ShoreColor;11;0;Create;True;0;0;False;0;False;1,1,1,0;1,0.9606918,0.9292453,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ExpOpNode;337;271.6227,1831.851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;1694.121,3065.712;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;395;1646.456,3227.331;Inherit;False;Property;_FoamColor;FoamColor;15;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;237;586.8942,954.5559;Inherit;False;Property;_FresnelColor;FresnelColor;9;0;Create;True;0;0;False;0;False;0,0,0,0;0.3607843,0.6039216,0.9921569,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;343;442.9568,2060.213;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;396;1874.649,3132.976;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;350;535.6325,1955.983;Inherit;False;Property;_ShoreEdgeWidth;Shore Edge Width;13;0;Create;True;0;0;False;0;False;0;0.545;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;236;857.3265,848.5934;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;338;433.6227,1837.851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;351;836.6326,1984.983;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;389;2020.744,3136.061;Inherit;False;FoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;1048.997,850.7395;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;344;621.7461,2064.213;Inherit;False;ShoreColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;339;629.6229,1830.851;Inherit;False;WaterShore;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;1017.632,2028.983;Inherit;False;Property;_ShoreEdgeIntensity;Shore Edge Intensity;14;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;349;1016.632,1857.983;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;347;3147.369,1756.858;Inherit;True;344;ShoreColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;3463.439,2020.973;Inherit;False;389;FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;3155.857,1552.601;Inherit;True;234;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;348;3177.369,1964.858;Inherit;True;339;WaterShore;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;346;3541.282,1733.08;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;401;3683.206,1924.257;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;1290.632,1855.983;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;400;3861.287,1833.146;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;398;3709.125,2021.92;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;354;1476.184,1859.381;Inherit;False;ShoreEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;356;4204.123,1880.766;Inherit;False;354;ShoreEdge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;399;4084.852,1753.247;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;412;4232.764,1966.121;Inherit;False;411;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;355;4433.358,1762.438;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;357;4593.946,1753.768;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;294;1182.103,1040.275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;240;1036.123,970.8198;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;241;1327.843,973.2048;Inherit;False;WaterOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;413;4462.689,1944.469;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4785.291,1647.043;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Toon_Water_Low;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;5;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;217;0;215;0
WireConnection;218;0;217;0
WireConnection;219;0;218;0
WireConnection;220;0;216;2
WireConnection;220;1;219;0
WireConnection;222;0;220;0
WireConnection;366;0;414;0
WireConnection;366;1;364;0
WireConnection;360;0;358;0
WireConnection;360;1;359;0
WireConnection;419;0;366;0
WireConnection;378;1;366;0
WireConnection;416;1;419;0
WireConnection;361;0;360;0
WireConnection;408;0;405;0
WireConnection;408;1;406;0
WireConnection;410;13;408;0
WireConnection;410;12;409;0
WireConnection;410;11;407;0
WireConnection;362;0;361;0
WireConnection;379;0;378;0
WireConnection;379;1;382;0
WireConnection;417;0;416;0
WireConnection;417;1;418;0
WireConnection;411;0;410;0
WireConnection;415;0;417;0
WireConnection;377;0;379;0
WireConnection;368;0;362;0
WireConnection;368;1;369;0
WireConnection;370;0;365;0
WireConnection;421;0;377;0
WireConnection;421;1;415;0
WireConnection;363;0;368;0
WireConnection;363;1;370;0
WireConnection;422;0;421;0
WireConnection;424;0;226;0
WireConnection;424;1;425;0
WireConnection;367;0;363;0
WireConnection;383;0;367;0
WireConnection;383;1;422;0
WireConnection;227;0;424;0
WireConnection;228;0;227;0
WireConnection;228;1;229;0
WireConnection;393;0;362;0
WireConnection;393;1;383;0
WireConnection;373;0;361;0
WireConnection;230;0;228;0
WireConnection;391;0;362;0
WireConnection;391;1;392;0
WireConnection;384;0;393;0
WireConnection;384;1;385;0
WireConnection;371;0;373;0
WireConnection;371;1;372;0
WireConnection;334;0;333;0
WireConnection;387;0;371;0
WireConnection;336;0;334;0
WireConnection;336;1;335;0
WireConnection;231;0;230;0
WireConnection;386;0;391;0
WireConnection;386;1;384;0
WireConnection;232;0;224;0
WireConnection;232;1;225;0
WireConnection;232;2;231;0
WireConnection;238;3;239;0
WireConnection;337;0;336;0
WireConnection;374;0;387;0
WireConnection;374;1;386;0
WireConnection;343;0;341;0
WireConnection;396;0;374;0
WireConnection;396;1;395;0
WireConnection;236;0;232;0
WireConnection;236;1;237;0
WireConnection;236;2;238;0
WireConnection;338;0;337;0
WireConnection;351;0;350;0
WireConnection;389;0;396;0
WireConnection;234;0;236;0
WireConnection;344;0;343;0
WireConnection;339;0;338;0
WireConnection;349;0;339;0
WireConnection;349;1;351;0
WireConnection;346;0;273;0
WireConnection;346;1;347;0
WireConnection;346;2;348;0
WireConnection;401;0;397;0
WireConnection;352;0;349;0
WireConnection;352;1;353;0
WireConnection;400;0;346;0
WireConnection;400;1;401;0
WireConnection;398;0;397;0
WireConnection;354;0;352;0
WireConnection;399;0;346;0
WireConnection;399;1;400;0
WireConnection;399;2;398;0
WireConnection;355;0;399;0
WireConnection;355;1;356;0
WireConnection;357;0;355;0
WireConnection;294;0;240;0
WireConnection;240;0;236;0
WireConnection;241;0;294;0
WireConnection;413;0;412;0
WireConnection;0;2;357;0
WireConnection;0;9;413;0
ASEEND*/
//CHKSM=B05E3055B52B85A50070A933F0CE82B7FF9ED857