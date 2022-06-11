// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/ForceField"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		_HitRampTex("HitRampTex", 2D) = "white" {}
		_HitSpread("HitSpread", Float) = 0
		_HitNoise("HitNoise", 2D) = "white" {}
		_HitNoiseTilling("HitNoiseTilling", Vector) = (1,1,1,0)
		_HitNoiseIntensity("HitNoiseIntensity", Float) = 0
		_HitFadePower("HitFadePower", Float) = 1
		_HitFadeDistance("HitFadeDistance", Float) = 6
		_HitWaveIntensity("HitWaveIntensity", Float) = 0.2
		_EmissColor("EmissColor", Color) = (0,0,0,0)
		_EmissIntensity("EmissIntensity", Float) = 0
		_RimBias("RimBias", Float) = 0
		_RimScale("RimScale", Float) = 2
		_RimPower("RimPower", Float) = 3
		_DepthFadeDistance("DepthFadeDistance", Float) = 5
		_DepthFadePower("DepthFadePower", Float) = 5
		_Size("Size", Range( 0 , 10)) = 1
		_FlowLight("FlowLight", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowStrength("FlowStrength", Vector) = (0.2,0.2,0,0)
		_FlowSpeed("FlowSpeed", Float) = 0.2
		_DissolvePoint("DissolvePoint", Vector) = (0,0,0,0)
		_DissolveAmount("DissolveAmount", Float) = 0
		_DissolveSpread("DissolveSpread", Float) = 0
		_DissolveNoise("DissolveNoise", Float) = 1
		_DissolveRampTex("DissolveRampTex", 2D) = "white" {}
		_DissolveEdgeIntensity("DissolveEdgeIntensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float AffectorAmount;
		uniform float _CullMode;
		uniform float4 HitPosition[20];
		uniform float HitSize[20];
		uniform float _EmissIntensity;
		uniform float4 _EmissColor;
		uniform float _RimBias;
		uniform float _RimScale;
		uniform float _RimPower;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeDistance;
		uniform float _DepthFadePower;
		uniform sampler2D _FlowLight;
		uniform float4 _FlowLight_ST;
		uniform float _Size;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform sampler2D _HitRampTex;
		uniform sampler2D _HitNoise;
		uniform float3 _HitNoiseTilling;
		uniform float _HitNoiseIntensity;
		uniform float _HitSpread;
		uniform float _HitFadeDistance;
		uniform float _HitFadePower;
		uniform float2 _FlowStrength;
		uniform float _FlowSpeed;
		uniform float _HitWaveIntensity;
		uniform sampler2D _DissolveRampTex;
		SamplerState sampler_DissolveRampTex;
		uniform float3 _DissolvePoint;
		uniform float _DissolveAmount;
		uniform float _DissolveNoise;
		uniform float _DissolveSpread;
		uniform float _DissolveEdgeIntensity;


		inline float4 TriplanarSampling42( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		float HitWaveFunction35( sampler2D RampTex, float3 WorldPos, float HitNoise, float HitSpread, float HitFadeDistance, float HitFadePower )
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
			float3 switchResult212 = (((i.ASEVFace>0)?(ase_worldNormal):(-ase_worldNormal)));
			float fresnelNdotV132 = dot( switchResult212, ase_worldViewDir );
			float fresnelNode132 = ( _RimBias + _RimScale * pow( 1.0 - fresnelNdotV132, _RimPower ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth168 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth168 = abs( ( screenDepth168 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) );
			float clampResult172 = clamp( ( 1.0 - distanceDepth168 ) , 0.0 , 1.0 );
			float RimFactor136 = ( fresnelNode132 + pow( clampResult172 , _DepthFadePower ) );
			float2 uv_FlowLight = i.uv_texcoord * _FlowLight_ST.xy + _FlowLight_ST.zw;
			float2 temp_output_4_0_g1 = (( uv_FlowLight / _Size )).xy;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 temp_cast_0 = (0.5).xx;
			sampler2D RampTex35 = _HitRampTex;
			float3 WorldPos35 = ase_worldPos;
			float4 triplanar42 = TriplanarSampling42( _HitNoise, ( ase_worldPos * _HitNoiseTilling ), ase_worldNormal, 5.0, float2( 1,1 ), 1.0, 0 );
			float WaveNoise123 = triplanar42.x;
			float HitNoise35 = ( WaveNoise123 * _HitNoiseIntensity );
			float HitSpread35 = _HitSpread;
			float HitFadeDistance35 = _HitFadeDistance;
			float HitFadePower35 = _HitFadePower;
			float localHitWaveFunction35 = HitWaveFunction35( RampTex35 , WorldPos35 , HitNoise35 , HitSpread35 , HitFadeDistance35 , HitFadePower35 );
			float HitWave47 = localHitWaveFunction35;
			float2 temp_output_41_0_g1 = ( ( ( (tex2D( _FlowMap, uv_FlowMap )).rg - temp_cast_0 ) + HitWave47 ) + 0.5 );
			float2 temp_output_17_0_g1 = _FlowStrength;
			float mulTime22_g1 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g1 = frac( mulTime22_g1 );
			float2 temp_output_11_0_g1 = ( temp_output_4_0_g1 + ( temp_output_41_0_g1 * temp_output_17_0_g1 * temp_output_27_0_g1 ) );
			float2 temp_output_12_0_g1 = ( temp_output_4_0_g1 + ( temp_output_41_0_g1 * temp_output_17_0_g1 * frac( ( mulTime22_g1 + 0.5 ) ) ) );
			float4 lerpResult9_g1 = lerp( tex2D( _FlowLight, temp_output_11_0_g1 ) , tex2D( _FlowLight, temp_output_12_0_g1 ) , ( abs( ( temp_output_27_0_g1 - 0.5 ) ) / 0.5 ));
			float4 temp_cast_1 = (RimFactor136).xxxx;
			float smoothstepResult163 = smoothstep( 0.9 , 1.0 , i.uv_texcoord.y);
			float4 lerpResult159 = lerp( lerpResult9_g1 , temp_cast_1 , smoothstepResult163);
			float4 FlowColor155 = lerpResult159;
			float4 temp_output_165_0 = ( RimFactor136 * FlowColor155 );
			float3 objToWorld186 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float clampResult193 = clamp( ( ( ( distance( _DissolvePoint , ( ase_worldPos - objToWorld186 ) ) - _DissolveAmount ) - ( WaveNoise123 * _DissolveNoise ) ) / _DissolveSpread ) , 0.0 , 1.0 );
			float temp_output_197_0 = ( 1.0 - clampResult193 );
			float2 appendResult196 = (float2(temp_output_197_0 , 0.5));
			float DissoloveEdge194 = ( tex2D( _DissolveRampTex, appendResult196 ).r * _DissolveEdgeIntensity );
			float4 temp_output_177_0 = ( temp_output_165_0 + ( ( temp_output_165_0 + _HitWaveIntensity ) * HitWave47 ) + DissoloveEdge194 );
			o.Emission = ( ( _EmissIntensity * _EmissColor ) * temp_output_177_0 ).rgb;
			float grayscale166 = Luminance(temp_output_177_0.rgb);
			float smoothstepResult198 = smoothstep( 0.0 , 0.1 , temp_output_197_0);
			float DissoloveAlpha199 = smoothstepResult198;
			float clampResult167 = clamp( ( grayscale166 * DissoloveAlpha199 ) , 0.0 , 1.0 );
			o.Alpha = clampResult167;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-553;1157;1398;757;3815.186;-803.3623;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;41;-3148.643,-347.2888;Inherit;False;2291.384;1279.597;HitWave;18;37;35;40;39;28;13;30;36;16;5;17;42;43;46;44;45;47;123;HitWave;0.489655,1,0,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;44;-3093.004,309.8773;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;45;-3100.004,476.8772;Inherit;False;Property;_HitNoiseTilling;HitNoiseTilling;4;0;Create;True;0;0;False;0;False;1,1,1;0.1,0.1,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;137;-3147.574,1078.056;Inherit;False;2312.154;434.4788;RimFactor;13;173;172;171;169;168;136;132;135;133;134;174;175;212;RimFactor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-2818.005,302.8772;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;43;-3092.004,75.87718;Inherit;True;Property;_HitNoise;HitNoise;3;0;Create;True;0;0;False;0;False;None;3c506748d17579d4a85691a58877ff1e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;209;-3123.844,2636.546;Inherit;False;2764.176;734.4854;Dissolve;22;186;184;185;183;188;190;204;206;205;189;192;203;191;193;197;196;208;195;207;194;198;199;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-2520.943,1284.7;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;14;0;Create;True;0;0;False;0;False;5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;42;-2653.765,273.4065;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-2250.359,302.4339;Inherit;False;WaveNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;210;-3513.186,1093.362;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DepthFade;168;-2221.322,1245.299;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;186;-3073.844,3084.88;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;184;-3067.321,2910.546;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;164;-3115.536,1681.784;Inherit;False;2254.505;767.2251;FlowColor;17;152;153;154;158;144;145;161;149;157;151;163;143;159;160;155;180;181;FlowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2313.652,513.373;Inherit;False;Property;_HitNoiseIntensity;HitNoiseIntensity;5;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;173;-1962.316,1276.29;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1910.486,706.4278;Inherit;False;Property;_HitFadePower;HitFadePower;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;185;-2795.321,2990.546;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;211;-3292.186,1186.362;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;152;-3065.536,2080.357;Inherit;False;0;153;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;36;-1941.921,-58.51139;Inherit;True;Property;_HitRampTex;HitRampTex;1;0;Create;True;0;0;False;0;False;None;bfb5d11eb2154099bda5558461f45026;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;183;-3051.321,2686.546;Inherit;False;Property;_DissolvePoint;DissolvePoint;23;0;Create;True;0;0;False;0;False;0,0,0;0,-2.5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-1931.486,601.4274;Inherit;False;Property;_HitFadeDistance;HitFadeDistance;7;0;Create;True;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-1962.659,166.8094;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2030.821,425.8822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1893.352,491.1454;Inherit;False;Property;_HitSpread;HitSpread;2;0;Create;True;0;0;False;0;False;0;6.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-2603.321,2974.546;Inherit;False;Property;_DissolveAmount;DissolveAmount;24;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-3078.574,1209.401;Inherit;False;Property;_RimBias;RimBias;11;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-3084.574,1285.401;Inherit;False;Property;_RimScale;RimScale;12;0;Create;True;0;0;False;0;False;2;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;172;-1731.316,1291.29;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;212;-3115.186,1115.362;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;153;-2836.736,2050.757;Inherit;True;Property;_FlowMap;FlowMap;20;0;Create;True;0;0;False;0;False;-1;None;f4a4b1c04c15a784ca546dc6c403e249;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;135;-3089.574,1360.401;Inherit;False;Property;_RimPower;RimPower;13;0;Create;True;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-2415.57,3108.733;Inherit;False;123;WaveNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-1826.618,1428.038;Inherit;False;Property;_DepthFadePower;DepthFadePower;15;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;35;-1586.767,120.4486;Inherit;False;float hit_result@$$for(int j = 0@j < AffectorAmount@j++)${$$float distance_mask = distance(HitPosition[j].xyz,WorldPos)@$$float hit_range = -clamp((distance_mask - HitSize[j] + HitNoise) / HitSpread,-1,0)@$$float2 ramp_uv = float2(hit_range,0.5)@$$float hit_wave = tex2D(RampTex,ramp_uv).r@ $$float hit_fade = saturate((1.0 - distance_mask / HitFadeDistance) * HitFadePower)@$$hit_result = hit_result + hit_fade * hit_wave@$}$$return saturate(hit_result)@;1;False;6;True;RampTex;SAMPLER2D;;In;;Inherit;False;True;WorldPos;FLOAT3;0,0,0;In;;Inherit;False;True;HitNoise;FLOAT;0;In;;Inherit;False;True;HitSpread;FLOAT;0;In;;Inherit;False;True;HitFadeDistance;FLOAT;0;In;;Inherit;False;True;HitFadePower;FLOAT;0;In;;Inherit;False;HitWaveFunction;True;False;0;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-2431.506,3201.063;Inherit;False;Property;_DissolveNoise;DissolveNoise;26;0;Create;True;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;188;-2571.321,2814.546;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-2186.751,3141.638;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;189;-2379.321,2894.546;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1215.024,106.0543;Inherit;False;HitWave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;154;-2491.284,2057.551;Inherit;False;FLOAT2;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;175;-1524.565,1295.403;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;132;-2855.583,1130.47;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-2471.156,2162.217;Inherit;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-2000.873,3078.25;Inherit;False;Property;_DissolveSpread;DissolveSpread;25;0;Create;True;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;203;-2045.185,2932.297;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;157;-2249.368,2075.604;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;174;-1321.222,1199.038;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-2261.284,2178.022;Inherit;False;47;HitWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;145;-2176.591,1932.184;Inherit;False;0;144;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;144;-2162.891,1731.784;Inherit;True;Property;_FlowLight;FlowLight;19;0;Create;True;0;0;False;0;False;None;aeb46886909512e41842722f15bb898b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-2038.393,2062.576;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-1720.389,2240.698;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-1150.03,1158.258;Inherit;False;RimFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;149;-2103.743,2232.932;Inherit;False;Property;_FlowStrength;FlowStrength;21;0;Create;True;0;0;False;0;False;0.2,0.2;-0.5,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;191;-1774.873,2973.25;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-2099.148,2366.157;Inherit;False;Property;_FlowSpeed;FlowSpeed;22;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;193;-1622.874,3009.25;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;163;-1480.389,2255.698;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-1560.389,2135.698;Inherit;False;136;RimFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;143;-1753.891,1919.784;Inherit;False;Flow;16;;1;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;5;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;197;-1444.535,3015.79;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;159;-1284.576,2054.972;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-1085.03,1915.484;Inherit;False;FlowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;196;-1247.025,3070.619;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;200.5188,1928.096;Inherit;False;136;RimFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;200.4668,2019.941;Inherit;False;155;FlowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;195;-1091.38,3047.812;Inherit;True;Property;_DissolveRampTex;DissolveRampTex;27;0;Create;True;0;0;False;0;False;-1;None;88938e6d069d4f32bb303144ac06aa48;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;208;-1027.682,3255.031;Inherit;False;Property;_DissolveEdgeIntensity;DissolveEdgeIntensity;28;0;Create;True;0;0;False;0;False;1;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;-747.6825,3152.031;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;439.9616,1920.473;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;179;416.8355,2065.802;Inherit;False;Property;_HitWaveIntensity;HitWaveIntensity;8;0;Create;True;0;0;False;0;False;0.2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-584.6677,3126.356;Inherit;False;DissoloveEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;178;610.5355,2000.803;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;469.3244,2161.789;Inherit;False;47;HitWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;198;-1218.456,2904.382;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;682.3937,2185.218;Inherit;False;194;DissoloveEdge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;754.292,2014.551;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;-1012.028,2896.32;Inherit;False;DissoloveAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;1023.973,1939.787;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;166;1241.466,2022.408;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;140;393.1126,1711.456;Inherit;False;Property;_EmissColor;EmissColor;9;0;Create;True;0;0;False;0;False;0,0,0,0;0.9641557,0.6745098,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;141;405.1126,1605.456;Inherit;False;Property;_EmissIntensity;EmissIntensity;10;0;Create;True;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;1282.781,2153.629;Inherit;False;199;DissoloveAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;630.7493,1683.302;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;131;-800.0767,-280.1067;Inherit;False;228;165;Properties;1;130;Properties;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;1521.781,2068.629;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-750.0767,-230.1068;Inherit;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;1358.341,1764.391;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;167;1691.886,1996.222;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;39;-2134.987,-297.2888;Inherit;False;HitSize;0;20;0;False;False;0;1;True;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;37;-2393.205,-296.2248;Inherit;False;HitPosition;0;20;2;False;False;0;1;True;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1907.419,-288.031;Inherit;False;Global;AffectorAmount;AffectorAmount;6;0;Create;False;0;0;True;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1969.091,1729.539;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/ForceField;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;130;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;42;0;43;0
WireConnection;42;9;46;0
WireConnection;123;0;42;1
WireConnection;168;0;169;0
WireConnection;173;0;168;0
WireConnection;185;0;184;0
WireConnection;185;1;186;0
WireConnection;211;0;210;0
WireConnection;16;0;123;0
WireConnection;16;1;17;0
WireConnection;172;0;173;0
WireConnection;212;0;210;0
WireConnection;212;1;211;0
WireConnection;153;1;152;0
WireConnection;35;0;36;0
WireConnection;35;1;5;0
WireConnection;35;2;16;0
WireConnection;35;3;13;0
WireConnection;35;4;28;0
WireConnection;35;5;30;0
WireConnection;188;0;183;0
WireConnection;188;1;185;0
WireConnection;205;0;204;0
WireConnection;205;1;206;0
WireConnection;189;0;188;0
WireConnection;189;1;190;0
WireConnection;47;0;35;0
WireConnection;154;0;153;0
WireConnection;175;0;172;0
WireConnection;175;1;171;0
WireConnection;132;0;212;0
WireConnection;132;1;133;0
WireConnection;132;2;134;0
WireConnection;132;3;135;0
WireConnection;203;0;189;0
WireConnection;203;1;205;0
WireConnection;157;0;154;0
WireConnection;157;1;158;0
WireConnection;174;0;132;0
WireConnection;174;1;175;0
WireConnection;180;0;157;0
WireConnection;180;1;181;0
WireConnection;136;0;174;0
WireConnection;191;0;203;0
WireConnection;191;1;192;0
WireConnection;193;0;191;0
WireConnection;163;0;161;2
WireConnection;143;5;144;0
WireConnection;143;2;145;0
WireConnection;143;18;180;0
WireConnection;143;17;149;0
WireConnection;143;24;151;0
WireConnection;197;0;193;0
WireConnection;159;0;143;0
WireConnection;159;1;160;0
WireConnection;159;2;163;0
WireConnection;155;0;159;0
WireConnection;196;0;197;0
WireConnection;195;1;196;0
WireConnection;207;0;195;1
WireConnection;207;1;208;0
WireConnection;165;0;139;0
WireConnection;165;1;156;0
WireConnection;194;0;207;0
WireConnection;178;0;165;0
WireConnection;178;1;179;0
WireConnection;198;0;197;0
WireConnection;176;0;178;0
WireConnection;176;1;48;0
WireConnection;199;0;198;0
WireConnection;177;0;165;0
WireConnection;177;1;176;0
WireConnection;177;2;202;0
WireConnection;166;0;177;0
WireConnection;142;0;141;0
WireConnection;142;1;140;0
WireConnection;200;0;166;0
WireConnection;200;1;201;0
WireConnection;138;0;142;0
WireConnection;138;1;177;0
WireConnection;167;0;200;0
WireConnection;0;2;138;0
WireConnection;0;9;167;0
ASEEND*/
//CHKSM=0ECF9DF22F54630BD0BFE39F7255EF2C2BA1E111