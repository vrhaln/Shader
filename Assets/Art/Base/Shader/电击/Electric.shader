// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Particle/Electric"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_DisturbTexPanner("DisturbTexPanner", Vector) = (0,0,1,0)
		_MainDisturbMul("MainDisturbMul", Range( 0 , 1)) = 0.2
		_MaskDisturbMul("MaskDisturbMul", Range( 0 , 1)) = 0.2
		_Soft("Soft", Range( 0.51 , 1)) = 0.51
		_Float0("Float 0", Float) = 0
		_MaskOffset("MaskOffset", Vector) = (0,0,0,0)
		[Enum(UnityEngine.Rendering.CompareFunction)]_Ztest("Ztest", Float) = 4
		_VertexOffset("VertexOffset", Float) = 1
		_Mask2("Mask2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		ZTest [_Ztest]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
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

		uniform float _Ztest;
		uniform sampler2D _Mask;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbTexPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _MaskDisturbMul;
		uniform float4 _Mask_ST;
		uniform float2 _MaskOffset;
		uniform sampler2D _Mask2;
		uniform float4 _Mask2_ST;
		uniform float _VertexOffset;
		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform float _MainDisturbMul;
		uniform float _Soft;
		uniform float _Float0;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime5 = _Time.y * _DisturbTexPanner.z;
			float2 appendResult7 = (float2(_DisturbTexPanner.x , _DisturbTexPanner.y));
			float4 uvs_DisturbTex = v.texcoord;
			uvs_DisturbTex.xy = v.texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uvs_DisturbTex.xy);
			float4 tex2DNode20 = tex2Dlod( _DisturbTex, float4( panner2, 0, 0.0) );
			float4 uvs_Mask = v.texcoord;
			uvs_Mask.xy = v.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
			float2 uv_Mask2 = v.texcoord * _Mask2_ST.xy + _Mask2_ST.zw;
			float temp_output_44_0 = ( tex2Dlod( _Mask, float4( ( ( tex2DNode20.r * _MaskDisturbMul ) + uvs_Mask.xy + ( _MaskOffset * v.texcoord.z ) ), 0, 0.0) ).r * tex2Dlod( _Mask2, float4( uv_Mask2, 0, 0.0) ).r );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( temp_output_44_0 * ase_vertexNormal * _VertexOffset * (0.5 + (v.texcoord.y - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) );
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime29 = _Time.y * _MainTexPanner.z;
			float2 appendResult31 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner32 = ( mulTime29 * appendResult31 + uvs_MainTex.xy);
			float mulTime5 = _Time.y * _DisturbTexPanner.z;
			float2 appendResult7 = (float2(_DisturbTexPanner.x , _DisturbTexPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uvs_DisturbTex.xy);
			float4 tex2DNode20 = tex2D( _DisturbTex, panner2 );
			float4 tex2DNode1 = tex2D( _MainTex, ( panner32 + ( tex2DNode20.r * _MainDisturbMul ) ) );
			float smoothstepResult13 = smoothstep( ( 1.0 - _Soft ) , _Soft , tex2DNode1.r);
			float4 uvs_Mask = i.uv_texcoord;
			uvs_Mask.xy = i.uv_texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
			float2 uv_Mask2 = i.uv_texcoord * _Mask2_ST.xy + _Mask2_ST.zw;
			float temp_output_44_0 = ( tex2D( _Mask, ( ( tex2DNode20.r * _MaskDisturbMul ) + uvs_Mask.xy + ( _MaskOffset * i.uv_texcoord.z ) ) ).r * tex2D( _Mask2, uv_Mask2 ).r );
			c.rgb = 0;
			c.a = saturate( ( smoothstepResult13 * i.vertexColor.a * (_Float0 + (temp_output_44_0 - 0.0) * (1.0 - _Float0) / (1.0 - 0.0)) ) );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float mulTime29 = _Time.y * _MainTexPanner.z;
			float2 appendResult31 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner32 = ( mulTime29 * appendResult31 + uvs_MainTex.xy);
			float mulTime5 = _Time.y * _DisturbTexPanner.z;
			float2 appendResult7 = (float2(_DisturbTexPanner.x , _DisturbTexPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uvs_DisturbTex.xy);
			float4 tex2DNode20 = tex2D( _DisturbTex, panner2 );
			float4 tex2DNode1 = tex2D( _MainTex, ( panner32 + ( tex2DNode20.r * _MainDisturbMul ) ) );
			o.Emission = ( _MainColor * tex2DNode1.r * i.vertexColor ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;262;1415;757;1746.678;-481.7772;1;True;True
Node;AmplifyShaderEditor.Vector3Node;4;-3364.055,79.72292;Inherit;False;Property;_DisturbTexPanner;DisturbTexPanner;6;0;Create;True;0;0;0;False;0;False;0,0,1;0,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;7;-3078.896,93.89195;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-3326.907,-65.52592;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;5;-3100.427,213.0754;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;-2856.013,58.61843;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;33;-2385.904,-279.29;Inherit;False;Property;_MainTexPanner;MainTexPanner;3;0;Create;True;0;0;0;False;0;False;0,0,1;0,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;34;-2052.019,674.834;Inherit;False;Property;_MaskOffset;MaskOffset;11;0;Create;True;0;0;0;False;0;False;0,0;0,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;20;-2508.942,21.25042;Inherit;True;Property;_DisturbTex;DisturbTex;5;0;Create;True;0;0;0;False;0;False;-1;None;d0ab74fd2ed32b84e980587fdf90b397;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-2104.91,827.3505;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-2494.399,398.1446;Inherit;False;Property;_MaskDisturbMul;MaskDisturbMul;8;0;Create;True;0;0;0;False;0;False;0.2;0.34;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2060.397,485.054;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;31;-2100.745,-265.121;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2494.934,239.9757;Inherit;False;Property;_MainDisturbMul;MainDisturbMul;7;0;Create;True;0;0;0;False;0;False;0.2;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2081.577,259.1254;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-2122.276,-145.938;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-2218.932,-413.6115;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1790.276,741.2748;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;32;-1824.467,-284.5738;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1560.697,566.3347;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2112.505,57.2382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-1334.887,773.4828;Inherit;True;Property;_Mask2;Mask2;14;0;Create;True;0;0;0;False;0;False;-1;None;05b2a1c3e0dafdd48ad0a8453cc5de6c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1227.019,188.8754;Inherit;False;Property;_Soft;Soft;9;0;Create;True;0;0;0;False;0;False;0.51;0.51;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1508.362,-66.42169;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-1337.224,535.2438;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;-1;None;fb59b05cf31b1b5458789f199763496f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;15;-848.3851,158.2072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-998.1149,760.6807;Inherit;False;Property;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-955.8578,568.1326;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1160.101,-72.00314;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;-1;None;7c661b189605d9646a2d6f8d081b46e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;27;-609.6451,560.6849;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-591.2401,135.7044;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;10;-408.9137,69.74065;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-27.42097,138.0316;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-492.0994,-219.2477;Inherit;False;Property;_MainColor;MainColor;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;32.64645,32.64645,32.64645,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;42;-955.3192,946.4585;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-188.6162,977.3573;Inherit;False;Property;_VertexOffset;VertexOffset;13;0;Create;True;0;0;0;False;0;False;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;40;-238.1047,751.9394;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-3039.305,-554.5369;Inherit;False;Property;_Ztest;Ztest;12;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;263.364,144.3589;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;175.5459,678.2719;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-18.98638,-91.51299;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;653.9283,-77.80714;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Particle/Electric;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;True;38;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;4;1
WireConnection;7;1;4;2
WireConnection;5;0;4;3
WireConnection;2;0;3;0
WireConnection;2;2;7;0
WireConnection;2;1;5;0
WireConnection;20;1;2;0
WireConnection;31;0;33;1
WireConnection;31;1;33;2
WireConnection;25;0;20;1
WireConnection;25;1;24;0
WireConnection;29;0;33;3
WireConnection;35;0;34;0
WireConnection;35;1;37;3
WireConnection;32;0;16;0
WireConnection;32;2;31;0
WireConnection;32;1;29;0
WireConnection;19;0;25;0
WireConnection;19;1;17;0
WireConnection;19;2;35;0
WireConnection;21;0;20;1
WireConnection;21;1;22;0
WireConnection;18;0;32;0
WireConnection;18;1;21;0
WireConnection;12;1;19;0
WireConnection;15;0;14;0
WireConnection;44;0;12;1
WireConnection;44;1;43;1
WireConnection;1;1;18;0
WireConnection;27;0;44;0
WireConnection;27;3;28;0
WireConnection;13;0;1;1
WireConnection;13;1;15;0
WireConnection;13;2;14;0
WireConnection;11;0;13;0
WireConnection;11;1;10;4
WireConnection;11;2;27;0
WireConnection;42;0;37;2
WireConnection;26;0;11;0
WireConnection;39;0;44;0
WireConnection;39;1;40;0
WireConnection;39;2;41;0
WireConnection;39;3;42;0
WireConnection;9;0;8;0
WireConnection;9;1;1;1
WireConnection;9;2;10;0
WireConnection;0;2;9;0
WireConnection;0;9;26;0
WireConnection;0;11;39;0
ASEEND*/
//CHKSM=A060CB594582B6A5AE649DD72152832F0652DAF1