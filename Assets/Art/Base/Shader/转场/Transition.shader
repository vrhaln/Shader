// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Transition"
{
	Properties
	{
		[Toggle(_TEXCONTORL_ON)] _TexContorl("TexContorl", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_Tliling("Tliling", Vector) = (1,1,0,0)
		_A("A", 2D) = "white" {}
		_B("B", 2D) = "white" {}
		_RotationCenter("RotationCenter", Vector) = (0.5,0.5,0,0)
		_Rotation("Rotation", Range( 0 , 1)) = 1
		_Soft("Soft", Range( 0.51 , 1)) = 1
		_Change("Change", Range( 0 , 1)) = 0
		_Float0("Float 0", Float) = 0.32
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _TEXCONTORL_ON
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
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

		uniform sampler2D _A;
		uniform float4 _A_ST;
		uniform sampler2D _B;
		uniform float4 _B_ST;
		uniform float _Soft;
		uniform float2 _Tliling;
		uniform sampler2D _MainTex;
		uniform float _Float0;
		uniform float2 _RotationCenter;
		uniform float _Rotation;
		uniform float _Change;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_A = i.uv_texcoord * _A_ST.xy + _A_ST.zw;
			float2 uv_B = i.uv_texcoord * _B_ST.xy + _B_ST.zw;
			float2 temp_cast_0 = (0.5).xx;
			#ifdef _TEXCONTORL_ON
				float staticSwitch42 = tex2D( _MainTex, frac( ( i.uv_texcoord * _Tliling ) ) ).r;
			#else
				float staticSwitch42 = distance( frac( ( i.uv_texcoord * _Tliling ) ) , temp_cast_0 );
			#endif
			float cos17 = cos( ( _Rotation * UNITY_PI ) );
			float sin17 = sin( ( _Rotation * UNITY_PI ) );
			float2 rotator17 = mul( ( i.uv_texcoord + _Float0 ) - _RotationCenter , float2x2( cos17 , -sin17 , sin17 , cos17 )) + _RotationCenter;
			float smoothstepResult34 = smoothstep( ( 1.0 - _Soft ) , _Soft , ( (0.0 + (( staticSwitch42 + distance( rotator17.x , 0.5 ) ) - -1.0) * (1.0 - 0.0) / (2.0 - -1.0)) + 1.0 + ( -2.0 * _Change ) ));
			float4 lerpResult3 = lerp( tex2D( _A, uv_A ) , tex2D( _B, uv_B ) , smoothstepResult34);
			c.rgb = lerpResult3.rgb;
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
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
52;362;1298;657;2156.434;183.4423;1.360718;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-3154.682,-389.4521;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-3291.981,207.1595;Inherit;False;Property;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.32;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-3332.231,465.0176;Inherit;False;Property;_Rotation;Rotation;6;0;Create;True;0;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-3381.919,-78.5287;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3081.321,-722.506;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;44;-3441.271,-346.7232;Inherit;False;Property;_Tliling;Tliling;2;0;Create;True;0;0;0;False;0;False;1,1;45.5,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-2876.409,-376.1225;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PiNode;31;-2995.487,466.0319;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;32;-3080.092,210.9208;Inherit;False;Property;_RotationCenter;RotationCenter;5;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2803.048,-709.1764;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-3048.721,34.66619;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;14;-2640.334,-695.5896;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;47;-2685.631,-346.2885;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2528.375,-146.1062;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;17;-2751.032,181.1488;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-2375.019,-726.2761;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;a21de7a8a28904b41a57045aa20da08c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;-2405.189,476.957;Inherit;False;Constant;_Float3;Float 3;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;18;-2472.684,182.85;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;48;-2286.364,-223.7191;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;50;-2084.53,160.7195;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;42;-1830.299,-367.1886;Inherit;False;Property;_TexContorl;TexContorl;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1495.919,64.40885;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1438.183,418.4667;Inherit;False;Property;_Change;Change;8;0;Create;True;0;0;0;False;0;False;0;0.458;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1314.197,320.0871;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1092.213,364.7434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;-1189.695,66.30425;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;2;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1509.149,725.893;Inherit;False;Property;_Soft;Soft;7;0;Create;True;0;0;0;False;0;False;1;0.51;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1091.862,256.305;Inherit;False;Constant;_Float4;Float 4;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-836.9997,228.7512;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;-1028.748,579.4354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-443.2371,329.3301;Inherit;True;Property;_B;B;4;0;Create;True;0;0;0;False;0;False;-1;None;89609648b6dd11e46bbb56d663098269;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;34;-640.9439,679.4763;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-473.5818,104.6866;Inherit;True;Property;_A;A;3;0;Create;True;0;0;0;False;0;False;-1;None;de89bd1bf56b75746818063ecab78798;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;3;38.01283,444.8615;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;335.0009,191.8575;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Transition;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;45;0
WireConnection;46;1;44;0
WireConnection;31;0;30;0
WireConnection;12;0;4;0
WireConnection;12;1;44;0
WireConnection;52;0;16;0
WireConnection;52;1;53;0
WireConnection;14;0;12;0
WireConnection;47;0;46;0
WireConnection;17;0;52;0
WireConnection;17;1;32;0
WireConnection;17;2;31;0
WireConnection;33;1;14;0
WireConnection;18;0;17;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;50;0;18;0
WireConnection;50;1;51;0
WireConnection;42;1;48;0
WireConnection;42;0;33;1
WireConnection;15;0;42;0
WireConnection;15;1;50;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;26;0;15;0
WireConnection;40;0;26;0
WireConnection;40;1;41;0
WireConnection;40;2;38;0
WireConnection;35;0;11;0
WireConnection;34;0;40;0
WireConnection;34;1;35;0
WireConnection;34;2;11;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;3;2;34;0
WireConnection;0;13;3;0
ASEEND*/
//CHKSM=6C05CFDED6ECADD35AA691FF460B5E58F1EBB85A