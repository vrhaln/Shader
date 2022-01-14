// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/VAT"
{
	Properties
	{
		_VAT_POS("VAT_POS", 2D) = "white" {}
		_VAT_NORMAL("VAT_NORMAL", 2D) = "white" {}
		_Speed("Speed", Float) = 0
		_FrameCount("FrameCount", Float) = 100
		_BoundingMax("BoundingMax", Float) = 0
		_BoudingMin("BoudingMin", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform sampler2D _VAT_POS;
		uniform float _Speed;
		uniform float _FrameCount;
		uniform float _BoundingMax;
		uniform float _BoudingMin;
		uniform sampler2D _VAT_NORMAL;
		uniform float4 _VAT_NORMAL_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_28_0 = ( frac( ( _Time.y * _Speed ) ) * _FrameCount );
			float CurrentFrame8 = ( ( -ceil( temp_output_28_0 ) / _FrameCount ) + ( -1.0 / _FrameCount ) );
			float2 appendResult7 = (float2(v.texcoord1.xy.x , CurrentFrame8));
			float2 UV_VAT10 = appendResult7;
			float3 temp_cast_0 = (_BoudingMin).xxx;
			float3 break15 = ( ( (tex2Dlod( _VAT_POS, float4( UV_VAT10, 0, 0.0) )).rgb * ( _BoundingMax - _BoudingMin ) ) - temp_cast_0 );
			float3 appendResult16 = (float3(-break15.x , break15.y , break15.z));
			float3 VAT_VertexOffset39 = appendResult16;
			v.vertex.xyz += VAT_VertexOffset39;
			v.vertex.w = 1;
			float2 uv_VAT_NORMAL = v.texcoord * _VAT_NORMAL_ST.xy + _VAT_NORMAL_ST.zw;
			float3 break34 = (tex2Dlod( _VAT_NORMAL, float4( uv_VAT_NORMAL, 0, 0.0) )).rgb;
			float3 appendResult37 = (float3(-break34.x , break34.y , break34.z));
			float3 VAT_VertexNormal40 = appendResult37;
			v.normal = VAT_VertexNormal40;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-1546;92;1562;935;2624.676;427.8845;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;5;-2214.447,-40.05667;Inherit;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;24;-2235.251,-123.5182;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2063.234,-107.7026;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;27;-1899.578,-122.5079;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2185.358,128.5087;Inherit;False;Property;_FrameCount;FrameCount;3;0;Create;True;0;0;False;0;False;100;31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1738.141,-119.5751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;31;-1526.842,-16.97502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;12;-1276.366,-57.09897;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;6;-1017.745,-49.33409;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1062.833,98.57745;Inherit;False;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-840.8333,36.57745;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-637.3934,-77.91383;Inherit;False;CurrentFrame;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1457.908,219.7559;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;9;-1417.275,355.7149;Inherit;False;8;CurrentFrame;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-1173.67,285.3854;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1022.052,283.9187;Inherit;False;UV_VAT;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-1082.521,475.7511;Inherit;False;10;UV_VAT;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-661.9615,674.6489;Inherit;False;Property;_BoundingMax;BoundingMax;4;0;Create;True;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-663.4329,780.5944;Inherit;False;Property;_BoudingMin;BoudingMin;5;0;Create;True;0;0;False;0;False;0;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-888.1855,451.8023;Inherit;True;Property;_VAT_POS;VAT_POS;0;0;Create;True;0;0;False;0;False;-1;27b70ace4a4940f469371d576fbf283d;6e4466ed58e6bf44fa06cb7f0b978214;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-431.2277,656.5213;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;18;-544.0903,453.474;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-269.2277,569.5213;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;-536.8376,1065.589;Inherit;True;Property;_VAT_NORMAL;VAT_NORMAL;1;0;Create;True;0;0;False;0;False;-1;23df80ce87068134eb0372b54c6f1456;23df80ce87068134eb0372b54c6f1456;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;-127.5323,635.5338;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;33;-173.8832,1087.649;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;34;23.42949,1090.325;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;15;78.48097,478.1378;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NegateNode;19;310.6213,476.3423;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;35;255.5697,1088.529;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;397.1024,1092.687;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;470.3539,479.2003;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;638.6992,491.858;Inherit;False;VAT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;572.0881,1117.818;Inherit;False;VAT_VertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;29;-1532.042,-180.7749;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;30;-1530.742,-98.87505;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;975.4192,629.2004;Inherit;False;40;VAT_VertexNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;972.6518,536.4811;Inherit;False;39;VAT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2222.676,-250.8845;Inherit;False;Property;_Float0;Float 0;6;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1247.306,296.119;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASE/VAT;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;24;0
WireConnection;32;1;5;0
WireConnection;27;0;32;0
WireConnection;28;0;27;0
WireConnection;28;1;4;0
WireConnection;31;0;28;0
WireConnection;12;0;31;0
WireConnection;6;0;12;0
WireConnection;6;1;4;0
WireConnection;14;1;4;0
WireConnection;13;0;6;0
WireConnection;13;1;14;0
WireConnection;8;0;13;0
WireConnection;7;0;3;1
WireConnection;7;1;9;0
WireConnection;10;0;7;0
WireConnection;1;1;11;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;18;0;1;0
WireConnection;46;0;18;0
WireConnection;46;1;45;0
WireConnection;47;0;46;0
WireConnection;47;1;44;0
WireConnection;33;0;2;0
WireConnection;34;0;33;0
WireConnection;15;0;47;0
WireConnection;19;0;15;0
WireConnection;35;0;34;0
WireConnection;37;0;35;0
WireConnection;37;1;34;1
WireConnection;37;2;34;2
WireConnection;16;0;19;0
WireConnection;16;1;15;1
WireConnection;16;2;15;2
WireConnection;39;0;16;0
WireConnection;40;0;37;0
WireConnection;29;0;28;0
WireConnection;30;0;28;0
WireConnection;0;11;42;0
WireConnection;0;12;41;0
ASEEND*/
//CHKSM=2B929DC7290F30ACE42E95C317EA7CDABEB0F0FD