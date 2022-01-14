// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Particle/Exp"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_FlowStrength("FlowStrength", Float) = 0
		_ColorStart("ColorStart", Color) = (0,0.3333335,1,1)
		_ColorEnd("ColorEnd", Color) = (1,0.1372549,0.7803922,1)
		_TimeScale("TimeScale", Float) = 0
		_TimeScaleoverLifetimeStrength("TimeScale over Lifetime Strength", Float) = 0
		_Emission("Emission", Float) = 0
		[Toggle(_USEDARKEDGE_ON)] _UseDarkEdge("UseDarkEdge", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USEDARKEDGE_ON
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _ColorStart;
		uniform float4 _ColorEnd;
		uniform float _Emission;
		uniform sampler2D _MainTex;
		uniform float _TimeScale;
		uniform float _TimeScaleoverLifetimeStrength;
		uniform float _FlowStrength;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float u25 = i.uv_texcoord.x;
			float4 lerpResult3 = lerp( _ColorStart , _ColorEnd , ( u25 * 1.0 ));
			float mulTime21 = _Time.y * ( _TimeScale * ( 1.0 - ( ( _TimeScaleoverLifetimeStrength * i.vertexColor.a ) * 0.1 ) ) );
			float Time22 = mulTime21;
			float2 uv14 = i.uv_texcoord;
			float2 panner39 = ( Time22 * float2( -1,-0.2 ) + uv14);
			float clampResult42 = clamp( ( ( ( 1.0 - u25 ) + -0.55 ) * 2.0 ) , 0.25 , 0.75 );
			float clampResult45 = clamp( ( ( tex2D( _MainTex, panner39 ).g + clampResult42 ) - ( u25 * 0.9 ) ) , 0.0 , 1.0 );
			float clampResult28 = clamp( ( ( 1.0 - u25 ) * 1.0 ) , 0.0 , 1.0 );
			float Mask30 = ( clampResult28 * 1.0 );
			float2 panner15 = ( Time22 * float2( -1,0 ) + uv14);
			float2 panner52 = ( Time22 * float2( -0.9,0 ) + ( uv14 + ( ( ( (tex2D( _MainTex, panner15 )).rg + -0.5 ) * 1.0 ) * _FlowStrength * u25 ) ));
			float temp_output_11_0 = ( i.vertexColor.a * clampResult45 * Mask30 * tex2D( _MainTex, panner52 ).b );
			#ifdef _USEDARKEDGE_ON
				float staticSwitch9 = temp_output_11_0;
			#else
				float staticSwitch9 = 1.0;
			#endif
			o.Emission = ( ( lerpResult3 * i.vertexColor * _Emission ) * staticSwitch9 ).rgb;
			o.Alpha = temp_output_11_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1048;171;1048;708;3195.421;217.9423;1;True;False
Node;AmplifyShaderEditor.VertexColorNode;57;-4472.083,636.1151;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-4566.498,401.555;Inherit;True;Property;_TimeScaleoverLifetimeStrength;TimeScale over Lifetime Strength;5;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-4193.381,575.9849;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-4044.739,569.4466;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-4055.801,326.0308;Inherit;False;Property;_TimeScale;TimeScale;4;0;Create;True;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-3918.166,527.0757;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-3729.956,462.343;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-3638.363,160.2988;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;21;-3576.834,342.5515;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-3274.82,149.7344;Inherit;False;uv;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-3347.816,343.9756;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-3393.195,663.1426;Inherit;False;u;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;15;-3025.894,174.0272;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-3496.321,-730.8126;Inherit;False;25;u;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-2748.026,145.8112;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;18;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;31;-2426.653,144.8663;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-3497.251,-643.7655;Inherit;False;14;uv;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-3495.043,-547.1436;Inherit;False;22;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-3216.578,-432.7913;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-3176.063,650.7295;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-3185.926,899.5429;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2905.431,470.3693;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;39;-3199.536,-611.8903;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;32;-2169.423,151.0145;Inherit;False;ConstantBiasScale;-1;;3;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2138.953,286.1634;Inherit;False;Property;_FlowStrength;FlowStrength;1;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;41;-3008.73,-408.1367;Inherit;False;ConstantBiasScale;-1;;4;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-0.55;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2155.953,396.1634;Inherit;False;25;u;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1898.968,181.5102;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-1933.961,75.33327;Inherit;False;14;uv;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;42;-2761.583,-411.7723;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;28;-2681.09,559.3698;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-2939.813,-638.8005;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;18;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-2511.325,-585.5797;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1733.961,76.33327;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2521.908,557.5323;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2523.941,-724.7279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1751.479,220.2664;Inherit;False;22;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-2307.01,-700.8156;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;52;-1550.467,74.09621;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.9,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1492.157,-173.4409;Inherit;False;25;u;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-2273.624,560.6113;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-941.4303,165.6005;Inherit;False;30;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1432.82,-357.7129;Inherit;False;Property;_ColorEnd;ColorEnd;3;0;Create;True;0;0;False;0;False;1,0.1372549,0.7803922,1;1,0,0.968781,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;-1271.291,128.4259;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;18;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;45;-1991.497,-690.0808;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;6;-910.2878,-88.27178;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-1438.535,-547.1029;Inherit;False;Property;_ColorStart;ColorStart;2;0;Create;True;0;0;False;0;False;0,0.3333335,1,1;0,0.6691942,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1290.123,-172.0423;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-726.9094,-4.718172;Inherit;False;Property;_Emission;Emission;6;0;Create;True;0;0;False;0;False;0;3.73;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;-959.8041,-312.7651;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-675.166,187.9531;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-592.2228,96.15019;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;9;-418.6801,100.2712;Inherit;False;Property;_UseDarkEdge;UseDarkEdge;7;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-501.4707,-173.9824;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;18;-3572.658,-204.416;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;False;-1;None;6ffdd27dbb6e82a479546144ffb6121e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-174.1514,3.473076;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;23;-3175.53,427.3678;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;55.9,5.199999;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Particle/Exp;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;0;59;0
WireConnection;60;1;57;4
WireConnection;63;0;60;0
WireConnection;62;0;63;0
WireConnection;58;0;20;0
WireConnection;58;1;62;0
WireConnection;21;0;58;0
WireConnection;14;0;13;0
WireConnection;22;0;21;0
WireConnection;25;0;13;1
WireConnection;15;0;14;0
WireConnection;15;1;22;0
WireConnection;19;1;15;0
WireConnection;31;0;19;0
WireConnection;40;0;33;0
WireConnection;26;0;25;0
WireConnection;24;0;26;0
WireConnection;24;1;27;0
WireConnection;39;0;34;0
WireConnection;39;1;36;0
WireConnection;32;3;31;0
WireConnection;41;3;40;0
WireConnection;47;0;32;0
WireConnection;47;1;48;0
WireConnection;47;2;49;0
WireConnection;42;0;41;0
WireConnection;28;0;24;0
WireConnection;37;1;39;0
WireConnection;43;0;37;2
WireConnection;43;1;42;0
WireConnection;51;0;50;0
WireConnection;51;1;47;0
WireConnection;29;0;28;0
WireConnection;38;0;33;0
WireConnection;44;0;43;0
WireConnection;44;1;38;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;30;0;29;0
WireConnection;54;1;52;0
WireConnection;45;0;44;0
WireConnection;56;0;55;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;56;0
WireConnection;11;0;6;4
WireConnection;11;1;45;0
WireConnection;11;2;46;0
WireConnection;11;3;54;3
WireConnection;9;1;10;0
WireConnection;9;0;11;0
WireConnection;4;0;3;0
WireConnection;4;1;6;0
WireConnection;4;2;7;0
WireConnection;8;0;4;0
WireConnection;8;1;9;0
WireConnection;23;0;13;2
WireConnection;0;2;8;0
WireConnection;0;9;11;0
ASEEND*/
//CHKSM=9DBAFC02A011A3357F70FEDF0C3DC8F36543441A