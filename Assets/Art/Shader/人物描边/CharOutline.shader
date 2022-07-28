// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Fx/ScreenOutline"
{
	Properties
	{
		[Toggle(_UV2_WTCONTORLCENTEROFFSET_ON)] _UV2_WTContorlCenterOffset("UV2_WTContorlCenterOffset", Float) = 0
		_Center("Center", Vector) = (0.5,0.5,0,0)
		[KeywordEnum(X8,X16,X21,X26)] _Numberofsamples("BlurCount", Float) = 0
		_blur("blur", Float) = 0
		_RT("RT", 2D) = "white" {}
		[Toggle(_DISTURBON_ON)] _DisturbOn("DisturbOn", Float) = 0
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_DisturbPanner("DisturbPanner", Vector) = (0,0,1,0)
		_DisturbStr("DisturbStr", Float) = 0
		[HDR]_MainColor("MainColor ", Color) = (1,1,1,1)
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		_DisTex("DisTex", 2D) = "white" {}
		_NoisePanner("NoisePanner", Vector) = (0,0,1,0)
		_Invers("Invers", Range( 0 , 1)) = 0
		_Dissolution("Dissolution", Range( 0 , 1)) = 0
		_DisHardness("DisHardness", Range( 0 , 0.99)) = 0
		_ScreenTiling("ScreenTiling", Vector) = (1,1,0,0)
		_MaskTiling("MaskTiling", Float) = 1
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
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 5.0
		#pragma shader_feature _NUMBEROFSAMPLES_X8 _NUMBEROFSAMPLES_X16 _NUMBEROFSAMPLES_X21 _NUMBEROFSAMPLES_X26
		#pragma shader_feature_local _DISTURBON_ON
		#pragma shader_feature_local _UV2_WTCONTORLCENTEROFFSET_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 screenPos;
			float4 uv_texcoord;
			float4 uv2_texcoord2;
			float4 vertexColor : COLOR;
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

		uniform sampler2D _RT;
		uniform float2 _ScreenTiling;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _DisturbStr;
		uniform float2 _Center;
		uniform half _blur;
		uniform sampler2D _DisTex;
		uniform float3 _NoisePanner;
		uniform float4 _DisTex_ST;
		uniform float _Invers;
		uniform float _Dissolution;
		uniform float _DisHardness;
		uniform float _MaskTiling;
		uniform float4 _MainColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 break203 = ase_screenPosNorm;
			float mulTime174 = _Time.y * _DisturbPanner.z;
			float2 appendResult175 = (float2(_DisturbPanner.x , _DisturbPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner177 = ( mulTime174 * appendResult175 + uvs_DisturbTex.xy);
			#ifdef _DISTURBON_ON
				float staticSwitch183 = ( tex2D( _DisturbTex, panner177 ).r * _DisturbStr );
			#else
				float staticSwitch183 = 0.0;
			#endif
			float DisturbColor184 = staticSwitch183;
			float2 appendResult95 = (float2(( ( ( break203.x - 0.5 ) * _ScreenTiling.x ) + 0.5 ) , ( ( ( ( break203.y - 0.5 ) * _ScreenTiling.y ) + 0.5 ) + DisturbColor184 )));
			float2 ScreenUV96 = appendResult95;
			float2 appendResult104 = (float2(i.uv2_texcoord2.z , i.uv2_texcoord2.w));
			float2 UV2_WT105 = appendResult104;
			#ifdef _UV2_WTCONTORLCENTEROFFSET_ON
				float2 staticSwitch100 = UV2_WT105;
			#else
				float2 staticSwitch100 = _Center;
			#endif
			float2 Center101 = staticSwitch100;
			float2 temp_output_13_0 = ( ( ScreenUV96 - Center101 ) * 0.01 * _blur );
			float2 temp_output_14_0 = ( ScreenUV96 - temp_output_13_0 );
			float2 temp_output_15_0 = ( temp_output_14_0 - temp_output_13_0 );
			float2 temp_output_16_0 = ( temp_output_15_0 - temp_output_13_0 );
			float2 temp_output_17_0 = ( temp_output_16_0 - temp_output_13_0 );
			float2 temp_output_18_0 = ( temp_output_17_0 - temp_output_13_0 );
			float2 temp_output_19_0 = ( temp_output_18_0 - temp_output_13_0 );
			float2 temp_output_20_0 = ( temp_output_19_0 - temp_output_13_0 );
			float4 temp_output_65_0 = ( tex2D( _RT, ScreenUV96 ) + tex2D( _RT, temp_output_14_0 ) + tex2D( _RT, temp_output_15_0 ) + tex2D( _RT, temp_output_16_0 ) + tex2D( _RT, temp_output_17_0 ) + tex2D( _RT, temp_output_18_0 ) + tex2D( _RT, temp_output_19_0 ) + tex2D( _RT, temp_output_20_0 ) );
			float2 temp_output_23_0 = ( temp_output_20_0 - temp_output_13_0 );
			float2 BlurUV21 = temp_output_13_0;
			float2 temp_output_24_0 = ( temp_output_23_0 - BlurUV21 );
			float2 temp_output_25_0 = ( temp_output_24_0 - BlurUV21 );
			float2 temp_output_26_0 = ( temp_output_25_0 - BlurUV21 );
			float2 temp_output_27_0 = ( temp_output_26_0 - BlurUV21 );
			float2 temp_output_28_0 = ( temp_output_27_0 - BlurUV21 );
			float2 temp_output_29_0 = ( temp_output_28_0 - BlurUV21 );
			float2 temp_output_30_0 = ( temp_output_29_0 - BlurUV21 );
			float4 temp_output_70_0 = ( temp_output_65_0 + ( tex2D( _RT, temp_output_23_0 ) + tex2D( _RT, temp_output_24_0 ) + tex2D( _RT, temp_output_25_0 ) + tex2D( _RT, temp_output_26_0 ) + tex2D( _RT, temp_output_27_0 ) + tex2D( _RT, temp_output_28_0 ) + tex2D( _RT, temp_output_29_0 ) + tex2D( _RT, temp_output_30_0 ) ) );
			float2 temp_output_31_0 = ( temp_output_30_0 - BlurUV21 );
			float2 temp_output_32_0 = ( temp_output_31_0 - BlurUV21 );
			float2 temp_output_33_0 = ( temp_output_32_0 - BlurUV21 );
			float2 temp_output_34_0 = ( temp_output_33_0 - BlurUV21 );
			float2 temp_output_35_0 = ( temp_output_34_0 - BlurUV21 );
			float4 temp_output_76_0 = ( temp_output_70_0 + ( tex2D( _RT, temp_output_31_0 ) + tex2D( _RT, temp_output_32_0 ) + tex2D( _RT, temp_output_33_0 ) + tex2D( _RT, temp_output_34_0 ) + tex2D( _RT, temp_output_35_0 ) ) );
			float2 temp_output_36_0 = ( temp_output_35_0 - BlurUV21 );
			float2 temp_output_37_0 = ( temp_output_36_0 - BlurUV21 );
			float2 temp_output_38_0 = ( temp_output_37_0 - BlurUV21 );
			float2 temp_output_43_0 = ( temp_output_38_0 - BlurUV21 );
			#if defined(_NUMBEROFSAMPLES_X8)
				float4 staticSwitch87 = ( temp_output_65_0 / 8.0 );
			#elif defined(_NUMBEROFSAMPLES_X16)
				float4 staticSwitch87 = ( temp_output_70_0 / 16.0 );
			#elif defined(_NUMBEROFSAMPLES_X21)
				float4 staticSwitch87 = ( temp_output_76_0 / 21.0 );
			#elif defined(_NUMBEROFSAMPLES_X26)
				float4 staticSwitch87 = ( ( temp_output_76_0 + ( tex2D( _RT, temp_output_36_0 ) + tex2D( _RT, temp_output_37_0 ) + tex2D( _RT, temp_output_38_0 ) + tex2D( _RT, temp_output_43_0 ) + tex2D( _RT, ( temp_output_43_0 - BlurUV21 ) ) ) ) / 26.0 );
			#else
				float4 staticSwitch87 = ( temp_output_65_0 / 8.0 );
			#endif
			float4 BlurColor88 = staticSwitch87;
			float mulTime153 = _Time.y * _NoisePanner.z;
			float2 appendResult154 = (float2(_NoisePanner.x , _NoisePanner.y));
			float4 uvs_DisTex = i.uv_texcoord;
			uvs_DisTex.xy = i.uv_texcoord.xy * _DisTex_ST.xy + _DisTex_ST.zw;
			float2 panner156 = ( mulTime153 * appendResult154 + uvs_DisTex.xy);
			float temp_output_3_0_g1 = tex2D( _DisTex, ( panner156 + DisturbColor184 ) ).r;
			float lerpResult5_g1 = lerp( temp_output_3_0_g1 , ( 1.0 - temp_output_3_0_g1 ) , _Invers);
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch11 = i.uv_texcoord.w;
			#else
				float staticSwitch11 = _Dissolution;
			#endif
			float UV1_T107 = staticSwitch11;
			float temp_output_8_0_g1 = _DisHardness;
			float Opacity139 = tex2D( _RT, ( ( ( ScreenUV96 - float2( 0.5,0.5 ) ) * _MaskTiling ) + float2( 0.5,0.5 ) ) ).a;
			c.rgb = ( _MainColor * i.vertexColor ).rgb;
			c.a = saturate( ( ( BlurColor88.a * saturate( ( ( ( ( lerpResult5_g1 + 1.0 ) - ( ( 1.0 - (-0.5 + (UV1_T107 - 0.0) * (1.0 - -0.5) / (1.0 - 0.0)) ) * ( ( 1.0 - temp_output_8_0_g1 ) + 1.0 ) ) ) - temp_output_8_0_g1 ) / ( temp_output_8_0_g1 - 1.0 ) ) ) * i.vertexColor.a ) - Opacity139 ) );
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
36;172;1481;747;-123.0538;1955.035;1.508323;True;True
Node;AmplifyShaderEditor.CommentaryNode;172;-4159.396,-2247.96;Inherit;False;1861.461;712.423;DisturbColor;12;184;183;182;181;180;179;178;177;176;175;174;173;DisturbColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;173;-4140.383,-1958.829;Inherit;False;Property;_DisturbPanner;DisturbPanner;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;176;-4089.201,-2118.072;Inherit;False;0;178;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;175;-3889.385,-2005.829;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;174;-3892.385,-1851.829;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;-4150.271,-1193.767;Inherit;False;1779.951;796.2784;Comment;13;167;95;96;164;168;162;169;165;170;94;185;186;203;ScreenUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;177;-3707.704,-2037.691;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;94;-4122.17,-1016.719;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;180;-3262.236,-1817.29;Inherit;False;Property;_DisturbStr;DisturbStr;9;0;Create;True;0;0;0;False;0;False;0;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;178;-3468.569,-2049.538;Inherit;True;Property;_DisturbTex;DisturbTex;7;0;Create;True;0;0;0;False;0;False;-1;None;cb34b6fe5a3b9ad439ba09ed802e6731;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;102;-5226.274,-1198.292;Inherit;False;990.2749;575.4301;Comment;8;108;107;106;105;104;103;11;160;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;203;-3846.127,-1011.539;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;181;-3006.16,-2086.36;Inherit;False;Constant;_0;0;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-3029.759,-1941.584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;183;-2818.093,-1998.731;Inherit;False;Property;_DisturbOn;DisturbOn;6;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-5182.554,-893.9162;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;167;-3863.374,-855.7603;Inherit;False;Property;_ScreenTiling;ScreenTiling;17;0;Create;True;0;0;0;False;0;False;1,1;1.77,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;165;-3329.747,-881.0956;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;-3170.272,-872.4445;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;-4915.556,-821.8364;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-2527.217,-1996.828;Inherit;False;DisturbColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;170;-3330.054,-1018.316;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-3113.416,-736.8845;Inherit;False;184;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-4755.338,-826.1306;Inherit;False;UV2_WT;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;-3002.068,-876.3555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-3170.387,-1033.058;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-5226.123,-566.3104;Inherit;False;862.8101;297.7964;Comment;3;101;100;98;Center;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;99;-5497.713,-471.6392;Inherit;False;Property;_Center;Center;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.51,0.42;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;98;-5189.466,-377.8428;Inherit;False;105;UV2_WT;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;186;-2865.328,-847.017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-3017.453,-1015.911;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;95;-2743.191,-1013.125;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;100;-4965.355,-461.284;Inherit;False;Property;_UV2_WTContorlCenterOffset;UV2_WTContorlCenterOffset;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;2;-5273.42,827.7488;Inherit;False;1363.454;1069.81;;5;21;13;10;4;3;BlurUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-4600.656,-461.3221;Inherit;False;Center;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;3;-5244.886,934.3619;Inherit;False;931.1185;543.8665;;3;8;6;5;CenterOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-2580.282,-1011.01;Inherit;False;ScreenUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;5;-5200.465,1105.88;Inherit;False;101;Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;6;-5204.277,987.61;Inherit;False;96;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;9;-3783.143,386.2116;Inherit;False;3299.75;5444.986;;56;67;60;58;49;48;43;38;37;36;35;34;33;32;31;30;29;28;27;26;25;24;23;22;20;19;18;17;16;15;14;12;110;111;112;113;114;115;116;118;119;120;121;123;124;125;126;127;128;129;130;131;132;133;134;135;137;Blur;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-4949.639,1049.809;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4963.486,1620.359;Inherit;False;Constant;_Float9;Float 9;15;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4953.007,1698.118;Half;False;Property;_blur;blur;4;0;Create;True;0;0;0;False;0;False;0;4.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-4748.913,1599.737;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-3749.138,446.3366;Inherit;False;96;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-3088.994,525.0208;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-3083.281,630.3521;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-3079.771,737.5576;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-3063.771,897.5576;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-3045.145,1067.946;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-3015.654,1195.159;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-3015.739,1363.112;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-4530.26,1724.164;Float;False;BlurUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-3672.042,2647.24;Inherit;False;21;BlurUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-3026.461,1556.378;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-3029.086,1778.171;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-2994.163,1963.974;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;-3002.819,2154.661;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-3004.969,2310.78;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-3007.594,2532.573;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-3033.244,2757.612;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-3013.679,2898.755;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-3133.349,4039.236;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-3121.965,4230.867;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-3114.375,4414.912;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-3116.273,4583.777;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-3118.17,4726.081;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-3086.938,4893.924;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-3075.554,5083.559;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;38;-3067.965,5267.601;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;49;-1735.523,1230.215;Inherit;False;581.5006;481.4781;;4;82;77;70;66;x16;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;112;-2769.726,845.4824;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;124;-2769.225,2959.939;Inherit;True;Property;_TextureSample12;Texture Sample 12;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;115;-2780.051,1449.31;Inherit;True;Property;_TextureSample5;Texture Sample 5;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;110;-2772.784,439.78;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;126;-2766.709,3361.561;Inherit;True;Property;_TextureSample14;Texture Sample 14;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;111;-2770.149,647.514;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-3069.862,5436.465;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;125;-2768.529,3154.918;Inherit;True;Property;_TextureSample13;Texture Sample 13;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;127;-2767.426,3572.208;Inherit;True;Property;_TextureSample15;Texture Sample 15;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;123;-2762.028,2757.379;Inherit;True;Property;_TextureSample11;Texture Sample 11;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;120;-2764.893,2325.041;Inherit;True;Property;_TextureSample9;Texture Sample 9;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;116;-2782.712,1659.898;Inherit;True;Property;_TextureSample6;Texture Sample 6;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;118;-2785.756,1874.16;Inherit;True;Property;_TextureSample7;Texture Sample 7;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;48;-2296.175,470.5416;Inherit;False;365.3561;441.59;;3;86;81;65;x8;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;121;-2761.161,2563.661;Inherit;True;Property;_TextureSample10;Texture Sample 10;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;113;-2774.186,1051.563;Inherit;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;119;-2761.382,2114.579;Inherit;True;Property;_TextureSample8;Texture Sample 8;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;114;-2774.346,1254.729;Inherit;True;Property;_TextureSample4;Texture Sample 4;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;128;-2830.207,3894.358;Inherit;True;Property;_TextureSample16;Texture Sample 16;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;129;-2827.371,4085.62;Inherit;True;Property;_TextureSample17;Texture Sample 17;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-2234.183,642.8417;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;131;-2822.54,4492.837;Inherit;True;Property;_TextureSample19;Texture Sample 19;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;60;-1641.942,2822.845;Inherit;False;572.4196;259.085;;4;84;79;76;68;x21;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-1677.534,1281.259;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;130;-2823.54,4286.794;Inherit;True;Property;_TextureSample18;Texture Sample 18;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-3071.76,5578.769;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;132;-2822.061,4685.928;Inherit;True;Property;_TextureSample20;Texture Sample 20;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;137;-2809.418,5487.314;Inherit;True;Property;_TextureSample24;Texture Sample 24;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1497.947,1280.215;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;133;-2819.373,4891.019;Inherit;True;Property;_TextureSample21;Texture Sample 21;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;134;-2819.726,5090.013;Inherit;True;Property;_TextureSample22;Texture Sample 22;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;138;-2805.787,5679.126;Inherit;True;Property;_TextureSample25;Texture Sample 25;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1591.941,2879.929;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;67;-1379.49,4227.622;Inherit;False;657.3184;349.3452;;4;83;80;78;75;x26;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;135;-2820.807,5287.982;Inherit;True;Property;_TextureSample23;Texture Sample 23;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1302.617,4315.196;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-1403.16,2872.845;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;201;-2315.127,-1200.851;Inherit;False;1229.121;344.3044;Opacity;7;195;194;139;197;200;199;196;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1664.479,1533.551;Float;False;Constant;_Float4;Float 4;10;0;Create;True;0;0;0;False;0;False;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-1076.967,4274.933;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-2247.885,527.4886;Half;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;152;-792.3795,-1212.903;Inherit;False;Property;_NoisePanner;NoisePanner;13;0;Create;True;0;0;0;False;0;False;0,0,1;0,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;79;-1432.523,2963.683;Float;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;21;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1066.887,4459.279;Float;False;Constant;_Float6;Float 6;10;0;Create;True;0;0;0;False;0;False;26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-2281.426,-1121.851;Inherit;False;96;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-5176.274,-1148.292;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;154;-541.3806,-1259.903;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;84;-1226.522,2881.683;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;153;-544.3806,-1105.903;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-291.6016,769.6067;Inherit;False;537;263;;2;88;87;BlurSwitch;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;83;-852.2986,4397.351;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;86;-2089.53,522.2525;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;199;-2101.25,-1107.213;Inherit;False;2;0;FLOAT2;0.5,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;82;-1311.023,1286.568;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;-607.1966,-1395.147;Inherit;False;0;151;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;160;-5148.138,-975.8983;Inherit;False;Property;_Dissolution;Dissolution;15;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-2275.027,-977.6195;Inherit;False;Property;_MaskTiling;MaskTiling;18;0;Create;True;0;0;0;False;0;False;1;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;156;-345.5191,-1291.766;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;11;-4803.638,-986.5117;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;11;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-1959.981,-1103.948;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;87;-241.6016,819.6057;Float;False;Property;_Numberofsamples;BlurCount;3;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;4;X8;X16;X21;X26;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;-348.9226,-1130.347;Inherit;False;184;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;200;-1813.497,-1102.739;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-4520.161,-977.8137;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;4.520386,817.5876;Inherit;False;BlurColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;205;-144.2988,-1265.816;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;194;-1672.722,-1133.28;Inherit;True;Property;_TextureSample26;Texture Sample 26;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;109;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;161;172.2607,-926.6935;Inherit;False;Property;_DisHardness;DisHardness;16;0;Create;True;0;0;0;False;0;False;0;0;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;66.36821,-1465.81;Inherit;False;88;BlurColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;151;91.80103,-1294.533;Inherit;True;Property;_DisTex;DisTex;12;0;Create;True;0;0;0;False;0;False;-1;None;e5da0c3efc51421baf0f1ee86c9f88ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;159;169.293,-1097.026;Inherit;False;Property;_Invers;Invers;14;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;276.2195,-1013.877;Inherit;False;107;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;208;652.5927,-991.9036;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-1355.756,-1038.678;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;158;555.5372,-1147.757;Inherit;False;Dissolution;-1;;1;8ed0a8fdbfe80554382ce257577aff19;0;4;3;FLOAT;0;False;7;FLOAT;0;False;4;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;143;658.9984,-1457.473;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;140;979.3939,-1223.919;Inherit;True;139;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;876.6395,-1384.326;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;148;1318.866,-1388.282;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;144;1054.241,-1652.131;Inherit;False;Property;_MainColor;MainColor ;10;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;3.600938,1.409801,1.687149,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;90;-5207.016,-184.1123;Inherit;False;585.1255;281.2644;Comment;2;109;92;RT;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-4681.4,-1104.938;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;109;-4952.803,-129.9392;Inherit;True;Property;_RT;RT;5;0;Create;True;0;0;0;False;0;False;-1;None;2537fbd56f7881a4497832c5bd04f87b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;145;1560.236,-1389.86;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-3280.863,-1704.859;Inherit;False;108;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-5184.833,-106.408;Inherit;False;96;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;207;-5287.8,-511.4189;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;1349.372,-1617.714;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1944.247,-1847.48;Float;False;True;-1;7;ASEMaterialInspector;0;0;CustomLighting;Whl/Fx/ScreenOutline;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;175;0;173;1
WireConnection;175;1;173;2
WireConnection;174;0;173;3
WireConnection;177;0;176;0
WireConnection;177;2;175;0
WireConnection;177;1;174;0
WireConnection;178;1;177;0
WireConnection;203;0;94;0
WireConnection;182;0;178;1
WireConnection;182;1;180;0
WireConnection;183;1;181;0
WireConnection;183;0;182;0
WireConnection;165;0;203;1
WireConnection;162;0;165;0
WireConnection;162;1;167;2
WireConnection;104;0;103;3
WireConnection;104;1;103;4
WireConnection;184;0;183;0
WireConnection;170;0;203;0
WireConnection;105;0;104;0
WireConnection;164;0;162;0
WireConnection;169;0;170;0
WireConnection;169;1;167;1
WireConnection;186;0;164;0
WireConnection;186;1;185;0
WireConnection;168;0;169;0
WireConnection;95;0;168;0
WireConnection;95;1;186;0
WireConnection;100;1;99;0
WireConnection;100;0;98;0
WireConnection;101;0;100;0
WireConnection;96;0;95;0
WireConnection;8;0;6;0
WireConnection;8;1;5;0
WireConnection;13;0;8;0
WireConnection;13;1;10;0
WireConnection;13;2;4;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;16;0;15;0
WireConnection;16;1;13;0
WireConnection;17;0;16;0
WireConnection;17;1;13;0
WireConnection;18;0;17;0
WireConnection;18;1;13;0
WireConnection;19;0;18;0
WireConnection;19;1;13;0
WireConnection;20;0;19;0
WireConnection;20;1;13;0
WireConnection;21;0;13;0
WireConnection;23;0;20;0
WireConnection;23;1;13;0
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;25;0;24;0
WireConnection;25;1;22;0
WireConnection;26;0;25;0
WireConnection;26;1;22;0
WireConnection;27;0;26;0
WireConnection;27;1;22;0
WireConnection;28;0;27;0
WireConnection;28;1;22;0
WireConnection;29;0;28;0
WireConnection;29;1;22;0
WireConnection;30;0;29;0
WireConnection;30;1;22;0
WireConnection;31;0;30;0
WireConnection;31;1;22;0
WireConnection;32;0;31;0
WireConnection;32;1;22;0
WireConnection;33;0;32;0
WireConnection;33;1;22;0
WireConnection;34;0;33;0
WireConnection;34;1;22;0
WireConnection;35;0;34;0
WireConnection;35;1;22;0
WireConnection;36;0;35;0
WireConnection;36;1;22;0
WireConnection;37;0;36;0
WireConnection;37;1;22;0
WireConnection;38;0;37;0
WireConnection;38;1;22;0
WireConnection;112;1;15;0
WireConnection;124;1;27;0
WireConnection;115;1;18;0
WireConnection;110;1;12;0
WireConnection;126;1;29;0
WireConnection;111;1;14;0
WireConnection;43;0;38;0
WireConnection;43;1;22;0
WireConnection;125;1;28;0
WireConnection;127;1;30;0
WireConnection;123;1;26;0
WireConnection;120;1;24;0
WireConnection;116;1;19;0
WireConnection;118;1;20;0
WireConnection;121;1;25;0
WireConnection;113;1;16;0
WireConnection;119;1;23;0
WireConnection;114;1;17;0
WireConnection;128;1;31;0
WireConnection;129;1;32;0
WireConnection;65;0;110;0
WireConnection;65;1;111;0
WireConnection;65;2;112;0
WireConnection;65;3;113;0
WireConnection;65;4;114;0
WireConnection;65;5;115;0
WireConnection;65;6;116;0
WireConnection;65;7;118;0
WireConnection;131;1;34;0
WireConnection;66;0;119;0
WireConnection;66;1;120;0
WireConnection;66;2;121;0
WireConnection;66;3;123;0
WireConnection;66;4;124;0
WireConnection;66;5;125;0
WireConnection;66;6;126;0
WireConnection;66;7;127;0
WireConnection;130;1;33;0
WireConnection;58;0;43;0
WireConnection;58;1;22;0
WireConnection;132;1;35;0
WireConnection;137;1;43;0
WireConnection;70;0;65;0
WireConnection;70;1;66;0
WireConnection;133;1;36;0
WireConnection;134;1;37;0
WireConnection;138;1;58;0
WireConnection;68;0;128;0
WireConnection;68;1;129;0
WireConnection;68;2;130;0
WireConnection;68;3;131;0
WireConnection;68;4;132;0
WireConnection;135;1;38;0
WireConnection;75;0;133;0
WireConnection;75;1;134;0
WireConnection;75;2;135;0
WireConnection;75;3;137;0
WireConnection;75;4;138;0
WireConnection;76;0;70;0
WireConnection;76;1;68;0
WireConnection;80;0;76;0
WireConnection;80;1;75;0
WireConnection;154;0;152;1
WireConnection;154;1;152;2
WireConnection;84;0;76;0
WireConnection;84;1;79;0
WireConnection;153;0;152;3
WireConnection;83;0;80;0
WireConnection;83;1;78;0
WireConnection;86;0;65;0
WireConnection;86;1;81;0
WireConnection;199;0;195;0
WireConnection;82;0;70;0
WireConnection;82;1;77;0
WireConnection;156;0;155;0
WireConnection;156;2;154;0
WireConnection;156;1;153;0
WireConnection;11;1;160;0
WireConnection;11;0;106;4
WireConnection;196;0;199;0
WireConnection;196;1;197;0
WireConnection;87;1;86;0
WireConnection;87;0;82;0
WireConnection;87;2;84;0
WireConnection;87;3;83;0
WireConnection;200;0;196;0
WireConnection;107;0;11;0
WireConnection;88;0;87;0
WireConnection;205;0;156;0
WireConnection;205;1;206;0
WireConnection;194;1;200;0
WireConnection;151;1;205;0
WireConnection;139;0;194;4
WireConnection;158;3;151;1
WireConnection;158;7;159;0
WireConnection;158;4;204;0
WireConnection;158;8;161;0
WireConnection;143;0;89;0
WireConnection;157;0;143;3
WireConnection;157;1;158;0
WireConnection;157;2;208;4
WireConnection;148;0;157;0
WireConnection;148;1;140;0
WireConnection;108;0;106;3
WireConnection;109;1;92;0
WireConnection;145;0;148;0
WireConnection;209;0;144;0
WireConnection;209;1;208;0
WireConnection;0;9;145;0
WireConnection;0;13;209;0
ASEEND*/
//CHKSM=7EC48658C12E24D20D78A99F5D93D9240545D82B