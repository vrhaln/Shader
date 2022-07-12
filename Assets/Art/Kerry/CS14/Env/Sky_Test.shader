// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sky_Test"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		[HDR]_EmissColor("EmissColor", Color) = (0,0,0,0)
		_Intensity("Intensity", Float) = 0
		_NebulaTex("NebulaTex", 2D) = "white" {}
		_NebulaTexPanner("NebulaTexPanner", Vector) = (0,0,0,0)
		_NoiseMask("NoiseMask", 2D) = "white" {}
		_NoiseSpeed("NoiseSpeed", Vector) = (0,0,0,0)
		_StarIntensity("StarIntensity", Float) = 10
		_EmissionTex("EmissionTex", 2D) = "black" {}
		_EmissionTex2("EmissionTex2", 2D) = "white" {}
		_EmissionTex2Panner("EmissionTex2Panner", Vector) = (0,0,0,0)
		_EmissionIntensity("EmissionIntensity", Float) = 1
		_EmissionTex3("EmissionTex3", 2D) = "white" {}
		_Disturbstr("Disturbstr", Float) = 0.1
		_EmissionTex3Panner("EmissionTex3Panner", Vector) = (0,0,0,0)
		_FogColor("FogColor", Color) = (0,0,0,0)
		_SkyFogOffset("SkyFogOffset", Vector) = (0,2,0,0)
		_FlowRange("FlowRange", Range( 0 , 2)) = 0.9
		_FlowRange2("FlowRange2", Range( 0 , 2)) = 0.9
		_FlowSoft("FlowSoft", Range( 0.51 , 1)) = 0.9
		_Range2("Range2", Vector) = (0,0.5,0,0)
		_FlowEmissRange("FlowEmissRange", Float) = 0.92
		_FlowEmissSoft("FlowEmissSoft", Range( 0.51 , 1)) = 0.7809411
		_FlowEmissIntensity("FlowEmissIntensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 worldPos;
			float4 screenPos;
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

		uniform float4 _BaseColor;
		uniform sampler2D _NoiseMask;
		uniform float2 _NoiseSpeed;
		uniform float4 _NoiseMask_ST;
		uniform sampler2D _NebulaTex;
		uniform float3 _NebulaTexPanner;
		uniform float4 _NebulaTex_ST;
		uniform float _StarIntensity;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform sampler2D _EmissionTex2;
		uniform float3 _EmissionTex2Panner;
		uniform float4 _EmissionTex2_ST;
		uniform float _EmissionIntensity;
		uniform float _FlowEmissSoft;
		uniform sampler2D _EmissionTex3;
		uniform float3 _EmissionTex3Panner;
		uniform float4 _EmissionTex3_ST;
		uniform float _Disturbstr;
		uniform float3 _SkyFogOffset;
		uniform float _FlowEmissRange;
		uniform float _FlowEmissIntensity;
		uniform float _Intensity;
		uniform float4 _EmissColor;
		uniform float4 _FogColor;
		uniform float _FlowSoft;
		uniform float3 _Range2;
		uniform float _FlowRange2;
		uniform float _FlowRange;

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
			float2 uv_NoiseMask = i.uv_texcoord * _NoiseMask_ST.xy + _NoiseMask_ST.zw;
			float2 panner136 = ( 1.0 * _Time.y * _NoiseSpeed + uv_NoiseMask);
			float4 tex2DNode131 = tex2D( _NoiseMask, panner136 );
			float mulTime145 = _Time.y * _NebulaTexPanner.z;
			float2 appendResult144 = (float2(_NebulaTexPanner.x , _NebulaTexPanner.y));
			float2 uv_NebulaTex = i.uv_texcoord * _NebulaTex_ST.xy + _NebulaTex_ST.zw;
			float2 panner142 = ( mulTime145 * appendResult144 + uv_NebulaTex);
			float4 tex2DNode114 = tex2D( _NebulaTex, panner142 );
			float4 saferPower130 = abs( tex2DNode114 );
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float mulTime160 = _Time.y * _EmissionTex2Panner.z;
			float2 appendResult162 = (float2(_EmissionTex2Panner.x , _EmissionTex2Panner.y));
			float2 uv_EmissionTex2 = i.uv_texcoord * _EmissionTex2_ST.xy + _EmissionTex2_ST.zw;
			float2 panner163 = ( mulTime160 * appendResult162 + uv_EmissionTex2);
			float mulTime149 = _Time.y * _EmissionTex3Panner.z;
			float2 appendResult150 = (float2(_EmissionTex3Panner.x , _EmissionTex3Panner.y));
			float2 uv_EmissionTex3 = i.uv_texcoord * _EmissionTex3_ST.xy + _EmissionTex3_ST.zw;
			float2 panner151 = ( mulTime149 * appendResult150 + uv_EmissionTex3);
			float Noise281 = tex2DNode131.r;
			float4 tex2DNode170 = tex2D( _EmissionTex3, ( panner151 + ( Noise281 * _Disturbstr ) ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult69 = normalize( ( ase_worldNormal + ase_worldViewDir + _SkyFogOffset ) );
			float clampResult110 = clamp( (normalizeResult69).y , 0.0 , 1.0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float clampResult107 = clamp( ( clampResult110 - ( ( distance( (ase_screenPosNorm).xy , float2( 0.5,0.5 ) ) * ase_screenPosNorm.y ) * 0.7 ) ) , 0.0 , 1.0 );
			float smoothstepResult119 = smoothstep( 0.0 , 0.9 , clampResult107);
			float3 normalizeResult123 = normalize( ase_worldPos );
			float temp_output_126_0 = ( 1.0 - abs( (normalizeResult123).y ) );
			float HorizonMask154 = saturate( saturate( ( ( 1.0 - smoothstepResult119 ) * ( temp_output_126_0 * temp_output_126_0 ) ) ) );
			float temp_output_242_0 = ( tex2DNode170.r * HorizonMask154 );
			float FlowEmissColor250 = temp_output_242_0;
			float smoothstepResult256 = smoothstep( ( 1.0 - _FlowEmissSoft ) , _FlowEmissSoft , pow( FlowEmissColor250 , _FlowEmissRange ));
			float4 EmissColor213 = ( ( ( ( tex2DNode131.r * max( pow( saferPower130 , 5.0 ) , float4( 0,0,0,0 ) ) * _StarIntensity ) + tex2DNode114 + ( tex2D( _EmissionTex, uv_EmissionTex ).r * ( ( tex2D( _EmissionTex2, panner163 ).r * _EmissionIntensity ) + tex2DNode114.r ) ) + ( smoothstepResult256 * _FlowEmissIntensity ) ) * _Intensity * _EmissColor ) * HorizonMask154 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 worldToObj205 = mul( unity_WorldToObject, float4( ase_vertex3Pos, 1 ) ).xyz;
			float clampResult280 = clamp( ( 1.0 - distance( worldToObj205.y , _Range2.y ) ) , 0.0 , 1.0 );
			float smoothstepResult202 = smoothstep( ( 1.0 - _FlowSoft ) , _FlowSoft , pow( ( temp_output_242_0 + ( tex2DNode170.r * pow( clampResult280 , _FlowRange2 ) ) ) , _FlowRange ));
			float FlowMask210 = saturate( smoothstepResult202 );
			float4 lerpResult216 = lerp( ( _BaseColor + EmissColor213 ) , _FogColor , saturate( FlowMask210 ));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_267_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 temp_cast_0 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch268 = temp_cast_0;
			#else
				float3 staticSwitch268 = temp_output_267_0;
			#endif
			float3 LightColor269 = staticSwitch268;
			float4 FinalColor220 = ( lerpResult216 * float4( LightColor269 , 0.0 ) );
			c.rgb = FinalColor220.rgb;
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
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
369;251;1322;768;-610.5248;309.2571;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;249;-8487.235,1438.211;Inherit;False;4171.583;1250.098;HorizonMask;29;154;224;208;153;128;127;120;126;119;107;125;124;106;123;112;110;113;109;122;70;99;69;100;101;74;68;104;141;75;HorizonMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;75;-8375.402,1679.605;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;141;-8344.201,1846.167;Inherit;False;Property;_SkyFogOffset;SkyFogOffset;16;0;Create;True;0;0;0;False;0;False;0,2,0;1,1.9,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenPosInputsNode;104;-8066.414,1946.792;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;68;-8437.235,1488.211;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-8025.66,1670.007;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;101;-7823.391,2088.106;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SwizzleNode;100;-7808.003,1948.298;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;69;-7834.592,1663.554;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;99;-7575.764,1953.836;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;122;-7491.116,2392.31;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-7375.891,1979.621;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;70;-7603.689,1659.388;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-7340.451,2193.648;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-7128.722,1985.112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;110;-7232.116,1681.135;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;123;-7287.012,2392.509;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;-6935.861,1795.855;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;124;-7103.886,2388.791;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;259;-4180.851,-2434.015;Inherit;False;4222.17;2614.664;EmissColor;43;258;256;254;257;251;255;213;129;134;217;223;155;222;156;152;133;138;135;131;165;146;130;164;171;136;137;114;132;157;158;142;163;162;144;161;160;115;145;159;143;261;262;281;EmissColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;107;-6694.975,1793.065;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;125;-6890.977,2392.84;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;132;-3898.023,-2384.015;Inherit;False;0;131;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;119;-6449.024,1960.502;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;137;-3860.845,-2108.833;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;6;0;Create;True;0;0;0;False;0;False;0,0;0.15,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;126;-6663.432,2390.303;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;136;-3364.094,-2150.812;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;120;-6132.977,1979.491;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-6424.522,2375.553;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-5776.756,2154.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;225;-9261.865,-874.3691;Inherit;False;4647.345;1430.753;FlowMask;31;210;211;202;228;230;231;186;244;247;246;245;250;196;242;226;238;243;170;205;180;151;150;148;149;179;147;280;282;283;284;285;FlowMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;131;-2990.982,-2158.009;Inherit;True;Property;_NoiseMask;NoiseMask;5;0;Create;True;0;0;0;False;0;False;-1;None;efccf27a2e7dd4a4c9a7b81f565bc7df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;153;-5386.515,2013.687;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;147;-8695.55,-605.8897;Inherit;False;Property;_EmissionTex3Panner;EmissionTex3Panner;14;0;Create;True;0;0;0;False;0;False;0,0,0;0,-0.2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;281;-2594.793,-2130.75;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;282;-8249.998,-441.4753;Inherit;False;281;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;149;-8496.288,-488.5467;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;150;-8363.444,-629.1369;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;148;-8499.107,-748.4977;Inherit;False;0;170;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;285;-8248.998,-344.4753;Inherit;False;Property;_Disturbstr;Disturbstr;13;0;Create;True;0;0;0;False;0;False;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;208;-5153.032,2019.71;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;151;-8177.466,-654.5984;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;224;-4951.417,2028.079;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;-8037.998,-396.4753;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;283;-7935.998,-575.4753;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;179;-9252.729,-261.4297;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-4654.745,2033.045;Inherit;True;HorizonMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-7677.57,-437.5854;Inherit;True;154;HorizonMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;143;-3954.367,-1684.458;Inherit;False;Property;_NebulaTexPanner;NebulaTexPanner;4;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;159;-4130.851,-790.2655;Inherit;False;Property;_EmissionTex2Panner;EmissionTex2Panner;10;0;Create;True;0;0;0;False;0;False;0,0,0;0,-0.5,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;180;-9045.175,2.607836;Inherit;False;Property;_Range2;Range2;20;0;Create;True;0;0;0;False;0;False;0,0.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;205;-9021.725,-266.6199;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;170;-7736.568,-674.9551;Inherit;True;Property;_EmissionTex3;EmissionTex3;12;0;Create;True;0;0;0;False;0;False;-1;None;392c171f5aa09c24bb0f9c8142722010;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;-7370.025,-553.7609;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;160;-3931.589,-672.9227;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;115;-3821.979,-1882.766;Inherit;False;0;114;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;162;-3798.748,-813.5127;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-3976.867,-974.175;Inherit;False;0;158;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;243;-8776.834,-85.96935;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;145;-3755.105,-1567.116;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;144;-3622.264,-1707.707;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;142;-3436.287,-1733.167;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;163;-3612.772,-838.9741;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;250;-6989.14,-701.6138;Inherit;False;FlowEmissColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;226;-8321.929,-88.66015;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;280;-8046.626,-70.16032;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-3034.996,-1624.932;Inherit;True;Property;_NebulaTex;NebulaTex;3;0;Create;True;0;0;0;False;0;False;-1;None;3433162ddc7ee6b4687996d52e67fac4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;257;-2392.77,-312.2432;Inherit;False;Property;_FlowEmissSoft;FlowEmissSoft;22;0;Create;True;0;0;0;False;0;False;0.7809411;0.914;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-8124.078,78.49085;Inherit;False;Property;_FlowRange2;FlowRange2;18;0;Create;True;0;0;0;False;0;False;0.9;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;-2370.254,-712.9656;Inherit;False;250;FlowEmissColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-3239.409,-559.312;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;11;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;255;-2388.623,-543.74;Inherit;False;Property;_FlowEmissRange;FlowEmissRange;21;0;Create;True;0;0;0;False;0;False;0.92;3.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;158;-3324.944,-862.506;Inherit;True;Property;_EmissionTex2;EmissionTex2;9;0;Create;True;0;0;0;False;0;False;-1;None;16697fe2c09b70e43b57089fb6f8c2f5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;258;-2052.782,-499.5591;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;254;-2115.48,-607.8677;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-2927.26,-798.0771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;130;-2689.021,-1721.622;Inherit;False;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;5;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;171;-3564.649,-1319.02;Inherit;False;0;146;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;246;-7748.722,-69.40617;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-2470.562,-1598.109;Inherit;False;Property;_StarIntensity;StarIntensity;7;0;Create;True;0;0;0;False;0;False;10;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-1626.475,-404.3172;Inherit;False;Property;_FlowEmissIntensity;FlowEmissIntensity;23;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-7344.253,-231.7854;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;256;-1813.592,-517.4507;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-2659.853,-838.4745;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;146;-3144.508,-1308.198;Inherit;True;Property;_EmissionTex;EmissionTex;8;0;Create;True;0;0;0;False;0;False;-1;None;88644092a973e7243934ef4deb86738d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;135;-2459.784,-1728.663;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-2236.776,-1744.165;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-7015.442,-166.0348;Inherit;False;Property;_FlowRange;FlowRange;17;0;Create;True;0;0;0;False;0;False;0.9;0.8;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-1401.623,-546.3567;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-2360.213,-1287.932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;244;-7081.307,-435.2946;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-6825.979,125.3623;Inherit;False;Property;_FlowSoft;FlowSoft;19;0;Create;True;0;0;0;False;0;False;0.9;1;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;222;-1420.964,-1652.039;Inherit;False;Property;_EmissColor;EmissColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.05,0.05,0.05,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;228;-6647.674,-342.8653;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;230;-6337.002,-190.4166;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-1369.002,-1463.892;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1277.957,-1189.066;Inherit;False;Property;_Intensity;Intensity;2;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;-888.5349,-1428.443;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-1025.942,-1069.824;Inherit;True;154;HorizonMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;263;-7150.601,-2073.237;Inherit;False;1525.385;680.1929;LightAtten;10;273;272;271;270;269;268;267;266;265;264;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;202;-5941.083,-171.0756;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;264;-7092.601,-1725.441;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;211;-5634.31,-160.6347;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;265;-7075.313,-1645.582;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-599.1385,-1395.283;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;213;-288.7136,-1408.219;Inherit;True;EmissColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;210;-5356.893,-169.685;Inherit;False;FlowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;248;260.6757,-2393.597;Inherit;False;2194.077;1176.943;FinalColor;10;220;275;216;274;237;87;218;219;215;214;FinalColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-6670.252,-1947.995;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;-6830.859,-1711.896;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;268;-6428.673,-1966.55;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;214;310.6757,-2343.597;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.0509804,0.0509804,0.0509804,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;219;310.6757,-2119.597;Inherit;False;213;EmissColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;630.6755,-1735.597;Inherit;True;210;FlowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;-6071.656,-1967.669;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;237;914.4149,-1737.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;710.6755,-1975.597;Inherit;False;Property;_FogColor;FogColor;15;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2784314,0.2784314,0.2784314,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;218;726.6755,-2199.597;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;1346.867,-1728.496;Inherit;False;269;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;216;1238.675,-2023.597;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;1750.783,-1996.453;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;1983.27,-2003.74;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;196;-8036.65,190.5822;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;-2868.712,-1063.35;Inherit;False;154;HorizonMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;270;-6517.258,-1692.936;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;271;-6277.354,-1714.043;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;273;-5858.219,-1679.961;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;272;-6122.406,-1681.727;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;1246.456,39.39398;Inherit;False;220;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1480.551,-190.5632;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Sky_Test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;74;0;68;0
WireConnection;74;1;75;0
WireConnection;74;2;141;0
WireConnection;100;0;104;0
WireConnection;69;0;74;0
WireConnection;99;0;100;0
WireConnection;99;1;101;0
WireConnection;109;0;99;0
WireConnection;109;1;104;2
WireConnection;70;0;69;0
WireConnection;112;0;109;0
WireConnection;112;1;113;0
WireConnection;110;0;70;0
WireConnection;123;0;122;0
WireConnection;106;0;110;0
WireConnection;106;1;112;0
WireConnection;124;0;123;0
WireConnection;107;0;106;0
WireConnection;125;0;124;0
WireConnection;119;0;107;0
WireConnection;126;0;125;0
WireConnection;136;0;132;0
WireConnection;136;2;137;0
WireConnection;120;0;119;0
WireConnection;127;0;126;0
WireConnection;127;1;126;0
WireConnection;128;0;120;0
WireConnection;128;1;127;0
WireConnection;131;1;136;0
WireConnection;153;0;128;0
WireConnection;281;0;131;1
WireConnection;149;0;147;3
WireConnection;150;0;147;1
WireConnection;150;1;147;2
WireConnection;208;0;153;0
WireConnection;151;0;148;0
WireConnection;151;2;150;0
WireConnection;151;1;149;0
WireConnection;224;0;208;0
WireConnection;284;0;282;0
WireConnection;284;1;285;0
WireConnection;283;0;151;0
WireConnection;283;1;284;0
WireConnection;154;0;224;0
WireConnection;205;0;179;0
WireConnection;170;1;283;0
WireConnection;242;0;170;1
WireConnection;242;1;238;0
WireConnection;160;0;159;3
WireConnection;162;0;159;1
WireConnection;162;1;159;2
WireConnection;243;0;205;2
WireConnection;243;1;180;2
WireConnection;145;0;143;3
WireConnection;144;0;143;1
WireConnection;144;1;143;2
WireConnection;142;0;115;0
WireConnection;142;2;144;0
WireConnection;142;1;145;0
WireConnection;163;0;161;0
WireConnection;163;2;162;0
WireConnection;163;1;160;0
WireConnection;250;0;242;0
WireConnection;226;0;243;0
WireConnection;280;0;226;0
WireConnection;114;1;142;0
WireConnection;158;1;163;0
WireConnection;258;0;257;0
WireConnection;254;0;251;0
WireConnection;254;1;255;0
WireConnection;164;0;158;1
WireConnection;164;1;157;0
WireConnection;130;0;114;0
WireConnection;246;0;280;0
WireConnection;246;1;245;0
WireConnection;247;0;170;1
WireConnection;247;1;246;0
WireConnection;256;0;254;0
WireConnection;256;1;258;0
WireConnection;256;2;257;0
WireConnection;165;0;164;0
WireConnection;165;1;114;1
WireConnection;146;1;171;0
WireConnection;135;0;130;0
WireConnection;133;0;131;1
WireConnection;133;1;135;0
WireConnection;133;2;138;0
WireConnection;261;0;256;0
WireConnection;261;1;262;0
WireConnection;152;0;146;1
WireConnection;152;1;165;0
WireConnection;244;0;242;0
WireConnection;244;1;247;0
WireConnection;228;0;244;0
WireConnection;228;1;186;0
WireConnection;230;0;231;0
WireConnection;134;0;133;0
WireConnection;134;1;114;0
WireConnection;134;2;152;0
WireConnection;134;3;261;0
WireConnection;217;0;134;0
WireConnection;217;1;129;0
WireConnection;217;2;222;0
WireConnection;202;0;228;0
WireConnection;202;1;230;0
WireConnection;202;2;231;0
WireConnection;211;0;202;0
WireConnection;223;0;217;0
WireConnection;223;1;155;0
WireConnection;213;0;223;0
WireConnection;210;0;211;0
WireConnection;267;0;264;0
WireConnection;267;1;265;1
WireConnection;268;1;267;0
WireConnection;268;0;266;0
WireConnection;269;0;268;0
WireConnection;237;0;215;0
WireConnection;218;0;214;0
WireConnection;218;1;219;0
WireConnection;216;0;218;0
WireConnection;216;1;87;0
WireConnection;216;2;237;0
WireConnection;275;0;216;0
WireConnection;275;1;274;0
WireConnection;220;0;275;0
WireConnection;270;0;267;0
WireConnection;271;0;270;0
WireConnection;271;1;270;1
WireConnection;273;0;272;0
WireConnection;272;0;271;0
WireConnection;272;1;270;2
WireConnection;0;13;221;0
ASEEND*/
//CHKSM=0E4DA4560D82A87D774F666CB101545F4B6F2B23