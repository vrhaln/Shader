// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/ScreenCut"
{
	Properties
	{
		_CutCenter("CutCenter", Vector) = (0.5,0.5,0,0)
		_Rotator("Rotator", Range( 0 , 360)) = 0
		[HDR]_GlowColor("GlowColor", Color) = (0,0,0,0)
		[Toggle(_UV1WCONTORLCHANGE_ON)] _UV1WContorlChange("UV1WContorlChange", Float) = 0
		[Toggle(_UV1TCONTORLRANGE_ON)] _UV1TContorlRange("UV1TContorlRange", Float) = 0
		_Change("Change", Range( 0 , 0.1)) = 0
		_GlowRange("GlowRange", Range( 0 , 1)) = 1
		_Soft("Soft", Range( 0.51 , 1)) = 0.51
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Off
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _UV1WCONTORLCHANGE_ON
		#pragma shader_feature_local _UV1TCONTORLRANGE_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 screenPos;
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

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float2 _CutCenter;
		uniform float _Rotator;
		uniform float _Change;
		uniform float _Soft;
		uniform float _GlowRange;
		uniform float4 _GlowColor;


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


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult64 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float2 appendResult66 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float cos52 = cos( ( (0.0 + (_Rotator - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float sin52 = sin( ( (0.0 + (_Rotator - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float2 rotator52 = mul( i.uv_texcoord.xy - _CutCenter , float2x2( cos52 , -sin52 , sin52 , cos52 )) + _CutCenter;
			float2 temp_cast_0 = (0.5).xx;
			float2 clampResult50 = clamp( step( rotator52 , temp_cast_0 ) , float2( 0,0 ) , float2( 1,0 ) );
			float2 appendResult51 = (float2(clampResult50.x , 0.0));
			float UV1W92 = i.uv_texcoord.z;
			#ifdef _UV1WCONTORLCHANGE_ON
				float staticSwitch69 = UV1W92;
			#else
				float staticSwitch69 = 1.0;
			#endif
			float2 lerpResult40 = lerp( appendResult64 , ( appendResult66 - appendResult51 ) , ( _Change * staticSwitch69 ));
			float4 screenColor38 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,lerpResult40);
			float UV1T94 = i.uv_texcoord.w;
			#ifdef _UV1TCONTORLRANGE_ON
				float staticSwitch90 = (0.0 + (UV1T94 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			#else
				float staticSwitch90 = 0.0;
			#endif
			float smoothstepResult84 = smoothstep( ( 1.0 - _Soft ) , _Soft , ( ( pow( ( 1.0 - distance( rotator52.x , 0.5 ) ) , 50.0 ) - _GlowRange ) - staticSwitch90 ));
			float clampResult79 = clamp( smoothstepResult84 , 0.0 , 1.0 );
			c.rgb = ( screenColor38 + ( clampResult79 * i.vertexColor * _GlowColor ) ).rgb;
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
Version=18935
173;356;1481;765;1299.016;-460.1444;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;56;-4085.953,537.1;Inherit;False;Property;_Rotator;Rotator;2;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-3784.175,538.2543;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;360;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;57;-3567.938,532.4847;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;62;-3799.732,379.3475;Inherit;False;Property;_CutCenter;CutCenter;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-3715.458,88.8806;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;95;-1378.79,1582.412;Inherit;False;517.1759;304.7209;UV1;3;68;94;92;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotatorNode;52;-3353.982,364.672;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-1328.79,1632.412;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;73;-3046.423,776.6037;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;72;-2866.857,777.6848;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1085.614,1771.133;Inherit;False;UV1T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2253.881,479.7159;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;74;-2631.585,779.9155;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2591.262,1176.827;Inherit;False;94;UV1T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;48;-1995.229,343.5546;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;97;-2406.809,1179.568;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;75;-2395.989,775.3109;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-2370.604,1078.574;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-2407.916,1001.719;Inherit;False;Property;_GlowRange;GlowRange;7;0;Create;True;0;0;0;False;0;False;1;0.085;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;50;-1696.894,351.8524;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-1089.079,1663.928;Inherit;False;UV1W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;90;-2191.71,1148.539;Inherit;False;Property;_UV1TContorlRange;UV1TContorlRange;5;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-744.3268,1050.953;Inherit;False;92;UV1W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;100;-2013.409,776.5439;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1882.51,1206.269;Inherit;False;Property;_Soft;Soft;8;0;Create;True;0;0;0;False;0;False;0.51;0.613;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-713.8784,953.903;Inherit;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;63;-1530.295,351.314;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GrabScreenPosition;65;-1635.223,116.0536;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-623.0512,758.7639;Inherit;False;Property;_Change;Change;6;0;Create;True;0;0;0;False;0;False;0;0.03;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;-1785.736,834.6617;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;42;-1096.599,-34.30478;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;86;-1635.16,1062.89;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-1343.977,351.9691;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;69;-538.8386,957.0316;Inherit;False;Property;_UV1WContorlChange;UV1WContorlChange;4;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;66;-1365.357,146.4633;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-319.4775,760.4146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;-806.8422,-9.577988;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-1035.035,138.518;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;84;-1411.822,1056.016;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;89;-1389.721,1203.595;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;40;-195.1756,67.32898;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;79;-1286.605,805.0761;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;98;-1464.45,1366.386;Inherit;False;Property;_GlowColor;GlowColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;2.670157,2.670157,2.670157,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;38;265.5336,-26.11322;Inherit;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1086.78,803.4055;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;581.3799,776.7168;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1018.115,-61.74876;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/ScreenCut;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;56;0
WireConnection;57;0;58;0
WireConnection;52;0;67;0
WireConnection;52;1;62;0
WireConnection;52;2;57;0
WireConnection;73;0;52;0
WireConnection;72;0;73;0
WireConnection;94;0;68;4
WireConnection;74;0;72;0
WireConnection;48;0;52;0
WireConnection;48;1;49;0
WireConnection;97;0;96;0
WireConnection;75;0;74;0
WireConnection;50;0;48;0
WireConnection;92;0;68;3
WireConnection;90;1;99;0
WireConnection;90;0;97;0
WireConnection;100;0;75;0
WireConnection;100;1;83;0
WireConnection;63;0;50;0
WireConnection;87;0;100;0
WireConnection;87;1;90;0
WireConnection;86;0;85;0
WireConnection;51;0;63;0
WireConnection;69;1;102;0
WireConnection;69;0;93;0
WireConnection;66;0;65;1
WireConnection;66;1;65;2
WireConnection;101;0;41;0
WireConnection;101;1;69;0
WireConnection;64;0;42;1
WireConnection;64;1;42;2
WireConnection;71;0;66;0
WireConnection;71;1;51;0
WireConnection;84;0;87;0
WireConnection;84;1;86;0
WireConnection;84;2;85;0
WireConnection;40;0;64;0
WireConnection;40;1;71;0
WireConnection;40;2;101;0
WireConnection;79;0;84;0
WireConnection;38;0;40;0
WireConnection;76;0;79;0
WireConnection;76;1;89;0
WireConnection;76;2;98;0
WireConnection;78;0;38;0
WireConnection;78;1;76;0
WireConnection;0;13;78;0
ASEEND*/
//CHKSM=ED9BFAB296C1AD55BE395DB13B737AF43A95EDC1