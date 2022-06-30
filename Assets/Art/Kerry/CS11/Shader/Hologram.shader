// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Hologram"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (0,0,0,0)
		[Toggle]_ZWriteMode("ZWriteMode", Float) = 0
		_NormalMap("NormalMap", 2D) = "bump" {}
		_RimBias("RimBias", Float) = 0
		_RimScale("RimScale", Float) = 1
		_RimPower("RimPower", Float) = 2
		_WireFrame("WireFrame", 2D) = "white" {}
		_WireFrameIntensity("WireFrameIntensity", Float) = 1
		_FlickControl("FlickControl", Range( 0 , 1)) = 0
		_Alpha("Alpha", Range( 0 , 1)) = 0
		[HDR]_ScanlineColor("ScanlineColor", Color) = (0,0,0,0)
		_Scanline1("Scanline1", 2D) = "white" {}
		_Scanline1Tilling("Scanline 1 Tilling", Float) = 0
		_Scanline1Speed("Scanline 1 Speed", Float) = 0
		_Scanline1Width("Scanline 1 Width", Range( 0 , 1)) = 0
		_Scanline1Hardness("Scanline 1 Hardness", Float) = 0
		_Scanline1Alpha("Scanline 1 Alpha", Range( 0 , 1)) = 1
		_Scanline2("Scanline2", 2D) = "white" {}
		_Scanline2Tilling("Scanline 2 Tilling", Float) = 0
		_Scanline2Speed("Scanline 2 Speed", Float) = 0
		_Scanline2Width("Scanline 2 Width", Range( 0 , 1)) = 0
		_Scanline2Hardness("Scanline 2 Hardness", Float) = 0
		_Scanline2Alpha("Scanline 2 Alpha", Range( 0 , 1)) = 1
		_RandomVertexOffset("RandomVertexOffset", Vector) = (0,0,0,0)
		_RandomGlitchTilling("RandomGlitchTilling", Float) = 3
		_ScanlineVertexOffset("ScanlineVertexOffset", Vector) = (0,0,0,0)
		_ScanlineGlicthTex("ScanlineGlicthTex", 2D) = "white" {}
		_ScanlineGlitchTilling("ScanlineGlitchTilling", Float) = 0
		_ScanlineGlitchSpeed("ScanlineGlitchSpeed", Float) = 0
		_ScanlineGlitchWidth("ScanlineGlitchWidth", Range( 0 , 1)) = 0
		_ScanlineGlitchHardness("ScanlineGlitchHardness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite [_ZWriteMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float vertexToFrag165;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform float _ZWriteMode;
		uniform float3 _RandomVertexOffset;
		uniform float _RandomGlitchTilling;
		uniform float3 _ScanlineVertexOffset;
		uniform sampler2D _ScanlineGlicthTex;
		uniform float _ScanlineGlitchTilling;
		uniform float _ScanlineGlitchSpeed;
		uniform float _ScanlineGlitchWidth;
		uniform float _ScanlineGlitchHardness;
		uniform float _FlickControl;
		uniform float4 _MainColor;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _RimBias;
		uniform float _RimScale;
		uniform float _RimPower;
		uniform sampler2D _Scanline1;
		uniform float _Scanline1Tilling;
		uniform float _Scanline1Speed;
		uniform float _Scanline1Width;
		uniform float _Scanline1Hardness;
		uniform sampler2D _Scanline2;
		uniform float _Scanline2Tilling;
		uniform float _Scanline2Speed;
		uniform float _Scanline2Width;
		uniform float _Scanline2Hardness;
		uniform float4 _ScanlineColor;
		uniform float _Scanline1Alpha;
		uniform float _Scanline2Alpha;
		uniform sampler2D _WireFrame;
		uniform float4 _WireFrame_ST;
		uniform float _WireFrameIntensity;
		uniform float _Alpha;


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
			float3 objToWorld2_g7 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime8_g7 = _Time.y * _ScanlineGlitchSpeed;
			float2 appendResult10_g7 = (float2(0.5 , (( ase_worldPos.y - objToWorld2_g7.y )*_ScanlineGlitchTilling + mulTime8_g7)));
			float clampResult16_g7 = clamp( ( ( tex2Dlod( _ScanlineGlicthTex, float4( appendResult10_g7, 0, 0.0) ).r - _ScanlineGlitchWidth ) * _ScanlineGlitchHardness ) , 0.0 , 1.0 );
			float3 ScanlineOffset161 = ( ( viewToObjDir157 * 0.01 ) * clampResult16_g7 );
			v.vertex.xyz += ( GlitchVertexOffset119 + ScanlineOffset161 );
			float3 objToWorld10 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime6 = _Time.y * 15.0;
			float mulTime17 = _Time.y * 0.5;
			float2 appendResult16 = (float2((( objToWorld10.x + objToWorld10.y + objToWorld10.z )*200.0 + mulTime6) , mulTime17));
			float simplePerlin2D8 = snoise( appendResult16 );
			simplePerlin2D8 = simplePerlin2D8*0.5 + 0.5;
			float clampResult22 = clamp( (-0.5 + (simplePerlin2D8 - 0.0) * (2.0 - -0.5) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float lerpResult50 = lerp( 1.0 , clampResult22 , _FlickControl);
			o.vertexToFrag165 = lerpResult50;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float Flicking18 = i.vertexToFrag165;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float fresnelNdotV27 = dot( normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) ), ase_worldViewDir );
			float fresnelNode27 = ( _RimBias + _RimScale * pow( max( 1.0 - fresnelNdotV27 , 0.0001 ), _RimPower ) );
			float FresnelFactor34 = max( fresnelNode27 , 0.0 );
			float3 objToWorld2_g5 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime8_g5 = _Time.y * _Scanline1Speed;
			float2 appendResult10_g5 = (float2(0.5 , (( ase_worldPos.y - objToWorld2_g5.y )*_Scanline1Tilling + mulTime8_g5)));
			float clampResult16_g5 = clamp( ( ( tex2D( _Scanline1, appendResult10_g5 ).r - _Scanline1Width ) * _Scanline1Hardness ) , 0.0 , 1.0 );
			float temp_output_80_0 = clampResult16_g5;
			float3 objToWorld2_g6 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime8_g6 = _Time.y * _Scanline2Speed;
			float2 appendResult10_g6 = (float2(0.5 , (( ase_worldPos.y - objToWorld2_g6.y )*_Scanline2Tilling + mulTime8_g6)));
			float clampResult16_g6 = clamp( ( ( tex2D( _Scanline2, appendResult10_g6 ).r - _Scanline2Width ) * _Scanline2Hardness ) , 0.0 , 1.0 );
			float temp_output_99_0 = clampResult16_g6;
			float4 Scanline65 = ( ( temp_output_80_0 * temp_output_99_0 ) * _ScanlineColor );
			o.Emission = ( Flicking18 * ( _MainColor + ( _MainColor * FresnelFactor34 ) + max( Scanline65 , float4( 0,0,0,0 ) ) ) ).rgb;
			float temp_output_101_0 = ( temp_output_99_0 * _Scanline2Alpha );
			float ScanlineAlpha89 = ( ( ( temp_output_80_0 * _Scanline1Alpha ) * temp_output_101_0 ) + temp_output_101_0 );
			float clampResult46 = clamp( ( _MainColor.a + FresnelFactor34 + ScanlineAlpha89 ) , 0.0 , 1.0 );
			float2 uv_WireFrame = i.uv_texcoord * _WireFrame_ST.xy + _WireFrame_ST.zw;
			float WireFrame39 = ( tex2D( _WireFrame, uv_WireFrame ).r * _WireFrameIntensity );
			o.Alpha = ( clampResult46 * WireFrame39 * _Alpha );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.x = customInputData.vertexToFrag165;
				o.customPack1.yz = customInputData.uv_texcoord;
				o.customPack1.yz = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.vertexToFrag165 = IN.customPack1.x;
				surfIN.uv_texcoord = IN.customPack1.yz;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-21;305;1579;839;4726.865;-744.8826;4.157014;True;True
Node;AmplifyShaderEditor.CommentaryNode;149;-2678.932,2135.772;Inherit;False;2817.83;1165.322;RandomGlitch;35;109;105;107;112;106;123;110;124;125;126;137;139;128;127;129;138;140;130;135;141;111;136;114;142;116;144;143;147;122;118;148;117;146;119;166;RandomGlitch;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;105;-2628.932,2360.798;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;107;-2629.232,2521.198;Inherit;False;Property;_RandomGlitchTilling;RandomGlitchTilling;25;0;Create;True;0;0;False;0;False;3;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;109;-2623.932,2639.798;Inherit;False;1;0;FLOAT;-2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;123;-2342.207,2907.888;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;106;-2388.932,2438.798;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;112;-2375.932,2605.798;Inherit;False;1;0;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-2092.207,2937.889;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;125;-2098.805,3172.438;Inherit;False;1;0;FLOAT;-5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-2091.667,3075.36;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;False;0;False;200;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;127;-1852.249,2968.74;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;128;-1867.901,3190.094;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-2154.932,2456.798;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2669.753,-565.6251;Inherit;False;2136.784;476.1043;Flicking;14;18;165;50;51;22;21;8;16;17;14;13;6;11;10;Flicking;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;-1623.572,3007.874;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-1948.772,2621.073;Inherit;False;Constant;_Float1;Float 1;26;0;Create;True;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;137;-2028.939,2720.168;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TransformPositionNode;10;-2619.753,-515.6251;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;130;-1457.156,2971.405;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2369.213,-348.1534;Inherit;False;Constant;_TimeTilling;TimeTilling;2;0;Create;True;0;0;False;0;False;200;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2376.352,-251.0757;Inherit;False;1;0;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;82;-2655.926,604.5742;Inherit;False;1707.927;1347.378;Scanline;23;103;102;101;88;85;100;94;96;95;97;99;98;80;81;56;71;61;72;65;89;84;83;104;Scanline;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-1788.197,2651.081;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-2369.753,-485.6251;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2509.285,860.5516;Inherit;False;Property;_Scanline1Tilling;Scanline 1 Tilling;13;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-2147.199,-291.1966;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;14;-2129.795,-454.774;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2631.579,1731.129;Inherit;False;Property;_Scanline2Width;Scanline 2 Width;21;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2503.116,1159.156;Inherit;False;Property;_Scanline1Hardness;Scanline 1 Hardness;16;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2538.938,1612.797;Inherit;False;Property;_Scanline2Speed;Scanline 2 Speed;20;0;Create;True;0;0;False;0;False;0;-3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2605.926,1058.884;Inherit;False;Property;_Scanline1Width;Scanline 1 Width;15;0;Create;True;0;0;False;0;False;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2513.285,940.5516;Inherit;False;Property;_Scanline1Speed;Scanline 1 Speed;14;0;Create;True;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-2534.938,1532.797;Inherit;False;Property;_Scanline2Tilling;Scanline 2 Tilling;19;0;Create;True;0;0;False;0;False;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2528.769,1831.401;Inherit;False;Property;_Scanline2Hardness;Scanline 2 Hardness;22;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;98;-2532.679,1326.819;Inherit;True;Property;_Scanline2;Scanline2;18;0;Create;True;0;0;False;0;False;None;4bbf045a9f687084ea4bc84d53c39623;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;81;-2507.026,654.5742;Inherit;True;Property;_Scanline1;Scanline1;12;0;Create;True;0;0;False;0;False;None;afb16754b93daf04187b10b438f7a250;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;35;-2660.126,-28.19011;Inherit;False;1360.984;538.9061;Fresnel;9;49;34;33;27;30;29;28;31;32;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-1644.736,2722.435;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;135;-1215.464,2935.991;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-2635.668,17.91909;Inherit;True;Property;_NormalMap;NormalMap;3;0;Create;True;0;0;False;0;False;-1;None;77b91526e481d164aa4fee6e8b5fc94c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;141;-1511.374,2717.876;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;99;-2193.78,1426.749;Inherit;False;Scanline;-1;;6;04e5088286151bb48b4a81e604337ea7;0;6;25;SAMPLER2D;0;False;21;FLOAT;0;False;18;FLOAT;2;False;19;FLOAT;1;False;20;FLOAT;0;False;26;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-2166.34,1659.184;Inherit;False;Property;_Scanline2Alpha;Scanline 2 Alpha;23;0;Create;True;0;0;False;0;False;1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;80;-2168.127,754.5037;Inherit;False;Scanline;-1;;5;04e5088286151bb48b4a81e604337ea7;0;6;25;SAMPLER2D;0;False;21;FLOAT;0;False;18;FLOAT;2;False;19;FLOAT;1;False;20;FLOAT;0;False;26;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-2157.035,1191.251;Inherit;False;Property;_Scanline1Alpha;Scanline 1 Alpha;17;0;Create;True;0;0;False;0;False;1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1901.118,-415.6396;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;136;-992.9961,2940.773;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;111;-1542.322,2453.531;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1820.067,1153.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-1741.065,-407.5727;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;28;-2335.171,21.80987;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;30;-2153.617,252.5873;Inherit;False;Property;_RimBias;RimBias;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2152.218,426.6874;Inherit;False;Property;_RimPower;RimPower;6;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2151.617,340.7874;Inherit;False;Property;_RimScale;RimScale;5;0;Create;True;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;166;-828.3115,2948.598;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1802.883,1486.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;162;224.0585,2129.525;Inherit;False;1556.768;985.3582;ScanlineGlicth;12;154;152;155;153;150;151;156;157;158;159;160;161;ScanlineGlicth;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;114;-1276.868,2452.479;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;29;-2319.617,174.5873;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;142;-1237.975,2724.125;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;27;-1936.194,144.9923;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1631.883,1306.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;156;247.3957,2179.525;Inherit;False;Property;_ScanlineVertexOffset;ScanlineVertexOffset;26;0;Create;True;0;0;False;0;False;0,0,0;3,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;21;-1516.676,-386.6461;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-873.6307,2485.165;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;143;-1023.226,2721.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;83;-1712.943,888.2556;Inherit;False;Property;_ScanlineColor;ScanlineColor;11;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,2.307109,34.60664,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-1767.889,773.6876;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;116;-1686.342,2185.772;Inherit;False;Property;_RandomVertexOffset;RandomVertexOffset;24;0;Create;True;0;0;False;0;False;0,0,0;-2.5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-677.3801,2684.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;22;-1316.676,-386.6461;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;488.5394,2347.907;Inherit;False;Constant;_Float2;Float 2;24;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1470.646,776.0661;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformDirectionNode;122;-1375.111,2185.865;Inherit;False;View;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;118;-1360.608,2354.154;Inherit;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;391.7575,2998.882;Inherit;False;Property;_ScanlineGlitchHardness;ScanlineGlitchHardness;31;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-1452.883,1397.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;299.9474,2900.61;Inherit;False;Property;_ScanlineGlitchWidth;ScanlineGlitchWidth;30;0;Create;True;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;157;474.0365,2179.618;Inherit;False;View;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;40;-1233.194,-13.52741;Inherit;False;836.7146;381.0144;WireFrame;4;37;36;38;39;WireFrame;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;155;422.5885,2709.278;Inherit;False;Property;_ScanlineGlitchTilling;ScanlineGlitchTilling;28;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;151;365.3614,2474.921;Inherit;True;Property;_ScanlineGlicthTex;ScanlineGlicthTex;27;0;Create;True;0;0;False;0;False;None;afb16754b93daf04187b10b438f7a250;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;33;-1663.051,163.1173;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1462.514,-208.5906;Inherit;False;Property;_FlickControl;FlickControl;9;0;Create;True;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;411.5885,2801.278;Inherit;False;Property;_ScanlineGlitchSpeed;ScanlineGlitchSpeed;29;0;Create;True;0;0;False;0;False;0;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;783.0305,2277.205;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;50;-1169.514,-305.5906;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1253.572,760.1007;Inherit;False;Scanline;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;148;-506.9421,2493.459;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1099.892,251.4872;Inherit;False;Property;_WireFrameIntensity;WireFrameIntensity;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1523.142,170.2544;Inherit;False;FresnelFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-1284.461,1389.244;Inherit;False;ScanlineAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1066.117,2283.452;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;150;690.7439,2633.421;Inherit;False;Scanline;-1;;7;04e5088286151bb48b4a81e604337ea7;0;6;25;SAMPLER2D;0;False;21;FLOAT;0;False;18;FLOAT;2;False;19;FLOAT;1;False;20;FLOAT;0;False;26;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1183.194,36.47257;Inherit;True;Property;_WireFrame;WireFrame;7;0;Create;True;0;0;False;0;False;-1;None;92f284b27dea88e41885444624ec2963;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;92;112.796,169.9955;Inherit;False;65;Scanline;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;1227.969,2553.118;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;26.77931,76.56297;Inherit;False;34;FresnelFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-207.5154,271.9926;Inherit;False;34;FresnelFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-306.9225,2283.454;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-781.0203,132.3233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-221.106,-50.34035;Inherit;False;Property;_MainColor;MainColor;1;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0.6158246,4,0.03529412;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;90;-132.0152,382.005;Inherit;False;89;ScanlineAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;165;-1008.044,-300.2793;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;1451.826,2559.287;Inherit;False;ScanlineOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;93;289.3585,169.4514;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-620.4792,158.8117;Inherit;False;WireFrame;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;127.2312,268.1945;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;250.3911,13.64032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-786.8088,-307.4265;Inherit;False;Flicking;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-106.1024,2411.279;Inherit;False;GlitchVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;504.2801,552.058;Inherit;False;119;GlitchVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;513.527,641.9568;Inherit;False;161;ScanlineOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;430.4911,-37.55973;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;46;284.2314,295.1945;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;189.9094,504.6467;Inherit;False;Property;_Alpha;Alpha;10;0;Create;True;0;0;False;0;False;0;0.736;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-459.9952,-553.244;Inherit;False;240;166;ProPerties;1;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;253.2314,423.1945;Inherit;False;39;WireFrame;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;321.0709,-114.8266;Inherit;False;18;Flicking;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;470.2313,331.1945;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-409.9952,-503.244;Inherit;False;Property;_ZWriteMode;ZWriteMode;2;1;[Toggle];Create;True;0;1;;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;571.5636,-97.74689;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;803.527,591.9568;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;960.3796,30.20535;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;True;25;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;106;0;105;2
WireConnection;106;1;107;0
WireConnection;106;2;109;0
WireConnection;124;0;123;1
WireConnection;124;1;123;2
WireConnection;124;2;123;3
WireConnection;127;0;124;0
WireConnection;127;1;126;0
WireConnection;127;2;125;0
WireConnection;110;0;106;0
WireConnection;110;1;112;0
WireConnection;129;0;127;0
WireConnection;129;1;128;0
WireConnection;137;0;110;0
WireConnection;130;0;129;0
WireConnection;138;0;139;0
WireConnection;138;1;137;0
WireConnection;11;0;10;1
WireConnection;11;1;10;2
WireConnection;11;2;10;3
WireConnection;14;0;11;0
WireConnection;14;1;13;0
WireConnection;14;2;6;0
WireConnection;140;0;138;0
WireConnection;140;1;137;1
WireConnection;135;0;130;0
WireConnection;141;0;140;0
WireConnection;99;25;98;0
WireConnection;99;18;97;0
WireConnection;99;19;95;0
WireConnection;99;20;96;0
WireConnection;99;26;94;0
WireConnection;80;25;81;0
WireConnection;80;18;56;0
WireConnection;80;19;61;0
WireConnection;80;20;71;0
WireConnection;80;26;72;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;136;0;135;0
WireConnection;111;0;110;0
WireConnection;85;0;80;0
WireConnection;85;1;88;0
WireConnection;8;0;16;0
WireConnection;28;0;49;0
WireConnection;166;0;136;0
WireConnection;101;0;99;0
WireConnection;101;1;100;0
WireConnection;114;0;111;0
WireConnection;142;0;141;0
WireConnection;27;0;28;0
WireConnection;27;4;29;0
WireConnection;27;1;30;0
WireConnection;27;2;31;0
WireConnection;27;3;32;0
WireConnection;102;0;85;0
WireConnection;102;1;101;0
WireConnection;21;0;8;0
WireConnection;144;0;114;0
WireConnection;144;1;166;0
WireConnection;143;0;142;0
WireConnection;104;0;80;0
WireConnection;104;1;99;0
WireConnection;147;0;144;0
WireConnection;147;1;143;0
WireConnection;22;0;21;0
WireConnection;84;0;104;0
WireConnection;84;1;83;0
WireConnection;122;0;116;0
WireConnection;103;0;102;0
WireConnection;103;1;101;0
WireConnection;157;0;156;0
WireConnection;33;0;27;0
WireConnection;159;0;157;0
WireConnection;159;1;158;0
WireConnection;50;1;22;0
WireConnection;50;2;51;0
WireConnection;65;0;84;0
WireConnection;148;0;144;0
WireConnection;148;1;147;0
WireConnection;34;0;33;0
WireConnection;89;0;103;0
WireConnection;117;0;122;0
WireConnection;117;1;118;0
WireConnection;150;25;151;0
WireConnection;150;18;155;0
WireConnection;150;19;152;0
WireConnection;150;20;154;0
WireConnection;150;26;153;0
WireConnection;160;0;159;0
WireConnection;160;1;150;0
WireConnection;146;0;117;0
WireConnection;146;1;148;0
WireConnection;37;0;36;1
WireConnection;37;1;38;0
WireConnection;165;0;50;0
WireConnection;161;0;160;0
WireConnection;93;0;92;0
WireConnection;39;0;37;0
WireConnection;45;0;1;4
WireConnection;45;1;41;0
WireConnection;45;2;90;0
WireConnection;42;0;1;0
WireConnection;42;1;91;0
WireConnection;18;0;165;0
WireConnection;119;0;146;0
WireConnection;43;0;1;0
WireConnection;43;1;42;0
WireConnection;43;2;93;0
WireConnection;46;0;45;0
WireConnection;47;0;46;0
WireConnection;47;1;48;0
WireConnection;47;2;52;0
WireConnection;4;0;23;0
WireConnection;4;1;43;0
WireConnection;163;0;120;0
WireConnection;163;1;164;0
WireConnection;0;2;4;0
WireConnection;0;9;47;0
WireConnection;0;11;163;0
ASEEND*/
//CHKSM=9E5F100186362A5AE19BF7D04842A48ADCD230EA