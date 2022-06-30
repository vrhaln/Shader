// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Blood"
{
	Properties
	{
		_Blood_1("Blood_1", 2D) = "white" {}
		_Blood_1_Normal("Blood_1_Normal", 2D) = "white" {}
		_Emission("Emission", Float) = 1
		_Metallic("Metallic", Float) = 1
		_Smoothness("Smoothness", Float) = 1
		_Dissolve("Dissolve", Range( 0 , 1)) = 0.66
		_Max("Max", Float) = 1
		_Niose("Niose", 2D) = "white" {}
		_NormalStr("NormalStr", Float) = 31.37
		_Noise2Offset("Noise2Offset", Float) = 0.19
		_FlowNoise("FlowNoise", 2D) = "white" {}
		_buchong("buchong", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform sampler2D _Blood_1;
		uniform float4 _Blood_1_ST;
		uniform float _Dissolve;
		uniform float _buchong;
		uniform sampler2D _Niose;
		uniform float4 _Niose_ST;
		uniform float _Noise2Offset;
		uniform float _Max;
		uniform float _NormalStr;
		uniform sampler2D _FlowNoise;
		uniform sampler2D _Blood_1_Normal;
		uniform float4 _Blood_1_Normal_ST;
		uniform float _Emission;
		uniform float _Metallic;
		uniform float _Smoothness;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_Blood_1 = i.uv_texcoord * _Blood_1_ST.xy + _Blood_1_ST.zw;
			float4 tex2DNode1 = tex2D( _Blood_1, uv_Blood_1 );
			float2 uv_Niose = i.uv_texcoord * _Niose_ST.xy + _Niose_ST.zw;
			float4 tex2DNode20 = tex2D( _Niose, uv_Niose );
			float2 uv0_Niose = i.uv_texcoord * _Niose_ST.xy + _Niose_ST.zw;
			float2 break23 = uv0_Niose;
			float temp_output_17_0 = ( _Noise2Offset * -0.1 );
			float2 appendResult24 = (float2(( break23.x + temp_output_17_0 ) , break23.y));
			float4 tex2DNode19 = tex2D( _Niose, appendResult24 );
			float2 appendResult21 = (float2(break23.x , ( break23.y + temp_output_17_0 )));
			float4 tex2DNode18 = tex2D( _Niose, appendResult21 );
			SurfaceOutputStandard s8 = (SurfaceOutputStandard ) 0;
			s8.Albedo = tex2DNode1.rgb;
			float smoothstepResult27 = smoothstep( _Dissolve , _Max , tex2DNode20.r);
			float smoothstepResult28 = smoothstep( _Dissolve , _Max , tex2DNode19.r);
			float2 panner62 = ( 1.0 * _Time.y * float2( 0.1,0.1 ) + i.uv_texcoord);
			float4 tex2DNode61 = tex2D( _FlowNoise, panner62 );
			float3 appendResult37 = (float3(1.0 , 0.0 , ( ( ( smoothstepResult27 - smoothstepResult28 ) * _NormalStr ) * tex2DNode61.r )));
			float smoothstepResult29 = smoothstep( _Dissolve , _Max , tex2DNode18.r);
			float3 appendResult38 = (float3(0.0 , 1.0 , ( ( ( smoothstepResult27 - smoothstepResult29 ) * _NormalStr ) * tex2DNode61.r )));
			float3 normalizeResult40 = normalize( cross( appendResult37 , appendResult38 ) );
			float2 uv_Blood_1_Normal = i.uv_texcoord * _Blood_1_Normal_ST.xy + _Blood_1_Normal_ST.zw;
			float3 Normal42 = BlendNormals( normalizeResult40 , tex2D( _Blood_1_Normal, uv_Blood_1_Normal ).rgb );
			s8.Normal = WorldNormalVector( i , Normal42 );
			float3 temp_cast_2 = (_Emission).xxx;
			s8.Emission = temp_cast_2;
			s8.Metallic = _Metallic;
			s8.Smoothness = _Smoothness;
			s8.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi8 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g8 = UnityGlossyEnvironmentSetup( s8.Smoothness, data.worldViewDir, s8.Normal, float3(0,0,0));
			gi8 = UnityGlobalIllumination( data, s8.Occlusion, s8.Normal, g8 );
			#endif

			float3 surfResult8 = LightingStandard ( s8, viewDir, gi8 ).rgb;
			surfResult8 += s8.Emission;

			#ifdef UNITY_PASS_FORWARDADD//8
			surfResult8 -= s8.Emission;
			#endif//8
			c.rgb = surfResult8;
			c.a = ( tex2DNode1.a * saturate( ( step( ( _Dissolve - _buchong ) , tex2DNode20.r ) + step( _Dissolve , tex2DNode19.r ) + step( _Dissolve , tex2DNode18.r ) ) ) );
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
-1887;22;1562;917;-895.327;-957.2219;1.35885;True;True
Node;AmplifyShaderEditor.RangedFloatNode;44;-2403.003,1627.718;Inherit;False;Property;_Noise2Offset;Noise2Offset;11;0;Create;True;0;0;False;0;False;0.19;0.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-2555.041,1379.24;Inherit;False;0;26;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleNode;17;-2204.357,1632.214;Inherit;False;-0.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;23;-2331.665,1416.614;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1877.82,1690.37;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1878.859,1505.558;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1675.699,1483.353;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;26;-1789.202,1070.277;Inherit;True;Property;_Niose;Niose;9;0;Create;True;0;0;False;0;False;None;d94f22923bffd924788dc486ca1218af;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1679.224,1636.023;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;19;-1457.868,1341.047;Inherit;True;Property;_TextureSample4;Texture Sample 4;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1447.978,1652.528;Inherit;True;Property;_TextureSample3;Texture Sample 3;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-941.8468,1254.382;Inherit;False;Property;_Max;Max;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1456.568,1059.024;Inherit;True;Property;_TextureSample5;Texture Sample 5;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1635.804,2289.528;Inherit;False;Property;_Dissolve;Dissolve;7;0;Create;True;0;0;False;0;False;0.66;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;27;-363.1339,1083.238;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;64;-530.7571,909.2727;Inherit;False;Constant;_Vector0;Vector 0;13;0;Create;True;0;0;False;0;False;0.1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-571.5568,636.0728;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;28;-354.5253,1359.363;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;29;-357.9334,1642.193;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;187.8279,1214.38;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;207.4555,1457.231;Inherit;False;Property;_NormalStr;NormalStr;10;0;Create;True;0;0;False;0;False;31.37;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;62;-206.2572,827.1729;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;216.3723,1687.056;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;446.6101,881.3886;Inherit;True;Property;_FlowNoise;FlowNoise;12;0;Create;True;0;0;False;0;False;-1;None;bd1c52d775c09284eb17c646f4981cf0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;576.0673,1254.317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;597.1956,1536.506;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;900.2025,1549.057;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;892.699,1247.048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;1183.762,1553.815;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;1182.446,1287.24;Inherit;True;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-692.2985,2209.888;Inherit;False;Property;_buchong;buchong;13;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;39;1440.023,1410.508;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;51;-449.079,2075.4;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;1678.031,1671.34;Inherit;True;Property;_Blood_1_Normal;Blood_1_Normal;2;0;Create;True;0;0;False;0;False;-1;9eb2bc48408cd5a428890f4a6bb55d4b;31477b8d68952c640909f88da960d4f1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;40;1721.75,1417.034;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;41;2035.957,1554.322;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;48;-223.1817,2431.281;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;47;-229.0449,2267.427;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;46;-231.4994,2091.746;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;2373.064,1546.811;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;88.82694,2215.907;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-724.7993,75.86967;Inherit;False;Property;_Emission;Emission;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;50;336.3314,2224.858;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-215.8522,235.2782;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-817.2753,312.666;Inherit;True;Property;_Blood_1;Blood_1;1;0;Create;True;0;0;False;0;False;-1;2b6335e37f8821545827870712d50445;2b6335e37f8821545827870712d50445;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;43;-313.0393,-63.36839;Inherit;False;42;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-209.7505,481.3096;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;False;1;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;1458.819,1722.779;Inherit;False;Property;_NormalScale;NormalScale;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;-2070.967,1812.344;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;505.0465,447.8065;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;8;30.71238,118.03;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;16;-2500.548,1691.288;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;861.7014,174.1953;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Blood;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;44;0
WireConnection;23;0;25;0
WireConnection;15;0;23;1
WireConnection;15;1;17;0
WireConnection;22;0;23;0
WireConnection;22;1;17;0
WireConnection;24;0;22;0
WireConnection;24;1;23;1
WireConnection;21;0;23;0
WireConnection;21;1;15;0
WireConnection;19;0;26;0
WireConnection;19;1;24;0
WireConnection;18;0;26;0
WireConnection;18;1;21;0
WireConnection;20;0;26;0
WireConnection;27;0;20;1
WireConnection;27;1;11;0
WireConnection;27;2;12;0
WireConnection;28;0;19;1
WireConnection;28;1;11;0
WireConnection;28;2;12;0
WireConnection;29;0;18;1
WireConnection;29;1;11;0
WireConnection;29;2;12;0
WireConnection;32;0;27;0
WireConnection;32;1;28;0
WireConnection;62;0;63;0
WireConnection;62;2;64;0
WireConnection;33;0;27;0
WireConnection;33;1;29;0
WireConnection;61;1;62;0
WireConnection;34;0;32;0
WireConnection;34;1;35;0
WireConnection;36;0;33;0
WireConnection;36;1;35;0
WireConnection;66;0;36;0
WireConnection;66;1;61;1
WireConnection;65;0;34;0
WireConnection;65;1;61;1
WireConnection;38;2;66;0
WireConnection;37;2;65;0
WireConnection;39;0;37;0
WireConnection;39;1;38;0
WireConnection;51;0;11;0
WireConnection;51;1;52;0
WireConnection;40;0;39;0
WireConnection;41;0;40;0
WireConnection;41;1;2;0
WireConnection;48;0;11;0
WireConnection;48;1;18;1
WireConnection;47;0;11;0
WireConnection;47;1;19;1
WireConnection;46;0;51;0
WireConnection;46;1;20;1
WireConnection;42;0;41;0
WireConnection;49;0;46;0
WireConnection;49;1;47;0
WireConnection;49;2;48;0
WireConnection;50;0;49;0
WireConnection;13;0;1;4
WireConnection;13;1;50;0
WireConnection;8;0;1;0
WireConnection;8;1;43;0
WireConnection;8;2;4;0
WireConnection;8;3;5;0
WireConnection;8;4;6;0
WireConnection;0;9;13;0
WireConnection;0;13;8;0
ASEEND*/
//CHKSM=DB0FF3711CDA17029E1B9E572EF9C95C76344EB3