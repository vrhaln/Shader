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
		_EmissionStr("EmissionStr", Float) = 1
		_CenterGlowRangeStr("CenterGlowRange Str", Vector) = (0.5,1,0,0)
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
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
		sampler2D _Sampler6058;
		uniform float2 _ShiningTiling;
		uniform sampler2D _GradientTex;
		uniform float4 _GradientTex_ST;
		uniform float4 _MainColor;
		uniform float _EmissionStr;
		uniform float2 _CenterGlowRangeStr;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 temp_output_1_0_g2 = float2( 1,1 );
			float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * i.uv_texcoord.xy.x ) , ( i.uv_texcoord.xy.y * (temp_output_1_0_g2).y )));
			float2 temp_output_11_0_g2 = float2( 0,0 );
			float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord.xy);
			float2 panner19_g2 = ( ( _Time.y * (temp_output_11_0_g2).y ) * float2( 0,1 ) + i.uv_texcoord.xy);
			float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
			float2 uvs_TexCoord78_g2 = i.uv_texcoord;
			uvs_TexCoord78_g2.xy = i.uv_texcoord.xy * float2( 2,2 );
			float2 temp_output_31_0_g2 = ( uvs_TexCoord78_g2.xy - float2( 1,1 ) );
			float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g2 )));
			float2 break89_g2 = appendResult39_g2;
			float2 appendResult12 = (float2(( i.uv_texcoord.z * 0.1 ) , (-7.0 + (i.uv_texcoord.w - 0.0) * (4.5 - -7.0) / (1.0 - 0.0))));
			float2 temp_output_47_0_g2 = appendResult12;
			float temp_output_50_0_g2 = (temp_output_47_0_g2).y;
			float2 appendResult58_g2 = (float2(( break89_g2.x + (temp_output_47_0_g2).x ) , ( break89_g2.y + temp_output_50_0_g2 )));
			float4 tex2DNode7 = tex2D( _MainTex, tex2D( _NoiseTex, ( ( (tex2D( _Sampler6058, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( _ShiningTiling * appendResult58_g2 ) ) ).rg );
			float4 uvs_GradientTex = i.uv_texcoord;
			uvs_GradientTex.xy = i.uv_texcoord.xy * _GradientTex_ST.xy + _GradientTex_ST.zw;
			float4 tex2DNode20 = tex2D( _GradientTex, uvs_GradientTex.xy );
			c.rgb = ( ( ( saturate( tex2DNode7 ) * tex2DNode20.r ) * _MainColor * i.vertexColor * _EmissionStr * i.uv2_texcoord2.z ) + saturate( ( ( ( 1.0 - distance( i.uv_texcoord.xy , float2( 0.5,0.5 ) ) ) - _CenterGlowRangeStr.x ) * _CenterGlowRangeStr.y ) ) ).rgb;
			c.a = saturate( ( tex2DNode7.r * i.vertexColor.a * tex2DNode20.r ) );
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
-1874;181;1599;838;2521.09;817.3394;2.707548;True;True
Node;AmplifyShaderEditor.CommentaryNode;42;-2867.791,-439.1719;Inherit;False;1568.071;534.8583;Radial UV Distortion;7;12;38;11;33;32;5;56;Radial UV Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2817.791,-377.3742;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-2482.514,-250.1699;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2292.14,-306.7598;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-2482.761,-111.3136;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-7;False;4;FLOAT;4.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-2002.619,-389.1719;Inherit;False;Property;_ShiningTiling;ShiningTiling;5;0;Create;True;0;0;0;False;0;False;3,0.02;3,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;12;-2032.684,-230.636;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1573.207,449.016;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;46;-1536.207,726.016;Inherit;False;Constant;_Vector0;Vector 0;8;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;58;-1652.549,-264.184;Inherit;False;RadialUVDistortion2;-1;;2;b11d017adbaad6641aa59450fd648dfb;0;7;60;SAMPLER2D;_Sampler6058;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;6;-1111.849,-361.1569;Inherit;True;Property;_NoiseTex;NoiseTex;3;0;Create;True;0;0;0;False;0;False;-1;5a8d4e680ed8b6e4ab88c77001db906e;f8e07d1bee7054b4db8a698197267e32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;45;-1315.207,548.016;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-749.3533,-370.6358;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;f9f85f52c5ad25c48955458e0c2ad9a8;3b199975ce6c5b643939a84baa20fe1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-1076.697,218.5726;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;52;-1156.62,809.1761;Inherit;False;Property;_CenterGlowRangeStr;CenterGlowRange Str;7;0;Create;True;0;0;0;False;0;False;0.5,1;0.5,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;47;-1091.015,553.022;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-745.6341,200.3214;Inherit;True;Property;_GradientTex;GradientTex;4;0;Create;True;0;0;0;False;0;False;-1;5a8d4e680ed8b6e4ab88c77001db906e;0ce33015e757db34d81b91228d166bee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-843.4589,590.7526;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;-292.6211,-234.2922;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-118.0303,-155.7855;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-590.0077,830.825;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;16;-310.9966,241.7168;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-370.428,-117.0573;Inherit;False;Property;_EmissionStr;EmissionStr;6;0;Create;True;0;0;0;False;0;False;1;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-353.9333,50.60933;Inherit;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-602.8491,-114.9664;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;140.3578,-164.9569;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;41;-3597.354,-464.9121;Inherit;False;235;166;Comment;1;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;54;226.3418,211.5401;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;22.08169,371.379;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;435.4846,-16.36995;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-3547.354,-414.9121;Inherit;False;Property;_ZTestMode;ZTestMode;8;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;180.7038,396.3443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;56;-1721.639,-364.6012;Inherit;False;RadialUVDistortion_2;-1;;2;;0;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;740.6093,18.84447;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Shining;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;True;10;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;11;3
WireConnection;32;1;33;0
WireConnection;38;0;11;4
WireConnection;12;0;32;0
WireConnection;12;1;38;0
WireConnection;58;68;5;0
WireConnection;58;47;12;0
WireConnection;6;1;58;0
WireConnection;45;0;44;0
WireConnection;45;1;46;0
WireConnection;7;1;6;0
WireConnection;47;0;45;0
WireConnection;20;1;35;0
WireConnection;48;0;47;0
WireConnection;48;1;52;1
WireConnection;36;0;7;0
WireConnection;26;0;36;0
WireConnection;26;1;20;1
WireConnection;50;0;48;0
WireConnection;50;1;52;2
WireConnection;8;0;26;0
WireConnection;8;1;9;0
WireConnection;8;2;16;0
WireConnection;8;3;31;0
WireConnection;8;4;34;3
WireConnection;54;0;50;0
WireConnection;17;0;7;1
WireConnection;17;1;16;4
WireConnection;17;2;20;1
WireConnection;53;0;8;0
WireConnection;53;1;54;0
WireConnection;22;0;17;0
WireConnection;0;9;22;0
WireConnection;0;13;53;0
ASEEND*/
//CHKSM=B640A05DA9540D1332FBBA35ED8E8170242A789A