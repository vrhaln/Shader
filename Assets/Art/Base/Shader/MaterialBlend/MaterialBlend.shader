// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/MaterialBlend"
{
	Properties
	{
		_BlendContrast("BlendContrast", Range( 0.1 , 1)) = 0.1
		_Layer1_Tilling("Layer1_Tilling", Float) = 1
		_Layer1_BaseColor("Layer1_BaseColor", 2D) = "white" {}
		_Layer1_Normal("Layer1_Normal", 2D) = "bump" {}
		_Layer1_HRA("Layer1_HRA", 2D) = "white" {}
		_Layer1_HeightContrast("Layer1_HeightContrast", Range( 0 , 1)) = 0
		_Layer2_Tilling("Layer2_Tilling", Float) = 1
		_Layer2_BaseColor("Layer2_BaseColor", 2D) = "white" {}
		_Layer2_Normal("Layer2_Normal", 2D) = "bump" {}
		_Layer2_HRA("Layer2_HRA", 2D) = "white" {}
		_Layer2_HeightContrast("Layer2_HeightContrast", Range( 0 , 1)) = 0
		_Layer3_Tilling("Layer3_Tilling", Float) = 1
		_Layer3_BaseColor("Layer3_BaseColor", 2D) = "white" {}
		_Layer3_Normal("Layer3_Normal", 2D) = "bump" {}
		_Layer3_HRA("Layer3_HRA", 2D) = "white" {}
		_Layer3_HeightContrast("Layer3_HeightContrast", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
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

		uniform sampler2D _Layer1_BaseColor;
		uniform float _Layer1_Tilling;
		uniform float _Layer1_HeightContrast;
		uniform sampler2D _Layer1_HRA;
		SamplerState sampler_Layer1_HRA;
		uniform float _Layer2_HeightContrast;
		uniform sampler2D _Layer2_HRA;
		SamplerState sampler_Layer2_HRA;
		uniform float _Layer2_Tilling;
		uniform float _Layer3_HeightContrast;
		uniform sampler2D _Layer3_HRA;
		SamplerState sampler_Layer3_HRA;
		uniform float _Layer3_Tilling;
		uniform float _BlendContrast;
		uniform sampler2D _Layer2_BaseColor;
		uniform sampler2D _Layer3_BaseColor;
		uniform sampler2D _Layer1_Normal;
		uniform sampler2D _Layer2_Normal;
		uniform sampler2D _Layer3_Normal;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float2 LayerUV7 = i.uv_texcoord;
			float2 temp_output_11_0 = ( LayerUV7 * _Layer1_Tilling );
			float4 Layer1_BaseColor14 = tex2D( _Layer1_BaseColor, temp_output_11_0 );
			float temp_output_1_0_g8 = _Layer1_HeightContrast;
			float4 tex2DNode3 = tex2D( _Layer1_HRA, temp_output_11_0 );
			float lerpResult4_g8 = lerp( ( 0.0 - temp_output_1_0_g8 ) , ( temp_output_1_0_g8 + 1.0 ) , tex2DNode3.r);
			float clampResult5_g8 = clamp( lerpResult4_g8 , 0.0 , 1.0 );
			float Layer1_Hight63 = clampResult5_g8;
			float temp_output_138_0 = ( Layer1_Hight63 + i.vertexColor.r );
			float temp_output_1_0_g7 = _Layer2_HeightContrast;
			float2 temp_output_28_0 = ( LayerUV7 * _Layer2_Tilling );
			float4 tex2DNode29 = tex2D( _Layer2_HRA, temp_output_28_0 );
			float lerpResult4_g7 = lerp( ( 0.0 - temp_output_1_0_g7 ) , ( temp_output_1_0_g7 + 1.0 ) , tex2DNode29.r);
			float clampResult5_g7 = clamp( lerpResult4_g7 , 0.0 , 1.0 );
			float Layer2_Hight64 = clampResult5_g7;
			float temp_output_139_0 = ( Layer2_Hight64 + i.vertexColor.g );
			float temp_output_1_0_g9 = _Layer3_HeightContrast;
			float2 temp_output_76_0 = ( LayerUV7 * _Layer3_Tilling );
			float4 tex2DNode77 = tex2D( _Layer3_HRA, temp_output_76_0 );
			float lerpResult4_g9 = lerp( ( 0.0 - temp_output_1_0_g9 ) , ( temp_output_1_0_g9 + 1.0 ) , tex2DNode77.r);
			float clampResult5_g9 = clamp( lerpResult4_g9 , 0.0 , 1.0 );
			float Layer3_Hight78 = clampResult5_g9;
			float temp_output_140_0 = ( Layer3_Hight78 + i.vertexColor.b );
			float temp_output_94_0 = ( max( max( temp_output_138_0 , temp_output_139_0 ) , temp_output_140_0 ) - _BlendContrast );
			float temp_output_99_0 = max( ( temp_output_138_0 - temp_output_94_0 ) , 0.0 );
			float temp_output_100_0 = max( ( temp_output_139_0 - temp_output_94_0 ) , 0.0 );
			float temp_output_101_0 = max( ( temp_output_140_0 - temp_output_94_0 ) , 0.0 );
			float4 appendResult102 = (float4(temp_output_99_0 , temp_output_100_0 , temp_output_101_0 , 0.0));
			float4 BlendWeight90 = ( appendResult102 / ( temp_output_99_0 + temp_output_100_0 + temp_output_101_0 ) );
			float4 break113 = BlendWeight90;
			float4 Layer2_BaseColor35 = tex2D( _Layer2_BaseColor, temp_output_28_0 );
			float4 Layer3_BaseColor84 = tex2D( _Layer3_BaseColor, temp_output_76_0 );
			float4 Base_Color41 = ( ( Layer1_BaseColor14 * break113.x ) + ( Layer2_BaseColor35 * break113.y ) + ( Layer3_BaseColor84 * break113.z ) );
			s1.Albedo = Base_Color41.rgb;
			float3 Layer1_Normal15 = UnpackNormal( tex2D( _Layer1_Normal, temp_output_11_0 ) );
			float4 break136 = BlendWeight90;
			float3 Layer2_Normal34 = UnpackNormal( tex2D( _Layer2_Normal, temp_output_28_0 ) );
			float3 Layer3_Normal82 = UnpackNormal( tex2D( _Layer3_Normal, temp_output_76_0 ) );
			float3 Normal60 = ( ( Layer1_Normal15 * break136.x ) + ( Layer2_Normal34 * break136.y ) + ( Layer3_Normal82 * break136.z ) );
			s1.Normal = WorldNormalVector( i , Normal60 );
			s1.Emission = float3( 0,0,0 );
			s1.Metallic = 0.0;
			float Layer1_Roughness16 = tex2DNode3.g;
			float4 break124 = BlendWeight90;
			float Layer2_Roughness31 = tex2DNode29.g;
			float Layer3_Roughness81 = tex2DNode77.g;
			float Roughness47 = ( ( Layer1_Roughness16 * break124.x ) + ( Layer2_Roughness31 * break124.y ) + ( Layer3_Roughness81 * break124.z ) );
			s1.Smoothness = ( 1.0 - Roughness47 );
			float Layer1_AO17 = tex2DNode3.b;
			float4 break130 = BlendWeight90;
			float Layer2_AO33 = tex2DNode29.b;
			float Layer3_AO83 = tex2DNode77.b;
			float AO54 = ( ( Layer1_AO17 * break130.x ) + ( Layer2_AO33 * break130.y ) + ( Layer3_AO83 * break130.z ) );
			s1.Occlusion = AO54;

			data.light = gi.light;

			UnityGI gi1 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g1 = UnityGlossyEnvironmentSetup( s1.Smoothness, data.worldViewDir, s1.Normal, float3(0,0,0));
			gi1 = UnityGlobalIllumination( data, s1.Occlusion, s1.Normal, g1 );
			#endif

			float3 surfResult1 = LightingStandard ( s1, viewDir, gi1 ).rgb;
			surfResult1 += s1.Emission;

			#ifdef UNITY_PASS_FORWARDADD//1
			surfResult1 -= s1.Emission;
			#endif//1
			c.rgb = surfResult1;
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
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-1920;65;1603;954;6111.847;-1081.48;2.139483;True;True
Node;AmplifyShaderEditor.CommentaryNode;8;-2101.164,-248.0639;Inherit;False;519.8381;209;LayerUV;2;7;6;LayerUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2054.464,-190.7639;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;9;-2108.873,140.4628;Inherit;False;1216.034;854.9859;Layer01;13;2;3;4;10;11;12;14;15;16;17;63;155;156;Layer01;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1788.326,-191.8749;Inherit;False;LayerUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;25;-2099.418,1236.741;Inherit;False;1216.034;854.9859;Layer02;13;35;34;33;32;31;30;29;28;27;26;64;157;158;Layer02;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2091.194,340.1158;Inherit;False;Property;_Layer1_Tilling;Layer1_Tilling;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;-2090.037,243.8979;Inherit;False;7;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2080.582,1340.176;Inherit;False;7;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2081.739,1436.394;Inherit;False;Property;_Layer2_Tilling;Layer2_Tilling;7;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;73;-2073.657,2310.388;Inherit;False;1216.034;854.9859;Layer03;13;84;83;82;81;80;79;78;77;76;75;74;159;160;Layer03;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-2054.821,2413.823;Inherit;False;7;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2055.978,2510.041;Inherit;False;Property;_Layer3_Tilling;Layer3_Tilling;12;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1902.859,1350.394;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1912.315,254.1158;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-1696.868,1467.675;Inherit;False;Property;_Layer2_HeightContrast;Layer2_HeightContrast;11;0;Create;True;0;0;False;0;False;0;0.18;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1877.097,2424.041;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-1707.564,456.0668;Inherit;True;Property;_Layer1_HRA;Layer1_HRA;5;0;Create;True;0;0;False;0;False;-1;None;62b664ccfe4887647b11ac949411414f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;156;-1679.55,381.1059;Inherit;False;Property;_Layer1_HeightContrast;Layer1_HeightContrast;6;0;Create;True;0;0;False;0;False;0;0.221;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-1699.575,1540.612;Inherit;True;Property;_Layer2_HRA;Layer2_HRA;10;0;Create;True;0;0;False;0;False;-1;None;ead3111df686e0c40aee12382636b082;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;77;-1673.813,2614.259;Inherit;True;Property;_Layer3_HRA;Layer3_HRA;15;0;Create;True;0;0;False;0;False;-1;None;c6f69b11a4c5dc04b8bd8f3068d6ae67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;160;-1683.417,2541.643;Inherit;False;Property;_Layer3_HeightContrast;Layer3_HeightContrast;16;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;157;-1421.575,1456.865;Inherit;False;CheapContrast;-1;;7;c3ba48661c08fe047b92dc11ddacd9c0;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;155;-1385.316,380.5388;Inherit;False;CheapContrast;-1;;8;c3ba48661c08fe047b92dc11ddacd9c0;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-4940.672,1821.293;Inherit;False;2482.057;926.3203;BlendWeight;21;90;105;102;103;99;101;100;98;97;96;138;139;94;140;142;93;143;141;95;92;87;BlendWeight;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;159;-1391.224,2538.633;Inherit;False;CheapContrast;-1;;9;c3ba48661c08fe047b92dc11ddacd9c0;0;2;1;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1173.472,1484.813;Inherit;False;Layer2_Hight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-1117.603,388.3837;Inherit;False;Layer1_Hight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;87;-4840.509,2089.776;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-1132.51,2543.959;Inherit;False;Layer3_Hight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-4577.964,2053.793;Inherit;False;63;Layer1_Hight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-4580.799,2166.744;Inherit;False;64;Layer2_Hight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-4579.621,2292.818;Inherit;False;78;Layer3_Hight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;-4363.497,2070.141;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;139;-4358.938,2192.268;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;92;-4148.883,2162.367;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;-4364.635,2308.036;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-4162.978,2487.714;Inherit;False;Property;_BlendContrast;BlendContrast;1;0;Create;True;0;0;False;0;False;0.1;0.221;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;93;-4027.87,2301.279;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;-3865.604,2441.616;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;98;-3548.106,2450.561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;-3542.551,2210.206;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;97;-3546.532,2331.084;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;100;-3379.901,2332.81;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;101;-3379.901,2452.81;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;99;-3382.901,2209.81;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-3152.977,2431.229;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;102;-3104.452,2216.955;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;105;-2930.505,2317.652;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-2646.262,2263.996;Inherit;False;BlendWeight;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;43;-4508.421,-350.5919;Inherit;False;1460.321;475.2942;Roughness;10;47;70;46;45;125;124;120;121;122;123;Roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;80;-1674.535,2836.555;Inherit;True;Property;_Layer3_Normal;Layer3_Normal;14;0;Create;True;0;0;False;0;False;-1;None;89d6c2224216fb946bee887158295aff;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-1700.297,1762.908;Inherit;True;Property;_Layer2_Normal;Layer2_Normal;9;0;Create;True;0;0;False;0;False;-1;None;f47a244b8364527449c8fc7e543f94ec;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1709.752,666.6296;Inherit;True;Property;_Layer1_Normal;Layer1_Normal;4;0;Create;True;0;0;False;0;False;-1;None;fce6684ca0f1ff14a8c4e053502a2446;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1325.21,481.0392;Inherit;False;Layer1_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1689.981,189.7844;Inherit;True;Property;_Layer1_BaseColor;Layer1_BaseColor;3;0;Create;True;0;0;False;0;False;-1;None;bb5f74724d5285a468f807fa0760cb71;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;55;-4509.73,691.2383;Inherit;False;1461.724;462.7566;Normal;10;60;57;59;72;132;133;134;135;136;137;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-4522.609,-950.1364;Inherit;False;1462.174;467.2252;Base_Color;10;41;119;116;115;114;69;38;37;113;112;Base_Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1315.754,1568.317;Inherit;False;Layer2_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-4478.766,-184.278;Inherit;False;90;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-1285.948,2643.869;Inherit;False;Layer3_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;79;-1682.763,2353.109;Inherit;True;Property;_Layer3_BaseColor;Layer3_BaseColor;13;0;Create;True;0;0;False;0;False;-1;None;d5fdf13a7bd401e40b1311f608061a23;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-1707.525,1277.462;Inherit;True;Property;_Layer2_BaseColor;Layer2_BaseColor;8;0;Create;True;0;0;False;0;False;-1;None;46e9508dc3b26e24db8709700ffe09e5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;49;-4507.157,175.4532;Inherit;False;1456.339;477.3564;AO;4;54;71;53;51;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-1268.992,2721.964;Inherit;False;Layer3_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1297.724,1765.666;Inherit;False;Layer2_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-3912.313,-36.9467;Inherit;False;81;Layer3_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1316.564,220.8102;Inherit;False;Layer1_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-3919.103,-298.3336;Inherit;False;16;Layer1_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;124;-4245.217,-177.5572;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1294.754,1648.317;Inherit;False;Layer2_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-1281.346,2390.735;Inherit;False;Layer3_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1307.108,1317.088;Inherit;False;Layer2_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-4482.577,844.7427;Inherit;False;90;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-4496.12,-741.2848;Inherit;False;90;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-1303.21,566.0392;Inherit;False;Layer1_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1307.18,669.3881;Inherit;False;Layer1_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-4481.749,351.266;Inherit;False;90;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-3912.849,-168.8624;Inherit;False;31;Layer2_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-1271.962,2839.313;Inherit;False;Layer3_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;130;-4248.2,357.9868;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;69;-3925.629,-624.4493;Inherit;False;84;Layer3_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-3881.678,242.538;Inherit;False;17;Layer1_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-3663.444,-17.2123;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-3884.935,732.9147;Inherit;False;15;Layer1_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-3878.841,860.2155;Inherit;False;34;Layer2_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-3661.738,-155.0016;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-3880.203,370.6107;Inherit;False;33;Layer2_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;136;-4249.027,851.4635;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;38;-3915.39,-763.4931;Inherit;False;35;Layer2_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-3665.531,-292.521;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;113;-4272.328,-767.2216;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;72;-3884.065,986.7697;Inherit;False;82;Layer3_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-3878.424,504.4856;Inherit;False;83;Layer3_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-3924.788,-897.5968;Inherit;False;14;Layer1_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-3664.718,380.5424;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-3665.549,874.0191;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-3693.664,-616.7696;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-3666.424,518.3317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-3404.677,-165.0736;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-3669.342,736.4997;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-3695.751,-892.0783;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-3667.255,1011.808;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-3668.511,243.023;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-3691.958,-754.5589;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-3259.956,-177.9806;Inherit;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-3434.897,-764.6309;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-3408.488,863.9471;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;-3407.657,370.4704;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-3263.327,-758.2423;Inherit;False;Base_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-3247.394,866.6869;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-805.2065,401.4162;Inherit;False;47;Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-3247.638,340.793;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-608.2065,405.4161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-634.6006,154.2122;Inherit;False;41;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;68;-4495.864,1246.538;Inherit;False;897.3374;433.9138;BlendFactor;5;66;62;40;65;67;BlendFactor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-623.0007,238.5122;Inherit;False;60;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-592.7937,324.4253;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-624.8007,491.4122;Inherit;False;54;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-4445.864,1472.227;Inherit;False;64;Layer2_Hight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-3836.529,1394.452;Inherit;False;BlendFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;40;-4427.079,1296.538;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomStandardSurface;1;-330.7887,243.0231;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;162;-5071.612,2181.406;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-5646.375,2186.264;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-4428.526,1564.452;Inherit;False;Property;_Float1;BlendContrast2;17;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;161;-5382.472,2171.692;Inherit;True;Property;_BlendMap;BlendMap;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;62;-4171.618,1403.46;Inherit;False;HeightLerp;-1;;10;906f35bed44319e49ab06a6a458c5346;0;3;4;FLOAT;0;False;1;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/MaterialBlend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;6;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;76;0;75;0
WireConnection;76;1;74;0
WireConnection;3;1;11;0
WireConnection;29;1;28;0
WireConnection;77;1;76;0
WireConnection;157;1;158;0
WireConnection;157;6;29;1
WireConnection;155;1;156;0
WireConnection;155;6;3;1
WireConnection;159;1;160;0
WireConnection;159;6;77;1
WireConnection;64;0;157;0
WireConnection;63;0;155;0
WireConnection;78;0;159;0
WireConnection;138;0;141;0
WireConnection;138;1;87;1
WireConnection;139;0;142;0
WireConnection;139;1;87;2
WireConnection;92;0;138;0
WireConnection;92;1;139;0
WireConnection;140;0;143;0
WireConnection;140;1;87;3
WireConnection;93;0;92;0
WireConnection;93;1;140;0
WireConnection;94;0;93;0
WireConnection;94;1;95;0
WireConnection;98;0;140;0
WireConnection;98;1;94;0
WireConnection;96;0;138;0
WireConnection;96;1;94;0
WireConnection;97;0;139;0
WireConnection;97;1;94;0
WireConnection;100;0;97;0
WireConnection;101;0;98;0
WireConnection;99;0;96;0
WireConnection;103;0;99;0
WireConnection;103;1;100;0
WireConnection;103;2;101;0
WireConnection;102;0;99;0
WireConnection;102;1;100;0
WireConnection;102;2;101;0
WireConnection;105;0;102;0
WireConnection;105;1;103;0
WireConnection;90;0;105;0
WireConnection;80;1;76;0
WireConnection;30;1;28;0
WireConnection;4;1;11;0
WireConnection;16;0;3;2
WireConnection;2;1;11;0
WireConnection;31;0;29;2
WireConnection;81;0;77;2
WireConnection;79;1;76;0
WireConnection;32;1;28;0
WireConnection;83;0;77;3
WireConnection;34;0;30;0
WireConnection;14;0;2;0
WireConnection;124;0;125;0
WireConnection;33;0;29;3
WireConnection;84;0;79;0
WireConnection;35;0;32;0
WireConnection;17;0;3;3
WireConnection;15;0;4;0
WireConnection;82;0;80;0
WireConnection;130;0;131;0
WireConnection;120;0;70;0
WireConnection;120;1;124;2
WireConnection;121;0;46;0
WireConnection;121;1;124;1
WireConnection;136;0;137;0
WireConnection;122;0;45;0
WireConnection;122;1;124;0
WireConnection;113;0;112;0
WireConnection;127;0;51;0
WireConnection;127;1;130;1
WireConnection;133;0;57;0
WireConnection;133;1;136;1
WireConnection;116;0;69;0
WireConnection;116;1;113;2
WireConnection;126;0;71;0
WireConnection;126;1;130;2
WireConnection;123;0;122;0
WireConnection;123;1;121;0
WireConnection;123;2;120;0
WireConnection;134;0;59;0
WireConnection;134;1;136;0
WireConnection;114;0;37;0
WireConnection;114;1;113;0
WireConnection;132;0;72;0
WireConnection;132;1;136;2
WireConnection;128;0;53;0
WireConnection;128;1;130;0
WireConnection;115;0;38;0
WireConnection;115;1;113;1
WireConnection;47;0;123;0
WireConnection;119;0;114;0
WireConnection;119;1;115;0
WireConnection;119;2;116;0
WireConnection;135;0;134;0
WireConnection;135;1;133;0
WireConnection;135;2;132;0
WireConnection;129;0;128;0
WireConnection;129;1;127;0
WireConnection;129;2;126;0
WireConnection;41;0;119;0
WireConnection;60;0;135;0
WireConnection;54;0;129;0
WireConnection;23;0;22;0
WireConnection;67;0;62;0
WireConnection;1;0;19;0
WireConnection;1;1;21;0
WireConnection;1;3;24;0
WireConnection;1;4;23;0
WireConnection;1;5;20;0
WireConnection;162;0;161;0
WireConnection;161;1;163;0
WireConnection;62;4;40;1
WireConnection;62;1;65;0
WireConnection;62;7;66;0
WireConnection;0;13;1;0
ASEEND*/
//CHKSM=6C306AD21867CC9CE7BDE3E8E8B2F4F122822FA4