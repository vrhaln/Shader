// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Hexagon"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		_HitRampTex("HitRampTex", 2D) = "white" {}
		_HitSpread("HitSpread", Float) = 0
		_HitNoise("HitNoise", 2D) = "white" {}
		_HitNoiseTilling("HitNoiseTilling", Vector) = (1,1,1,0)
		_HitNoiseIntensity("HitNoiseIntensity", Float) = 0
		_HitFadeDistance("HitFadeDistance", Float) = 6
		_HitFadePower("HitFadePower", Float) = 1
		_HitVertexOffset("HitVertexOffset", Float) = 0
		_HitWaveIntensity("HitWaveIntensity", Float) = 0.2
		_EmissColor("EmissColor", Color) = (0,0,0,0)
		_EmissIntensity("EmissIntensity", Float) = 0
		_RimBias("RimBias", Float) = 0
		_RimScale("RimScale", Float) = 2
		_RimPower("RimPower", Float) = 3
		_LineHexagon("LineHexagon", 2D) = "white" {}
		_LineEmissIntensity("LineEmissIntensity", Float) = 1
		_HexagonLineIntensity("HexagonLineIntensity", Float) = 0
		_LineEmissMask("LineEmissMask", 2D) = "white" {}
		_LineMaskSpeed("LineMaskSpeed", Vector) = (0,0,0,0)
		_AuraTex("AuraTex", 2D) = "white" {}
		_AuraIntensity("AuraIntensity", Float) = 0
		_AuraTexMask("AuraTexMask", 2D) = "white" {}
		_AuraSpeed("AuraSpeed", Vector) = (0,0,0,0)
		_DissolvePoint("DissolvePoint", Vector) = (0,0,0,0)
		_DepthFade("DepthFade", Float) = 0
		_DissolveAmount("DissolveAmount", Float) = 0
		_DissolveSpread("DissolveSpread", Float) = 0
		_DissolveEdgeintensity("DissolveEdgeintensity", Float) = 1.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.5
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
			float2 uv_texcoord;
			float2 uv3_texcoord3;
			float2 uv4_texcoord4;
			float4 screenPos;
		};

		uniform float _CullMode;
		uniform float AffectorAmount;
		uniform float HitSize[20];
		uniform float4 HitPosition[20];
		uniform sampler2D _HitRampTex;
		uniform float _HitNoiseIntensity;
		uniform float _HitSpread;
		uniform float _HitFadeDistance;
		uniform float _HitFadePower;
		uniform float _HitVertexOffset;
		uniform float3 _DissolvePoint;
		uniform float _DissolveAmount;
		uniform float _DissolveSpread;
		uniform float _EmissIntensity;
		uniform float4 _EmissColor;
		uniform float _RimBias;
		uniform float _RimScale;
		uniform float _RimPower;
		uniform sampler2D _LineHexagon;
		SamplerState sampler_LineHexagon;
		uniform float _HexagonLineIntensity;
		uniform sampler2D _LineEmissMask;
		SamplerState sampler_LineEmissMask;
		uniform float2 _LineMaskSpeed;
		uniform sampler2D _HitNoise;
		uniform float3 _HitNoiseTilling;
		uniform float4 _LineEmissMask_ST;
		uniform float _LineEmissIntensity;
		uniform sampler2D _AuraTex;
		SamplerState sampler_AuraTex;
		uniform float2 _AuraSpeed;
		uniform float4 _AuraTex_ST;
		uniform float _AuraIntensity;
		uniform sampler2D _AuraTexMask;
		SamplerState sampler_AuraTexMask;
		uniform float4 _AuraTexMask_ST;
		uniform float _DissolveEdgeintensity;
		uniform float _HitWaveIntensity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade;


		float HitWaveFunction_VS105( sampler2D RampTex, float3 WorldPos, float HitNoise, float HitSpread, float HitFadeDistance, float HitFadePower )
		{
			float hit_result;
			for(int j = 0;j < AffectorAmount;j++)
			{
			float distance_mask = distance(HitPosition[j].xyz,WorldPos);
			float hit_range = -clamp((distance_mask - HitSize[j] + HitNoise) / HitSpread,-1,0);
			float2 ramp_uv = float2(hit_range,0.5);
			float hit_wave = tex2Dlod(RampTex,float4(ramp_uv,0,0)).r; 
			float hit_fade = saturate((1.0 - distance_mask / HitFadeDistance) * HitFadePower);
			hit_result = hit_result + hit_fade * hit_wave;
			}
			return saturate(hit_result);
		}


		inline float4 TriplanarSampling74( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		float HitWaveFunction83( sampler2D RampTex, float3 WorldPos, float HitNoise, float HitSpread, float HitFadeDistance, float HitFadePower )
		{
			float hit_result;
			for(int j = 0;j < AffectorAmount;j++)
			{
			float distance_mask = distance(HitPosition[j].xyz,WorldPos);
			float hit_range = -clamp((distance_mask - HitSize[j] + HitNoise) / HitSpread,-1,0);
			float2 ramp_uv = float2(hit_range,0.5);
			float hit_wave = tex2D(RampTex,ramp_uv).r; 
			float hit_fade = saturate((1.0 - distance_mask / HitFadeDistance) * HitFadePower);
			hit_result = hit_result + hit_fade * hit_wave;
			}
			return saturate(hit_result);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			sampler2D RampTex105 = _HitRampTex;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 objToWorld111 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 temp_output_3_0_g1 = ( ase_worldPos - objToWorld111 );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 temp_output_6_0_g2 = ase_normWorldNormal;
			float dotResult1_g2 = dot( temp_output_3_0_g1 , temp_output_6_0_g2 );
			float dotResult2_g2 = dot( temp_output_6_0_g2 , temp_output_6_0_g2 );
			float3 PointToCenter114 = -( temp_output_3_0_g1 - ( ( dotResult1_g2 / dotResult2_g2 ) * temp_output_6_0_g2 ) );
			float3 HexgonCenter118 = ( ase_worldPos + PointToCenter114 );
			float3 WorldPos105 = HexgonCenter118;
			float HitNoise105 = ( v.texcoord3.xy.x * _HitNoiseIntensity );
			float HitSpread105 = _HitSpread;
			float HitFadeDistance105 = _HitFadeDistance;
			float HitFadePower105 = _HitFadePower;
			float localHitWaveFunction_VS105 = HitWaveFunction_VS105( RampTex105 , WorldPos105 , HitNoise105 , HitSpread105 , HitFadeDistance105 , HitFadePower105 );
			float HitWave_VS106 = localHitWaveFunction_VS105;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 objToWorld127 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float clampResult140 = clamp( ( ( distance( ( HexgonCenter118 - objToWorld127 ) , _DissolvePoint ) - _DissolveAmount ) / _DissolveSpread ) , 0.0 , 1.0 );
			float temp_output_177_0 = ( 1.0 - clampResult140 );
			float3 worldToObj171 = mul( unity_WorldToObject, float4( ( ase_worldPos + ( PointToCenter114 * temp_output_177_0 ) ), 1 ) ).xyz;
			float3 DissolveVertexPostion172 = worldToObj171;
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( ( ( ( HitWave_VS106 * ase_vertexNormal * 0.01 ) * _HitVertexOffset ) + DissolveVertexPostion172 ) - ase_vertex3Pos );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 switchResult10 = (((i.ASEVFace>0)?(ase_normWorldNormal):(-ase_normWorldNormal)));
			float fresnelNdotV14 = dot( switchResult10, ase_worldViewDir );
			float fresnelNode14 = ( _RimBias + _RimScale * pow( 1.0 - fresnelNdotV14, _RimPower ) );
			float RimFactor16 = fresnelNode14;
			float4 tex2DNode25 = tex2D( _LineHexagon, i.uv_texcoord );
			float HexagonLine26 = tex2DNode25.r;
			sampler2D RampTex83 = _HitRampTex;
			float3 WorldPos83 = ase_worldPos;
			float4 triplanar74 = TriplanarSampling74( _HitNoise, ( ase_worldPos * _HitNoiseTilling ), ase_worldNormal, 5.0, float2( 1,1 ), 1.0, 0 );
			float WaveNoise75 = triplanar74.x;
			float HitNoise83 = ( WaveNoise75 * _HitNoiseIntensity );
			float HitSpread83 = _HitSpread;
			float HitFadeDistance83 = _HitFadeDistance;
			float HitFadePower83 = _HitFadePower;
			float localHitWaveFunction83 = HitWaveFunction83( RampTex83 , WorldPos83 , HitNoise83 , HitSpread83 , HitFadeDistance83 , HitFadePower83 );
			float HitWave84 = localHitWaveFunction83;
			float2 uv3_LineEmissMask = i.uv3_texcoord3 * _LineEmissMask_ST.xy + _LineEmissMask_ST.zw;
			float2 panner33 = ( 1.0 * _Time.y * _LineMaskSpeed + ( ( HitWave84 * 0.2 ) + uv3_LineEmissMask ));
			float LineEmiss38 = ( ( tex2DNode25.r * tex2D( _LineEmissMask, panner33 ).r ) * _LineEmissIntensity );
			float2 uv4_AuraTex = i.uv4_texcoord4 * _AuraTex_ST.xy + _AuraTex_ST.zw;
			float2 panner51 = ( 1.0 * _Time.y * ( _AuraSpeed * float2( 2,2 ) ) + ( uv4_AuraTex * float2( 0.5,0.5 ) ));
			float2 panner43 = ( 1.0 * _Time.y * _AuraSpeed + ( uv4_AuraTex + ( (tex2D( _AuraTex, panner51 )).rg * 0.5 ) + ( HitWave84 * 0.2 ) ));
			float4 tex2DNode41 = tex2D( _AuraTex, panner43 );
			float2 uv3_AuraTexMask = i.uv3_texcoord3 * _AuraTexMask_ST.xy + _AuraTexMask_ST.zw;
			float2 panner58 = ( 1.0 * _Time.y * float2( 0,0.01 ) + uv3_AuraTexMask);
			float AuraColor45 = ( ( tex2DNode41.r * _AuraIntensity ) + ( tex2DNode41.r * tex2D( _AuraTexMask, panner58 ).r * 2.0 ) );
			float3 objToWorld111 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 temp_output_3_0_g1 = ( ase_worldPos - objToWorld111 );
			float3 temp_output_6_0_g2 = ase_normWorldNormal;
			float dotResult1_g2 = dot( temp_output_3_0_g1 , temp_output_6_0_g2 );
			float dotResult2_g2 = dot( temp_output_6_0_g2 , temp_output_6_0_g2 );
			float3 PointToCenter114 = -( temp_output_3_0_g1 - ( ( dotResult1_g2 / dotResult2_g2 ) * temp_output_6_0_g2 ) );
			float3 HexgonCenter118 = ( ase_worldPos + PointToCenter114 );
			float3 objToWorld127 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float clampResult140 = clamp( ( ( distance( ( HexgonCenter118 - objToWorld127 ) , _DissolvePoint ) - _DissolveAmount ) / _DissolveSpread ) , 0.0 , 1.0 );
			float temp_output_177_0 = ( 1.0 - clampResult140 );
			float temp_output_150_0 = step( 0.01 , clampResult140 );
			float DissolveEmiss154 = ( ( temp_output_177_0 * temp_output_150_0 ) * _DissolveEdgeintensity );
			float temp_output_22_0 = ( RimFactor16 + ( HexagonLine26 * _HexagonLineIntensity ) + LineEmiss38 + AuraColor45 + ( DissolveEmiss154 + ( DissolveEmiss154 * HexagonLine26 ) ) );
			o.Emission = ( _EmissIntensity * _EmissColor * ( temp_output_22_0 + ( ( temp_output_22_0 + _HitWaveIntensity ) * HitWave84 ) ) ).rgb;
			float clampResult30 = clamp( temp_output_22_0 , 0.0 , 1.0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth65 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth65 = abs( ( screenDepth65 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) );
			float clampResult66 = clamp( distanceDepth65 , 0.0 , 1.0 );
			float DisslveAlpha149 = temp_output_150_0;
			o.Alpha = ( clampResult30 * clampResult66 * DisslveAlpha149 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-1478;9;1467;943;949.9025;383.9641;1.70257;True;True
Node;AmplifyShaderEditor.CommentaryNode;119;-4357.583,1884.937;Inherit;False;1529.037;541.2533;HexgonCenter;10;117;118;114;115;116;112;185;110;111;109;HexgonCenter;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;109;-4307.583,2038.038;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;111;-4313.413,2222.504;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;110;-4023.414,2116.504;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;185;-4034.58,2246.387;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;112;-3800.415,2119.504;Inherit;False;Rejection;-1;;1;ea6ca936e02c9e74fae837451ff893c3;0;2;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;116;-3624.342,2120.581;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;69;-4375.758,-1823.943;Inherit;False;2291.384;1279.597;HitWave;24;87;86;85;84;83;82;81;79;78;77;76;75;74;73;72;71;70;105;106;107;120;121;122;123;HitWave;0.489655,1,0,1;0;0
Node;AmplifyShaderEditor.Vector3Node;71;-4327.12,-999.777;Inherit;False;Property;_HitNoiseTilling;HitNoiseTilling;4;0;Create;True;0;0;False;0;False;1,1,1;0.1,0.1,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-3456.414,2115.504;Inherit;False;PointToCenter;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;115;-3547.391,1934.937;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;70;-4327.12,-1187.777;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;73;-4325.12,-1416.777;Inherit;True;Property;_HitNoise;HitNoise;3;0;Create;True;0;0;False;0;False;None;3c506748d17579d4a85691a58877ff1e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-4045.121,-1173.777;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-3220.342,1989.581;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;126;-4400.82,2653.533;Inherit;False;2643.534;887.5811;Dissolve;25;149;150;154;152;153;140;139;137;136;131;134;129;130;127;124;167;168;170;171;172;177;178;180;194;195;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-3080.03,2000.595;Inherit;False;HexgonCenter;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;64;-4360.211,1059.669;Inherit;False;3178.137;632.8176;AuraColor;23;54;42;52;53;51;50;63;55;62;43;44;46;47;41;56;58;59;60;57;61;45;93;94;AuraColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TriplanarNode;74;-3880.88,-1203.248;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-4310.211,1109.669;Inherit;False;3;41;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;127;-4390.814,3127.708;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;44;-3859.93,1199.43;Inherit;False;Property;_AuraSpeed;AuraSpeed;23;0;Create;True;0;0;False;0;False;0,0;-0.02,0.035;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;124;-4391.474,3005.895;Inherit;False;118;HexgonCenter;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-3495.474,-1188.221;Inherit;False;WaveNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-3540.768,-963.281;Inherit;False;Property;_HitNoiseIntensity;HitNoiseIntensity;5;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-3257.937,-1050.772;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;121;-3133.117,-1184.175;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;130;-4364.127,3308.858;Inherit;False;Property;_DissolvePoint;DissolvePoint;24;0;Create;True;0;0;False;0;False;0,0,0;-4,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-3966.607,1381.202;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-3158.601,-864.5775;Inherit;False;Property;_HitFadeDistance;HitFadeDistance;6;0;Create;True;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;129;-4136.143,3071.81;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-3685.216,1407.148;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;78;-3212.764,-1562.861;Inherit;True;Property;_HitRampTex;HitRampTex;1;0;Create;True;0;0;False;0;False;None;bfb5d11eb2154099bda5558461f45026;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;82;-3124.017,-965.985;Inherit;False;Property;_HitSpread;HitSpread;2;0;Create;True;0;0;False;0;False;0;6.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-3141.151,-763.1273;Inherit;False;Property;_HitFadePower;HitFadePower;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-3984.64,3203.472;Inherit;False;Property;_DissolveAmount;DissolveAmount;26;0;Create;True;0;0;False;0;False;0;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;134;-3961.939,3090.472;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;83;-2788.354,-1026.907;Inherit;False;float hit_result@$$for(int j = 0@j < AffectorAmount@j++)${$$float distance_mask = distance(HitPosition[j].xyz,WorldPos)@$$float hit_range = -clamp((distance_mask - HitSize[j] + HitNoise) / HitSpread,-1,0)@$$float2 ramp_uv = float2(hit_range,0.5)@$$float hit_wave = tex2D(RampTex,ramp_uv).r@ $$float hit_fade = saturate((1.0 - distance_mask / HitFadeDistance) * HitFadePower)@$$hit_result = hit_result + hit_fade * hit_wave@$}$$return saturate(hit_result)@;1;False;6;True;RampTex;SAMPLER2D;;In;;Inherit;False;True;WorldPos;FLOAT3;0,0,0;In;;Inherit;False;True;HitNoise;FLOAT;0;In;;Inherit;False;True;HitSpread;FLOAT;0;In;;Inherit;False;True;HitFadeDistance;FLOAT;0;In;;Inherit;False;True;HitFadePower;FLOAT;0;In;;Inherit;False;HitWaveFunction;True;False;0;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;51;-3503.506,1385.63;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-2416.611,-1041.301;Inherit;False;HitWave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;136;-3777.109,3146.674;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-4369.501,272.8275;Inherit;False;1709.965;617.4638;LineColor;14;32;97;98;96;38;26;36;35;37;25;31;29;33;34;LineColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;50;-3315.254,1397.296;Inherit;True;Global;AuraTex;AuraTex;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;41;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;137;-3841.062,3291.265;Inherit;False;Property;_DissolveSpread;DissolveSpread;27;0;Create;True;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-4352,432;Inherit;False;84;HitWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-2890.326,1228.929;Inherit;False;84;HitWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2996.268,1390.542;Inherit;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;55;-3042.108,1274.341;Inherit;False;FLOAT2;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;139;-3609.333,3195.941;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-2849.266,1315.542;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-4256,608;Inherit;False;2;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;140;-3399.357,3195.022;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-2716.557,1232.576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-4160,480;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-2796.296,1486.061;Inherit;False;2;56;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;150;-3024.127,3312.602;Inherit;False;2;0;FLOAT;0.01;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-4032,528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0.2,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-2623.835,1115.284;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;34;-4136.822,742.494;Inherit;False;Property;_LineMaskSpeed;LineMaskSpeed;19;0;Create;True;0;0;False;0;False;0,0;0.015,0.015;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;1;-4359.705,-361.0064;Inherit;False;1488.904;409.2207;RimFactor;9;16;14;11;8;10;7;6;3;183;RimFactor;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;177;-3112.808,3146.008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;33;-3889.537,612.5844;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;3;-4338.779,-317.9586;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;153;-2673.847,3280.263;Inherit;False;Property;_DissolveEdgeintensity;DissolveEdgeintensity;28;0;Create;True;0;0;False;0;False;1.5;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-2765.315,3158.124;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;58;-2537.271,1487.033;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-3946.21,347.2592;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;43;-2485.271,1184.129;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-2363.958,3140.181;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2125.869,1366.45;Inherit;False;Property;_AuraIntensity;AuraIntensity;21;0;Create;True;0;0;False;0;False;0;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;-2294.8,1456.321;Inherit;True;Property;_AuraTexMask;AuraTexMask;22;0;Create;True;0;0;False;0;False;-1;None;aeb46886909512e41842722f15bb898b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;122;-3563.689,-1409.997;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-2208.142,1135.454;Inherit;True;Property;_AuraTex;AuraTex;20;0;Create;True;0;0;False;0;False;-1;None;57451d90cad4e93448f1dbe1a84a7c70;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-3699.537,596.5845;Inherit;True;Property;_LineEmissMask;LineEmissMask;18;0;Create;True;0;0;False;0;False;-1;None;b2ebe4a36fc94024d91fe15b52fe5772;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-3693.864,321.1823;Inherit;True;Property;_LineHexagon;LineHexagon;15;0;Create;True;0;0;False;0;False;-1;None;373bb7a955475ea4a82cd75a31359196;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-1982.255,1576.487;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;6;-4036.143,-250.0342;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-3267.537,564.5845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-3210.264,369.4324;Inherit;False;HexagonLine;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3779.183,-192.6611;Inherit;False;Property;_RimBias;RimBias;12;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1818.446,1192.278;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-2168.131,3134.451;Inherit;False;DissolveEmiss;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-3261.114,-1280.838;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;10;-3808.17,-323.7003;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-3785.183,-116.6611;Inherit;False;Property;_RimScale;RimScale;13;0;Create;True;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1811.919,1462.503;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-3299.537,692.5844;Inherit;False;Property;_LineEmissIntensity;LineEmissIntensity;16;0;Create;True;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-3144.521,-1357.496;Inherit;False;118;HexgonCenter;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3790.183,-41.66125;Inherit;False;Property;_RimPower;RimPower;14;0;Create;True;0;0;False;0;False;3;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-3059.538,628.5844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-1311.491,580.5457;Inherit;False;26;HexagonLine;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1637.806,1205.391;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-1312.693,461.647;Inherit;False;154;DissolveEmiss;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;14;-3509.663,-215.8006;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-3098.407,2987.34;Inherit;False;114;PointToCenter;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;105;-2790.351,-1374.55;Inherit;False;float hit_result@$$for(int j = 0@j < AffectorAmount@j++)${$$float distance_mask = distance(HitPosition[j].xyz,WorldPos)@$$float hit_range = -clamp((distance_mask - HitSize[j] + HitNoise) / HitSpread,-1,0)@$$float2 ramp_uv = float2(hit_range,0.5)@$$float hit_wave = tex2Dlod(RampTex,float4(ramp_uv,0,0)).r@ $$float hit_fade = saturate((1.0 - distance_mask / HitFadeDistance) * HitFadePower)@$$hit_result = hit_result + hit_fade * hit_wave@$}$$return saturate(hit_result)@;1;False;6;True;RampTex;SAMPLER2D;;In;;Inherit;False;True;WorldPos;FLOAT3;0,0,0;In;;Inherit;False;True;HitNoise;FLOAT;0;In;;Inherit;False;True;HitSpread;FLOAT;0;In;;Inherit;False;True;HitFadeDistance;FLOAT;0;In;;Inherit;False;True;HitFadePower;FLOAT;0;In;;Inherit;False;HitWaveFunction_VS;True;False;0;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;170;-2977.472,2799.477;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-2858.563,2983.287;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-1065.616,523.5944;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-2883.538,628.5844;Inherit;False;LineEmiss;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;107;-2520.192,-1374.62;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1086.221,70.5482;Inherit;False;26;HexagonLine;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-3158.659,-294.7779;Inherit;False;RimFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1131.487,163.655;Inherit;False;Property;_HexagonLineIntensity;HexagonLineIntensity;17;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1406.075,1211.508;Inherit;False;AuraColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-2282.173,-1373.399;Inherit;False;HitWave_VS;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-2677.089,2877.772;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-962.9351,-30.20118;Inherit;False;16;RimFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-1041.559,246.6541;Inherit;False;38;LineEmiss;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-858.4498,58.22174;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-1039.298,326.833;Inherit;False;45;AuraColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;-917.1199,433.3535;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-682.0424,197.9655;Inherit;False;Property;_HitWaveIntensity;HitWaveIntensity;9;0;Create;True;0;0;False;0;False;0.2;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-680.4346,11.06789;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;101;-845.9703,697.9441;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;171;-2467.672,2871.977;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;100;-852.4377,597.2017;Inherit;False;106;HitWave_VS;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-822.9998,864.2251;Inherit;False;Constant;_Float2;Float 2;23;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-475.9473,367.5217;Inherit;False;Property;_DepthFade;DepthFade;25;0;Create;True;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-485.4984,263.4997;Inherit;False;84;HitWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-421.0579,104.5916;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-565.5748,659.8755;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;-2210.898,2875.294;Inherit;False;DissolveVertexPostion;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-596.4956,803.1616;Inherit;False;Property;_HitVertexOffset;HitVertexOffset;8;0;Create;True;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-256.568,163.5059;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;65;-294.8682,328.2027;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;-581.7838,911.7839;Inherit;False;172;DissolveVertexPostion;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-2672.211,3405.84;Inherit;False;DisslveAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-350.5045,715.4174;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-350.3061,-238.1909;Inherit;False;Property;_EmissIntensity;EmissIntensity;11;0;Create;True;0;0;False;0;False;0;1.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;181;-2010.028,-1826.482;Inherit;False;228;165;Properties;1;182;Properties;1,0,0,1;0;0
Node;AmplifyShaderEditor.ColorNode;17;-362.3061,-132.191;Inherit;False;Property;_EmissColor;EmissColor;10;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.333807,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-125.0269,52.12033;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;30;-0.01904297,127.364;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;66;11.90597,272.2145;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-28.66679,410.2451;Inherit;False;149;DisslveAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;176;-283.6217,995.787;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-161.3878,757.548;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;-15.58753,519.8917;Inherit;False;190;Test;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-2292.307,2429.336;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.1,0.1,0.1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;199;-2566.293,2387.16;Inherit;False;Property;_Vector0;Vector 0;29;0;Create;True;0;0;False;0;False;0,0,0;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;200;-2608.551,2555.526;Inherit;False;Property;_Float3;Float 3;30;0;Create;True;0;0;False;0;False;0;-0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-2076.312,2434.311;Inherit;False;Test;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-3592.226,3357.488;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;119.5129,-43.85014;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-3532.184,-317.7337;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-1960.028,-1776.482;Inherit;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;282.3853,156.0696;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-3803.677,3415.046;Inherit;False;106;HitWave_VS;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;85;-3385.103,-1772.943;Inherit;False;HitSize;0;20;0;False;False;0;1;True;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;175;34.21919,782.8522;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GlobalArrayNode;86;-3620.321,-1772.879;Inherit;False;HitPosition;0;20;2;False;False;0;1;True;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3134.534,-1764.686;Inherit;False;Global;AffectorAmount;AffectorAmount;6;0;Create;False;0;0;True;0;False;20;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;500.6191,-79.3511;Float;False;True;-1;3;ASEMaterialInspector;0;0;Unlit;ASE/Hexagon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;110;0;109;0
WireConnection;110;1;111;0
WireConnection;112;3;110;0
WireConnection;112;4;185;0
WireConnection;116;0;112;0
WireConnection;114;0;116;0
WireConnection;72;0;70;0
WireConnection;72;1;71;0
WireConnection;117;0;115;0
WireConnection;117;1;114;0
WireConnection;118;0;117;0
WireConnection;74;0;73;0
WireConnection;74;9;72;0
WireConnection;75;0;74;1
WireConnection;81;0;75;0
WireConnection;81;1;76;0
WireConnection;52;0;42;0
WireConnection;129;0;124;0
WireConnection;129;1;127;0
WireConnection;53;0;44;0
WireConnection;134;0;129;0
WireConnection;134;1;130;0
WireConnection;83;0;78;0
WireConnection;83;1;121;0
WireConnection;83;2;81;0
WireConnection;83;3;82;0
WireConnection;83;4;79;0
WireConnection;83;5;77;0
WireConnection;51;0;52;0
WireConnection;51;2;53;0
WireConnection;84;0;83;0
WireConnection;136;0;134;0
WireConnection;136;1;131;0
WireConnection;50;1;51;0
WireConnection;55;0;50;0
WireConnection;139;0;136;0
WireConnection;139;1;137;0
WireConnection;62;0;55;0
WireConnection;62;1;63;0
WireConnection;140;0;139;0
WireConnection;94;0;93;0
WireConnection;98;0;96;0
WireConnection;150;1;140;0
WireConnection;97;0;98;0
WireConnection;97;1;32;0
WireConnection;54;0;42;0
WireConnection;54;1;62;0
WireConnection;54;2;94;0
WireConnection;177;0;140;0
WireConnection;33;0;97;0
WireConnection;33;2;34;0
WireConnection;178;0;177;0
WireConnection;178;1;150;0
WireConnection;58;0;59;0
WireConnection;43;0;54;0
WireConnection;43;2;44;0
WireConnection;152;0;178;0
WireConnection;152;1;153;0
WireConnection;56;1;58;0
WireConnection;41;1;43;0
WireConnection;31;1;33;0
WireConnection;25;1;29;0
WireConnection;6;0;3;0
WireConnection;35;0;25;1
WireConnection;35;1;31;1
WireConnection;26;0;25;1
WireConnection;47;0;41;1
WireConnection;47;1;46;0
WireConnection;154;0;152;0
WireConnection;123;0;122;1
WireConnection;123;1;76;0
WireConnection;10;0;3;0
WireConnection;10;1;6;0
WireConnection;57;0;41;1
WireConnection;57;1;56;1
WireConnection;57;2;60;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;61;0;47;0
WireConnection;61;1;57;0
WireConnection;14;0;10;0
WireConnection;14;1;7;0
WireConnection;14;2;8;0
WireConnection;14;3;11;0
WireConnection;105;0;78;0
WireConnection;105;1;120;0
WireConnection;105;2;123;0
WireConnection;105;3;82;0
WireConnection;105;4;79;0
WireConnection;105;5;77;0
WireConnection;167;0;168;0
WireConnection;167;1;177;0
WireConnection;161;0;157;0
WireConnection;161;1;160;0
WireConnection;38;0;36;0
WireConnection;107;0;105;0
WireConnection;16;0;14;0
WireConnection;45;0;61;0
WireConnection;106;0;107;0
WireConnection;180;0;170;0
WireConnection;180;1;167;0
WireConnection;23;0;27;0
WireConnection;23;1;24;0
WireConnection;162;0;157;0
WireConnection;162;1;161;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;22;2;39;0
WireConnection;22;3;48;0
WireConnection;22;4;162;0
WireConnection;171;0;180;0
WireConnection;89;0;22;0
WireConnection;89;1;90;0
WireConnection;99;0;100;0
WireConnection;99;1;101;0
WireConnection;99;2;102;0
WireConnection;172;0;171;0
WireConnection;91;0;89;0
WireConnection;91;1;88;0
WireConnection;65;0;67;0
WireConnection;149;0;150;0
WireConnection;103;0;99;0
WireConnection;103;1;104;0
WireConnection;92;0;22;0
WireConnection;92;1;91;0
WireConnection;30;0;22;0
WireConnection;66;0;65;0
WireConnection;173;0;103;0
WireConnection;173;1;174;0
WireConnection;198;1;199;0
WireConnection;198;2;200;0
WireConnection;190;0;198;0
WireConnection;195;1;194;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;19;2;92;0
WireConnection;183;0;10;0
WireConnection;68;0;30;0
WireConnection;68;1;66;0
WireConnection;68;2;155;0
WireConnection;175;0;173;0
WireConnection;175;1;176;0
WireConnection;0;2;19;0
WireConnection;0;9;68;0
WireConnection;0;11;175;0
ASEEND*/
//CHKSM=010CE2A672049301ADD0B646BCEDD674C59D87D4