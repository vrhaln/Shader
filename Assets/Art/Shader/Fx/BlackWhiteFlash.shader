// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Fx/BlackWhiteFlash"
{
	Properties
	{
		[Toggle(_UV1_WCONTORLREVERSE_ON)] _UV1_WContorlReverse("UV1_WContorlReverse", Float) = 0
		_Reverse("Reverse", Range( 0 , 1)) = 0
		[HDR]_MainColor("MainColor", Color) = (1,1,1,0)
		[HDR]_SubColor("SubColor", Color) = (0,0,0,0)
		_Range("Range", Float) = 1
		_Soft("Soft", Range( 0 , 0.1)) = 0
		_NoiseTex("NoiseTex", 2D) = "white" {}
		[Toggle(_UV2_WTCONTORLCENTEROFFSET_ON)] _UV2_WTContorlCenterOffset("UV2_WTContorlCenterOffset", Float) = 0
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_NoisePanner("NoisePanner", Vector) = (0,0,1,0)
		_NoiseStr("NoiseStr", Range( 0 , 1)) = 0
		[Toggle(_UV1_TCONTORLBLUR_ON)] _UV1_TContorlBlur("UV1_TContorlBlur", Float) = 0
		_blur("blur", Float) = 0
		[KeywordEnum(X8,X16,X21,X26)] _Numberofsamples("偏移次数", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ "_GrabScreen0" }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _NUMBEROFSAMPLES_X8 _NUMBEROFSAMPLES_X16 _NUMBEROFSAMPLES_X21 _NUMBEROFSAMPLES_X26
		#pragma shader_feature_local _UV2_WTCONTORLCENTEROFFSET_ON
		#pragma shader_feature_local _UV1_TCONTORLBLUR_ON
		#pragma shader_feature_local _UV1_WCONTORLREVERSE_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 screenPos;
			float4 uv2_texcoord2;
			float4 uv_texcoord;
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

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabScreen0 )
		uniform float4 _MainColor;
		uniform float4 _SubColor;
		uniform float _Range;
		uniform float _Soft;
		uniform float2 _Center;
		uniform half _blur;
		uniform sampler2D _NoiseTex;
		uniform float3 _NoisePanner;
		uniform float2 _Tiling;
		uniform float _NoiseStr;
		uniform float _Reverse;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult3 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 ScreenUV8 = appendResult3;
			float4 screenColor136 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,ScreenUV8);
			float2 appendResult163 = (float2(i.uv2_texcoord2.z , i.uv2_texcoord2.w));
			float2 UV2_WT164 = appendResult163;
			#ifdef _UV2_WTCONTORLCENTEROFFSET_ON
				float2 staticSwitch166 = UV2_WT164;
			#else
				float2 staticSwitch166 = _Center;
			#endif
			float2 Center145 = staticSwitch166;
			float UV1_T150 = i.uv_texcoord.w;
			#ifdef _UV1_TCONTORLBLUR_ON
				float staticSwitch149 = UV1_T150;
			#else
				float staticSwitch149 = _blur;
			#endif
			float2 temp_output_132_0 = ( ( ScreenUV8 - Center145 ) * 0.01 * staticSwitch149 );
			float2 temp_output_138_0 = ( ScreenUV8 - temp_output_132_0 );
			float4 screenColor79 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_138_0);
			float2 temp_output_137_0 = ( temp_output_138_0 - temp_output_132_0 );
			float4 screenColor90 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_137_0);
			float2 temp_output_52_0 = ( temp_output_137_0 - temp_output_132_0 );
			float4 screenColor78 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_52_0);
			float2 temp_output_53_0 = ( temp_output_52_0 - temp_output_132_0 );
			float4 screenColor87 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_53_0);
			float2 temp_output_54_0 = ( temp_output_53_0 - temp_output_132_0 );
			float4 screenColor76 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_54_0);
			float2 temp_output_56_0 = ( temp_output_54_0 - temp_output_132_0 );
			float4 screenColor81 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_56_0);
			float2 temp_output_58_0 = ( temp_output_56_0 - temp_output_132_0 );
			float4 screenColor85 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_58_0);
			float4 temp_output_98_0 = ( screenColor136 + screenColor79 + screenColor90 + screenColor78 + screenColor87 + screenColor76 + screenColor81 + screenColor85 );
			float2 temp_output_60_0 = ( temp_output_58_0 - temp_output_132_0 );
			float4 screenColor86 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_60_0);
			float2 BlurUV127 = temp_output_132_0;
			float2 temp_output_61_0 = ( temp_output_60_0 - BlurUV127 );
			float4 screenColor77 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_61_0);
			float2 temp_output_62_0 = ( temp_output_61_0 - BlurUV127 );
			float4 screenColor84 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_62_0);
			float2 temp_output_63_0 = ( temp_output_62_0 - BlurUV127 );
			float4 screenColor88 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_63_0);
			float2 temp_output_64_0 = ( temp_output_63_0 - BlurUV127 );
			float4 screenColor91 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_64_0);
			float2 temp_output_65_0 = ( temp_output_64_0 - BlurUV127 );
			float4 screenColor83 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_65_0);
			float2 temp_output_66_0 = ( temp_output_65_0 - BlurUV127 );
			float4 screenColor133 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_66_0);
			float2 temp_output_67_0 = ( temp_output_66_0 - BlurUV127 );
			float4 screenColor134 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_67_0);
			float4 temp_output_105_0 = ( temp_output_98_0 + ( screenColor86 + screenColor77 + screenColor84 + screenColor88 + screenColor91 + screenColor83 + screenColor133 + screenColor134 ) );
			float2 temp_output_68_0 = ( temp_output_67_0 - BlurUV127 );
			float4 screenColor95 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_68_0);
			float2 temp_output_69_0 = ( temp_output_68_0 - BlurUV127 );
			float4 screenColor92 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_69_0);
			float2 temp_output_70_0 = ( temp_output_69_0 - BlurUV127 );
			float4 screenColor97 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_70_0);
			float2 temp_output_71_0 = ( temp_output_70_0 - BlurUV127 );
			float4 screenColor94 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_71_0);
			float2 temp_output_72_0 = ( temp_output_71_0 - BlurUV127 );
			float4 screenColor99 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_72_0);
			float4 temp_output_109_0 = ( temp_output_105_0 + ( screenColor95 + screenColor92 + screenColor97 + screenColor94 + screenColor99 ) );
			float2 temp_output_73_0 = ( temp_output_72_0 - BlurUV127 );
			float4 screenColor102 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_73_0);
			float2 temp_output_74_0 = ( temp_output_73_0 - BlurUV127 );
			float4 screenColor107 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_74_0);
			float2 temp_output_75_0 = ( temp_output_74_0 - BlurUV127 );
			float4 screenColor108 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_75_0);
			float2 temp_output_89_0 = ( temp_output_75_0 - BlurUV127 );
			float4 screenColor103 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,temp_output_89_0);
			float4 screenColor101 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,( temp_output_89_0 - BlurUV127 ));
			#if defined(_NUMBEROFSAMPLES_X8)
				float4 staticSwitch121 = ( temp_output_98_0 / 8.0 );
			#elif defined(_NUMBEROFSAMPLES_X16)
				float4 staticSwitch121 = ( temp_output_105_0 / 16.0 );
			#elif defined(_NUMBEROFSAMPLES_X21)
				float4 staticSwitch121 = ( temp_output_109_0 / 21.0 );
			#elif defined(_NUMBEROFSAMPLES_X26)
				float4 staticSwitch121 = ( ( temp_output_109_0 + ( screenColor102 + screenColor107 + screenColor108 + screenColor103 + screenColor101 ) ) / 26.0 );
			#else
				float4 staticSwitch121 = ( temp_output_98_0 / 8.0 );
			#endif
			float4 BlurColor142 = staticSwitch121;
			float3 desaturateInitialColor12 = BlurColor142.rgb;
			float desaturateDot12 = dot( desaturateInitialColor12, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar12 = lerp( desaturateInitialColor12, desaturateDot12.xxx, 0.0 );
			float mulTime29 = _Time.y * _NoisePanner.z;
			float2 appendResult28 = (float2(_NoisePanner.x , _NoisePanner.y));
			float2 CenteredUV15_g1 = ( ScreenUV8 - Center145 );
			float2 break17_g1 = CenteredUV15_g1;
			float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * _Tiling.x * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * _Tiling.y )));
			float2 panner25 = ( mulTime29 * appendResult28 + appendResult23_g1);
			float NoiseColor154 = tex2D( _NoiseTex, panner25 ).r;
			float lerpResult40 = lerp( (desaturateVar12).x , NoiseColor154 , _NoiseStr);
			float smoothstepResult14 = smoothstep( _Range , ( _Range + _Soft ) , lerpResult40);
			float UV1_W45 = i.uv_texcoord.z;
			#ifdef _UV1_WCONTORLREVERSE_ON
				float staticSwitch46 = saturate( UV1_W45 );
			#else
				float staticSwitch46 = _Reverse;
			#endif
			float lerpResult23 = lerp( smoothstepResult14 , ( 1.0 - smoothstepResult14 ) , staticSwitch46);
			float4 lerpResult20 = lerp( ( _MainColor * i.vertexColor ) , _SubColor , lerpResult23);
			c.rgb = lerpResult20.rgb;
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
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
7;342;1311;677;6626.13;-212.7682;2.510713;True;True
Node;AmplifyShaderEditor.CommentaryNode;44;-5623.274,-332.4536;Inherit;False;990.2749;575.4301;Comment;6;164;45;150;43;163;160;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;160;-5579.554,-28.07708;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;163;-5312.556,44.00272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-5144.338,55.70851;Inherit;False;UV2_WT;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;168;-5698.523,728.3826;Inherit;False;862.8101;297.7964;Comment;4;165;166;6;145;Center;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-3952.276,-500.5678;Inherit;False;826.5537;347.0828;Comment;3;8;3;2;ScreenUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;-5661.866,916.8502;Inherit;False;164;UV2_WT;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-3902.276,-432.1552;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-5654.113,785.0538;Inherit;False;Property;_Center;Center;9;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;166;-5437.755,833.409;Inherit;False;Property;_UV2_WTContorlCenterOffset;UV2_WTContorlCenterOffset;8;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;50;-5701.604,1869.731;Inherit;False;1363.454;1069.81;;7;127;132;149;147;125;151;49;BlurUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-5573.274,-282.4536;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;3;-3695.275,-396.1552;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-3521.201,-398.9815;Inherit;False;ScreenUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;49;-5673.071,1976.344;Inherit;False;931.1185;543.8665;;3;131;148;169;CenterOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;-5073.056,833.3709;Inherit;False;Center;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;-5297.162,-134.1746;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-5605.191,2715.1;Half;False;Property;_blur;blur;14;0;Create;True;0;0;0;False;0;False;0;1.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-5628.649,2147.862;Inherit;False;145;Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-5632.461,2029.592;Inherit;False;8;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-5636.675,2807.013;Inherit;False;150;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;131;-5377.823,2091.791;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;51;-4234.938,1758.748;Inherit;False;3299.75;5444.986;;57;67;134;133;83;91;88;84;77;86;66;103;104;101;102;107;108;95;93;92;99;97;96;94;87;78;76;79;136;89;82;85;80;90;81;75;74;73;72;71;70;69;68;65;64;63;62;61;60;58;56;54;53;52;137;138;59;159;Blur;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-5391.67,2662.341;Inherit;False;Constant;_Float9;Float 9;15;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;149;-5446.412,2749.896;Inherit;False;Property;_UV1_TContorlBlur;UV1_TContorlBlur;13;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;-4139.933,1822.873;Inherit;False;8;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-5177.097,2641.719;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;138;-3532.754,1851.669;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;137;-3538.638,1976.171;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-3531.566,2110.094;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;-3515.566,2270.094;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;-3496.94,2440.482;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-3467.449,2567.695;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-3467.534,2735.648;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-4937.445,2633.146;Float;False;BlurUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-4123.837,4019.777;Inherit;False;127;BlurUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;-3478.256,2928.914;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-3480.881,3150.707;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;-3445.958,3336.51;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;63;-3454.614,3527.197;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;-3456.764,3683.316;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;-3459.389,3905.109;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;-3485.039,4130.148;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;-3465.474,4271.291;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;-3585.144,5411.772;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;69;-3573.76,5603.404;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-3566.17,5787.448;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-3568.068,5956.314;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;72;-3569.965,6098.617;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;-3538.733,6266.461;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;74;-3527.349,6456.095;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;75;-3519.76,6640.137;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;134;-3131.583,4975.527;Float;False;Global;_GrabScreen15;Grab Screen 15;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;85;-3156.18,3258.657;Float;False;Global;_GrabScreen12;Grab Screen 12;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;79;-3161.658,2009.345;Float;False;Global;_GrabScreen1;Grab Screen 1;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;78;-3162.78,2422.64;Float;False;Global;_GrabScreen6;Grab Screen 6;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;89;-3521.657,6809.002;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;87;-3158.026,2635.23;Float;False;Global;_GrabScreen5;Grab Screen 5;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;77;-3145.648,3716.531;Float;False;Global;_GrabScreen14;Grab Screen 14;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;90;-3170.061,2229.904;Float;False;Global;_GrabScreen3;Grab Screen 3;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;88;-3144.624,4166.67;Float;False;Global;_GrabScreen8;Grab Screen 8;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;80;-2747.97,1843.078;Inherit;False;365.3561;441.59;;3;119;111;98;x8;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;82;-2187.318,2602.751;Inherit;False;581.5006;481.4781;;4;117;113;105;100;x16;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenColorNode;136;-3167.602,1814.804;Float;False;Global;_GrabScreen0;Grab Screen 0;9;0;Fetch;True;0;0;0;True;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;83;-3143.848,4519.14;Float;False;Global;_GrabScreen10;Grab Screen 10;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;91;-3148.465,4343.743;Float;False;Global;_GrabScreen9;Grab Screen 9;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;84;-3142.245,3915.332;Float;False;Global;_GrabScreen4;Grab Screen 4;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;86;-3149.2,3532.838;Float;False;Global;_GrabScreen13;Grab Screen 13;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;81;-3158.807,3025.353;Float;False;Global;_GrabScreen7;Grab Screen 7;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;76;-3163.653,2838.833;Float;False;Global;_GrabScreen2;Grab Screen 2;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;133;-3139.346,4740.78;Float;False;Global;_GrabScreen11;Grab Screen 11;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;-3523.555,6951.305;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;97;-3226.559,5645.371;Float;False;Global;_GrabScreen18;Grab Screen 18;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;93;-2093.737,4195.382;Inherit;False;572.4196;259.085;;4;118;114;109;106;x21;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenColorNode;99;-3229.915,5999.185;Float;False;Global;_GrabScreen19;Grab Screen 19;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;92;-3243.34,5468.906;Float;False;Global;_GrabScreen17;Grab Screen 17;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;95;-3246.696,5270.891;Float;False;Global;_GrabScreen16;Grab Screen 16;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;94;-3228.503,5823.25;Float;False;Global;_GrabScreen20;Grab Screen 20;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-2685.978,2015.378;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-2129.329,2653.795;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1831.285,5600.158;Inherit;False;657.3184;349.3452;;4;120;115;112;110;x26;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;-2043.736,4252.466;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;103;-3195.626,6743.52;Float;False;Global;_GrabScreen22;Grab Screen 22;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-1949.742,2652.751;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;101;-3200.927,6919.456;Float;False;Global;_GrabScreen21;Grab Screen 21;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;102;-3215.763,6195.11;Float;False;Global;_GrabScreen25;Grab Screen 25;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;107;-3219.487,6391.123;Float;False;Global;_GrabScreen24;Grab Screen 24;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;108;-3195.626,6565.642;Float;False;Global;_GrabScreen23;Grab Screen 23;9;0;Fetch;True;0;0;0;False;0;False;Instance;10;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-1754.412,5687.733;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-1854.955,4245.382;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-2116.274,2906.087;Float;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-1518.682,5831.816;Float;False;Constant;_Float6;Float 6;10;0;Create;True;0;0;0;False;0;False;26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;153;-3928.2,94.23144;Inherit;False;2202.52;627.1752;Noise;10;26;152;25;1;28;7;27;29;154;167;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1884.318,4336.219;Float;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;21;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;-1528.762,5647.469;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-2699.681,1900.025;Half;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;117;-1762.818,2659.104;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;120;-1304.094,5769.887;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;118;-1678.317,4254.219;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;116;-743.397,2142.143;Inherit;False;537;263;;2;142;121;BlurSwitch;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;119;-2541.325,1894.789;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;27;-3305.713,462.9762;Inherit;False;Property;_NoisePanner;NoisePanner;11;0;Create;True;0;0;0;False;0;False;0,0,1;-0.1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;167;-3668.628,258.5861;Inherit;False;145;Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;7;-3672.044,373.881;Inherit;False;Property;_Tiling;Tiling;10;0;Create;True;0;0;0;False;0;False;1,1;0.01,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;152;-3669.584,146.0185;Inherit;False;8;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3104.713,563.9763;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;121;-693.397,2192.142;Float;False;Property;_Numberofsamples;偏移次数;15;0;Create;False;0;0;0;False;0;False;0;0;1;True;;KeywordEnum;4;X8;X16;X21;X26;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-3070.712,461.9762;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;1;-3275.58,225.6165;Inherit;True;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-447.2751,2190.124;Inherit;False;BlurColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;25;-2898.781,427.437;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;26;-2659.992,179.5212;Inherit;True;Property;_NoiseTex;NoiseTex;7;0;Create;True;0;0;0;False;0;False;-1;None;3433162ddc7ee6b4687996d52e67fac4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;156;-1624.103,-583.1816;Inherit;False;142;BlurColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;12;-1381.571,-577.8192;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-2301.987,194.4015;Inherit;False;NoiseColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-5294.401,-218.2993;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-1103.479,-343.3877;Inherit;False;154;NoiseColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-999.1123,-127.9657;Inherit;False;Property;_Range;Range;5;0;Create;True;0;0;0;False;0;False;1;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1032.624,17.71028;Inherit;False;Property;_Soft;Soft;6;0;Create;True;0;0;0;False;0;False;0;0.1;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-1155.025,-557.5803;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1212.97,-231.7929;Inherit;False;Property;_NoiseStr;NoiseStr;12;0;Create;True;0;0;0;False;0;False;0;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;40;-868.7874,-376.9979;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-720.6238,-27.28973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-964.8843,238.0819;Inherit;False;45;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;48;-793.3933,245.2371;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-992.7525,154.959;Inherit;False;Property;_Reverse;Reverse;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;14;-486.2104,-157.5421;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;46;-655.8844,181.0819;Inherit;False;Property;_UV1_WContorlReverse;UV1_WContorlReverse;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;41;-271.6581,-556.306;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;19;-298.6477,-65.28168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-296.456,-736.2413;Inherit;False;Property;_MainColor;MainColor;3;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-64.97357,-144.9015;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-276.1271,-336.4478;Inherit;False;Property;_SubColor;SubColor;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;170;-5688.509,1301.231;Inherit;False;441.4449;262;Comment;2;157;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;42.71571,-687.8966;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;20;256.3329,-296.0624;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;10;-5443.062,1351.231;Inherit;False;Global;_GrabScreen0;Grab Screen 0;2;0;Create;True;0;0;0;True;0;False;Object;-1;True;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;-105.7844,282.0771;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-5638.509,1351.748;Inherit;False;8;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1081.026,-638.5444;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Fx/BlackWhiteFlash;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;163;0;160;3
WireConnection;163;1;160;4
WireConnection;164;0;163;0
WireConnection;166;1;6;0
WireConnection;166;0;165;0
WireConnection;3;0;2;1
WireConnection;3;1;2;2
WireConnection;8;0;3;0
WireConnection;145;0;166;0
WireConnection;150;0;43;4
WireConnection;131;0;148;0
WireConnection;131;1;169;0
WireConnection;149;1;125;0
WireConnection;149;0;151;0
WireConnection;132;0;131;0
WireConnection;132;1;147;0
WireConnection;132;2;149;0
WireConnection;138;0;159;0
WireConnection;138;1;132;0
WireConnection;137;0;138;0
WireConnection;137;1;132;0
WireConnection;52;0;137;0
WireConnection;52;1;132;0
WireConnection;53;0;52;0
WireConnection;53;1;132;0
WireConnection;54;0;53;0
WireConnection;54;1;132;0
WireConnection;56;0;54;0
WireConnection;56;1;132;0
WireConnection;58;0;56;0
WireConnection;58;1;132;0
WireConnection;127;0;132;0
WireConnection;60;0;58;0
WireConnection;60;1;132;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;62;0;61;0
WireConnection;62;1;59;0
WireConnection;63;0;62;0
WireConnection;63;1;59;0
WireConnection;64;0;63;0
WireConnection;64;1;59;0
WireConnection;65;0;64;0
WireConnection;65;1;59;0
WireConnection;66;0;65;0
WireConnection;66;1;59;0
WireConnection;67;0;66;0
WireConnection;67;1;59;0
WireConnection;68;0;67;0
WireConnection;68;1;59;0
WireConnection;69;0;68;0
WireConnection;69;1;59;0
WireConnection;70;0;69;0
WireConnection;70;1;59;0
WireConnection;71;0;70;0
WireConnection;71;1;59;0
WireConnection;72;0;71;0
WireConnection;72;1;59;0
WireConnection;73;0;72;0
WireConnection;73;1;59;0
WireConnection;74;0;73;0
WireConnection;74;1;59;0
WireConnection;75;0;74;0
WireConnection;75;1;59;0
WireConnection;134;0;67;0
WireConnection;85;0;58;0
WireConnection;79;0;138;0
WireConnection;78;0;52;0
WireConnection;89;0;75;0
WireConnection;89;1;59;0
WireConnection;87;0;53;0
WireConnection;77;0;61;0
WireConnection;90;0;137;0
WireConnection;88;0;63;0
WireConnection;136;0;159;0
WireConnection;83;0;65;0
WireConnection;91;0;64;0
WireConnection;84;0;62;0
WireConnection;86;0;60;0
WireConnection;81;0;56;0
WireConnection;76;0;54;0
WireConnection;133;0;66;0
WireConnection;96;0;89;0
WireConnection;96;1;59;0
WireConnection;97;0;70;0
WireConnection;99;0;72;0
WireConnection;92;0;69;0
WireConnection;95;0;68;0
WireConnection;94;0;71;0
WireConnection;98;0;136;0
WireConnection;98;1;79;0
WireConnection;98;2;90;0
WireConnection;98;3;78;0
WireConnection;98;4;87;0
WireConnection;98;5;76;0
WireConnection;98;6;81;0
WireConnection;98;7;85;0
WireConnection;100;0;86;0
WireConnection;100;1;77;0
WireConnection;100;2;84;0
WireConnection;100;3;88;0
WireConnection;100;4;91;0
WireConnection;100;5;83;0
WireConnection;100;6;133;0
WireConnection;100;7;134;0
WireConnection;106;0;95;0
WireConnection;106;1;92;0
WireConnection;106;2;97;0
WireConnection;106;3;94;0
WireConnection;106;4;99;0
WireConnection;103;0;89;0
WireConnection;105;0;98;0
WireConnection;105;1;100;0
WireConnection;101;0;96;0
WireConnection;102;0;73;0
WireConnection;107;0;74;0
WireConnection;108;0;75;0
WireConnection;110;0;102;0
WireConnection;110;1;107;0
WireConnection;110;2;108;0
WireConnection;110;3;103;0
WireConnection;110;4;101;0
WireConnection;109;0;105;0
WireConnection;109;1;106;0
WireConnection;112;0;109;0
WireConnection;112;1;110;0
WireConnection;117;0;105;0
WireConnection;117;1;113;0
WireConnection;120;0;112;0
WireConnection;120;1;115;0
WireConnection;118;0;109;0
WireConnection;118;1;114;0
WireConnection;119;0;98;0
WireConnection;119;1;111;0
WireConnection;29;0;27;3
WireConnection;121;1;119;0
WireConnection;121;0;117;0
WireConnection;121;2;118;0
WireConnection;121;3;120;0
WireConnection;28;0;27;1
WireConnection;28;1;27;2
WireConnection;1;1;152;0
WireConnection;1;2;167;0
WireConnection;1;3;7;1
WireConnection;1;4;7;2
WireConnection;142;0;121;0
WireConnection;25;0;1;0
WireConnection;25;2;28;0
WireConnection;25;1;29;0
WireConnection;26;1;25;0
WireConnection;12;0;156;0
WireConnection;154;0;26;1
WireConnection;45;0;43;3
WireConnection;13;0;12;0
WireConnection;40;0;13;0
WireConnection;40;1;155;0
WireConnection;40;2;39;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;48;0;47;0
WireConnection;14;0;40;0
WireConnection;14;1;15;0
WireConnection;14;2;16;0
WireConnection;46;1;24;0
WireConnection;46;0;48;0
WireConnection;19;0;14;0
WireConnection;23;0;14;0
WireConnection;23;1;19;0
WireConnection;23;2;46;0
WireConnection;42;0;21;0
WireConnection;42;1;41;0
WireConnection;20;0;42;0
WireConnection;20;1;22;0
WireConnection;20;2;23;0
WireConnection;10;0;157;0
WireConnection;0;9;41;4
WireConnection;0;13;20;0
ASEEND*/
//CHKSM=71DBC9E60E5DE61889A1083947C605E7306A297C