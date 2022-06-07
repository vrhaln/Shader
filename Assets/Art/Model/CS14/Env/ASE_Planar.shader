// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Planar"
{
	Properties
	{
		_MainColor("MainColor", Color) = (0,0,0,0)
		_ShaowColor("ShaowColor", Color) = (0,0,0,0)
		_ShadowRange("ShadowRange", Float) = 0
		_ShadowSoft("ShadowSoft", Range( 0.51 , 1)) = 0.51
		_NormalMap("NormalMap", 2D) = "white" {}
		_ReflectionTex("ReflectionTex", 2D) = "black" {}
		_RefIntensity("RefIntensity", Float) = 1
		_EmissionTex("EmissionTex", 2D) = "black" {}
		_EmissionColor("EmissionColor", Color) = (1,1,1,1)
		_NoiseMask("NoiseMask", 2D) = "white" {}
		_NoiseSpeed("NoiseSpeed", Vector) = (0,0,0,0)
		_FadeColor("FadeColor", Color) = (0,0,0,0)
		_Range("Range", Float) = 0
		_Softness("Softness", Range( 0.51 , 10)) = 0.51
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
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
			float4 screenPos;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform float4 _FadeColor;
		uniform float4 _ShaowColor;
		uniform sampler2D _ReflectionTex;
		uniform float _RefIntensity;
		uniform float4 _MainColor;
		uniform float _ShadowSoft;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _ShadowRange;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform sampler2D _NoiseMask;
		uniform float2 _NoiseSpeed;
		uniform float4 _NoiseMask_ST;
		uniform float4 _EmissionColor;
		uniform float _Softness;
		uniform float _Range;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_30_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 temp_cast_0 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch36 = temp_cast_0;
			#else
				float3 staticSwitch36 = temp_output_30_0;
			#endif
			float3 LightColor37 = staticSwitch36;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 BaseColor73 = ( float4( LightColor37 , 0.0 ) * ( ( tex2D( _ReflectionTex, (ase_screenPosNorm).xy ) * _RefIntensity ) + _MainColor ) );
			float4 ShaowColor79 = ( _ShaowColor * BaseColor73 );
			float3 break31 = temp_output_30_0;
			float LightAtten34 = max( max( break31.x , break31.y ) , break31.z );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 WorldNormal100 = normalize( (WorldNormalVector( i , tex2D( _NormalMap, uv_NormalMap ).rgb )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g1 = dot( WorldNormal100 , ase_worldlightDir );
			float smoothstepResult89 = smoothstep( ( 1.0 - _ShadowSoft ) , _ShadowSoft , pow( (dotResult5_g1*0.5 + 0.5) , _ShadowRange ));
			float4 lerpResult83 = lerp( ShaowColor79 , BaseColor73 , ( LightAtten34 * smoothstepResult89 ));
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float2 uv_NoiseMask = i.uv_texcoord * _NoiseMask_ST.xy + _NoiseMask_ST.zw;
			float2 panner25 = ( 1.0 * _Time.y * _NoiseSpeed + uv_NoiseMask);
			float4 EmissColor103 = ( tex2D( _EmissionTex, uv_EmissionTex ) * tex2D( _NoiseMask, panner25 ).r * _EmissionColor );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float smoothstepResult8 = smoothstep( ( 1.0 - _Softness ) , _Softness , ( ( 1.0 - distance( ( _WorldSpaceCameraPos - ase_worldPos ) , ase_vertexNormal ) ) - _Range ));
			float FadeRange108 = smoothstepResult8;
			float4 lerpResult110 = lerp( _FadeColor , ( lerpResult83 + EmissColor103 ) , FadeRange108);
			float4 FinalColor85 = ( lerpResult110 * float4( LightColor37 , 0.0 ) );
			c.rgb = FinalColor85.rgb;
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
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.screenPos = IN.screenPos;
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
304;226;1403;771;796.7476;1623.405;1.136485;True;True
Node;AmplifyShaderEditor.CommentaryNode;27;-2466.316,-1480.613;Inherit;False;1525.385;680.1929;LightAtten;10;37;36;35;34;33;32;31;30;29;28;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;-615.4467,-1359.922;Inherit;False;1981.299;607.1929;BaseColor;10;10;18;42;1;40;39;41;38;43;73;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;28;-2408.316,-1132.817;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;29;-2391.028,-1052.958;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;10;-565.4467,-1264.69;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;18;-316.5086,-1265.159;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1985.967,-1355.371;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2146.574,-1119.272;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;36;-1744.388,-1373.926;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-109.6289,-1285.314;Inherit;True;Property;_ReflectionTex;ReflectionTex;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;43.0679,-1081.413;Inherit;False;Property;_RefIntensity;RefIntensity;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-2441.018,-2192.435;Inherit;False;1300.417;431.639;WorldNormal&ViewDir;7;102;101;100;99;98;97;96;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;98;-1939.41,-2143.832;Inherit;True;Property;_NormalMap;NormalMap;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;249.3297,-1309.922;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;-70.86277,-964.7296;Inherit;False;Property;_MainColor;MainColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.135,0.12,0.15,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-1387.37,-1375.045;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;99;-1598.399,-2136.058;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;41;542.0011,-1101.584;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;536.5183,-1242.996;Inherit;False;37;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;107;-2470.135,349.2299;Inherit;False;2044.628;870.7977;FinalOpacity;12;108;8;55;57;53;51;54;52;7;4;3;2;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;84;1937.396,-556.56;Inherit;False;3314.848;1265.778;FinalColor;20;89;88;91;90;87;85;106;93;105;83;94;72;82;81;70;71;69;110;111;112;FinalColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;31;-1832.972,-1100.312;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-1368.641,-2142.435;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;2;-2420.135,399.2299;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-2356.825,579.5288;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;104;-2413.824,-665.9001;Inherit;False;1719.236;760.9474;EmissColor;9;24;23;25;26;19;22;20;21;103;EmissColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;830.7448,-1136.635;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;1996.384,-88.79941;Inherit;False;100;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-2363.824,-340.4594;Inherit;False;0;26;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;23;-2332.658,-189.568;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;11;0;Create;True;0;0;0;False;0;False;0,0;0.02,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;76;1851.182,-1326.234;Inherit;False;1009.513;513.5418;ShaowColor;4;77;78;79;80;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;32;-1593.068,-1121.419;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;1141.853,-1136.035;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;7;-2157.969,740.204;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-2038.931,520.9408;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;88;2374.541,38.14493;Inherit;False;Property;_ShadowRange;ShadowRange;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;71;2214.385,-81.79941;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;2021.822,-1007.583;Inherit;False;73;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;25;-2050.658,-312.5681;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;33;-1438.12,-1089.103;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;2366.541,136.1449;Inherit;False;Property;_ShadowSoft;ShadowSoft;3;0;Create;True;0;0;0;False;0;False;0.51;1;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2119.191,-602.5464;Inherit;False;0;19;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;52;-1855.523,519.9261;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;2011.045,-1249.681;Inherit;False;Property;_ShaowColor;ShaowColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3584906,0.3584906,0.3584906,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-1566.547,1013.174;Inherit;False;Property;_Softness;Softness;14;0;Create;True;0;0;0;False;0;False;0.51;10;0.51;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1674.542,703.5929;Inherit;False;Property;_Range;Range;13;0;Create;True;0;0;0;False;0;False;0;-20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;-1683.053,536.9541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1173.933,-1087.337;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;2331.046,-1073.681;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;91;2738.54,71.14493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;87;2646.54,-18.85505;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1788.341,-338.4197;Inherit;True;Property;_NoiseMask;NoiseMask;10;0;Create;True;0;0;0;False;0;False;-1;None;efccf27a2e7dd4a4c9a7b81f565bc7df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1846.283,-615.9;Inherit;True;Property;_EmissionTex;EmissionTex;8;0;Create;True;0;0;0;False;0;False;-1;None;10f26b1403db1364285908c315ec5fdf;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-1810.95,-116.9527;Inherit;False;Property;_EmissionColor;EmissionColor;9;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.1308295,0.1476181,0.5660378,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;55;-1283.32,817.9289;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1161.522,-231.1806;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;2877.382,-172.7994;Inherit;False;34;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;89;2951.54,77.14494;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;2543.351,-1079.286;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;57;-1341.857,709.7274;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;3196.379,-313.9874;Inherit;True;73;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;3181.383,-108.7995;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;3193.529,-516.2251;Inherit;True;79;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;8;-985.0185,725.1533;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-918.5872,-223.4404;Inherit;False;EmissColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-703.2752,731.1898;Inherit;False;FadeRange;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;83;3679.897,-290.7513;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;3672.983,14.79153;Inherit;True;103;EmissColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;4242.796,-119.9319;Inherit;False;108;FadeRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;4045.3,-262.7974;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;111;4304.394,-492.0875;Inherit;False;Property;_FadeColor;FadeColor;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.04705883,0.03529412,0.08235294,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;110;4520.34,-298.45;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;4517.249,-129.1137;Inherit;False;37;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;4728.458,-283.8547;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;4880.75,-278.2507;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-1364.6,-1940.597;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;101;-1576.733,-1943.937;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;96;-2404.269,-2113.263;Inherit;False;Property;_NormalScale;NormalScale;5;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;944.4087,706.0787;Inherit;False;85;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-2114.795,-2106.823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1164.123,463.507;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Planar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;10;0
WireConnection;30;0;28;0
WireConnection;30;1;29;1
WireConnection;36;1;30;0
WireConnection;36;0;35;0
WireConnection;1;1;18;0
WireConnection;39;0;1;0
WireConnection;39;1;42;0
WireConnection;37;0;36;0
WireConnection;99;0;98;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;31;0;30;0
WireConnection;100;0;99;0
WireConnection;43;0;38;0
WireConnection;43;1;41;0
WireConnection;32;0;31;0
WireConnection;32;1;31;1
WireConnection;73;0;43;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;71;3;69;0
WireConnection;25;0;24;0
WireConnection;25;2;23;0
WireConnection;33;0;32;0
WireConnection;33;1;31;2
WireConnection;52;0;4;0
WireConnection;52;1;7;0
WireConnection;53;0;52;0
WireConnection;34;0;33;0
WireConnection;78;0;77;0
WireConnection;78;1;80;0
WireConnection;91;0;90;0
WireConnection;87;0;71;0
WireConnection;87;1;88;0
WireConnection;26;1;25;0
WireConnection;19;1;22;0
WireConnection;55;0;54;0
WireConnection;20;0;19;0
WireConnection;20;1;26;1
WireConnection;20;2;21;0
WireConnection;89;0;87;0
WireConnection;89;1;91;0
WireConnection;89;2;90;0
WireConnection;79;0;78;0
WireConnection;57;0;53;0
WireConnection;57;1;51;0
WireConnection;72;0;70;0
WireConnection;72;1;89;0
WireConnection;8;0;57;0
WireConnection;8;1;55;0
WireConnection;8;2;54;0
WireConnection;103;0;20;0
WireConnection;108;0;8;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;83;2;72;0
WireConnection;106;0;83;0
WireConnection;106;1;105;0
WireConnection;110;0;111;0
WireConnection;110;1;106;0
WireConnection;110;2;112;0
WireConnection;93;0;110;0
WireConnection;93;1;94;0
WireConnection;85;0;93;0
WireConnection;102;0;101;0
WireConnection;97;0;96;0
WireConnection;0;13;86;0
ASEEND*/
//CHKSM=2C5B5FDF540E7298261059A960D7C80593EF4135