// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Fog/Sky"
{
	Properties
	{
		_SkyHDR("SkyHDR", 2D) = "white" {}
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 0
		_FogHorizonStart("Fog Horizon Start", Range( -1 , 1)) = 0
		_FogHorizonEnd("Fog Horizon End", Range( -1 , 1)) = 700
		_SunFogColor("Sun Fog Color", Color) = (0,0,0,0)
		_SunFogRange("Sun Fog Range", Float) = 0
		_SunFogIntensity("Sun Fog Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			float3 worldPos;
		};

		uniform sampler2D _SkyHDR;
		uniform float4 _SkyHDR_ST;
		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		uniform float _SunFogRange;
		uniform float _SunFogIntensity;
		uniform float _FogHorizonEnd;
		uniform float _FogHorizonStart;
		uniform float _FogIntensity;


		float3 ACESTonemap45( float3 LinearColor )
		{
			float a = 2.51f;
			float b = 0.03f;
			float c = 2.43f;
			float d = 0.59f;
			float e = 0.14f;
			return
			saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e));
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv0_SkyHDR = i.uv_texcoord * _SkyHDR_ST.xy + _SkyHDR_ST.zw;
			float dotResult37 = dot( -i.viewDir , float3(0,0,1) );
			float clampResult28 = clamp( pow( (dotResult37*0.5 + 0.5) , _SunFogRange ) , 0.0 , 1.0 );
			float SunFog31 = ( clampResult28 * _SunFogIntensity );
			float4 lerpResult19 = lerp( _FogColor , _SunFogColor , SunFog31);
			float temp_output_11_0_g5 = _FogHorizonEnd;
			float3 ase_worldPos = i.worldPos;
			float3 objToWorld48 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 normalizeResult50 = normalize( ( ase_worldPos - objToWorld48 ) );
			float clampResult7_g5 = clamp( ( ( temp_output_11_0_g5 - (normalizeResult50).y ) / ( temp_output_11_0_g5 - _FogHorizonStart ) ) , 0.0 , 1.0 );
			float FogHight42 = ( 1.0 - ( 1.0 - clampResult7_g5 ) );
			float clampResult9 = clamp( ( FogHight42 * _FogIntensity ) , 0.0 , 1.0 );
			float4 lerpResult10 = lerp( tex2D( _SkyHDR, uv0_SkyHDR ) , lerpResult19 , clampResult9);
			float3 LinearColor45 = ( lerpResult10 * lerpResult10 ).rgb;
			float3 localACESTonemap45 = ACESTonemap45( LinearColor45 );
			o.Emission = sqrt( localACESTonemap45 );
			o.Alpha = 1;
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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Version=18100
395;249;1239;779;5757.814;1834.58;6.009177;True;False
Node;AmplifyShaderEditor.CommentaryNode;7;-4329.652,-154.3864;Inherit;False;2016.264;488.9303;Fog Horizon;11;34;42;41;39;36;35;51;50;49;48;47;Fog Horizon;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-4814.305,653.5443;Inherit;False;451.5728;238.0134;Sun Position;2;26;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-4331.627,445.4772;Inherit;False;1649.897;563.2485;Sun Fog;9;40;38;37;33;31;30;29;28;27;Sun Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-4249.633,-106.0734;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;48;-4271,115.0582;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;32;-4292.038,538.1851;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;52;-4544.974,716.3943;Inherit;False;Constant;_Vector1;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;33;-4089.684,545.2256;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-4008.202,12.50439;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;37;-3938.348,613.5804;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;50;-3836.461,14.47268;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3348.335,96.79366;Inherit;False;Property;_FogHorizonStart;Fog Horizon Start;4;0;Create;True;0;0;False;0;False;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3348.603,199.8365;Inherit;False;Property;_FogHorizonEnd;Fog Horizon End;5;0;Create;True;0;0;False;0;False;700;0.382;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;51;-3644.461,36.47267;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;38;-3772.348,616.5804;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-3867.661,771.1836;Inherit;False;Property;_SunFogRange;Sun Fog Range;7;0;Create;True;0;0;False;0;False;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;40;-3532.348,701.5807;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;39;-3070.153,3.013443;Inherit;False;Fog Linear;-1;;5;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-3397.031,881.9329;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;8;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;41;-2788.879,4.249527;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;28;-3354.348,726.5807;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-3099.132,804.3346;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;8;-1668.752,-19.36093;Inherit;False;922.4023;873.5225;Fog Combine;9;19;18;17;16;15;13;12;10;9;Fog Combine;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-2543.388,35.6116;Inherit;False;FogHight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-2883.783,854.8365;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-1368.174,629.6689;Inherit;False;42;FogHight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1389.508,768.0984;Inherit;False;Property;_FogIntensity;Fog Intensity;3;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-1618.752,223.8072;Inherit;False;Property;_SunFogColor;Sun Fog Color;6;0;Create;True;0;0;False;0;False;0,0,0,0;0.7264151,0.3929383,0.05825027,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1654.95,-327.665;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1102.721,670.3141;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-1527.476,409.7221;Inherit;False;31;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-1604.577,30.63906;Inherit;False;Property;_FogColor;FogColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;9;-937.0836,647.2087;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-1276.477,301.3221;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1362.111,-295.2425;Inherit;True;Property;_SkyHDR;SkyHDR;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;10;-928.3501,185.4965;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-578.8168,105.6711;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;45;-429.4142,117.5912;Inherit;False;float a = 2.51f@$float b = 0.03f@$float c = 2.43f@$float d = 0.59f@$float e = 0.14f@$return$saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e))@;3;False;1;True;LinearColor;FLOAT3;0,0,0;In;;Inherit;False;ACESTonemap;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;34;-3581.118,-104.3046;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SqrtOpNode;46;-208.097,122.8415;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;26;-4773.363,714.745;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;294,-44;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Fog/Sky;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;32;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;37;0;33;0
WireConnection;37;1;52;0
WireConnection;50;0;49;0
WireConnection;51;0;50;0
WireConnection;38;0;37;0
WireConnection;40;0;38;0
WireConnection;40;1;27;0
WireConnection;39;13;51;0
WireConnection;39;12;35;0
WireConnection;39;11;36;0
WireConnection;41;0;39;0
WireConnection;28;0;40;0
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;42;0;41;0
WireConnection;31;0;30;0
WireConnection;18;0;12;0
WireConnection;18;1;13;0
WireConnection;9;0;18;0
WireConnection;19;0;15;0
WireConnection;19;1;16;0
WireConnection;19;2;17;0
WireConnection;3;1;4;0
WireConnection;10;0;3;0
WireConnection;10;1;19;0
WireConnection;10;2;9;0
WireConnection;44;0;10;0
WireConnection;44;1;10;0
WireConnection;45;0;44;0
WireConnection;46;0;45;0
WireConnection;2;2;46;0
ASEEND*/
//CHKSM=E26C332EAE4D226F6E34FE39D10A28CBF8DFE963