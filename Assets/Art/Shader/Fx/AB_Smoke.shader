// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Fx/AB_Smoke"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[Toggle(_UV2WTCONTORLOFFSET_ON)] _UV2WTContorlOffset("UV2WTContorlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_RampTex("RampTex", 2D) = "white" {}
		_FadeTex("FadeTex", 2D) = "white" {}
		_Noise_1("Noise_1", 2D) = "white" {}
		_NoiseInvers("NoiseInvers", Range( 0 , 1)) = 0
		_NoisePanner("NoisePanner", Vector) = (0,0,1,0)
		[HDR]_Color1("Color1", Color) = (1,0.6313726,0,0)
		[HDR]_Color2("Color2", Color) = (0.6981132,0.2220839,0.003292995,0)
		[HDR]_Color3("Color3", Color) = (0.03773582,0.01297998,0.006941968,0)
		_Invers1("Invers1", Range( 0 , 1)) = 0
		_Invers2("Invers2", Range( 0 , 1)) = 0
		_Invers3("Invers3", Range( 0 , 1)) = 0
		_DissHardness1("DissHardness1", Range( 0 , 0.99)) = 0
		_DissHardness2("DissHardness2", Range( 0 , 0.99)) = 0
		_DissHardness3("DissHardness3", Range( 0 , 0.99)) = 0
		[Toggle(_DISTURBON_ON)] _DisturbOn("DisturbOn", Float) = 0
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_DisturbPanner("DisturbPanner", Vector) = (0,0,1,0)
		_DisturbStr("DisturbStr", Float) = 0
		[Toggle(_UV2YCONTORLFLOW_ON)] _UV2YContorlFlow("UV2YContorlFlow", Float) = 0
		_FlowTex("FlowTex", 2D) = "white" {}
		_FlowStr("FlowStr", Range( 0 , 1.5)) = 0.5
		[Toggle(_SOFTPARTICLE_ON)] _SoftParticle("SoftParticle", Float) = 0
		_FadeRange("FadeRange", Float) = 1
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull [_CullMode]
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _UV2WTCONTORLOFFSET_ON
		#pragma shader_feature_local _UV2YCONTORLFLOW_ON
		#pragma shader_feature_local _DISTURBON_ON
		#pragma shader_feature_local _SOFTPARTICLE_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
			float4 uv2_texcoord2;
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

		uniform float _CullMode;
		uniform float _ZTestMode;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _FlowTex;
		uniform float4 _FlowTex_ST;
		uniform float _FlowStr;
		uniform sampler2D _Noise_1;
		uniform float3 _NoisePanner;
		uniform float4 _Noise_1_ST;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _DisturbStr;
		uniform float _NoiseInvers;
		uniform float _Invers3;
		uniform float _DissHardness3;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FadeRange;
		uniform sampler2D _FadeTex;
		uniform float4 _FadeTex_ST;
		uniform float4 _Color1;
		uniform float _Invers1;
		uniform float _DissHardness1;
		uniform float4 _Color2;
		uniform float _Invers2;
		uniform float _DissHardness2;
		uniform float4 _Color3;
		uniform sampler2D _RampTex;
		uniform float4 _RampTex_ST;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float VertexColorA154 = i.vertexColor.a;
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 temp_cast_0 = (0.0).xx;
			float UV2W195 = i.uv2_texcoord2.z;
			float UV2T197 = i.uv2_texcoord2.w;
			float2 appendResult198 = (float2(UV2W195 , UV2T197));
			#ifdef _UV2WTCONTORLOFFSET_ON
				float2 staticSwitch196 = appendResult198;
			#else
				float2 staticSwitch196 = temp_cast_0;
			#endif
			float2 UVOffset200 = staticSwitch196;
			float2 uv_FlowTex = i.uv_texcoord * _FlowTex_ST.xy + _FlowTex_ST.zw;
			float4 tex2DNode165 = tex2D( _FlowTex, uv_FlowTex );
			float2 appendResult166 = (float2(tex2DNode165.r , tex2DNode165.g));
			float2 FlowUV167 = appendResult166;
			#ifdef _UV2YCONTORLFLOW_ON
				float staticSwitch176 = i.uv2_texcoord2.y;
			#else
				float staticSwitch176 = 0.0;
			#endif
			float UV2Y135 = ( staticSwitch176 * _FlowStr );
			float2 lerpResult171 = lerp( ( uvs_MainTex.xy + UVOffset200 ) , FlowUV167 , UV2Y135);
			float MainTexA124 = tex2D( _MainTex, lerpResult171 ).r;
			float mulTime146 = _Time.y * _NoisePanner.z;
			float2 appendResult145 = (float2(_NoisePanner.x , _NoisePanner.y));
			float4 uvs_Noise_1 = i.uv_texcoord;
			uvs_Noise_1.xy = i.uv_texcoord.xy * _Noise_1_ST.xy + _Noise_1_ST.zw;
			float2 lerpResult174 = lerp( uvs_Noise_1.xy , FlowUV167 , UV2Y135);
			float2 panner142 = ( mulTime146 * appendResult145 + lerpResult174);
			float2 break223 = panner142;
			float mulTime211 = _Time.y * _DisturbPanner.z;
			float2 appendResult212 = (float2(_DisturbPanner.x , _DisturbPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner214 = ( mulTime211 * appendResult212 + uvs_DisturbTex.xy);
			#ifdef _DISTURBON_ON
				float staticSwitch220 = ( tex2D( _DisturbTex, panner214 ).r * _DisturbStr );
			#else
				float staticSwitch220 = 0.0;
			#endif
			float DisturbColor221 = staticSwitch220;
			float2 appendResult226 = (float2(break223.x , ( break223.y + DisturbColor221 )));
			float4 tex2DNode70 = tex2D( _Noise_1, appendResult226 );
			float lerpResult206 = lerp( tex2DNode70.r , ( 1.0 - tex2DNode70.r ) , _NoiseInvers);
			float Noise92 = lerpResult206;
			float temp_output_3_0_g7 = Noise92;
			float lerpResult5_g7 = lerp( temp_output_3_0_g7 , ( 1.0 - temp_output_3_0_g7 ) , _Invers3);
			float UV2X134 = i.uv2_texcoord2.x;
			float Hardness3163 = _DissHardness3;
			float temp_output_8_0_g7 = Hardness3163;
			float temp_output_71_0 = ( MainTexA124 * saturate( ( ( ( ( lerpResult5_g7 + 1.0 ) - ( ( 1.0 - (-0.5 + (UV2X134 - 0.0) * (1.0 - -0.5) / (1.0 - 0.0)) ) * ( ( 1.0 - temp_output_8_0_g7 ) + 1.0 ) ) ) - temp_output_8_0_g7 ) / ( temp_output_8_0_g7 - 1.0 ) ) ) );
			float Alpha128 = temp_output_71_0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth187 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth187 = abs( ( screenDepth187 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FadeRange ) );
			#ifdef _SOFTPARTICLE_ON
				float staticSwitch188 = distanceDepth187;
			#else
				float staticSwitch188 = 1.0;
			#endif
			float SoftParticle190 = saturate( staticSwitch188 );
			float2 uv_FadeTex = i.uv_texcoord * _FadeTex_ST.xy + _FadeTex_ST.zw;
			float temp_output_3_0_g8 = Noise92;
			float lerpResult5_g8 = lerp( temp_output_3_0_g8 , ( 1.0 - temp_output_3_0_g8 ) , _Invers1);
			float UV1W131 = i.uv_texcoord.z;
			float Hardness195 = _DissHardness1;
			float temp_output_8_0_g8 = Hardness195;
			float temp_output_109_0 = ( MainTexA124 * saturate( ( ( ( ( lerpResult5_g8 + 1.0 ) - ( ( 1.0 - (-0.5 + (UV1W131 - 0.0) * (1.0 - -0.5) / (1.0 - 0.0)) ) * ( ( 1.0 - temp_output_8_0_g8 ) + 1.0 ) ) ) - temp_output_8_0_g8 ) / ( temp_output_8_0_g8 - 1.0 ) ) ) );
			float3 VertexColorRGB155 = (i.vertexColor).rgb;
			float temp_output_3_0_g6 = Noise92;
			float lerpResult5_g6 = lerp( temp_output_3_0_g6 , ( 1.0 - temp_output_3_0_g6 ) , _Invers2);
			float UV1T132 = i.uv_texcoord.w;
			float Hardness2161 = _DissHardness2;
			float temp_output_8_0_g6 = Hardness2161;
			float temp_output_84_0 = ( ( MainTexA124 * saturate( ( ( ( ( lerpResult5_g6 + 1.0 ) - ( ( 1.0 - (-0.5 + (UV1T132 - 0.0) * (1.0 - -0.5) / (1.0 - 0.0)) ) * ( ( 1.0 - temp_output_8_0_g6 ) + 1.0 ) ) ) - temp_output_8_0_g6 ) / ( temp_output_8_0_g6 - 1.0 ) ) ) ) + 0.0 );
			float2 uv_RampTex = i.uv_texcoord * _RampTex_ST.xy + _RampTex_ST.zw;
			c.rgb = ( ( ( ( _Color1 * temp_output_109_0 * float4( VertexColorRGB155 , 0.0 ) ) * temp_output_109_0 ) + ( saturate( ( 1.0 - temp_output_109_0 ) ) * ( ( ( _Color2 * temp_output_84_0 * float4( VertexColorRGB155 , 0.0 ) ) * temp_output_84_0 ) + ( saturate( ( 1.0 - temp_output_84_0 ) ) * ( _Color3 * temp_output_71_0 * float4( VertexColorRGB155 , 0.0 ) ) ) ) ) ) * tex2D( _RampTex, uv_RampTex ) ).rgb;
			c.a = saturate( ( VertexColorA154 * Alpha128 * SoftParticle190 * tex2D( _FadeTex, uv_FadeTex ).r ) );
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
100;222;1433;788;5765.016;-3116.897;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;136;-6254.367,-193.0191;Inherit;False;1281.456;1063.931;Comment;16;200;196;199;198;197;195;176;133;135;179;131;134;132;130;180;177;UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;209;-6245.52,3241.755;Inherit;False;1861.461;712.423;DisturbColor;11;221;220;219;218;217;215;214;213;212;211;210;DisturbColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;175;-6012.023,1581.095;Inherit;False;881.2886;414.4147;Comment;3;167;166;165;FlowMap;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;133;-6228.206,150.0338;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;177;-6001.582,220.7016;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;210;-6141.295,3545.088;Inherit;False;Property;_DisturbPanner;DisturbPanner;22;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;165;-5962.023,1631.095;Inherit;True;Property;_FlowTex;FlowTex;25;0;Create;True;0;0;0;False;0;False;-1;None;563f6c64f71c1cc4dac2cd746b238513;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;180;-5875.501,346.6575;Inherit;False;Property;_FlowStr;FlowStr;26;0;Create;True;0;0;0;False;0;False;0.5;1.5;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;213;-6088.112,3384.845;Inherit;False;0;215;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;211;-5893.296,3652.088;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;176;-5858.582,230.7016;Inherit;False;Property;_UV2YContorlFlow;UV2YContorlFlow;24;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;212;-5890.296,3498.088;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;214;-5708.615,3466.226;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;166;-5597.283,1661.161;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-5560.503,250.6581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-5382.878,244.6728;Inherit;False;UV2Y;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-5359.283,1658.161;Inherit;False;FlowUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-5348.36,3672.425;Inherit;False;Property;_DisturbStr;DisturbStr;23;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;215;-5469.48,3454.38;Inherit;True;Property;_DisturbTex;DisturbTex;21;0;Create;True;0;0;0;False;0;False;-1;None;ecf5ddd689bf9984d8422de99b50f312;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;173;-5611.185,-988.636;Inherit;False;135;UV2Y;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-5092.284,3403.355;Inherit;False;Constant;_0;0;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;144;-5507.478,-630.1577;Inherit;False;Property;_NoisePanner;NoisePanner;9;0;Create;True;0;0;0;False;0;False;0,0,1;-1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-5621.225,-862.2694;Inherit;False;0;70;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;169;-5608.688,-1140.667;Inherit;False;167;FlowUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-5115.884,3548.131;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;146;-5282.526,-498.7993;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;220;-4904.218,3490.984;Inherit;False;Property;_DisturbOn;DisturbOn;20;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;174;-5264.323,-888.6711;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;145;-5246.526,-602.7996;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;142;-5038.75,-769.9462;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-5952.615,566.3024;Inherit;False;UV2W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;221;-4663.342,3489.887;Inherit;False;DisturbColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-5959.221,660.6996;Inherit;False;UV2T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;-4952.011,-610.381;Inherit;False;221;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;223;-4846.388,-727.9944;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;199;-5800.221,458.6993;Inherit;False;Constant;_Float2;Float 2;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;198;-5689.223,626.6996;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;196;-5507.832,531.4775;Inherit;False;Property;_UV2WTContorlOffset;UV2WTContorlOffset;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;227;-4714.388,-662.2943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;226;-4589.388,-725.9944;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-5217.296,532.8274;Inherit;False;UVOffset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-5783.036,-1524.479;Inherit;False;0;73;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;201;-5780.657,-1340.356;Inherit;False;200;UVOffset;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;70;-4414.895,-746.802;Inherit;True;Property;_Noise_1;Noise_1;7;0;Create;True;0;0;0;False;0;False;-1;79731f369eb8f3148bc2e10bef525fa2;e7ebdc83168a38649b3b2ebed4b6b00d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;207;-4113.973,-631.5313;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-4169.973,-548.5313;Inherit;False;Property;_NoiseInvers;NoiseInvers;8;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;-5478.745,-1393.783;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;130;-6204.367,-143.0192;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;206;-3866.973,-714.5313;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;171;-5300.066,-1210.823;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-4404.023,-301.2418;Inherit;False;Property;_DissHardness2;DissHardness2;17;0;Create;True;0;0;0;False;0;False;0;0.076;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-4083.596,-305.4431;Inherit;False;Hardness2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3684.231,-721.7889;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-5823.207,-10.96613;Inherit;False;UV1T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-4329.798,-1098.683;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;-1;aac6f6954ba231041b9193611de33f96;421f947f369de624bb475c5213c4ddd8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-3836.438,-1055.21;Inherit;False;MainTexA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-4415.338,-192.6708;Inherit;False;Property;_DissHardness3;DissHardness3;18;0;Create;True;0;0;0;False;0;False;0;0.163;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;156;-6000.253,1164.201;Inherit;False;685.4014;264;Comment;4;148;154;153;155;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-2952.421,678.2302;Inherit;False;92;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-2915.633,869.0583;Inherit;False;132;UV1T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2862.524,1040.352;Inherit;False;161;Hardness2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3024.042,769.4344;Inherit;False;Property;_Invers2;Invers2;14;0;Create;True;0;0;0;False;0;False;0;0.012;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-4094.911,-196.8721;Inherit;False;Hardness3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;148;-5950.253,1220.71;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;126;-2571.963,570.7969;Inherit;False;124;MainTexA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-4414.464,-415.1233;Inherit;False;Property;_DissHardness1;DissHardness1;16;0;Create;True;0;0;0;False;0;False;0;0.037;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;90;-2652.015,705.2108;Inherit;False;Dissolution;-1;;6;8ed0a8fdbfe80554382ce257577aff19;0;4;3;FLOAT;0;False;7;FLOAT;0;False;4;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-5825.56,117.4899;Inherit;False;UV2X;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-4094.037,-419.3246;Inherit;False;Hardness1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;-3305.043,2319.685;Inherit;False;163;Hardness3;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;184;-6006.566,2130.768;Inherit;False;1080.439;324.1655;SoftParticle;6;190;189;188;187;186;185;SoftParticle;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-2272,560;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-3407.927,2112.026;Inherit;False;Property;_Invers3;Invers3;15;0;Create;True;0;0;0;False;0;False;0;0.111;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-5823.207,-103.9663;Inherit;False;UV1W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-3310.854,2214.038;Inherit;False;134;UV2X;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;153;-5760.851,1214.201;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-3334.094,1999.053;Inherit;False;92;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-2859.37,1795.155;Inherit;False;124;MainTexA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-1319.4,-12.61329;Inherit;False;95;Hardness1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-5945.228,2318.747;Inherit;False;Property;_FadeRange;FadeRange;28;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-2031.881,600.6828;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1445.918,-222.5306;Inherit;False;Property;_Invers1;Invers1;13;0;Create;True;0;0;0;False;0;False;0;0.113;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-1374.297,-313.7348;Inherit;False;92;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-5545.851,1216.201;Inherit;False;VertexColorRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;80;-2971.059,2073.614;Inherit;False;Dissolution;-1;;7;8ed0a8fdbfe80554382ce257577aff19;0;4;3;FLOAT;0;False;7;FLOAT;0;False;4;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-1360.6,-130.8295;Inherit;False;131;UV1W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;187;-5765.703,2298.933;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;81;-2633.24,1412.297;Inherit;False;Property;_Color3;Color3;12;1;[HDR];Create;True;0;0;0;False;0;False;0.03773582,0.01297998,0.006941968,0;4,0,1.319372,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;127;-1069.297,-431.0414;Inherit;False;124;MainTexA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-2613.281,1607.948;Inherit;False;155;VertexColorRGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-5736.615,2203.449;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;85;-2002.46,256.7271;Inherit;False;Property;_Color2;Color2;11;1;[HDR];Create;True;0;0;0;False;0;False;0.6981132,0.2220839,0.003292995,0;0,2.963207,3.159143,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;101;-1611.546,760.1829;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;104;-1073.891,-286.7542;Inherit;False;Dissolution;-1;;8;8ed0a8fdbfe80554382ce257577aff19;0;4;3;FLOAT;0;False;7;FLOAT;0;False;4;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;-1982.771,441.9177;Inherit;False;155;VertexColorRGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2620.246,1802.361;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-2243.211,1663.56;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;141;-1436.714,916.0617;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1629.404,409.1273;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-707.4455,-400.6511;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;188;-5501.969,2210.694;Inherit;False;Property;_SoftParticle;SoftParticle;27;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;189;-5266.725,2231.165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1283.918,1011.422;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;110;-651.2429,-769.3254;Inherit;False;Property;_Color1;Color1;10;1;[HDR];Create;True;0;0;0;False;0;False;1,0.6313726,0,0;9.115936,20.0636,24.18255,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1280.365,562.5497;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;114;-323.437,-199.3037;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-670.5981,-580.5547;Inherit;False;155;VertexColorRGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-224.4993,-581.2579;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;140;-81.63374,-103.3947;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-2243.779,1948.776;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-908.3223,819.5129;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-5716.851,1312.201;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-5133.22,2213.304;Inherit;False;SoftParticle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;635.3334,-841.3742;Inherit;False;154;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;116.8678,-420.0757;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;205;549.6937,-526.304;Inherit;True;Property;_FadeTex;FadeTex;6;0;Create;True;0;0;0;False;0;False;-1;None;a1b8d8791b5ee394ca2a09a825786114;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;191;631.4885,-652.3434;Inherit;False;190;SoftParticle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;91.08042,-24.79519;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;640.668,-743.3154;Inherit;False;128;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;1036.02,-741.3054;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;387.7985,-242.6615;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;203;663.4601,-70.03197;Inherit;True;Property;_RampTex;RampTex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;181;-6012.258,2595.576;Inherit;False;448;277.753;Comment;2;183;182;Enum;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-3372.54,937.2712;Inherit;False;Constant;_Dissolution2;Dissolution2;15;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-3270.243,1027.399;Inherit;False;117;Dissolution;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;159;1272.143,-457.8676;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-5962.258,2743.329;Inherit;False;Property;_ZTestMode;ZTestMode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;1080.507,-244.3561;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;-1503.824,-121.4896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;-3064.243,936.399;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-1709.824,-30.48962;Inherit;False;117;Dissolution;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-4010.002,-1047.534;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-4089.23,-70.99559;Inherit;False;Dissolution;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-5958.779,2645.575;Inherit;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-4414.63,-71.44167;Inherit;False;Property;_Dissolution;Dissolution;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-3539.244,2189.211;Inherit;False;117;Dissolution;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1812.121,-120.6174;Inherit;False;Constant;_Dissolution1;Dissolution1;15;0;Create;True;0;0;0;False;0;False;0.4;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1424.235,-565.5914;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Fx/AB_Smoke;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;7;True;182;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;True;183;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;211;0;210;3
WireConnection;176;1;177;0
WireConnection;176;0;133;2
WireConnection;212;0;210;1
WireConnection;212;1;210;2
WireConnection;214;0;213;0
WireConnection;214;2;212;0
WireConnection;214;1;211;0
WireConnection;166;0;165;1
WireConnection;166;1;165;2
WireConnection;179;0;176;0
WireConnection;179;1;180;0
WireConnection;135;0;179;0
WireConnection;167;0;166;0
WireConnection;215;1;214;0
WireConnection;219;0;215;1
WireConnection;219;1;217;0
WireConnection;146;0;144;3
WireConnection;220;1;218;0
WireConnection;220;0;219;0
WireConnection;174;0;143;0
WireConnection;174;1;169;0
WireConnection;174;2;173;0
WireConnection;145;0;144;1
WireConnection;145;1;144;2
WireConnection;142;0;174;0
WireConnection;142;2;145;0
WireConnection;142;1;146;0
WireConnection;195;0;133;3
WireConnection;221;0;220;0
WireConnection;197;0;133;4
WireConnection;223;0;142;0
WireConnection;198;0;195;0
WireConnection;198;1;197;0
WireConnection;196;1;199;0
WireConnection;196;0;198;0
WireConnection;227;0;223;1
WireConnection;227;1;222;0
WireConnection;226;0;223;0
WireConnection;226;1;227;0
WireConnection;200;0;196;0
WireConnection;70;1;226;0
WireConnection;207;0;70;1
WireConnection;202;0;170;0
WireConnection;202;1;201;0
WireConnection;206;0;70;1
WireConnection;206;1;207;0
WireConnection;206;2;208;0
WireConnection;171;0;202;0
WireConnection;171;1;169;0
WireConnection;171;2;173;0
WireConnection;161;0;160;0
WireConnection;92;0;206;0
WireConnection;132;0;130;4
WireConnection;73;1;171;0
WireConnection;124;0;73;1
WireConnection;163;0;162;0
WireConnection;90;3;94;0
WireConnection;90;7;87;0
WireConnection;90;4;138;0
WireConnection;90;8;96;0
WireConnection;134;0;133;1
WireConnection;95;0;76;0
WireConnection;91;0;126;0
WireConnection;91;1;90;0
WireConnection;131;0;130;3
WireConnection;153;0;148;0
WireConnection;84;0;91;0
WireConnection;155;0;153;0
WireConnection;80;3;93;0
WireConnection;80;7;75;0
WireConnection;80;4;137;0
WireConnection;80;8;164;0
WireConnection;187;0;185;0
WireConnection;101;0;84;0
WireConnection;104;3;106;0
WireConnection;104;7;108;0
WireConnection;104;4;139;0
WireConnection;104;8;107;0
WireConnection;71;0;125;0
WireConnection;71;1;80;0
WireConnection;82;0;81;0
WireConnection;82;1;71;0
WireConnection;82;2;192;0
WireConnection;141;0;101;0
WireConnection;86;0;85;0
WireConnection;86;1;84;0
WireConnection;86;2;193;0
WireConnection;109;0;127;0
WireConnection;109;1;104;0
WireConnection;188;1;186;0
WireConnection;188;0;187;0
WireConnection;189;0;188;0
WireConnection;102;0;141;0
WireConnection;102;1;82;0
WireConnection;98;0;86;0
WireConnection;98;1;84;0
WireConnection;114;0;109;0
WireConnection;111;0;110;0
WireConnection;111;1;109;0
WireConnection;111;2;194;0
WireConnection;140;0;114;0
WireConnection;128;0;71;0
WireConnection;99;0;98;0
WireConnection;99;1;102;0
WireConnection;154;0;148;4
WireConnection;190;0;189;0
WireConnection;113;0;111;0
WireConnection;113;1;109;0
WireConnection;115;0;140;0
WireConnection;115;1;99;0
WireConnection;158;0;157;0
WireConnection;158;1;129;0
WireConnection;158;2;191;0
WireConnection;158;3;205;1
WireConnection;116;0;113;0
WireConnection;116;1;115;0
WireConnection;159;0;158;0
WireConnection;204;0;116;0
WireConnection;204;1;203;0
WireConnection;122;0;123;0
WireConnection;122;1;121;0
WireConnection;120;0;89;0
WireConnection;120;1;119;0
WireConnection;117;0;74;0
WireConnection;0;9;159;0
WireConnection;0;13;204;0
ASEEND*/
//CHKSM=22E6879B5D317304061552693931B82D2985935E