// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sky_Test"
{
	Properties
	{
		_FogColor("FogColor", Color) = (0,0,0,0)
		_NebulaTex("NebulaTex", 2D) = "white" {}
		_NebulaTexPanner("NebulaTexPanner", Vector) = (0,0,0,0)
		_Intensity("Intensity", Float) = 0
		_NoiseMask("NoiseMask", 2D) = "white" {}
		_NoiseSpeed("NoiseSpeed", Vector) = (0,0,0,0)
		_StarIntensity("StarIntensity", Float) = 10
		_SkyFogOffset("SkyFogOffset", Vector) = (0,2,0,0)
		_EmissionTex("EmissionTex", 2D) = "black" {}
		_EmissionTex2("EmissionTex2", 2D) = "white" {}
		_EmissionTex2Panner("EmissionTex2Panner", Vector) = (0,0,0,0)
		_EmissionIntensity("EmissionIntensity", Float) = 1
		_EmissionTex3("EmissionTex3", 2D) = "white" {}
		_EmissionTex3Panner("EmissionTex3Panner", Vector) = (0,0,0,0)
		_MaskPower("MaskPower", Float) = 1
		_Range("Range", Float) = 0.9
		_HoriazonGlow("HoriazonGlow", Float) = 1
		_Float2("Float 2", Float) = 1.16
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 worldPos;
			float4 screenPos;
		};

		uniform float4 _FogColor;
		uniform sampler2D _NoiseMask;
		uniform float2 _NoiseSpeed;
		uniform float4 _NoiseMask_ST;
		uniform sampler2D _NebulaTex;
		uniform float3 _NebulaTexPanner;
		uniform float4 _NebulaTex_ST;
		uniform float _StarIntensity;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform float3 _SkyFogOffset;
		uniform sampler2D _EmissionTex2;
		uniform float3 _EmissionTex2Panner;
		uniform float4 _EmissionTex2_ST;
		uniform float _EmissionIntensity;
		uniform float _Float2;
		uniform sampler2D _EmissionTex3;
		uniform float3 _EmissionTex3Panner;
		uniform float4 _EmissionTex3_ST;
		uniform float _MaskPower;
		uniform float _Range;
		uniform float _HoriazonGlow;
		uniform float _Intensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_NoiseMask = i.uv_texcoord * _NoiseMask_ST.xy + _NoiseMask_ST.zw;
			float2 panner136 = ( 1.0 * _Time.y * _NoiseSpeed + uv_NoiseMask);
			float mulTime145 = _Time.y * _NebulaTexPanner.z;
			float2 appendResult144 = (float2(_NebulaTexPanner.x , _NebulaTexPanner.y));
			float2 uv_NebulaTex = i.uv_texcoord * _NebulaTex_ST.xy + _NebulaTex_ST.zw;
			float2 panner142 = ( mulTime145 * appendResult144 + uv_NebulaTex);
			float4 tex2DNode114 = tex2D( _NebulaTex, panner142 );
			float4 saferPower130 = abs( tex2DNode114 );
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
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
			float HorizonMask154 = saturate( ( ( 1.0 - smoothstepResult119 ) * ( temp_output_126_0 * temp_output_126_0 ) ) );
			float mulTime160 = _Time.y * _EmissionTex2Panner.z;
			float2 appendResult162 = (float2(_EmissionTex2Panner.x , _EmissionTex2Panner.y));
			float2 uv_EmissionTex2 = i.uv_texcoord * _EmissionTex2_ST.xy + _EmissionTex2_ST.zw;
			float2 panner163 = ( mulTime160 * appendResult162 + uv_EmissionTex2);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 worldToObj205 = mul( unity_WorldToObject, float4( ase_vertex3Pos, 1 ) ).xyz;
			float dotResult181 = dot( worldToObj205.y , 1 );
			float smoothstepResult202 = smoothstep( 0.0 , _Float2 , dotResult181);
			float temp_output_196_0 = saturate( smoothstepResult202 );
			float mulTime149 = _Time.y * _EmissionTex3Panner.z;
			float2 appendResult150 = (float2(_EmissionTex3Panner.x , _EmissionTex3Panner.y));
			float2 uv_EmissionTex3 = i.uv_texcoord * _EmissionTex3_ST.xy + _EmissionTex3_ST.zw;
			float2 panner151 = ( mulTime149 * appendResult150 + uv_EmissionTex3);
			float4 tex2DNode170 = tex2D( _EmissionTex3, panner151 );
			float lerpResult198 = lerp( temp_output_196_0 , ( ( tex2DNode170.r * ( tex2DNode170.r * temp_output_196_0 ) ) + ( 1.0 - temp_output_196_0 ) ) , 2.34);
			float4 temp_cast_0 = (clampResult107).xxxx;
			float4 lerpResult118 = lerp( ( ( tex2D( _NoiseMask, panner136 ).r * max( pow( saferPower130 , 5.0 ) , float4( 0,0,0,0 ) ) * _StarIntensity ) + tex2DNode114 + ( ( tex2D( _EmissionTex, uv_EmissionTex ).r * HorizonMask154 * ( ( tex2D( _EmissionTex2, panner163 ).r * _EmissionIntensity ) + tex2DNode114.r ) ) + ( saturate( ( pow( lerpResult198 , _MaskPower ) * _Range * 0.1 ) ) * _HoriazonGlow ) ) ) , temp_cast_0 , HorizonMask154);
			o.Emission = ( _FogColor * lerpResult118 * _Intensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
-1658;129;1599;826;4539.566;-358.3725;1;True;True
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;75;-3071.43,1157.214;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenPosInputsNode;104;-2762.439,1424.4;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;68;-3133.263,965.8196;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;141;-3040.228,1323.775;Inherit;False;Property;_SkyFogOffset;SkyFogOffset;7;0;Create;True;0;0;0;False;0;False;0,2,0;8.55,9.48,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;100;-2504.028,1425.906;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-2721.685,1147.616;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;101;-2519.416,1565.715;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PosVertexDataNode;179;-4166.57,462.5627;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;180;-4062.389,758.4555;Inherit;False;Constant;_Vector0;Vector 0;17;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;69;-2530.617,1141.163;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;205;-3924.566,466.3725;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;147;-4166.145,119.335;Inherit;False;Property;_EmissionTex3Panner;EmissionTex3Panner;13;0;Create;True;0;0;0;False;0;False;0,0,0;0,-0.2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;99;-2271.789,1431.445;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;149;-3966.883,236.678;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-3665.368,863.5878;Inherit;False;Property;_Float2;Float 2;17;0;Create;True;0;0;0;False;0;False;1.16;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;148;-3969.703,-23.27287;Inherit;False;0;170;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;181;-3838.942,641.503;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-2071.916,1457.229;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;122;-2187.141,1869.917;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;113;-2091.476,1576.255;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;70;-2183.715,1140.997;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;150;-3834.041,96.08781;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;123;-1983.037,1870.116;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;110;-1928.141,1158.743;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1888.747,1455.721;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;202;-3509.398,687.4934;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;151;-3648.065,70.62636;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;124;-1799.911,1866.398;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;196;-3310.886,646.399;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;170;-3436.922,65.40317;Inherit;True;Property;_EmissionTex3;EmissionTex3;12;0;Create;True;0;0;0;False;0;False;-1;None;392c171f5aa09c24bb0f9c8142722010;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;-1631.886,1273.463;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;125;-1587.002,1870.447;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-3072.346,331.4359;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;107;-1391,1270.674;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;119;-1145.05,1438.111;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;126;-1359.457,1867.91;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;159;-3059.201,-199.4839;Inherit;False;Property;_EmissionTex2Panner;EmissionTex2Panner;10;0;Create;True;0;0;0;False;0;False;0,0,0;0,-0.5,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;182;-2832.297,467.7689;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-2873.874,165.4753;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;188;-2582.133,422.1942;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;120;-829.0013,1457.099;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1120.548,1853.16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;-2410.618,814.2874;Inherit;False;Constant;_Float1;Float 1;17;0;Create;True;0;0;0;False;0;False;2.34;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-2926.813,-397.7911;Inherit;False;0;158;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;162;-2727.098,-222.7311;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;143;-2882.717,-1093.677;Inherit;False;Property;_NebulaTexPanner;NebulaTexPanner;2;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;160;-2859.939,-82.14105;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;198;-2135.512,649.8307;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;163;-2541.122,-248.1925;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;115;-2750.329,-1291.985;Inherit;False;0;114;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;145;-2683.455,-976.3344;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;144;-2550.614,-1116.925;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-378.7805,1504.107;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-2070.119,892.6251;Inherit;False;Property;_MaskPower;MaskPower;14;0;Create;True;0;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;153;-82.53898,1491.295;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;142;-2364.637,-1142.386;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-1769.88,1032.396;Inherit;False;Constant;_Float3;Float 3;18;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;158;-2253.294,-271.7244;Inherit;True;Property;_EmissionTex2;EmissionTex2;9;0;Create;True;0;0;0;False;0;False;-1;None;16697fe2c09b70e43b57089fb6f8c2f5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;186;-1831.64,945.6849;Inherit;False;Property;_Range;Range;15;0;Create;True;0;0;0;False;0;False;0.9;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-2222.691,-9.728552;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;11;0;Create;True;0;0;0;False;0;False;1;80;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;174;-1821.464,671.9251;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;134.562,1489.104;Inherit;True;HorizonMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;171;-2492.999,-728.2383;Inherit;False;0;146;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;114;-1963.346,-1034.15;Inherit;True;Property;_NebulaTex;NebulaTex;1;0;Create;True;0;0;0;False;0;False;-1;None;3433162ddc7ee6b4687996d52e67fac4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;132;-2826.373,-1793.233;Inherit;False;0;131;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-1531.993,722.6107;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;137;-2789.195,-1518.051;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;5;0;Create;True;0;0;0;False;0;False;0,0;0.15,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-1855.61,-207.2955;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-1588.202,-247.6929;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;183;-1389.265,709.3259;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-1529.117,1003.892;Inherit;False;Property;_HoriazonGlow;HoriazonGlow;16;0;Create;True;0;0;0;False;0;False;1;3.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;130;-1617.37,-1130.841;Inherit;False;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;5;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;146;-2072.858,-717.4164;Inherit;True;Property;_EmissionTex;EmissionTex;8;0;Create;True;0;0;0;False;0;False;-1;None;88644092a973e7243934ef4deb86738d;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;156;-1797.062,-472.5685;Inherit;False;154;HorizonMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;136;-2292.443,-1560.03;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;131;-1919.332,-1567.227;Inherit;True;Property;_NoiseMask;NoiseMask;4;0;Create;True;0;0;0;False;0;False;-1;None;efccf27a2e7dd4a4c9a7b81f565bc7df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-1398.911,-1007.328;Inherit;False;Property;_StarIntensity;StarIntensity;6;0;Create;True;0;0;0;False;0;False;10;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-1157.051,778.7057;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;135;-1388.134,-1137.882;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1305.717,-667.7426;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-1131.898,-672.3543;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1165.126,-1153.383;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-926.3905,-864.1176;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-78.95869,74.28197;Inherit;False;154;HorizonMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;556.5087,-219.1381;Inherit;False;Property;_FogColor;FogColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4111137,0.2728729,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;118;276.0061,-0.3703301;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;129;435.8783,239.0162;Inherit;False;Property;_Intensity;Intensity;3;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;204;-4228.566,576.3726;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;200;-3459.086,954.1503;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;189;-2463.801,69.76692;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;933.8846,-121.531;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1492.085,-14.66682;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sky_Test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;100;0;104;0
WireConnection;74;0;68;0
WireConnection;74;1;75;0
WireConnection;74;2;141;0
WireConnection;69;0;74;0
WireConnection;205;0;179;0
WireConnection;99;0;100;0
WireConnection;99;1;101;0
WireConnection;149;0;147;3
WireConnection;181;0;205;2
WireConnection;181;1;180;2
WireConnection;109;0;99;0
WireConnection;109;1;104;2
WireConnection;70;0;69;0
WireConnection;150;0;147;1
WireConnection;150;1;147;2
WireConnection;123;0;122;0
WireConnection;110;0;70;0
WireConnection;112;0;109;0
WireConnection;112;1;113;0
WireConnection;202;0;181;0
WireConnection;202;2;201;0
WireConnection;151;0;148;0
WireConnection;151;2;150;0
WireConnection;151;1;149;0
WireConnection;124;0;123;0
WireConnection;196;0;202;0
WireConnection;170;1;151;0
WireConnection;106;0;110;0
WireConnection;106;1;112;0
WireConnection;125;0;124;0
WireConnection;195;0;170;1
WireConnection;195;1;196;0
WireConnection;107;0;106;0
WireConnection;119;0;107;0
WireConnection;126;0;125;0
WireConnection;182;0;196;0
WireConnection;192;0;170;1
WireConnection;192;1;195;0
WireConnection;188;0;192;0
WireConnection;188;1;182;0
WireConnection;120;0;119;0
WireConnection;127;0;126;0
WireConnection;127;1;126;0
WireConnection;162;0;159;1
WireConnection;162;1;159;2
WireConnection;160;0;159;3
WireConnection;198;0;196;0
WireConnection;198;1;188;0
WireConnection;198;2;199;0
WireConnection;163;0;161;0
WireConnection;163;2;162;0
WireConnection;163;1;160;0
WireConnection;145;0;143;3
WireConnection;144;0;143;1
WireConnection;144;1;143;2
WireConnection;128;0;120;0
WireConnection;128;1;127;0
WireConnection;153;0;128;0
WireConnection;142;0;115;0
WireConnection;142;2;144;0
WireConnection;142;1;145;0
WireConnection;158;1;163;0
WireConnection;174;0;198;0
WireConnection;174;1;175;0
WireConnection;154;0;153;0
WireConnection;114;1;142;0
WireConnection;185;0;174;0
WireConnection;185;1;186;0
WireConnection;185;2;203;0
WireConnection;164;0;158;1
WireConnection;164;1;157;0
WireConnection;165;0;164;0
WireConnection;165;1;114;1
WireConnection;183;0;185;0
WireConnection;130;0;114;0
WireConnection;146;1;171;0
WireConnection;136;0;132;0
WireConnection;136;2;137;0
WireConnection;131;1;136;0
WireConnection;187;0;183;0
WireConnection;187;1;169;0
WireConnection;135;0;130;0
WireConnection;152;0;146;1
WireConnection;152;1;156;0
WireConnection;152;2;165;0
WireConnection;176;0;152;0
WireConnection;176;1;187;0
WireConnection;133;0;131;1
WireConnection;133;1;135;0
WireConnection;133;2;138;0
WireConnection;134;0;133;0
WireConnection;134;1;114;0
WireConnection;134;2;176;0
WireConnection;118;0;134;0
WireConnection;118;1;107;0
WireConnection;118;2;155;0
WireConnection;200;1;201;0
WireConnection;86;0;87;0
WireConnection;86;1;118;0
WireConnection;86;2;129;0
WireConnection;0;2;86;0
ASEEND*/
//CHKSM=9F0192E595A17C0133C6D306BDA3818A43EFCD3F