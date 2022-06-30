// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Hologram"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (0,0,0,0)
		[Toggle]_ZWriteMode("ZWriteMode", Float) = 0
		_RimBias("RimBias", Float) = 0
		_RimScale("RimScale", Float) = 1
		_RimPower("RimPower", Float) = 2
		_WireFrame("WireFrame", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_WireFrameIntensity("WireFrameIntensity", Float) = 1
		_FlickControl("FlickControl", Range( 0 , 1)) = 0
		_Alpha("Alpha", Range( 0 , 1)) = 0
		_ScanlineColor("ScanlineColor", Color) = (0,0,0,0)
		_Scanline1("Scanline1", 2D) = "white" {}
		_Scanline1Tilling("Scanline 1 Tilling", Float) = 0
		_Scanline1Speed("Scanline 1 Speed", Float) = 0
		_Scanline1Width("Scanline 1 Width", Range( 0 , 1)) = 0
		_Scanline1Hardness("Scanline 1 Hardness", Float) = 0
		_Scanline1Alpha("Scanline 1 Alpha", Range( 0 , 1)) = 1
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform float _ZWriteMode;
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
		uniform float4 _ScanlineColor;
		uniform float _Scanline1Alpha;
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 objToWorld10 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime6 = _Time.y * 15.0;
			float mulTime17 = _Time.y * 0.5;
			float2 appendResult16 = (float2((( objToWorld10.x + objToWorld10.y + objToWorld10.z )*200.0 + mulTime6) , mulTime17));
			float simplePerlin2D8 = snoise( appendResult16 );
			simplePerlin2D8 = simplePerlin2D8*0.5 + 0.5;
			float clampResult22 = clamp( (-0.5 + (simplePerlin2D8 - 0.0) * (2.0 - -0.5) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float lerpResult50 = lerp( 1.0 , clampResult22 , _FlickControl);
			float Flicking18 = lerpResult50;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float fresnelNdotV27 = dot( normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) ), ase_worldViewDir );
			float fresnelNode27 = ( _RimBias + _RimScale * pow( max( 1.0 - fresnelNdotV27 , 0.0001 ), _RimPower ) );
			float FresnelFactor34 = max( fresnelNode27 , 0.0 );
			float3 objToWorld94 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime8_g3 = _Time.y * _Scanline1Speed;
			float2 appendResult10_g3 = (float2(0.5 , (( ase_worldPos.x - objToWorld94.x )*_Scanline1Tilling + mulTime8_g3)));
			float clampResult16_g3 = clamp( ( ( tex2D( _Scanline1, appendResult10_g3 ).r - _Scanline1Width ) * _Scanline1Hardness ) , 0.0 , 1.0 );
			float temp_output_80_0 = clampResult16_g3;
			float4 Scanline65 = ( temp_output_80_0 * _ScanlineColor );
			o.Emission = ( Flicking18 * ( _MainColor + ( _MainColor * FresnelFactor34 ) + Scanline65 ) ).rgb;
			float ScanlineAlpha89 = ( temp_output_80_0 * _Scanline1Alpha );
			float clampResult46 = clamp( ( _MainColor.a + FresnelFactor34 + ScanlineAlpha89 ) , 0.0 , 1.0 );
			float2 uv_WireFrame = i.uv_texcoord * _WireFrame_ST.xy + _WireFrame_ST.zw;
			float WireFrame39 = ( tex2D( _WireFrame, uv_WireFrame ).r * _WireFrameIntensity );
			o.Alpha = ( clampResult46 * WireFrame39 * _Alpha );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				float2 customPack1 : TEXCOORD1;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
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
27;432;1083;641;4690.177;1358.722;5.792328;True;True
Node;AmplifyShaderEditor.CommentaryNode;20;-2669.753,-565.6251;Inherit;False;1871.287;468.3714;Flicking;13;18;8;16;17;14;6;13;11;10;21;22;50;51;Flicking;1,1,1,1;0;0
Node;AmplifyShaderEditor.TransformPositionNode;10;-2619.753,-515.6251;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-2369.753,-485.6251;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2376.352,-251.0757;Inherit;False;1;0;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;-2660.126,-28.19011;Inherit;False;1360.984;538.9061;Fresnel;9;49;34;33;27;30;29;28;31;32;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2369.213,-348.1534;Inherit;False;Constant;_TimeTilling;TimeTilling;2;0;Create;True;0;0;False;0;False;200;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;82;-2655.926,604.5742;Inherit;False;1402.745;1036.042;Scanline;15;65;84;89;83;85;88;80;61;71;81;56;72;93;95;94;Scanline;1,1,1,1;0;0
Node;AmplifyShaderEditor.TransformPositionNode;94;-2582.488,1031.292;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;95;-2571.466,878.1323;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;14;-2129.795,-454.774;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-2635.668,17.91909;Inherit;True;Property;_NormalMap;NormalMap;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;17;-2147.199,-291.1966;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;28;-2335.171,21.80987;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;29;-2319.617,174.5873;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;32;-2152.218,426.6874;Inherit;False;Property;_RimPower;RimPower;5;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2153.617,252.5873;Inherit;False;Property;_RimBias;RimBias;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2151.617,340.7874;Inherit;False;Property;_RimScale;RimScale;4;0;Create;True;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2412.841,1260.371;Inherit;False;Property;_Scanline1Speed;Scanline 1 Speed;14;0;Create;True;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;-2333.022,949.7737;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2511.482,1359.703;Inherit;False;Property;_Scanline1Width;Scanline 1 Width;15;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;81;-2404.304,740.1752;Inherit;True;Property;_Scanline1;Scanline1;12;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2412.841,1187.371;Inherit;False;Property;_Scanline1Tilling;Scanline 1 Tilling;13;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2408.672,1459.975;Inherit;False;Property;_Scanline1Hardness;Scanline 1 Hardness;16;0;Create;True;0;0;False;0;False;0;1.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1901.118,-415.6396;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1980.313,1216.852;Inherit;False;Property;_Scanline1Alpha;Scanline 1 Alpha;17;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;80;-2065.405,840.1047;Inherit;False;Scanline;-1;;3;04e5088286151bb48b4a81e604337ea7;0;6;25;SAMPLER2D;0;False;21;FLOAT;0;False;18;FLOAT;2;False;19;FLOAT;1;False;20;FLOAT;0;False;26;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-1741.065,-407.5727;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;27;-1936.194,144.9923;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1687.346,1110.309;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;83;-1980.52,1032.655;Inherit;False;Property;_ScanlineColor;ScanlineColor;11;0;Create;True;0;0;False;0;False;0,0,0,0;0.2129317,0.7396193,0.8207547,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;21;-1516.676,-386.6461;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;33;-1663.051,163.1173;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1233.194,-13.52741;Inherit;False;836.7146;381.0144;WireFrame;4;37;36;38;39;WireFrame;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1700.695,846.6546;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-1533.274,1100.792;Inherit;False;ScanlineAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1462.514,-208.5906;Inherit;False;Property;_FlickControl;FlickControl;9;0;Create;True;0;0;False;0;False;0;0.34;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1099.892,251.4872;Inherit;False;Property;_WireFrameIntensity;WireFrameIntensity;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1183.194,36.47257;Inherit;True;Property;_WireFrame;WireFrame;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1523.142,170.2544;Inherit;False;FresnelFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;22;-1316.676,-386.6461;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-132.0152,382.005;Inherit;False;89;ScanlineAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;-1150.514,-293.5906;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-207.5154,271.9926;Inherit;False;34;FresnelFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-781.0203,132.3233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;26.77931,76.56297;Inherit;False;34;FresnelFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1541.166,848.2037;Inherit;False;Scanline;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-221.106,-50.34035;Inherit;False;Property;_MainColor;MainColor;1;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,1.549738,4,0.03529412;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;250.3911,13.64032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;214.796,134.9955;Inherit;False;65;Scanline;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-620.4792,158.8117;Inherit;False;WireFrame;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;127.2312,268.1945;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-995.598,-356.4016;Inherit;False;Flicking;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;253.2314,423.1945;Inherit;False;39;WireFrame;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;46;284.2314,295.1945;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;189.9094,504.6467;Inherit;False;Property;_Alpha;Alpha;10;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;430.4911,-37.55973;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;26;-761.5797,-558.3993;Inherit;False;240;166;ProPerties;1;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;321.0709,-114.8266;Inherit;False;18;Flicking;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;470.2313,331.1945;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-711.5797,-508.3993;Inherit;False;Property;_ZWriteMode;ZWriteMode;2;1;[Toggle];Create;True;0;1;;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;571.5636,-97.74689;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;960.3796,30.20535;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Hologram;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;True;25;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;1
WireConnection;11;1;10;2
WireConnection;11;2;10;3
WireConnection;14;0;11;0
WireConnection;14;1;13;0
WireConnection;14;2;6;0
WireConnection;28;0;49;0
WireConnection;93;0;95;1
WireConnection;93;1;94;1
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;80;25;81;0
WireConnection;80;21;93;0
WireConnection;80;18;56;0
WireConnection;80;19;61;0
WireConnection;80;20;71;0
WireConnection;80;26;72;0
WireConnection;8;0;16;0
WireConnection;27;0;28;0
WireConnection;27;4;29;0
WireConnection;27;1;30;0
WireConnection;27;2;31;0
WireConnection;27;3;32;0
WireConnection;85;0;80;0
WireConnection;85;1;88;0
WireConnection;21;0;8;0
WireConnection;33;0;27;0
WireConnection;84;0;80;0
WireConnection;84;1;83;0
WireConnection;89;0;85;0
WireConnection;34;0;33;0
WireConnection;22;0;21;0
WireConnection;50;1;22;0
WireConnection;50;2;51;0
WireConnection;37;0;36;1
WireConnection;37;1;38;0
WireConnection;65;0;84;0
WireConnection;42;0;1;0
WireConnection;42;1;91;0
WireConnection;39;0;37;0
WireConnection;45;0;1;4
WireConnection;45;1;41;0
WireConnection;45;2;90;0
WireConnection;18;0;50;0
WireConnection;46;0;45;0
WireConnection;43;0;1;0
WireConnection;43;1;42;0
WireConnection;43;2;92;0
WireConnection;47;0;46;0
WireConnection;47;1;48;0
WireConnection;47;2;52;0
WireConnection;4;0;23;0
WireConnection;4;1;43;0
WireConnection;0;2;4;0
WireConnection;0;9;47;0
ASEEND*/
//CHKSM=AB138FC49EB3CD7CF4D03562CA35E1EED91B1730