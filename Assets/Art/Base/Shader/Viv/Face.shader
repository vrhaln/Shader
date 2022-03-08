// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Face"
{
	Properties
	{
		_PixStr("PixStr", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,1)
		_EmissionTex("EmissionTex", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,1)
		_MainEmisStr("MainEmisStr", Range( 0 , 3)) = 1
		_SmoothnessTex("SmoothnessTex", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HDR]_FreColor("FreColor", Color) = (1,1,1,1)
		_Fre("Fre", Vector) = (0,1.1,1.1,0)
		_FreStr("FreStr", Float) = 0
		_ScanTex("ScanTex", 2D) = "white" {}
		_ScanTexTiling1("ScanTexTiling1", Vector) = (1,1,0,0)
		_RChannelPanner("RChannelPanner", Vector) = (0,0,1,0)
		_ScanTexTiling2("ScanTexTiling2", Vector) = (1,1,0,0)
		_RChannelPanner2("RChannelPanner2", Vector) = (0,0,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float2 uv_texcoord;
			float3 worldPos;
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

		uniform sampler2D _MainTex;
		uniform float _PixStr;
		uniform float4 _MainColor;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionColor;
		uniform sampler2D _ScanTex;
		uniform float3 _RChannelPanner2;
		uniform float2 _ScanTexTiling2;
		uniform float3 _Fre;
		uniform float _FreStr;
		uniform float4 _FreColor;
		uniform float3 _RChannelPanner;
		uniform float2 _ScanTexTiling1;
		uniform float _MainEmisStr;
		uniform float _Metallic;
		uniform sampler2D _SmoothnessTex;
		uniform float4 _SmoothnessTex_ST;
		uniform float _Smoothness;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s2 = (SurfaceOutputStandard ) 0;
			float2 temp_cast_0 = (0.5).xx;
			float temp_output_53_0 = ( _PixStr * 10.0 );
			float2 PixUV63 = ( ( ceil( ( ( i.uv_texcoord - temp_cast_0 ) * temp_output_53_0 ) ) / temp_output_53_0 ) + 0.5 );
			float4 MainColor61 = ( tex2D( _MainTex, PixUV63 ) * _MainColor );
			s2.Albedo = MainColor61.rgb;
			float3 ase_worldNormal = i.worldNormal;
			s2.Normal = ase_worldNormal;
			float mulTime37 = _Time.y * _RChannelPanner2.z;
			float2 appendResult38 = (float2(_RChannelPanner2.x , _RChannelPanner2.y));
			float2 uv_TexCoord39 = i.uv_texcoord * _ScanTexTiling2;
			float2 panner40 = ( mulTime37 * appendResult38 + uv_TexCoord39);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV14 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode14 = ( 0.0 + _Fre.y * pow( 1.0 - fresnelNdotV14, _Fre.z ) );
			float mulTime29 = _Time.y * _RChannelPanner.z;
			float2 appendResult30 = (float2(_RChannelPanner.x , _RChannelPanner.y));
			float2 uv_TexCoord31 = i.uv_texcoord * _ScanTexTiling1;
			float2 panner32 = ( mulTime29 * appendResult30 + uv_TexCoord31);
			s2.Emission = ( ( ( ( tex2D( _EmissionTex, PixUV63 ) * _EmissionColor * MainColor61 ) * tex2D( _ScanTex, panner40 ).r ) + ( ( max( ( 1.0 - fresnelNode14 ) , 0.0 ) * _FreStr ) * _FreColor * tex2D( _ScanTex, panner32 ).r ) ) * _MainEmisStr ).rgb;
			s2.Metallic = _Metallic;
			float2 uv_SmoothnessTex = i.uv_texcoord * _SmoothnessTex_ST.xy + _SmoothnessTex_ST.zw;
			s2.Smoothness = ( tex2D( _SmoothnessTex, uv_SmoothnessTex ).r * _Smoothness );
			s2.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi2 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g2 = UnityGlossyEnvironmentSetup( s2.Smoothness, data.worldViewDir, s2.Normal, float3(0,0,0));
			gi2 = UnityGlobalIllumination( data, s2.Occlusion, s2.Normal, g2 );
			#endif

			float3 surfResult2 = LightingStandard ( s2, viewDir, gi2 ).rgb;
			surfResult2 += s2.Emission;

			#ifdef UNITY_PASS_FORWARDADD//2
			surfResult2 -= s2.Emission;
			#endif//2
			c.rgb = surfResult2;
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
174;297;1278;769;5065.396;1375.271;4.820611;True;False
Node;AmplifyShaderEditor.RangedFloatNode;48;-4245.073,519.9219;Inherit;False;Property;_PixStr;PixStr;0;0;Create;True;0;0;0;False;0;False;1;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-4325.768,421.878;Inherit;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-4395.576,249.5184;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;-4104.259,252.8186;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-4072.342,516.3659;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-3938.177,252.6487;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CeilOpNode;50;-3804.792,256.4548;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-3666.535,261.1896;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-3480.401,77.60942;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-3318.063,64.05308;Inherit;False;PixUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-1460.145,-135.4229;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;17;-3006.542,730.1194;Inherit;False;Property;_Fre;Fre;10;0;Create;True;0;0;0;False;0;False;0,1.1,1.1;0,0.7,0.6;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;3;-941.4308,98.62112;Inherit;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.65,0.65,0.65,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1089.979,-172.8191;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;48338c4cfecbfc64e90e054e5ecf8dd2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;28;-3326.353,1250.4;Inherit;False;Property;_RChannelPanner;RChannelPanner;14;0;Create;True;0;0;0;False;0;False;0,0,1;0,2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;44;-3108.872,1463.987;Inherit;False;Property;_ScanTexTiling2;ScanTexTiling2;15;0;Create;True;0;0;0;False;0;False;1,1;1,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;45;-3140.173,1128.868;Inherit;False;Property;_ScanTexTiling1;ScanTexTiling1;13;0;Create;True;0;0;0;False;0;False;1,1;1,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FresnelNode;14;-2784.653,659.7991;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;36;-2970.636,1619.697;Inherit;False;Property;_RChannelPanner2;RChannelPanner2;16;0;Create;True;0;0;0;False;0;False;0,0,1;0,50,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-691.0306,-27.92164;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2984.335,9.785461;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-3120.351,1267.8;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-2778.636,1619.697;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;24;-2440.79,706.1321;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-2775.151,1376;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;37;-2778.636,1715.697;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2795.235,1468.297;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2919.151,1136;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-443.3913,-60.31079;Inherit;False;MainColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2405.973,1001.839;Inherit;False;Property;_FreStr;FreStr;11;0;Create;True;0;0;0;False;0;False;0;1.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;40;-2569.336,1587.697;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-2660.856,18.59581;Inherit;True;Property;_EmissionTex;EmissionTex;3;0;Create;True;0;0;0;False;0;False;-1;None;e686a5c859f3a5a438c7390d44a54f76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;32;-2567.151,1248;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;6;-2607.071,225.2306;Inherit;False;Property;_EmissionColor;EmissionColor;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;60;-2583.104,433.5125;Inherit;False;61;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;20;-2248.262,711.8146;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-2110.767,877.4109;Inherit;False;Property;_FreColor;FreColor;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0,0.4245283,0.2020447,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-2196.01,1210.331;Inherit;True;Property;_ScanTex;ScanTex;12;0;Create;True;0;0;0;False;0;False;-1;None;4ce5c6694c9418847bb143ef1b41b417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-2184.65,1554.134;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;fd67039a540e4ae43878e96bc497d2d5;True;0;False;black;Auto;False;Instance;33;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2085.7,215.8664;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2093.214,715.8674;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1775.882,825.0734;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1482.999,616.2016;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1287.203,899.5739;Inherit;False;Property;_MainEmisStr;MainEmisStr;5;0;Create;True;0;0;0;False;0;False;1;1.04;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1084.347,793.5586;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-281.3554,1097.968;Inherit;True;Property;_SmoothnessTex;SmoothnessTex;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-249.7024,1298.744;Inherit;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;65.8488,1138.152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-194.6712,374.8385;Inherit;False;61;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-893.8235,806.6049;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-271.5093,966.403;Inherit;False;Property;_Metallic;Metallic;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;2;82.15449,413.9594;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;491.2073,159.5795;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Face;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;52;0
WireConnection;54;1;55;0
WireConnection;53;0;48;0
WireConnection;49;0;54;0
WireConnection;49;1;53;0
WireConnection;50;0;49;0
WireConnection;51;0;50;0
WireConnection;51;1;53;0
WireConnection;56;0;51;0
WireConnection;56;1;55;0
WireConnection;63;0;56;0
WireConnection;1;1;65;0
WireConnection;14;2;17;2
WireConnection;14;3;17;3
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;30;0;28;1
WireConnection;30;1;28;2
WireConnection;38;0;36;1
WireConnection;38;1;36;2
WireConnection;24;0;14;0
WireConnection;29;0;28;3
WireConnection;37;0;36;3
WireConnection;39;0;44;0
WireConnection;31;0;45;0
WireConnection;61;0;4;0
WireConnection;40;0;39;0
WireConnection;40;2;38;0
WireConnection;40;1;37;0
WireConnection;5;1;64;0
WireConnection;32;0;31;0
WireConnection;32;2;30;0
WireConnection;32;1;29;0
WireConnection;20;0;24;0
WireConnection;33;1;32;0
WireConnection;35;1;40;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;7;2;60;0
WireConnection;26;0;20;0
WireConnection;26;1;25;0
WireConnection;22;0;26;0
WireConnection;22;1;21;0
WireConnection;22;2;33;1
WireConnection;34;0;7;0
WireConnection;34;1;35;1
WireConnection;23;0;34;0
WireConnection;23;1;22;0
WireConnection;13;0;12;1
WireConnection;13;1;11;0
WireConnection;59;0;23;0
WireConnection;59;1;43;0
WireConnection;2;0;62;0
WireConnection;2;2;59;0
WireConnection;2;3;8;0
WireConnection;2;4;13;0
WireConnection;0;13;2;0
ASEEND*/
//CHKSM=91E848354D418071CF2C6806326BED177AFBF18A