// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/LightBean"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[HDR]_EmissColor("EmissColor", Color) = (0,0,0,0)
		_EmissIntensity("EmissIntensity", Float) = 0
		_EmissMap("EmissMap", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		_RimMin("RimMin", Float) = 0
		_RimMax("RimMax", Float) = 1
		_FadePower("FadePower", Float) = 0
		_FadeOffset("FadeOffset", Float) = 0
		_VertexExpand("VertexExpand", Float) = 0
		_VertexOffer("VertexOffer", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 viewDir;
		};

		uniform float _CullMode;
		uniform float _VertexExpand;
		uniform float _VertexOffer;
		uniform float4 _EmissColor;
		uniform float _EmissIntensity;
		uniform sampler2D _EmissMap;
		uniform float2 _Speed;
		uniform float4 _EmissMap_ST;
		uniform float _RimMin;
		uniform float _RimMax;
		uniform float _FadeOffset;
		uniform float _FadePower;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 break39 = ( ase_vertexNormal * _VertexExpand );
			float3 appendResult43 = (float3(break39.x , break39.y , ( break39.z + _VertexOffer )));
			v.vertex.xyz += ( appendResult43 * v.texcoord.xy.x );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv0_EmissMap = i.uv_texcoord * _EmissMap_ST.xy + _EmissMap_ST.zw;
			float2 panner8 = ( 1.0 * _Time.y * _Speed + uv0_EmissMap);
			o.Emission = ( _EmissColor * _EmissIntensity * tex2D( _EmissMap, panner8 ) ).rgb;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult12 = dot( ase_normWorldNormal , i.viewDir );
			float smoothstepResult13 = smoothstep( _RimMin , _RimMax , abs( dotResult12 ));
			float temp_output_17_0 = ( 1.0 - i.uv_texcoord.x );
			float clampResult24 = clamp( ( ( temp_output_17_0 - _FadeOffset ) * _FadePower ) , 0.0 , 1.0 );
			float fade33 = ( smoothstepResult13 * min( clampResult24 , temp_output_17_0 ) );
			o.Alpha = fade33;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
104;586;1467;937;3750.552;358.9238;1.508764;True;True
Node;AmplifyShaderEditor.CommentaryNode;26;-3437.743,-255.0116;Inherit;False;1876.296;907.7434;Fade;17;18;25;13;24;15;14;12;22;11;10;20;23;17;21;16;33;45;Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-3387.743,475.7581;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-3055.608,319.635;Inherit;False;Property;_FadeOffset;FadeOffset;9;0;Create;True;0;0;False;0;False;0;-0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-3152.829,499.7711;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2898.685,398.4211;Inherit;False;Property;_FadePower;FadePower;8;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-2846.009,236.0342;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;11;-3272.163,-34.56457;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;10;-3278.535,-214.064;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-1365.38,753.1787;Inherit;False;Property;_VertexExpand;VertexExpand;10;0;Create;True;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;27;-1390.027,571.6203;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2675.074,265.2221;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-2991.762,-115.2862;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;45;-2807.574,-119.0304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2688.054,126.3712;Inherit;False;Property;_RimMax;RimMax;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2694.554,7.967483;Inherit;False;Property;_RimMin;RimMin;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1158.75,654.1651;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;24;-2522.333,257.1052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;9;-1301.262,423.4039;Inherit;False;Property;_Speed;Speed;5;0;Create;True;0;0;False;0;False;0,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMinOpNode;25;-2316.683,310.7981;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-979.0531,722.3953;Inherit;False;Property;_VertexOffer;VertexOffer;11;0;Create;True;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1337.734,294.8135;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-2484.718,-100.4393;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;39;-997.6859,592.7471;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2201.483,-99.81661;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-777.9578,711.5063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-1067.734,310.8135;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-783.8824,257.7646;Inherit;True;Property;_EmissMap;EmissMap;4;0;Create;True;0;0;False;0;False;-1;None;a21b2ad21e1aef24aabb0ca39246f277;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-669.3661,132.208;Inherit;False;Property;_EmissIntensity;EmissIntensity;3;0;Create;True;0;0;False;0;False;0;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-594.4844,835.6851;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-2026.167,-91.10348;Inherit;False;fade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-646.5472,-64.76823;Inherit;False;Property;_EmissColor;EmissColor;2;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.06282721,1.109948,4,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;43;-629.4148,655.8463;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-2.518486,206.5425;Inherit;False;33;fade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1424.058,-216.6536;Inherit;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-310.1347,40.84129;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-302.9537,753.5743;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;252.8313,20.38961;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/LightBean;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;True;44;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;16;1
WireConnection;20;0;17;0
WireConnection;20;1;21;0
WireConnection;22;0;20;0
WireConnection;22;1;23;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;45;0;12;0
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;24;0;22;0
WireConnection;25;0;24;0
WireConnection;25;1;17;0
WireConnection;13;0;45;0
WireConnection;13;1;14;0
WireConnection;13;2;15;0
WireConnection;39;0;28;0
WireConnection;18;0;13;0
WireConnection;18;1;25;0
WireConnection;35;0;39;2
WireConnection;35;1;41;0
WireConnection;8;0;7;0
WireConnection;8;2;9;0
WireConnection;5;1;8;0
WireConnection;33;0;18;0
WireConnection;43;0;39;0
WireConnection;43;1;39;1
WireConnection;43;2;35;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;5;0
WireConnection;32;0;43;0
WireConnection;32;1;30;1
WireConnection;0;2;4;0
WireConnection;0;9;34;0
WireConnection;0;11;32;0
ASEEND*/
//CHKSM=7D7AD393A4F2549A57FBC662B1A6771C39DAD39A