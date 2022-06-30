// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Fog/CS19GlobalFog"
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
		_FogNoiseSpeed("Fog Noise Speed", Vector) = (0,0,0,0)
		_FogNoiseScale("Fog Noise Scale", Vector) = (1,1,1,0)
		_FogNoiseStart("Fog Noise Start", Float) = 0
		_FogNoiseEnd("Fog Noise End", Float) = 0
		_FogNoiseIntensity("Fog Noise Intensity", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
		};

		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float _SunFogRange;
		uniform float _SunFogIntensity;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _FogHeightEnd;
		uniform float _FogHeightStart;
		uniform float3 _FogNoiseScale;
		uniform float3 _FogNoiseSpeed;
		uniform float _FogNoiseEnd;
		uniform float _FogNoiseStart;
		uniform float _FogNoiseIntensity;
		uniform float _FogIntensity;


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
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
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult41 = dot( normalizeResult100 , float4( ase_worldlightDir , 0.0 ) );
			float clampResult47 = clamp( pow( (dotResult41*0.5 + 0.5) , _SunFogRange ) , 0.0 , 1.0 );
			float SunFog52 = ( clampResult47 * _SunFogIntensity );
			float4 lerpResult55 = lerp( _FogColor , _SunFogColor , SunFog52);
			o.Emission = lerpResult55.rgb;
			float temp_output_11_0_g13 = _FogDistanceEnd;
			float clampResult7_g13 = clamp( ( ( temp_output_11_0_g13 - distance( WorldPosFormDepth92 , float4( _WorldSpaceCameraPos , 0.0 ) ) ) / ( temp_output_11_0_g13 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance66 = ( 1.0 - clampResult7_g13 );
			float temp_output_11_0_g12 = _FogHeightEnd;
			float clampResult7_g12 = clamp( ( ( temp_output_11_0_g12 - (WorldPosFormDepth92).y ) / ( temp_output_11_0_g12 - _FogHeightStart ) ) , 0.0 , 1.0 );
			float FogHight31 = ( 1.0 - ( 1.0 - clampResult7_g12 ) );
			float simplePerlin3D110 = snoise( ( ( (WorldPosFormDepth92).xyz / _FogNoiseScale ) + ( _FogNoiseSpeed * _Time.y ) ) );
			simplePerlin3D110 = simplePerlin3D110*0.5 + 0.5;
			float temp_output_11_0_g11 = _FogNoiseEnd;
			float clampResult7_g11 = clamp( ( ( temp_output_11_0_g11 - distance( WorldPosFormDepth92 , float4( _WorldSpaceCameraPos , 0.0 ) ) ) / ( temp_output_11_0_g11 - _FogNoiseStart ) ) , 0.0 , 1.0 );
			float lerpResult113 = lerp( 1.0 , (simplePerlin3D110*0.5 + 0.5) , ( ( 1.0 - clampResult7_g11 ) * _FogNoiseIntensity ));
			float FogNoise124 = lerpResult113;
			float clampResult35 = clamp( ( ( FogDistance66 * FogHight31 * FogNoise124 ) * _FogIntensity ) , 0.0 , 1.0 );
			o.Alpha = clampResult35;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
				float3 worldPos : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
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
224;1126;1285;741;3377.451;-2263.756;1;True;False
Node;AmplifyShaderEditor.FunctionNode;91;-4294.293,764.1486;Inherit;False;Reconstruct World Position From Depth;1;;7;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3931.516,766.3242;Inherit;False;WorldPosFormDepth;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;125;-3142.339,2294.751;Inherit;False;2427.145;749.5061;FogNoise;21;113;116;117;118;120;121;122;114;123;119;106;107;111;108;109;104;105;102;101;110;124;FogNoise;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-3168.627,1529.742;Inherit;False;1938.36;561.4897;Sun Fog;13;99;98;96;52;48;47;49;44;43;45;41;42;100;Sun Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-3092.339,2399.62;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-3119.07,1580.222;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;99;-3126.721,1689.222;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;104;-2858.763,2520.411;Inherit;False;Property;_FogNoiseScale;Fog Noise Scale;13;0;Create;True;0;0;False;0;False;1,1,1;50,50,50;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;109;-2794.013,2933.257;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;107;-2754.013,2708.257;Inherit;False;Property;_FogNoiseSpeed;Fog Noise Speed;12;0;Create;True;0;0;False;0;False;0,0,0;-0.5,0.5,0.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;102;-2814.063,2405.411;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-2532.013,2778.257;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;105;-2622.267,2456.964;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;117;-2186.479,2736.25;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2167.479,2622.25;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;98;-2845.517,1593.732;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-2344.641,2470.553;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2958.047,771.8667;Inherit;False;1346.057;508.7882;Fog Hight;6;31;30;29;28;33;95;Fog Hight;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;42;-2797.887,1824.845;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;59;-2979.503,100.2627;Inherit;False;1346.057;508.7882;Fog Distance;7;66;65;64;63;62;61;93;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-1863.679,2869.819;Inherit;False;Property;_FogNoiseEnd;Fog Noise End;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;100;-2670.384,1617.743;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceOpNode;118;-1861.478,2671.25;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-2926.134,880.2278;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1866.679,2781.819;Inherit;False;Property;_FogNoiseStart;Fog Noise Start;14;0;Create;True;0;0;False;0;False;0;150;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;110;-2134.328,2459.127;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1575.137,2828.221;Inherit;False;Property;_FogNoiseIntensity;Fog Noise Intensity;16;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;61;-2929.503,356.2144;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-2646.937,1023.047;Inherit;False;Property;_FogHeightStart;Fog Height Start;7;0;Create;True;0;0;False;0;False;0;-100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;95;-2582.015,891.7161;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2647.205,1126.09;Inherit;False;Property;_FogHeightEnd;Fog Height End;8;0;Create;True;0;0;False;0;False;700;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-2924.148,236.6291;Inherit;False;92;WorldPosFormDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;41;-2486.887,1697.845;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;119;-1580.679,2679.819;Inherit;False;Fog Linear;-1;;11;228e72b1c5e4eae4bb943da00a676436;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;30;-2368.755,929.2667;Inherit;False;Fog Linear;-1;;12;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;111;-1851.906,2449.141;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;43;-2320.887,1700.845;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2442.063,472.0512;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;6;0;Create;True;0;0;False;0;False;700;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;63;-2585.831,275.2888;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2441.795,369.0086;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;5;0;Create;True;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2336.887,1859.845;Inherit;False;Property;_SunFogRange;Sun Fog Range;10;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1751.778,2344.751;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-1320.837,2657.623;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-2080.887,1785.845;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;113;-1120.254,2464.114;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;65;-2163.614,275.2289;Inherit;False;Fog Linear;-1;;13;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-2087.481,930.5027;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1841.99,961.8648;Inherit;False;FogHight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;47;-1902.886,1810.845;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1945.569,1966.198;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;11;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-1073.047,39.22899;Inherit;False;922.4023;873.5225;Fog Combine;9;32;54;53;17;35;55;57;58;68;Fog Combine;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-1857.446,349.2613;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-939.1942,2461.51;Inherit;False;FogNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1017.482,813.761;Inherit;False;124;FogNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1647.669,1888.599;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1015.469,695.2589;Inherit;False;31;FogHight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1022.051,586.5389;Inherit;False;66;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-796.1034,833.5921;Inherit;False;Property;_FogIntensity;Fog Intensity;4;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-723.0508,657.5389;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1432.321,1939.101;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-1008.872,89.22899;Inherit;False;Property;_FogColor;FogColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.3971608,0.7157634,0.8018868,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-931.7707,468.3118;Inherit;False;52;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;-1023.047,282.3969;Inherit;False;Property;_SunFogColor;Sun Fog Color;9;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.5942623,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-507.0154,728.9041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-680.7711,359.912;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;35;-341.3781,705.7985;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;59.32795,284.5863;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Fog/GlobalFog;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;0;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;92;0;91;0
WireConnection;102;0;101;0
WireConnection;108;0;107;0
WireConnection;108;1;109;0
WireConnection;105;0;102;0
WireConnection;105;1;104;0
WireConnection;98;0;96;0
WireConnection;98;1;99;0
WireConnection;106;0;105;0
WireConnection;106;1;108;0
WireConnection;100;0;98;0
WireConnection;118;0;116;0
WireConnection;118;1;117;0
WireConnection;110;0;106;0
WireConnection;95;0;94;0
WireConnection;41;0;100;0
WireConnection;41;1;42;0
WireConnection;119;13;118;0
WireConnection;119;12;120;0
WireConnection;119;11;121;0
WireConnection;30;13;95;0
WireConnection;30;12;28;0
WireConnection;30;11;29;0
WireConnection;111;0;110;0
WireConnection;43;0;41;0
WireConnection;63;0;93;0
WireConnection;63;1;61;0
WireConnection;122;0;119;0
WireConnection;122;1;123;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;113;0;114;0
WireConnection;113;1;111;0
WireConnection;113;2;122;0
WireConnection;65;13;63;0
WireConnection;65;12;64;0
WireConnection;65;11;62;0
WireConnection;33;0;30;0
WireConnection;31;0;33;0
WireConnection;47;0;44;0
WireConnection;66;0;65;0
WireConnection;124;0;113;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;68;0;67;0
WireConnection;68;1;32;0
WireConnection;68;2;126;0
WireConnection;52;0;48;0
WireConnection;58;0;68;0
WireConnection;58;1;57;0
WireConnection;55;0;17;0
WireConnection;55;1;53;0
WireConnection;55;2;54;0
WireConnection;35;0;58;0
WireConnection;0;2;55;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=57546D8E10D5B37FFCDE66F3B3C7E81CAE8663BA