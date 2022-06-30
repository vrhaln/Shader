// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Distor"
{
	Properties
	{
		_Rain("Rain", 2D) = "white" {}
		_NormalStr("NormalStr", Float) = 1
		_NormalOffset("NormalOffset", Float) = 1
		_BlurStr("BlurStr", Float) = 1
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskMul("MaskMul", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
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

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _BlurStr;
		uniform sampler2D _Rain;
		uniform float4 _Rain_ST;
		uniform sampler2D _MaskTex;
		uniform float _MaskMul;
		uniform float _NormalOffset;
		uniform float _NormalStr;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


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
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 temp_cast_0 = (1000.0).xx;
			float2 uv_TexCoord16 = i.uv_texcoord * temp_cast_0;
			float simplePerlin2D13 = snoise( uv_TexCoord16 );
			simplePerlin2D13 = simplePerlin2D13*0.5 + 0.5;
			float2 appendResult21 = (float2(sin( simplePerlin2D13 ) , cos( simplePerlin2D13 )));
			float2 temp_output_24_0 = frac( ( appendResult21 * 65.54 ) );
			float2 uv_Rain = i.uv_texcoord * _Rain_ST.xy + _Rain_ST.zw;
			float2 appendResult40 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float lerpResult30 = lerp( _BlurStr , 1.0 , saturate( ( ( tex2D( _Rain, uv_Rain ).r * 50.0 ) + ( tex2D( _MaskTex, appendResult40 ).r * _MaskMul ) ) ));
			float2 uv0_Rain = i.uv_texcoord * _Rain_ST.xy + _Rain_ST.zw;
			float2 temp_output_2_0_g1 = uv0_Rain;
			float2 break6_g1 = temp_output_2_0_g1;
			float temp_output_25_0_g1 = ( pow( _NormalOffset , 3.0 ) * 0.1 );
			float2 appendResult8_g1 = (float2(( break6_g1.x + temp_output_25_0_g1 ) , break6_g1.y));
			float4 tex2DNode14_g1 = tex2D( _Rain, temp_output_2_0_g1 );
			float temp_output_4_0_g1 = _NormalStr;
			float3 appendResult13_g1 = (float3(1.0 , 0.0 , ( ( tex2D( _Rain, appendResult8_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float2 appendResult9_g1 = (float2(break6_g1.x , ( break6_g1.y + temp_output_25_0_g1 )));
			float3 appendResult16_g1 = (float3(0.0 , 1.0 , ( ( tex2D( _Rain, appendResult9_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float3 normalizeResult22_g1 = normalize( cross( appendResult13_g1 , appendResult16_g1 ) );
			float4 screenColor18 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ( ( ( ase_grabScreenPosNorm - float4( temp_output_24_0, 0.0 , 0.0 ) ) * lerpResult30 ) + float4( temp_output_24_0, 0.0 , 0.0 ) ) + float4( normalizeResult22_g1 , 0.0 ) ).xy);
			c.rgb = screenColor18.rgb;
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
Version=18100
281;142;1338;893;4079.77;1195.635;2.664996;True;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-3241.704,-516.3336;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;False;1000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-3042.239,-580.5957;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;39;-2217.929,319.281;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;13;-2803.704,-571.2252;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1958.929,327.281;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-3078.879,157.5645;Inherit;True;Property;_Rain;Rain;2;0;Create;True;0;0;False;0;False;None;817ad6f67598da44ab95b176a652df29;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CosOpNode;20;-2509.47,-449.8267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;19;-2508.47,-673.8267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-2517.73,-48.02892;Inherit;True;Property;_TextureSample3;Texture Sample 3;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-1630.469,352.9819;Inherit;False;Property;_MaskMul;MaskMul;7;0;Create;True;0;0;False;0;False;1;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-1802.214,154.1902;Inherit;True;Property;_MaskTex;MaskTex;6;0;Create;True;0;0;False;0;False;-1;None;7605196420d204945843c4c794c58361;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1471.469,212.9819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2171.81,-306.1051;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;False;65.54;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-2247.47,-527.8267;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2030.558,-68.46761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1486.728,13.75453;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1958.47,-417.8267;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1401.655,-258.4216;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1397.928,-360.1395;Inherit;False;Property;_BlurStr;BlurStr;5;0;Create;True;0;0;False;0;False;1;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-1379.918,-155.7254;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;24;-1717.81,-425.1051;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;12;-1796.833,-748.0912;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-1389.928,-584.1395;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;30;-1204.051,-284.2975;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1113.928,-516.1395;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2624.678,377.9911;Inherit;False;Property;_NormalStr;NormalStr;3;0;Create;True;0;0;False;0;False;1;-0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2626.578,294.2911;Inherit;False;Property;_NormalOffset;NormalOffset;4;0;Create;True;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-856.037,-436.8717;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;5;-2304.534,163.5771;Inherit;False;NormalCreate;0;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-669.2817,-339.727;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;18;-484.5754,-336.1778;Inherit;False;Global;_GrabScreen1;Grab Screen 1;1;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-213.9766,-544.155;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Distor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;17;0
WireConnection;13;0;16;0
WireConnection;40;0;39;1
WireConnection;40;1;39;2
WireConnection;20;0;13;0
WireConnection;19;0;13;0
WireConnection;31;0;6;0
WireConnection;37;1;40;0
WireConnection;41;0;37;1
WireConnection;41;1;42;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;32;0;31;1
WireConnection;36;0;32;0
WireConnection;36;1;41;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;33;0;36;0
WireConnection;24;0;22;0
WireConnection;25;0;12;0
WireConnection;25;1;24;0
WireConnection;30;0;27;0
WireConnection;30;1;34;0
WireConnection;30;2;33;0
WireConnection;26;0;25;0
WireConnection;26;1;30;0
WireConnection;28;0;26;0
WireConnection;28;1;24;0
WireConnection;5;1;6;0
WireConnection;5;3;7;0
WireConnection;5;4;8;0
WireConnection;35;0;28;0
WireConnection;35;1;5;0
WireConnection;18;0;35;0
WireConnection;0;13;18;0
ASEEND*/
//CHKSM=971D3FB26E8335A82CA74404A28AEFCDB8F728FC