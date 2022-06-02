// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Transport"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.9
		[HDR]_EmissColor("EmissColor", Color) = (0,0,0,0)
		_EmissPos("EmissPos", Float) = 0.5
		_EmissSoft("EmissSoft", Float) = 0.5
		_Transport("Transport", Float) = 0
		_WarpDir("WarpDir", Vector) = (0,0,0,0)
		_SlashMax("SlashMax", Float) = 0
		_MaxRange("MaxRange", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_NoiseSmoothstep("NoiseSmoothstep", Vector) = (0,0.5,0,0)
		_MaskMul("MaskMul", Float) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 0.5
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
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

		uniform float _SlashMax;
		uniform float _Transport;
		uniform float _MaxRange;
		uniform float3 _WarpDir;
		uniform float2 _NoiseSmoothstep;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _MaskMul;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _EmissPos;
		uniform float _EmissSoft;
		uniform float4 _EmissColor;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.9;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float smoothstepResult22 = smoothstep( 0.0 , _SlashMax , ( ase_vertex3Pos.z + _Transport ));
			float clampResult19 = clamp( smoothstepResult22 , 0.0 , _MaxRange );
			float WarpRange38 = clampResult19;
			float3 VertexOffset54 = ( WarpRange38 * _WarpDir );
			v.vertex.xyz += VertexOffset54;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult22 = smoothstep( 0.0 , _SlashMax , ( ase_vertex3Pos.z + _Transport ));
			float clampResult19 = clamp( smoothstepResult22 , 0.0 , _MaxRange );
			float WarpRange38 = clampResult19;
			float temp_output_112_0 = ( 1.0 - WarpRange38 );
			float smoothstepResult121 = smoothstep( _NoiseSmoothstep.x , _NoiseSmoothstep.y , temp_output_112_0);
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float Nosie42 = tex2D( _Noise, uv_Noise ).r;
			float Opacity47 = ( smoothstepResult121 + ( temp_output_112_0 * Nosie42 * _MaskMul ) );
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			s1.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			float3 ase_worldNormal = i.worldNormal;
			s1.Normal = ase_worldNormal;
			float smoothstepResult116 = smoothstep( _EmissPos , ( _EmissPos + _EmissSoft ) , WarpRange38);
			s1.Emission = ( smoothstepResult116 * _EmissColor ).rgb;
			s1.Metallic = _Metallic;
			s1.Smoothness = _Smoothness;
			s1.Occlusion = 1.0;

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
			float3 BaseColor49 = surfResult1;
			c.rgb = BaseColor49;
			c.a = 1;
			clip( Opacity47 - _Cutoff );
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
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
Version=18935
-948;189;1403;777;1756.672;-1169.966;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;39;-3387.988,284.0007;Inherit;False;1869.876;746.96;Comment;8;38;11;14;10;22;20;19;111;WarpRange;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-3280.52,632.6014;Inherit;False;Property;_Transport;Transport;4;0;Create;True;0;0;0;False;0;False;0;-0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;14;-3323.452,424.5014;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-3052.244,495.4388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-3017.843,681.3217;Inherit;False;Property;_SlashMax;SlashMax;6;0;Create;True;0;0;0;False;0;False;0;-10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2591.204,724.9686;Inherit;False;Property;_MaxRange;MaxRange;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-2777.083,496.8718;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;43;-3387.878,-308.5733;Inherit;False;849.6466;280;Comment;3;36;33;42;Nosie;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;19;-2286.512,502.0789;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3337.878,-234.1783;Inherit;False;0;33;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-3081.232,-258.5733;Inherit;True;Property;_Noise;Noise;9;0;Create;True;0;0;0;False;0;False;-1;None;e90b7c601b496114cb282bcf156c9211;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-2076.335,495.6436;Inherit;False;WarpRange;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1640.991,1427.749;Inherit;False;1922.867;680.8029;Comment;9;47;41;79;112;113;114;120;121;122;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1380.877,432.8796;Inherit;False;Property;_EmissSoft;EmissSoft;3;0;Create;True;0;0;0;False;0;False;0.5;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-1377.877,321.8796;Inherit;False;Property;_EmissPos;EmissPos;2;0;Create;True;0;0;0;False;0;False;0.5;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1318.726,244.0158;Inherit;False;38;WarpRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;-1187.877,393.8796;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-2762.232,-233.5108;Inherit;False;Nosie;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-1581.995,1518.76;Inherit;True;38;WarpRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;122;-1366.672,1621.966;Inherit;False;Property;_NoiseSmoothstep;NoiseSmoothstep;10;0;Create;True;0;0;0;False;0;False;0,0.5;0.35,1.11;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;7;-1028.258,475.4443;Inherit;False;Property;_EmissColor;EmissColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,6.70157,16,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;120;-1286.796,1833.622;Inherit;False;Property;_MaskMul;MaskMul;11;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-1549.979,1724.641;Inherit;False;42;Nosie;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;112;-1320.017,1525.439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;116;-1038.991,281.9998;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-3268.118,1408.988;Inherit;False;1357.741;1047.276;Comment;5;54;110;52;12;44;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-2957.751,1651.263;Inherit;False;38;WarpRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-795.9921,-329.1523;Inherit;True;Property;_MainTex;MainTex;8;0;Create;True;0;0;0;False;0;False;-1;None;c795d115b91d6e44487d6889282c451f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-774.7747,27.74273;Inherit;False;Property;_Metallic;Metallic;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-773.0854,127.1017;Inherit;False;Property;_Smoothness;Smoothness;13;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-763.7243,245.4635;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;12;-3039.485,1803.823;Inherit;False;Property;_WarpDir;WarpDir;5;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,-70;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-1122.907,1705.916;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;121;-1082.672,1527.966;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-2640.193,1663.406;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomStandardSurface;1;-326.5377,16.15318;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;-814.6732,1534.899;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-476.6553,1529.214;Inherit;True;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-71.47131,11.43665;Inherit;False;BaseColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-2451.742,1671.475;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-181.9631,437.4012;Inherit;False;47;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-180.4447,532.5889;Inherit;False;49;BaseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-2927.87,2073.536;Inherit;False;42;Nosie;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-172.0529,294.325;Inherit;False;38;WarpRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2511.372,2057.456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-201.0774,660.0054;Inherit;False;54;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;212.642,275.212;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;Whl/Transport;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.9;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;3.6;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;14;3
WireConnection;11;1;10;0
WireConnection;22;0;11;0
WireConnection;22;2;111;0
WireConnection;19;0;22;0
WireConnection;19;2;20;0
WireConnection;33;1;36;0
WireConnection;38;0;19;0
WireConnection;118;0;117;0
WireConnection;118;1;119;0
WireConnection;42;0;33;1
WireConnection;112;0;41;0
WireConnection;116;0;51;0
WireConnection;116;1;117;0
WireConnection;116;2;118;0
WireConnection;37;0;116;0
WireConnection;37;1;7;0
WireConnection;113;0;112;0
WireConnection;113;1;79;0
WireConnection;113;2;120;0
WireConnection;121;0;112;0
WireConnection;121;1;122;1
WireConnection;121;2;122;2
WireConnection;110;0;52;0
WireConnection;110;1;12;0
WireConnection;1;0;2;0
WireConnection;1;2;37;0
WireConnection;1;3;3;0
WireConnection;1;4;4;0
WireConnection;114;0;121;0
WireConnection;114;1;113;0
WireConnection;47;0;114;0
WireConnection;49;0;1;0
WireConnection;54;0;110;0
WireConnection;35;1;44;0
WireConnection;0;10;48;0
WireConnection;0;13;50;0
WireConnection;0;11;55;0
ASEEND*/
//CHKSM=D64905482E60C244DF63A81EC13E839CC35DFF2C