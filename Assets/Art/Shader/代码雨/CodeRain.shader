// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/CodeRain"
{
	Properties
	{
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_Maintex("Maintex", 2D) = "white" {}
		_ColumsRows("Colums Rows", Vector) = (7,7,0,0)
		_FlipSpeed("FlipSpeed", Float) = 1
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		[HDR]_SubColor("SubColor", Color) = (1,1,1,1)
		_SubColorRange("SubColorRange", Float) = 1
		_Tex2("Tex2", 2D) = "white" {}
		_PixelsXY("PixelsX Y", Vector) = (7,1,0,0)
		_NoiseScale("NoiseScale", Float) = 5
		_FlowSpeed("FlowSpeed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
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

		uniform sampler2D _Maintex;
		uniform float2 _Tiling;
		uniform float2 _ColumsRows;
		uniform float _FlipSpeed;
		uniform sampler2D _Tex2;
		uniform float _FlowSpeed;
		uniform float2 _PixelsXY;
		uniform float _NoiseScale;
		uniform float4 _MainColor;
		uniform float _SubColorRange;
		uniform float4 _SubColor;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_TexCoord3 = i.uv_texcoord * _Tiling;
			float temp_output_4_0_g1 = _ColumsRows.x;
			float temp_output_5_0_g1 = _ColumsRows.y;
			float2 appendResult7_g1 = (float2(temp_output_4_0_g1 , temp_output_5_0_g1));
			float totalFrames39_g1 = ( temp_output_4_0_g1 * temp_output_5_0_g1 );
			float2 appendResult8_g1 = (float2(totalFrames39_g1 , temp_output_5_0_g1));
			float mulTime17 = _Time.y * _FlipSpeed;
			float clampResult42_g1 = clamp( 0.0 , 0.0001 , ( totalFrames39_g1 - 1.0 ) );
			float temp_output_35_0_g1 = frac( ( ( mulTime17 + clampResult42_g1 ) / totalFrames39_g1 ) );
			float2 appendResult29_g1 = (float2(temp_output_35_0_g1 , ( 1.0 - temp_output_35_0_g1 )));
			float2 temp_output_15_0_g1 = ( ( uv_TexCoord3 / appendResult7_g1 ) + ( floor( ( appendResult8_g1 * appendResult29_g1 ) ) / appendResult7_g1 ) );
			float mulTime14 = _Time.y * _FlowSpeed;
			float pixelWidth5 =  1.0f / _PixelsXY.x;
			float pixelHeight5 = 1.0f / _PixelsXY.y;
			half2 pixelateduv5 = half2((int)(i.uv_texcoord.x / pixelWidth5) * pixelWidth5, (int)(i.uv_texcoord.y / pixelHeight5) * pixelHeight5);
			float simplePerlin2D10 = snoise( pixelateduv5*_NoiseScale );
			simplePerlin2D10 = simplePerlin2D10*0.5 + 0.5;
			float2 temp_cast_0 = (simplePerlin2D10).xx;
			float2 panner11 = ( mulTime14 * temp_cast_0 + i.uv_texcoord);
			float4 tex2DNode9 = tex2D( _Tex2, panner11 );
			float temp_output_21_0 = ( tex2D( _Maintex, temp_output_15_0_g1 ).r * tex2DNode9.r );
			c.rgb = ( ( temp_output_21_0 * _MainColor ) + ( temp_output_21_0 * floor( ( tex2DNode9.r * _SubColorRange ) ) * _SubColor ) ).rgb;
			c.a = temp_output_21_0;
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
7;231;1481;788;1884.81;-29.48468;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1503.442,379.0627;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-1474.693,552.7445;Inherit;False;Property;_PixelsXY;PixelsX Y;9;0;Create;True;0;0;0;False;0;False;7,1;10,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;37;-963.4304,757.2886;Inherit;False;Property;_FlowSpeed;FlowSpeed;11;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;5;-1236.648,526.5732;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1203.431,653.6137;Inherit;False;Property;_NoiseScale;NoiseScale;10;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;33;-1505.16,-34.34966;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;0,0;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;18;-1290.334,251.1767;Inherit;False;Property;_FlipSpeed;FlipSpeed;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;10;-1006.417,521.7964;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;5.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-752.2717,758.3853;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-509.3313,383.6972;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1189.891,-49.78367;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;15;-1170.05,90.08585;Inherit;False;Property;_ColumsRows;Colums Rows;3;0;Create;True;0;0;0;False;0;False;7,7;4,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1100.441,255.9702;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2;-806.097,59.42684;Inherit;False;Flipbook;-1;;1;53c2488c220f6564ca6c90721ee16673;2,71,0,68,0;8;51;SAMPLER2D;0.0;False;13;FLOAT2;0,0;False;4;FLOAT;3;False;5;FLOAT;3;False;24;FLOAT;0;False;2;FLOAT;0;False;55;FLOAT;0;False;70;FLOAT;0;False;5;COLOR;53;FLOAT2;0;FLOAT;47;FLOAT;48;FLOAT;62
Node;AmplifyShaderEditor.RangedFloatNode;32;-124.9359,723.4502;Inherit;False;Property;_SubColorRange;SubColorRange;7;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-225.7213,451.8098;Inherit;True;Property;_Tex2;Tex2;8;0;Create;True;0;0;0;False;0;False;-1;21b93a22e93caab489ec4fefe73ae7cb;7057d8ee78b411c4bb357ce59c32a8a6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-445.9972,55.52685;Inherit;True;Property;_Maintex;Maintex;2;0;Create;True;0;0;0;False;0;False;-1;3c1fdea0a46be5145b34e64be512eee6;1667643fe94296b4795f9f41cfe73b33;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;61.06409,661.4502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;177.684,406.5744;Inherit;False;Property;_MainColor;MainColor;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;2.670157,0,0.2255018,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;24;180.9611,754.3193;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;160.5019,136.3661;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;162.2761,988.0997;Inherit;False;Property;_SubColor;SubColor;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;461.07,557.9093;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;471.6146,277.5422;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;684.3694,354.0702;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;29;-390.5332,627.07;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;888.2957,-8.841074;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/CodeRain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;6;0
WireConnection;5;1;7;1
WireConnection;5;2;7;2
WireConnection;10;0;5;0
WireConnection;10;1;19;0
WireConnection;14;0;37;0
WireConnection;11;0;6;0
WireConnection;11;2;10;0
WireConnection;11;1;14;0
WireConnection;3;0;33;0
WireConnection;17;0;18;0
WireConnection;2;13;3;0
WireConnection;2;4;15;1
WireConnection;2;5;15;2
WireConnection;2;2;17;0
WireConnection;9;1;11;0
WireConnection;1;1;2;0
WireConnection;31;0;9;1
WireConnection;31;1;32;0
WireConnection;24;0;31;0
WireConnection;21;0;1;1
WireConnection;21;1;9;1
WireConnection;25;0;21;0
WireConnection;25;1;24;0
WireConnection;25;2;27;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;26;0;22;0
WireConnection;26;1;25;0
WireConnection;0;9;21;0
WireConnection;0;13;26;0
ASEEND*/
//CHKSM=A33DA8B4B23122D471773072B42D6AD6B757D56F