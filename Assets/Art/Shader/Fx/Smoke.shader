// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Fx/Smoke"
{
	Properties
	{
		_Noise_1("Noise_1", 2D) = "white" {}
		_Float0("Float 0", Float) = 1.7
		[HDR]_Color1("Color1", Color) = (0.2641509,0.07586333,0,0)
		[HDR]_Color2("Color2", Color) = (1,0.1660024,0,0)
		[HDR]_Color0("Color 0", Color) = (1,0.6665002,0.2971698,0)
		_range1("range1", Float) = 0.02
		_range2("range2", Float) = 0.2
		_range3("range3", Float) = 0.5
		_soft1("soft1", Range( 0 , 0.5)) = 0
		_soft2("soft2", Range( 0 , 0.5)) = 0.4817654
		_soft3("soft3", Range( 0 , 0.5)) = 0.5
		_panner("panner", Vector) = (0,0,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Off
		ZWrite Off
		ZTest Always
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

		uniform float _range1;
		uniform float _soft1;
		uniform sampler2D _Noise_1;
		uniform float3 _panner;
		uniform float4 _Noise_1_ST;
		uniform float _Float0;
		uniform float4 _Color1;
		uniform float _range2;
		uniform float _soft2;
		uniform float4 _Color2;
		uniform float _range3;
		uniform float _soft3;
		uniform float4 _Color0;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float temp_output_13_0 = pow( ( ( 1.0 - distance( i.uv_texcoord.xy , float2( 0.5,0.5 ) ) ) * 1.0 ) , 6.0 );
			float mulTime57 = _Time.y * _panner.z;
			float2 appendResult56 = (float2(_panner.x , _panner.y));
			float4 uvs_Noise_1 = i.uv_texcoord;
			uvs_Noise_1.xy = i.uv_texcoord.xy * _Noise_1_ST.xy + _Noise_1_ST.zw;
			float2 panner54 = ( mulTime57 * appendResult56 + uvs_Noise_1.xy);
			float4 tex2DNode1 = tex2D( _Noise_1, panner54 );
			float temp_output_8_0 = pow( ( temp_output_13_0 + ( temp_output_13_0 * tex2DNode1.r ) ) , _Float0 );
			float temp_output_58_0 = ( 1.0 - tex2DNode1.r );
			float smoothstepResult34 = smoothstep( _range1 , ( _range1 + _soft1 ) , ( temp_output_8_0 - temp_output_58_0 ));
			float temp_output_27_0 = saturate( smoothstepResult34 );
			float Noise62 = temp_output_58_0;
			float smoothstepResult28 = smoothstep( _range2 , ( _range2 + _soft2 ) , ( ( temp_output_8_0 - ( temp_output_58_0 * i.uv_texcoord.w ) ) - Noise62 ));
			float smoothstepResult38 = smoothstep( _range3 , ( _range3 + _soft3 ) , ( ( temp_output_8_0 - ( temp_output_58_0 * i.uv2_texcoord2.x ) ) - Noise62 ));
			c.rgb = ( ( temp_output_27_0 * _Color1 ) + ( saturate( smoothstepResult28 ) * _Color2 ) + ( saturate( smoothstepResult38 ) * _Color0 ) ).rgb;
			c.a = saturate( ( ( saturate( temp_output_27_0 ) - Noise62 ) - i.uv_texcoord.z ) );
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
-55;570;1311;669;1998.971;361.929;3.856081;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-3018.531,-585.4099;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;5;-2872.932,-456.71;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;55;-3174.941,107.252;Inherit;False;Property;_panner;panner;12;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;3;-2670.132,-563.3099;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-3068.125,-35.37582;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;56;-2970.941,117.252;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;57;-2949.941,225.252;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-2402.212,-558.5927;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2420.674,-315.3497;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2126.183,-251.3117;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2177.081,-508.7919;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;54;-2781.494,7.896754;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;13;-1923.566,-503.5127;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;9.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2569.033,-13.67444;Inherit;True;Property;_Noise_1;Noise_1;1;0;Create;True;0;0;0;False;0;False;-1;79731f369eb8f3148bc2e10bef525fa2;79731f369eb8f3148bc2e10bef525fa2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1647.898,-309.634;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1362.829,-113.3767;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;1.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1400.565,-427.0187;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-2070.98,542.1273;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;58;-2117.206,82.31683;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;8;-1129.839,-428.3308;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;9.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1033.009,7.590903;Inherit;False;Property;_soft1;soft1;9;0;Create;True;0;0;0;False;0;False;0;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-2049.26,245.5283;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-937.8951,-92.42769;Inherit;False;Property;_range1;range1;6;0;Create;True;0;0;0;False;0;False;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1266.987,238.9063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-676.0451,-255.798;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-710.5219,-17.36079;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1252.209,581.5285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1879.64,-39.80028;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;-574.2211,648.5591;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;46;-626.2195,201.1817;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-788.5925,294.6143;Inherit;False;62;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;34;-455.7045,-232.364;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-790.1409,474.1889;Inherit;False;Property;_soft2;soft2;10;0;Create;True;0;0;0;False;0;False;0.4817654;0.4817654;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-695.0273,374.1703;Inherit;False;Property;_range2;range2;7;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-727.4626,1043.926;Inherit;False;Property;_soft3;soft3;11;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-652.4794,845.3405;Inherit;False;62;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-632.3491,943.9073;Inherit;False;Property;_range3;range3;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;-475.8764,256.2993;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-404.9762,1018.974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;-385.1125,753.0384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-467.6543,449.2372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-165.0834,-230.9434;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;64.79539,-141.6852;Inherit;False;62;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;55.08535,-352.0395;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-210.4983,933.0729;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;28;-273.1758,363.336;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-253.3072,65.3492;Inherit;False;Property;_Color1;Color1;3;1;[HDR];Create;True;0;0;0;False;0;False;0.2641509,0.07586333,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;22;-39.03425,602.2531;Inherit;False;Property;_Color2;Color2;4;1;[HDR];Create;True;0;0;0;False;0;False;1,0.1660024,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;26;-25.40503,361.6816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;81.47406,961.0973;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;283.3028,-249.5697;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;60.99664,1176.008;Inherit;False;Property;_Color0;Color 0;5;1;[HDR];Create;True;0;0;0;False;0;False;1,0.6665002,0.2971698,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;426.1734,-179.2609;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;132.5877,80.8862;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;296.6915,564.2651;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;418.62,1052.531;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1315.496,91.51305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;948.1218,303.6737;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;60;791.7516,-142.1634;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1616.098,49.80937;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Fx/Smoke;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;3;1;5;0
WireConnection;56;0;55;1
WireConnection;56;1;55;2
WireConnection;57;0;55;3
WireConnection;6;0;3;0
WireConnection;15;0;6;0
WireConnection;15;1;16;0
WireConnection;54;0;53;0
WireConnection;54;2;56;0
WireConnection;54;1;57;0
WireConnection;13;0;15;0
WireConnection;13;1;14;0
WireConnection;1;1;54;0
WireConnection;7;0;13;0
WireConnection;7;1;1;1
WireConnection;17;0;13;0
WireConnection;17;1;7;0
WireConnection;58;0;1;1
WireConnection;8;0;17;0
WireConnection;8;1;9;0
WireConnection;51;0;58;0
WireConnection;51;1;48;4
WireConnection;44;0;8;0
WireConnection;44;1;58;0
WireConnection;32;0;31;0
WireConnection;32;1;33;0
WireConnection;52;0;58;0
WireConnection;52;1;49;1
WireConnection;62;0;58;0
WireConnection;47;0;8;0
WireConnection;47;1;52;0
WireConnection;46;0;8;0
WireConnection;46;1;51;0
WireConnection;34;0;44;0
WireConnection;34;1;31;0
WireConnection;34;2;32;0
WireConnection;66;0;46;0
WireConnection;66;1;67;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;68;0;47;0
WireConnection;68;1;69;0
WireConnection;30;0;20;0
WireConnection;30;1;29;0
WireConnection;27;0;34;0
WireConnection;12;0;27;0
WireConnection;38;0;68;0
WireConnection;38;1;35;0
WireConnection;38;2;36;0
WireConnection;28;0;66;0
WireConnection;28;1;20;0
WireConnection;28;2;30;0
WireConnection;26;0;28;0
WireConnection;39;0;38;0
WireConnection;65;0;12;0
WireConnection;65;1;63;0
WireConnection;59;0;65;0
WireConnection;59;1;48;3
WireConnection;10;0;27;0
WireConnection;10;1;11;0
WireConnection;21;0;26;0
WireConnection;21;1;22;0
WireConnection;40;0;39;0
WireConnection;40;1;41;0
WireConnection;43;0;10;0
WireConnection;43;1;21;0
WireConnection;43;2;40;0
WireConnection;60;0;59;0
WireConnection;0;9;60;0
WireConnection;0;13;43;0
ASEEND*/
//CHKSM=3D30F4D4F3847C5905860D7CEFF542BDC3E0CF15