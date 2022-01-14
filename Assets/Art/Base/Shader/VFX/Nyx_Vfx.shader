// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Nyx_Vfx"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (1,0.7450981,0.4470589,1)
		_EmissMap("EmissMap", 2D) = "white" {}
		_FlowSpeed("FlowSpeed", Vector) = (0,0,0,0)
		_EmissIntensity("EmissIntensity", Float) = 5
		_NoiseMap("NoiseMap", 2D) = "white" {}
		_NoiseSpeed("NoiseSpeed", Vector) = (0,0,0,0)
		_NoiseIntensity("NoiseIntensity", Float) = 0
		_FadePower("FadePower", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _BaseColor;
		uniform sampler2D _EmissMap;
		uniform float2 _FlowSpeed;
		uniform sampler2D _NoiseMap;
		uniform float4 _NoiseMap_ST;
		uniform float2 _NoiseSpeed;
		uniform float _NoiseIntensity;
		uniform float _FadePower;
		uniform float _EmissIntensity;
		SamplerState sampler_EmissMap;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_NoiseMap = i.uv_texcoord * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
			float2 panner3 = ( 1.0 * _Time.y * _FlowSpeed + uv_NoiseMap);
			float2 panner21 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float smoothstepResult19 = smoothstep( 0.0 , 0.3 , ( 1.0 - abs( (i.uv_texcoord.x*2.0 + -1.0) ) ));
			float clampResult36 = clamp( pow( ( 1.0 - i.uv_texcoord.y ) , _FadePower ) , 0.0 , 1.0 );
			float FadeMask28 = ( smoothstepResult19 * clampResult36 );
			float4 tex2DNode2 = tex2D( _EmissMap, ( panner3 + ( (tex2D( _NoiseMap, panner21 )).rg * _NoiseIntensity * ( 1.0 - FadeMask28 ) ) ) );
			o.Emission = ( _BaseColor * ( tex2DNode2 * _EmissIntensity ) ).rgb;
			float clampResult8 = clamp( ( tex2DNode2.r * _EmissIntensity ) , 0.0 , 1.0 );
			o.Alpha = ( clampResult8 * FadeMask28 );
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
Version=18500
-1612;4;1603;996;3993.951;387.0096;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;33;-3108.927,680.9991;Inherit;False;1659.569;525.8116;FadeMask;11;28;18;19;12;17;16;15;11;34;35;36;FadeMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-3058.927,807.0693;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;15;-2745.202,751.5382;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2763.358,1038.842;Inherit;False;Property;_FadePower;FadePower;8;0;Create;True;0;0;False;0;False;2;2.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-2753.56,920.6473;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;16;-2544.203,733.5382;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;34;-2562.358,959.8423;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-2407.832,730.9991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;-2243.94,749.9662;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;36;-2283.358,950.8423;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2027.963,824.1893;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-4263.467,436.0732;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;6;0;Create;True;0;0;False;0;False;0,0;0.1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-4349.913,280.0037;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-1853.545,819.4572;Inherit;False;FadeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-4012.768,394.2108;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-3646.101,592.0085;Inherit;False;28;FadeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-3807.753,366.2321;Inherit;True;Property;_NoiseMap;NoiseMap;5;0;Create;True;0;0;False;0;False;-1;None;c0ac9065d45f20643bc9bc09c13f5303;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-3682.391,52.46373;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;4;-3612.219,215.8143;Inherit;False;Property;_FlowSpeed;FlowSpeed;3;0;Create;True;0;0;False;0;False;0,0;0.1,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;25;-3468.958,455.2187;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;7;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;-3438.604,548.8216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;23;-3425.958,364.4487;Inherit;False;FLOAT2;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;3;-3311.092,153.7302;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-3196.437,370.3376;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2885.854,222.0155;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2532.918,410.3875;Inherit;False;Property;_EmissIntensity;EmissIntensity;4;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2714.962,187.878;Inherit;True;Property;_EmissMap;EmissMap;2;0;Create;True;0;0;False;0;False;-1;None;03e1255974fad344581f085cf78efac8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2029.336,381.1952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;8;-1881.515,407.2109;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1915.74,545.1088;Inherit;False;28;FadeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-2086.796,-32.65163;Inherit;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;False;0;False;1,0.7450981,0.4470589,1;0.7122642,0.8562571,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-2191.992,189.2103;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1702.251,416.1908;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1666.576,62.24393;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1391.112,234.2404;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Nyx_Vfx;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;11;1
WireConnection;12;0;11;2
WireConnection;16;0;15;0
WireConnection;34;0;12;0
WireConnection;34;1;35;0
WireConnection;17;0;16;0
WireConnection;19;0;17;0
WireConnection;36;0;34;0
WireConnection;18;0;19;0
WireConnection;18;1;36;0
WireConnection;28;0;18;0
WireConnection;21;0;22;0
WireConnection;21;2;27;0
WireConnection;20;1;21;0
WireConnection;30;0;29;0
WireConnection;23;0;20;0
WireConnection;3;0;1;0
WireConnection;3;2;4;0
WireConnection;24;0;23;0
WireConnection;24;1;25;0
WireConnection;24;2;30;0
WireConnection;26;0;3;0
WireConnection;26;1;24;0
WireConnection;2;1;26;0
WireConnection;7;0;2;1
WireConnection;7;1;6;0
WireConnection;8;0;7;0
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;13;0;8;0
WireConnection;13;1;32;0
WireConnection;9;0;10;0
WireConnection;9;1;5;0
WireConnection;0;2;9;0
WireConnection;0;9;13;0
ASEEND*/
//CHKSM=89D36128F09ADC9568070292D5FE9072A04C5128