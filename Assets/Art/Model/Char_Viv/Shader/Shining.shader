// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Shining"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,1)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_GradientTex("GradientTex", 2D) = "white" {}
		_ShiningTiling("ShiningTiling", Vector) = (3,0.02,0,0)
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_EmissionStr("EmissionStr", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 uv2_texcoord2;
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

		uniform float _ZTestMode;
		uniform sampler2D _MainTex;
		uniform sampler2D _NoiseTex;
		sampler2D _Sampler601;
		uniform float2 _ShiningTiling;
		uniform sampler2D _GradientTex;
		sampler2D _Sampler6028;
		uniform float4 _MainColor;
		uniform float _EmissionStr;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 temp_output_1_0_g3 = float2( 1,1 );
			float2 appendResult10_g3 = (float2(( (temp_output_1_0_g3).x * i.uv_texcoord.xy.x ) , ( i.uv_texcoord.xy.y * (temp_output_1_0_g3).y )));
			float2 temp_output_11_0_g3 = float2( 0,0 );
			float2 panner18_g3 = ( ( (temp_output_11_0_g3).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord.xy);
			float2 panner19_g3 = ( ( _Time.y * (temp_output_11_0_g3).y ) * float2( 0,1 ) + i.uv_texcoord.xy);
			float2 appendResult24_g3 = (float2((panner18_g3).x , (panner19_g3).y));
			float2 appendResult12 = (float2(( i.uv_texcoord.z * 0.1 ) , ( i.uv_texcoord.w * 0.01 )));
			float2 temp_output_47_0_g3 = appendResult12;
			float2 uvs_TexCoord78_g3 = i.uv_texcoord;
			uvs_TexCoord78_g3.xy = i.uv_texcoord.xy * float2( 2,2 );
			float2 temp_output_31_0_g3 = ( uvs_TexCoord78_g3.xy - float2( 1,1 ) );
			float2 appendResult39_g3 = (float2(frac( ( atan2( (temp_output_31_0_g3).x , (temp_output_31_0_g3).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g3 )));
			float2 panner54_g3 = ( ( (temp_output_47_0_g3).x * _Time.y ) * float2( 1,0 ) + appendResult39_g3);
			float2 panner55_g3 = ( ( _Time.y * (temp_output_47_0_g3).y ) * float2( 0,1 ) + appendResult39_g3);
			float2 appendResult58_g3 = (float2((panner54_g3).x , (panner55_g3).y));
			float4 tex2DNode7 = tex2D( _MainTex, tex2D( _NoiseTex, ( ( (tex2D( _Sampler601, ( appendResult10_g3 + appendResult24_g3 ) )).rg * 1.0 ) + ( _ShiningTiling * appendResult58_g3 ) ) ).rg );
			float2 temp_output_1_0_g2 = float2( 1,1 );
			float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * i.uv_texcoord.xy.x ) , ( i.uv_texcoord.xy.y * (temp_output_1_0_g2).y )));
			float2 temp_output_11_0_g2 = float2( 0,0 );
			float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord.xy);
			float2 panner19_g2 = ( ( _Time.y * (temp_output_11_0_g2).y ) * float2( 0,1 ) + i.uv_texcoord.xy);
			float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
			float2 temp_output_47_0_g2 = float2( 1,0 );
			float2 uvs_TexCoord78_g2 = i.uv_texcoord;
			uvs_TexCoord78_g2.xy = i.uv_texcoord.xy * float2( 2,2 );
			float2 temp_output_31_0_g2 = ( uvs_TexCoord78_g2.xy - float2( 1,1 ) );
			float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g2 )));
			float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _Time.y ) * float2( 1,0 ) + appendResult39_g2);
			float2 panner55_g2 = ( ( _Time.y * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
			float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
			float2 appendResult24 = (float2((0.0 + ((( ( (tex2D( _Sampler6028, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( float2( 0.18,0.33 ) * appendResult58_g2 ) )).y - 0.0) * (1.0 - 0.0) / (0.3 - 0.0)) , 0.5));
			c.rgb = ( ( tex2DNode7.r * tex2D( _GradientTex, appendResult24 ).r ) * _MainColor * i.vertexColor * _EmissionStr * i.uv2_texcoord2.z ).rgb;
			c.a = saturate( ( tex2DNode7.r * i.vertexColor.a ) );
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
119;278;1248;741;2481.094;434.0823;1.391281;True;True
Node;AmplifyShaderEditor.Vector2Node;30;-2005.463,242.9039;Inherit;False;Constant;_Vector3;Vector 3;8;0;Create;True;0;0;0;False;0;False;0.18,0.33;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;15;-2701.992,61.5887;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;29;-1997.869,369.4936;Inherit;False;Constant;_Vector2;Vector 2;8;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2742.39,-241.9365;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-2703.814,-65.13666;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2441.279,-74.19708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2450.531,-161.8195;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;28;-1652.62,213.2242;Inherit;False;RadialUVDistortion;-1;;2;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6028;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;5;-2202.238,-413.6415;Inherit;False;Property;_ShiningTiling;ShiningTiling;5;0;Create;True;0;0;0;False;0;False;3,0.02;3,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;12;-2257.203,-147.5571;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;23;-1221.917,207.7776;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1;-1541.485,-214.3421;Inherit;False;RadialUVDistortion;-1;;3;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler601;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;-1053.501,236.6904;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1095.673,-176.282;Inherit;True;Property;_NoiseTex;NoiseTex;3;0;Create;True;0;0;0;False;0;False;-1;5a8d4e680ed8b6e4ab88c77001db906e;f8e07d1bee7054b4db8a698197267e32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;-838.6552,242.6732;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;20;-594.814,214.3979;Inherit;True;Property;_GradientTex;GradientTex;4;0;Create;True;0;0;0;False;0;False;-1;5a8d4e680ed8b6e4ab88c77001db906e;2e2c7293ddee2ff40b7a72f796ceaaf6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;16;-389.4229,611.7292;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-702.6361,-150.13;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;f9f85f52c5ad25c48955458e0c2ad9a8;448441a27ca22c74b89d52c408cc7bd8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-256.9684,255.0462;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;22.08169,371.379;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-205.6123,44.50219;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-436.3817,440.7312;Inherit;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-227.6516,156.4302;Inherit;False;Property;_EmissionStr;EmissionStr;8;0;Create;True;0;0;0;False;0;False;1;1.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-2678.353,204.4139;Inherit;False;Property;_RingPanner;RingPanner;6;0;Create;True;0;0;0;False;0;False;0.1,10;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-1132.763,514.5542;Inherit;False;Property;_ZTestMode;ZTestMode;7;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-529.2169,90.77621;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;180.7038,396.3443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;-1986.211,662.2244;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;34.05469,75.38052;Inherit;True;5;5;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;27;-619.2885,427.5276;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;462.9611,129.1919;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Shining;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;True;10;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;11;4
WireConnection;14;1;15;0
WireConnection;32;0;11;3
WireConnection;32;1;33;0
WireConnection;28;68;30;0
WireConnection;28;47;29;0
WireConnection;12;0;32;0
WireConnection;12;1;14;0
WireConnection;23;0;28;0
WireConnection;1;68;5;0
WireConnection;1;47;12;0
WireConnection;25;0;23;0
WireConnection;6;1;1;0
WireConnection;24;0;25;0
WireConnection;20;1;24;0
WireConnection;7;1;6;0
WireConnection;17;0;7;1
WireConnection;17;1;16;4
WireConnection;26;0;7;1
WireConnection;26;1;20;1
WireConnection;22;0;17;0
WireConnection;8;0;26;0
WireConnection;8;1;9;0
WireConnection;8;2;16;0
WireConnection;8;3;31;0
WireConnection;8;4;34;3
WireConnection;0;9;22;0
WireConnection;0;13;8;0
ASEEND*/
//CHKSM=7C0120B70275E050600B89722BEAF539E3DFF14D