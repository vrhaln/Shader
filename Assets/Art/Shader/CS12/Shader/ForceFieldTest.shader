// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ForceFieldTest"
{
	Properties
	{
		_Noise("Noise", 2D) = "white" {}
		_HitSpread("HitSpread", Float) = 4
		_HitNoiseIntensity("HitNoiseIntensity", Float) = 2
		_RampTex("RampTex", 2D) = "white" {}
		_HItFadePower("HItFadePower", Float) = 0
		_HItFadeDistance("HItFadeDistance", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 HitPosition;
		uniform float _HItFadeDistance;
		uniform float _HItFadePower;
		uniform sampler2D _RampTex;
		SamplerState sampler_RampTex;
		uniform float HitSize;
		uniform sampler2D _Noise;
		SamplerState sampler_Noise;
		uniform float4 _Noise_ST;
		uniform float _HitNoiseIntensity;
		uniform float _HitSpread;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_7_0 = distance( HitPosition , ase_worldPos );
			float clampResult21 = clamp( ( ( 1.0 - ( temp_output_7_0 / _HItFadeDistance ) ) * _HItFadePower ) , 0.0 , 1.0 );
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float clampResult13 = clamp( ( ( ( temp_output_7_0 - HitSize ) + ( tex2D( _Noise, uv_Noise ).r * _HitNoiseIntensity ) ) / _HitSpread ) , -1.0 , 0.0 );
			float2 appendResult14 = (float2(-clampResult13 , 0.5));
			float3 temp_cast_0 = (( clampResult21 * tex2D( _RampTex, appendResult14 ).r )).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
57;191;1354;837;3578.142;1482.434;3.370674;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2363.299,68.28739;Inherit;False;0;4;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;3;-2281.105,-355.0545;Inherit;False;Global;HitPosition;HitPosition;0;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-2281.105,-147.0545;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-2057.107,-67.0545;Inherit;False;Global;HitSize;HitSize;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-2057.107,-275.0545;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-2059.301,68.28739;Inherit;True;Property;_Noise;Noise;0;0;Create;True;0;0;False;0;False;-1;None;66819fafe6a64db797e1a5f6086c487f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1940.364,262.8729;Inherit;False;Property;_HitNoiseIntensity;HitNoiseIntensity;2;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1719.364,119.8718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-1753.107,-179.0545;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1449.107,-131.0545;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1515.531,90.00976;Inherit;False;Property;_HitSpread;HitSpread;1;0;Create;True;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1837.12,-325.1522;Inherit;False;Property;_HItFadeDistance;HItFadeDistance;5;0;Create;True;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-1276.2,-27.71255;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;17;-1596.12,-414.1522;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;13;-1118.97,41.82877;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1584.12,-302.1522;Inherit;False;Property;_HItFadePower;HItFadePower;4;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-1461.577,-394.3396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;16;-971.3009,52.28741;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1290.606,-367.6598;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-794.8651,52.35264;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;15;-582.8615,19.97729;Inherit;True;Property;_RampTex;RampTex;3;0;Create;True;0;0;False;0;False;-1;None;256d86d8496a4e0f947100121f1fafb2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;21;-1092.53,-331.2269;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-249.5996,-29.58534;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ForceFieldTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;3;0
WireConnection;7;1;1;0
WireConnection;4;1;2;0
WireConnection;9;0;4;1
WireConnection;9;1;5;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;17;0;7;0
WireConnection;17;1;18;0
WireConnection;13;0;12;0
WireConnection;22;0;17;0
WireConnection;16;0;13;0
WireConnection;19;0;22;0
WireConnection;19;1;20;0
WireConnection;14;0;16;0
WireConnection;15;1;14;0
WireConnection;21;0;19;0
WireConnection;23;0;21;0
WireConnection;23;1;15;1
WireConnection;0;2;23;0
ASEEND*/
//CHKSM=BD87E31368A2D8F9709594D841EF56A9AD164B93