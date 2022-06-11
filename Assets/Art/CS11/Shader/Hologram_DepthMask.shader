// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/HologramDepthMask"
{
	Properties
	{
		_RandomVertexOffset("RandomVertexOffset", Vector) = (0,0,0,0)
		_RandomGlitchTilling("RandomGlitchTilling", Float) = 3
		_ScanlineVertexOffset("ScanlineVertexOffset", Vector) = (0,0,0,0)
		_ScanlineGlicthTex("ScanlineGlicthTex", 2D) = "white" {}
		_ScanlineGlitchTilling("ScanlineGlitchTilling", Float) = 0
		_ScanlineGlitchSpeed("ScanlineGlitchSpeed", Float) = 0
		_ScanlineGlitchWidth("ScanlineGlitchWidth", Range( 0 , 1)) = 0
		_ScanlineGlitchHardness("ScanlineGlitchHardness", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		ColorMask 0
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float3 _RandomVertexOffset;
		uniform float _RandomGlitchTilling;
		uniform float3 _ScanlineVertexOffset;
		uniform sampler2D _ScanlineGlicthTex;
		uniform float _ScanlineGlitchTilling;
		uniform float _ScanlineGlitchSpeed;
		uniform float _ScanlineGlitchWidth;
		uniform float _ScanlineGlitchHardness;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 viewToObjDir122 = mul( UNITY_MATRIX_T_MV, float4( _RandomVertexOffset, 0 ) ).xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime109 = _Time.y * -2.5;
			float mulTime112 = _Time.y * -2.0;
			float2 appendResult110 = (float2((ase_worldPos.y*_RandomGlitchTilling + mulTime109) , mulTime112));
			float simplePerlin2D111 = snoise( appendResult110 );
			simplePerlin2D111 = simplePerlin2D111*0.5 + 0.5;
			float3 objToWorld123 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime125 = _Time.y * -5.0;
			float mulTime128 = _Time.y * -1.0;
			float2 appendResult129 = (float2((( objToWorld123.x + objToWorld123.y + objToWorld123.z )*200.0 + mulTime125) , mulTime128));
			float simplePerlin2D130 = snoise( appendResult129 );
			simplePerlin2D130 = simplePerlin2D130*0.5 + 0.5;
			float clampResult136 = clamp( (simplePerlin2D130*2.0 + -1.0) , 0.0 , 1.0 );
			float temp_output_144_0 = ( (simplePerlin2D111*2.0 + -1.0) * clampResult136 );
			float2 break137 = appendResult110;
			float2 appendResult140 = (float2(( 20.0 * break137.x ) , break137.y));
			float simplePerlin2D141 = snoise( appendResult140 );
			simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
			float clampResult143 = clamp( (simplePerlin2D141*2.0 + -1.0) , 0.0 , 1.0 );
			float3 GlitchVertexOffset119 = ( ( viewToObjDir122 * 0.01 ) * ( temp_output_144_0 + ( temp_output_144_0 * clampResult143 ) ) );
			float3 viewToObjDir157 = mul( UNITY_MATRIX_T_MV, float4( _ScanlineVertexOffset, 0 ) ).xyz;
			float3 objToWorld2_g8 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime8_g8 = _Time.y * _ScanlineGlitchSpeed;
			float2 appendResult10_g8 = (float2(0.5 , (( ase_worldPos.y - objToWorld2_g8.y )*_ScanlineGlitchTilling + mulTime8_g8)));
			float clampResult16_g8 = clamp( ( ( tex2Dlod( _ScanlineGlicthTex, float4( appendResult10_g8, 0, 0.0) ).r - _ScanlineGlitchWidth ) * _ScanlineGlitchHardness ) , 0.0 , 1.0 );
			float3 ScanlineOffset161 = ( ( viewToObjDir157 * 0.01 ) * clampResult16_g8 );
			v.vertex.xyz += ( GlitchVertexOffset119 + ScanlineOffset161 );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1606;140;1579;839;7137.994;2466.002;7.910968;True;True
Node;AmplifyShaderEditor.CommentaryNode;149;-4327.525,-103.5669;Inherit;False;2817.83;1165.322;RandomGlitch;35;109;105;107;112;106;123;110;124;125;126;137;139;128;127;129;138;140;130;135;141;111;136;114;142;116;144;143;147;122;118;148;117;146;119;166;RandomGlitch;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;105;-4277.525,121.4594;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;107;-4277.825,281.8593;Inherit;False;Property;_RandomGlitchTilling;RandomGlitchTilling;2;0;Create;True;0;0;False;0;False;3;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;109;-4272.525,400.4593;Inherit;False;1;0;FLOAT;-2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;123;-3990.8,668.5491;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;106;-4037.525,199.4594;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;112;-4024.525,366.4594;Inherit;False;1;0;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-3740.8,698.5501;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;125;-3747.398,933.0989;Inherit;False;1;0;FLOAT;-5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-3740.26,836.0212;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;False;0;False;200;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-3803.525,217.4593;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;127;-3500.842,729.4012;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;128;-3516.494,950.7551;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;-3272.165,768.535;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;137;-3677.532,480.8289;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;139;-3597.365,381.7343;Inherit;False;Constant;_Float1;Float 1;26;0;Create;True;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-3436.79,411.742;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;130;-3105.749,732.0662;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-3293.329,483.096;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;135;-2864.057,696.6522;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;141;-3159.967,478.5369;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;136;-2641.589,701.4339;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;111;-3190.915,214.1923;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;114;-2925.461,213.14;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;166;-2476.905,709.2591;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;162;-1424.535,-109.814;Inherit;False;1556.768;985.3582;ScanlineGlicth;12;154;152;155;153;150;151;156;157;158;159;160;161;ScanlineGlicth;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;142;-2886.568,484.7859;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2522.224,245.826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;116;-3334.935,-53.5669;Inherit;False;Property;_RandomVertexOffset;RandomVertexOffset;1;0;Create;True;0;0;False;0;False;0,0,0;-2.5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;143;-2671.819,481.7132;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;156;-1401.197,-59.81397;Inherit;False;Property;_ScanlineVertexOffset;ScanlineVertexOffset;3;0;Create;True;0;0;False;0;False;0,0,0;3,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;152;-1237.005,561.9393;Inherit;False;Property;_ScanlineGlitchSpeed;ScanlineGlitchSpeed;6;0;Create;True;0;0;False;0;False;0;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;151;-1283.232,235.5819;Inherit;True;Property;_ScanlineGlicthTex;ScanlineGlicthTex;4;0;Create;True;0;0;False;0;False;None;afb16754b93daf04187b10b438f7a250;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TransformDirectionNode;157;-1174.557,-59.72095;Inherit;False;View;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;154;-1348.646,661.2713;Inherit;False;Property;_ScanlineGlitchWidth;ScanlineGlitchWidth;7;0;Create;True;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1226.005,469.9393;Inherit;False;Property;_ScanlineGlitchTilling;ScanlineGlitchTilling;5;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-3009.201,114.8153;Inherit;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;122;-3023.704,-53.47388;Inherit;False;View;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;158;-1160.054,108.5682;Inherit;False;Constant;_Float2;Float 2;24;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-2325.973,445.3343;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-1256.836,759.5433;Inherit;False;Property;_ScanlineGlitchHardness;ScanlineGlitchHardness;8;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;148;-2155.535,254.12;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-2714.71,44.11304;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;150;-957.8492,394.0818;Inherit;False;Scanline;-1;;8;04e5088286151bb48b4a81e604337ea7;0;6;25;SAMPLER2D;0;False;21;FLOAT;0;False;18;FLOAT;2;False;19;FLOAT;1;False;20;FLOAT;0;False;26;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;-865.5626,37.86621;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-420.6241,313.7792;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-1955.516,44.11524;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-196.7671,319.9481;Inherit;False;ScanlineOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-1754.696,171.9403;Inherit;False;GlitchVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;490.3242,347.2837;Inherit;False;161;ScanlineOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;481.0773,257.3849;Inherit;False;119;GlitchVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;780.3242,297.2837;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;960.3796,30.20535;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/HologramDepthMask;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;25;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;False;False;False;False;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;106;0;105;2
WireConnection;106;1;107;0
WireConnection;106;2;109;0
WireConnection;124;0;123;1
WireConnection;124;1;123;2
WireConnection;124;2;123;3
WireConnection;110;0;106;0
WireConnection;110;1;112;0
WireConnection;127;0;124;0
WireConnection;127;1;126;0
WireConnection;127;2;125;0
WireConnection;129;0;127;0
WireConnection;129;1;128;0
WireConnection;137;0;110;0
WireConnection;138;0;139;0
WireConnection;138;1;137;0
WireConnection;130;0;129;0
WireConnection;140;0;138;0
WireConnection;140;1;137;1
WireConnection;135;0;130;0
WireConnection;141;0;140;0
WireConnection;136;0;135;0
WireConnection;111;0;110;0
WireConnection;114;0;111;0
WireConnection;166;0;136;0
WireConnection;142;0;141;0
WireConnection;144;0;114;0
WireConnection;144;1;166;0
WireConnection;143;0;142;0
WireConnection;157;0;156;0
WireConnection;122;0;116;0
WireConnection;147;0;144;0
WireConnection;147;1;143;0
WireConnection;148;0;144;0
WireConnection;148;1;147;0
WireConnection;117;0;122;0
WireConnection;117;1;118;0
WireConnection;150;25;151;0
WireConnection;150;18;155;0
WireConnection;150;19;152;0
WireConnection;150;20;154;0
WireConnection;150;26;153;0
WireConnection;159;0;157;0
WireConnection;159;1;158;0
WireConnection;160;0;159;0
WireConnection;160;1;150;0
WireConnection;146;0;117;0
WireConnection;146;1;148;0
WireConnection;161;0;160;0
WireConnection;119;0;146;0
WireConnection;163;0;120;0
WireConnection;163;1;164;0
WireConnection;0;11;163;0
ASEEND*/
//CHKSM=36AC4C160E5F4F861DB77E78A87E5C4967FC2740