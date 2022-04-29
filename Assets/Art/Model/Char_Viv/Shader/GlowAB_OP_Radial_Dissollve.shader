// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/GlowAB_OP_Radial_Dissollve"
{
	Properties
	{
		[Toggle(_UV_WCONTORLEMISSION_ON)] _UV_WContorlEmission("UV_WContorlEmission", Float) = 0
		[Toggle(_UV_TCONTORLDISS_ON)] _UV_TContorlDiss("UV_TContorlDiss", Float) = 0
		[Toggle(_UV2_WCONTORLOFFSET_ON)] _UV2_WContorlOffset("UV2_WContorlOffset", Float) = 0
		[Toggle(_UV2_TCONTORLOFFSET_ON)] _UV2_TContorlOffset("UV2_TContorlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_EmissionStr("EmissionStr", Float) = 1
		_MainColor("MainColor", Color) = (0,0,0,0)
		_Ramp("Ramp", 2D) = "white" {}
		_RampScale("RampScale", Vector) = (1,0.5,0,0)
		_Noise("Noise", 2D) = "white" {}
		_NoiseScale("NoiseScale", Vector) = (1,0.5,0,0)
		_NoiseTexPanner("NoiseTexPanner", Vector) = (0,0,1,0)
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_DissolutionTex("DissolutionTex", 2D) = "white" {}
		_DissolutionTexRampScale("DissolutionTexRampScale", Vector) = (1,0.5,0,0)
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		_DissolveHardness("DissolveHardness", Range( 0.51 , 1)) = 0.3935294
		_RampTex("RampTex", 2D) = "white" {}
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
		#pragma target 4.0
		#pragma shader_feature_local _UV2_WCONTORLOFFSET_ON
		#pragma shader_feature_local _UV2_TCONTORLOFFSET_ON
		#pragma shader_feature_local _UV_TCONTORLDISS_ON
		#pragma shader_feature_local _UV_WCONTORLEMISSION_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
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

		uniform float _CullMode;
		uniform float _ZTestMode;
		uniform float _DissolveHardness;
		uniform sampler2D _Ramp;
		uniform float2 _RampScale;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Noise;
		uniform float3 _NoiseTexPanner;
		uniform float2 _NoiseScale;
		uniform sampler2D _DissolutionTex;
		uniform float3 _DissolutionTexPanner;
		uniform float2 _DissolutionTexRampScale;
		uniform float4 _MainColor;
		uniform float _EmissionStr;
		uniform sampler2D _RampTex;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uvs_TexCoord63 = i.uv_texcoord;
			uvs_TexCoord63.xy = i.uv_texcoord.xy * float2( 2,2 );
			float2 temp_output_55_0 = ( uvs_TexCoord63.xy - float2( 1,1 ) );
			float2 appendResult66 = (float2(frac( ( atan2( (temp_output_55_0).x , (temp_output_55_0).y ) / 6.28318548202515 ) ) , length( temp_output_55_0 )));
			float2 RadialUV70 = appendResult66;
			#ifdef _UV2_WCONTORLOFFSET_ON
				float staticSwitch37 = i.uv2_texcoord2.z;
			#else
				float staticSwitch37 = 1.0;
			#endif
			float UV2W35 = staticSwitch37;
			float2 appendResult12 = (float2(0.0 , UV2W35));
			float2 temp_cast_0 = (0.5).xx;
			float2 appendResult93 = (float2(_RampScale.x , saturate( _RampScale.y )));
			float4 tex2DNode27 = tex2D( _Ramp, ( ( ( ( RadialUV70 + appendResult12 ) - temp_cast_0 ) * appendResult93 ) + 0.5 ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode47 = tex2D( _MainTex, uv_MainTex );
			float MainTexG25 = tex2DNode47.g;
			float mulTime99 = _Time.y * _NoiseTexPanner.z;
			float2 appendResult98 = (float2(_NoiseTexPanner.x , _NoiseTexPanner.y));
			#ifdef _UV2_TCONTORLOFFSET_ON
				float staticSwitch36 = i.uv2_texcoord2.w;
			#else
				float staticSwitch36 = 1.0;
			#endif
			float UV2T34 = staticSwitch36;
			float2 appendResult43 = (float2(0.0 , UV2T34));
			float2 panner101 = ( mulTime99 * ( appendResult98 + appendResult43 ) + ( RadialUV70 * _NoiseScale ));
			float EmissionColor82 = ( ( tex2DNode27.r * ( tex2DNode27.r + MainTexG25 ) ) * saturate( tex2D( _Noise, ( panner101 + float2( 0,0 ) ) ).r ) );
			float VertexColorA17 = i.vertexColor.a;
			float mulTime136 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult134 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float2 temp_cast_1 = (0.5).xx;
			float2 appendResult128 = (float2(_DissolutionTexRampScale.x , saturate( _DissolutionTexRampScale.y )));
			float2 panner132 = ( mulTime136 * appendResult134 + ( ( ( RadialUV70 - temp_cast_1 ) * appendResult128 ) + 0.5 ));
			#ifdef _UV_TCONTORLDISS_ON
				float staticSwitch33 = i.uv_texcoord.w;
			#else
				float staticSwitch33 = 1.0;
			#endif
			float UV1T31 = staticSwitch33;
			float smoothstepResult119 = smoothstep( ( 1.0 - _DissolveHardness ) , _DissolveHardness , ( ( EmissionColor82 * VertexColorA17 ) * saturate( ( tex2D( _DissolutionTex, panner132 ).r + 1.0 + ( -2.0 * UV1T31 ) ) ) ));
			float FinalOpacity80 = smoothstepResult119;
			float3 VertexColorRGB3 = (i.vertexColor).rgb;
			#ifdef _UV_WCONTORLEMISSION_ON
				float staticSwitch10 = i.uv_texcoord.z;
			#else
				float staticSwitch10 = 1.0;
			#endif
			float UV1W30 = staticSwitch10;
			float2 appendResult139 = (float2(FinalOpacity80 , 0.0));
			float4 FinalBaseColor8 = ( _MainColor * float4( VertexColorRGB3 , 0.0 ) * UV1W30 * _EmissionStr * tex2D( _RampTex, saturate( appendResult139 ) ) );
			c.rgb = FinalBaseColor8.rgb;
			c.a = FinalOpacity80;
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
-1880;38;1717;863;-957.7692;895.1185;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;54;-2416.466,-2194.842;Inherit;False;2072.726;509.4896;Radial Math;13;70;66;59;56;62;60;65;57;58;55;61;63;64;Radial Math;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;64;-2352.228,-2051.319;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;61;-2136.054,-1895.853;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-2192.228,-2067.319;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-1857.973,-2051.094;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;58;-1648.465,-2130.842;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;57;-1648.465,-2050.842;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;7;-3972.653,-2208.389;Inherit;False;1489.423;1051.603;UV1;12;49;48;38;37;36;35;34;33;31;30;20;10;UV1&UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.ATan2OpNode;65;-1403.926,-2131.863;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;60;-1399.114,-2017.347;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3381.49,-1523.856;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-1240.295,-2128.685;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-3908.927,-1515.042;Inherit;True;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;37;-3173.489,-1507.856;Inherit;False;Property;_UV2_WContorlOffset;UV2_WContorlOffset;3;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;56;-1103.072,-2082.731;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;59;-1586.585,-1886.471;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;66;-843.0497,-1983.119;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-2837.56,-1501.797;Inherit;False;UV2W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;36;-3174.511,-1318.953;Inherit;False;Property;_UV2_TContorlOffset;UV2_TContorlOffset;4;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1207.034,-1093.434;Inherit;False;35;UV2W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1193.955,-1200.96;Inherit;False;Constant;_Float6;Float 6;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-603.534,-1976.808;Inherit;False;RadialUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2844.92,-1296.437;Inherit;False;UV2T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;89;-860.5198,-925.2515;Inherit;False;Property;_RampScale;RampScale;9;0;Create;True;0;0;0;False;0;False;1,0.5;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;12;-958.2072,-1172.703;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-942.4811,-1291.983;Inherit;False;70;RadialUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-578.1832,-1062.105;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;91;-688.4467,-853.7368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-705.8188,-1242.028;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1815.111,-123.3422;Inherit;False;Constant;_Float7;Float 7;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1831.278,-4.514225;Inherit;False;34;UV2T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;97;-1814.82,-321.9976;Inherit;False;Property;_NoiseTexPanner;NoiseTexPanner;12;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;76;-1453.167,-411.5917;Inherit;False;Property;_NoiseScale;NoiseScale;11;0;Create;True;0;0;0;False;0;False;1,0.5;3,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;43;-1610.724,-74.20691;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;-426.1834,-1245.105;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;85;-3963.324,-1086.051;Inherit;False;749.6489;404.8277;MainTex;4;25;45;24;47;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-478.4467,-945.7368;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-1449.177,-530.2517;Inherit;False;70;RadialUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1494.821,-292.2435;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1171.153,-336.0098;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;47;-3913.324,-956.6038;Inherit;True;Property;_MainTex;MainTex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;131;-2398.13,857.1364;Inherit;False;Property;_DissolutionTexRampScale;DissolutionTexRampScale;16;0;Create;True;0;0;0;False;0;False;1,0.5;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;99;-1462,-191.0608;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-249.3423,-1223.914;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1122.081,-451.3878;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-70.18336,-1208.105;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-3440.653,-914.087;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;101;-918.069,-384.7148;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2220.077,519.1184;Inherit;False;70;RadialUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;126;-2185.936,977.3692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-2075.673,769.0012;Inherit;False;Constant;_Float8;Float 8;15;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;127;-1923.673,586.0012;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;128;-1975.936,885.3693;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-3461.778,-2158.389;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-3922.653,-2003.396;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-684.7081,-384.6447;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;209.6023,-776.265;Inherit;False;25;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;269.2144,-1219.584;Inherit;True;Property;_Ramp;Ramp;8;0;Create;True;0;0;0;False;0;False;-1;da2150fdbd9743b4a9ce23c537eeb33b;5408160b7fbcf5c47a22e61f92c29749;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;87;425.3535,-797.7509;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;133;-1595.507,749.0394;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;17;0;Create;True;0;0;0;False;0;False;0,0,1;0.2,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1746.832,607.1923;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;33;-3138.389,-1845.295;Inherit;False;Property;_UV_TContorlDiss;UV_TContorlDiss;2;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-500.5808,-414.4752;Inherit;True;Property;_Noise;Noise;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;136;-1320.507,865.0395;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-1567.673,623.0012;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;134;-1306.507,748.0394;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;638.2033,-818.2678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;502.9764,-375.8634;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;110;-3946.401,-577.3174;Inherit;False;630.96;262.5266;VertexColor;4;1;2;3;17;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-2833.097,-1845.465;Inherit;False;UV1T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-786.1038,998.3519;Inherit;False;Constant;_Float4;Float 4;15;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-822.2783,1098.496;Inherit;False;31;UV1T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1;-3896.401,-524.3513;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;828.4011,-406.9306;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;132;-1152.521,710.7109;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-3632.442,-430.7906;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-692.5406,888.4874;Inherit;False;Constant;_Float3;Float 3;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-759.8296,650.366;Inherit;True;Property;_DissolutionTex;DissolutionTex;15;0;Create;True;0;0;0;False;0;False;-1;None;d138738374bc8e7478f68cf9fb383912;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-619.1041,1045.352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;1203.971,-414.4651;Inherit;False;EmissionColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-298.8845,818.8217;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-143.7827,668.5692;Inherit;False;17;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-191.6931,529.4189;Inherit;False;82;EmissionColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;100.7004,612.1138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;117;-86.0515,814.2632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-560.917,1273.674;Inherit;False;Property;_DissolveHardness;DissolveHardness;18;0;Create;True;0;0;0;False;0;False;0.3935294;0.65;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;258.8095,640.9681;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;118;-92.23482,918.2735;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;119;466.0655,708.5674;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;931.7412,700.858;Inherit;True;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;1424.166,-575.9729;Inherit;True;80;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;10;-3139.241,-2117.308;Inherit;False;Property;_UV_WContorlEmission;UV_WContorlEmission;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;2;-3714.441,-527.3174;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;139;1662.576,-554.0961;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;141;1849.714,-531.4966;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;3;-3546.441,-524.3174;Inherit;False;VertexColorRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-2831.827,-2105.464;Inherit;False;UV1W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;140;2019.908,-553.2322;Inherit;True;Property;_RampTex;RampTex;19;0;Create;True;0;0;0;False;0;False;-1;None;fde817294a5b8bc45820eac6b2d6db88;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;1521.859,-913.7555;Inherit;True;Property;_EmissionStr;EmissionStr;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;1482.856,-1145.023;Inherit;True;30;UV1W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;5;1482.863,-1356.376;Inherit;True;3;VertexColorRGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;23;1474.473,-1552.26;Inherit;False;Property;_MainColor;MainColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;2175.962,-1135.763;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;2472.59,-1139.409;Inherit;True;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;9;-3135.81,-1087.395;Inherit;False;235;263.753;Eunm;2;32;28;Eunm;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-1139.247,1109.424;Inherit;False;Constant;_Float5;Float 5;17;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;3152.495,176.7494;Inherit;False;80;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-3439.008,-797.2231;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-3437.676,-1036.051;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-3085.809,-939.6429;Inherit;False;Property;_ZTestMode;ZTestMode;14;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;3127.219,288.7192;Inherit;True;8;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;1864.234,-857.4117;Inherit;False;82;EmissionColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-3082.33,-1037.397;Inherit;False;Property;_CullMode;CullMode;13;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3517.729,56.1631;Float;False;True;-1;4;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/GlowAB_OP_Radial_Dissollve;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;True;32;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;28;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;64;0
WireConnection;55;0;63;0
WireConnection;55;1;61;0
WireConnection;58;0;55;0
WireConnection;57;0;55;0
WireConnection;65;0;58;0
WireConnection;65;1;57;0
WireConnection;62;0;65;0
WireConnection;62;1;60;0
WireConnection;37;1;20;0
WireConnection;37;0;49;3
WireConnection;56;0;62;0
WireConnection;59;0;55;0
WireConnection;66;0;56;0
WireConnection;66;1;59;0
WireConnection;35;0;37;0
WireConnection;36;1;20;0
WireConnection;36;0;49;4
WireConnection;70;0;66;0
WireConnection;34;0;36;0
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;91;0;89;2
WireConnection;67;0;71;0
WireConnection;67;1;12;0
WireConnection;43;0;19;0
WireConnection;43;1;44;0
WireConnection;94;0;67;0
WireConnection;94;1;95;0
WireConnection;93;0;89;1
WireConnection;93;1;91;0
WireConnection;98;0;97;1
WireConnection;98;1;97;2
WireConnection;69;0;98;0
WireConnection;69;1;43;0
WireConnection;99;0;97;3
WireConnection;90;0;94;0
WireConnection;90;1;93;0
WireConnection;75;0;72;0
WireConnection;75;1;76;0
WireConnection;96;0;90;0
WireConnection;96;1;95;0
WireConnection;25;0;47;2
WireConnection;101;0;75;0
WireConnection;101;2;69;0
WireConnection;101;1;99;0
WireConnection;126;0;131;2
WireConnection;127;0;124;0
WireConnection;127;1;125;0
WireConnection;128;0;131;1
WireConnection;128;1;126;0
WireConnection;102;0;101;0
WireConnection;27;1;96;0
WireConnection;87;0;27;1
WireConnection;87;1;86;0
WireConnection;129;0;127;0
WireConnection;129;1;128;0
WireConnection;33;1;38;0
WireConnection;33;0;48;4
WireConnection;39;1;102;0
WireConnection;136;0;133;3
WireConnection;130;0;129;0
WireConnection;130;1;125;0
WireConnection;134;0;133;1
WireConnection;134;1;133;2
WireConnection;88;0;27;1
WireConnection;88;1;87;0
WireConnection;21;0;39;1
WireConnection;31;0;33;0
WireConnection;29;0;88;0
WireConnection;29;1;21;0
WireConnection;132;0;130;0
WireConnection;132;2;134;0
WireConnection;132;1;136;0
WireConnection;17;0;1;4
WireConnection;116;1;132;0
WireConnection;114;0;113;0
WireConnection;114;1;121;0
WireConnection;82;0;29;0
WireConnection;111;0;116;1
WireConnection;111;1;112;0
WireConnection;111;2;114;0
WireConnection;73;0;84;0
WireConnection;73;1;74;0
WireConnection;117;0;111;0
WireConnection;123;0;73;0
WireConnection;123;1;117;0
WireConnection;118;0;120;0
WireConnection;119;0;123;0
WireConnection;119;1;118;0
WireConnection;119;2;120;0
WireConnection;80;0;119;0
WireConnection;10;1;38;0
WireConnection;10;0;48;3
WireConnection;2;0;1;0
WireConnection;139;0;137;0
WireConnection;141;0;139;0
WireConnection;3;0;2;0
WireConnection;30;0;10;0
WireConnection;140;1;141;0
WireConnection;6;0;23;0
WireConnection;6;1;5;0
WireConnection;6;2;26;0
WireConnection;6;3;4;0
WireConnection;6;4;140;0
WireConnection;8;0;6;0
WireConnection;45;0;47;3
WireConnection;24;0;47;1
WireConnection;0;9;81;0
WireConnection;0;13;50;0
ASEEND*/
//CHKSM=78D2ADDB1CA1D56201D84A69E5531766EAC16F20