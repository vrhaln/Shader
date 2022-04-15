// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Body"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (1,1,1,1)
		_ShaowColor("ShaowColor", Color) = (0,0,0,0)
		_Power("Power", Float) = 7
		_Mul("Mul", Float) = 20
		_ShdowIntensity("ShdowIntensity", Range( 0 , 1)) = 1
		_EmissionTex("EmissionTex", 2D) = "white" {}
		_EmissionIntensity("EmissionIntensity", Float) = 1
		[Toggle(_FREONEMINUS_ON)] _FreOneMinus("FreOneMinus", Float) = 0
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,1)
		_Fre("Fre", Vector) = (0,1.1,1.1,0)
		_FreIntensity("FreIntensity", Float) = 1
		_MatCapTex("MatCapTex", 2D) = "black" {}
		_MatCapIntensity("MatCapIntensity", Float) = 1
		_ScanTex("ScanTex", 2D) = "black" {}
		_ScanColor("ScanColor", Color) = (0.990566,0.990566,0.990566,1)
		_NoisePanner("NoisePanner", Vector) = (0,0,0,0)
		_ScanlineIntensity("ScanlineIntensity", Range( 0 , 1)) = 1
		_SmoothTex("SmoothTex", 2D) = "black" {}
		_SmoothnessMaxMin("SmoothnessMaxMin", Vector) = (0.95,0.01,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_ReflectFre("ReflectFre", Vector) = (0,1,5,0)
		_NormalMap("NormalMap", 2D) = "bump" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _FREONEMINUS_ON
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
			float2 uv2_texcoord2;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
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

		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform float3 _Fre;
		uniform float _FreIntensity;
		uniform float4 _EmissionColor;
		uniform float _EmissionIntensity;
		uniform float4 _ShaowColor;
		uniform float4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Power;
		uniform float _Mul;
		uniform float _ShdowIntensity;
		uniform float2 _SmoothnessMaxMin;
		uniform sampler2D _SmoothTex;
		uniform float4 _SmoothTex_ST;
		uniform float _Smoothness;
		uniform float3 _ReflectFre;
		uniform sampler2D _ScanTex;
		uniform float3 _NoisePanner;
		uniform float4 _ScanTex_ST;
		uniform float4 _ScanColor;
		uniform float _ScanlineIntensity;
		uniform sampler2D _MatCapTex;
		uniform float _MatCapIntensity;

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
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 BaseColor53 = ( _BaseColor * tex2D( _MainTex, uv_MainTex ) );
			float4 ShaowColor58 = ( _ShaowColor * BaseColor53 );
			float4 blendOpSrc68 = ShaowColor58;
			float4 blendOpDest68 = BaseColor53;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_91_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 break92 = temp_output_91_0;
			float LightAtten95 = max( max( break92.x , break92.y ) , break92.z );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 WorldNormal101 = normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g1 = dot( WorldNormal101 , ase_worldlightDir );
			float4 lerpBlendMode68 = lerp(blendOpDest68,( blendOpSrc68 * blendOpDest68 ),( ( 1.0 - saturate( ( LightAtten95 * ( pow( (dotResult5_g1*0.5 + 0.5) , _Power ) * _Mul ) ) ) ) * _ShdowIntensity ));
			float2 uv2_EmissionTex = i.uv2_texcoord2 * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float4 tex2DNode5 = tex2D( _EmissionTex, uv2_EmissionTex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV15 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode15 = ( _Fre.x + _Fre.y * pow( 1.0 - fresnelNdotV15, _Fre.z ) );
			float temp_output_108_0 = saturate( fresnelNode15 );
			#ifdef _FREONEMINUS_ON
				float staticSwitch123 = ( 1.0 - temp_output_108_0 );
			#else
				float staticSwitch123 = temp_output_108_0;
			#endif
			float4 EmissionColor117 = ( ( tex2DNode5 * ( saturate( staticSwitch123 ) * _FreIntensity ) ) * _EmissionColor * _EmissionIntensity );
			float3 indirectNormal128 = WorldNormal101;
			float2 uv_SmoothTex = i.uv_texcoord * _SmoothTex_ST.xy + _SmoothTex_ST.zw;
			float lerpResult144 = lerp( _SmoothnessMaxMin.y , _SmoothnessMaxMin.x , ( ( 1.0 - tex2D( _SmoothTex, uv_SmoothTex ).r ) * _Smoothness ));
			float fresnelNdotV136 = dot( WorldNormal101, ase_worldViewDir );
			float fresnelNode136 = ( _ReflectFre.x + _ReflectFre.y * pow( max( 1.0 - fresnelNdotV136 , 0.0001 ), _ReflectFre.z ) );
			float clampResult138 = clamp( fresnelNode136 , 0.0 , 1.0 );
			Unity_GlossyEnvironmentData g128 = UnityGlossyEnvironmentSetup( lerpResult144, data.worldViewDir, indirectNormal128, float3(0,0,0));
			float3 indirectSpecular128 = UnityGI_IndirectSpecular( data, saturate( clampResult138 ), indirectNormal128, g128 );
			UnityGI gi139 = gi;
			float3 diffNorm139 = WorldNormal101;
			gi139 = UnityGI_Base( data, 1, diffNorm139 );
			float3 indirectDiffuse139 = gi139.indirect.diffuse + diffNorm139 * 0.0001;
			float3 ReflectColor130 = ( indirectSpecular128 * indirectDiffuse139 );
			float mulTime116 = _Time.y * _NoisePanner.z;
			float2 appendResult114 = (float2(_NoisePanner.x , _NoisePanner.y));
			float2 uv2_ScanTex = i.uv2_texcoord2 * _ScanTex_ST.xy + _ScanTex_ST.zw;
			float2 panner39 = ( mulTime116 * appendResult114 + uv2_ScanTex);
			float4 ScanColor105 = saturate( ( tex2D( _ScanTex, panner39 ) * _ScanColor * _ScanlineIntensity * tex2DNode5.r ) );
			float4 MatCap32 = tex2D( _MatCapTex, ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy + 1.0 ) * 0.5 ) );
			float3 temp_cast_4 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch97 = temp_cast_4;
			#else
				float3 staticSwitch97 = temp_output_91_0;
			#endif
			float3 LightColor98 = staticSwitch97;
			float4 FinalBaseColor83 = ( ( saturate( ( ( saturate( lerpBlendMode68 )) + EmissionColor117 + float4( ReflectColor130 , 0.0 ) + ScanColor105 ) ) + ( MatCap32 * _MatCapIntensity ) ) * float4( LightColor98 , 0.0 ) );
			c.rgb = saturate( FinalBaseColor83 ).rgb;
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
			float2 uv2_EmissionTex = i.uv2_texcoord2 * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float4 tex2DNode5 = tex2D( _EmissionTex, uv2_EmissionTex );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV15 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode15 = ( _Fre.x + _Fre.y * pow( 1.0 - fresnelNdotV15, _Fre.z ) );
			float temp_output_108_0 = saturate( fresnelNode15 );
			#ifdef _FREONEMINUS_ON
				float staticSwitch123 = ( 1.0 - temp_output_108_0 );
			#else
				float staticSwitch123 = temp_output_108_0;
			#endif
			float4 EmissionColor117 = ( ( tex2DNode5 * ( saturate( staticSwitch123 ) * _FreIntensity ) ) * _EmissionColor * _EmissionIntensity );
			o.Emission = EmissionColor117.rgb;
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
				float4 customPack1 : TEXCOORD1;
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
				o.customPack1.xy = customInputData.uv2_texcoord2;
				o.customPack1.xy = v.texcoord1;
				o.customPack1.zw = customInputData.uv_texcoord;
				o.customPack1.zw = v.texcoord;
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
				surfIN.uv2_texcoord2 = IN.customPack1.xy;
				surfIN.uv_texcoord = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
-1658;129;1599;826;7513.291;2433.055;3.77649;True;True
Node;AmplifyShaderEditor.CommentaryNode;88;-3089.09,-1282.639;Inherit;False;1525.385;680.1929;LightAtten;10;98;97;96;95;94;93;92;91;90;89;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-6047.013,-165.9748;Inherit;False;2288.386;1880.856;EmissionColor;27;19;108;112;21;15;14;111;5;43;105;42;40;39;116;114;38;115;117;122;123;124;125;126;127;141;142;60;EmissionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;90;-3039.09,-991.843;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;155;-7430.853,-1250.468;Inherit;True;Property;_NormalMap;NormalMap;22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;99;-7132.129,-1309.384;Inherit;False;504.303;432.5138;WorldNormal&ViewDir;4;103;102;101;100;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightColorNode;89;-3022.802,-786.9834;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;14;-5994.04,723.4124;Inherit;False;Property;_Fre;Fre;10;0;Create;True;0;0;0;False;0;False;0,1.1,1.1;0,1,2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;100;-7093.847,-1247.895;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-2769.348,-921.298;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;92;-2455.746,-902.3379;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-6872.088,-1251.272;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;15;-5820.342,718.7601;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-3633.901,-130.2669;Inherit;False;4797.417;1871.557;FinalBaseColor;27;133;118;120;83;82;81;84;85;121;33;87;68;69;63;62;70;71;72;73;75;74;76;77;79;78;80;147;FinalBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;46;-4607.456,-1293.745;Inherit;False;1309.754;677.8403;BaseColor;5;53;51;50;107;158;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;108;-5452.969,716.3848;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-3591.907,702.7513;Inherit;False;101;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;158;-4470.683,-970.8218;Inherit;False;0;51;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;93;-2215.842,-923.4449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;129;-4259.677,1959.992;Inherit;False;1862.541;1251.331;ReflectColor;18;130;140;139;128;138;131;136;134;132;137;144;145;146;148;149;153;154;156;ReflectColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;-6059.434,1931.83;Inherit;False;1639.263;893.4619;MatCap;10;32;31;30;28;29;27;26;25;23;24;MatCap;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;51;-4211.578,-1000.09;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;36f42ee6b39ca3145be7336ea7620e4d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;153;-4249.871,2642.591;Inherit;False;101;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;122;-5278.315,864.7269;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;134;-4204.484,2341.874;Inherit;True;Property;_SmoothTex;SmoothTex;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;94;-2060.894,-891.1288;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;137;-4211.927,2750.265;Inherit;False;Property;_ReflectFre;ReflectFre;21;0;Create;True;0;0;0;False;0;False;0,1,5;0,7.8,1.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;50;-4171.95,-1184.171;Inherit;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;79;-3351.907,718.7513;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;115;-6030.112,51.97414;Inherit;False;Property;_NoisePanner;NoisePanner;16;0;Create;True;0;0;0;False;0;False;0,0,0;0,0.2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;78;-3335.907,958.751;Inherit;False;Property;_Power;Power;3;0;Create;True;0;0;0;False;0;False;7;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-5997.013,-115.9747;Inherit;False;1;40;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;136;-4004.518,2700.841;Inherit;False;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;148;-3913.549,2368.241;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;24;-6009.434,2112.437;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;114;-5839.112,19.97413;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;123;-5159.417,727.0103;Inherit;False;Property;_FreOneMinus;FreOneMinus;8;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;116;-5853.112,122.974;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-3795.53,-1112.702;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-1799.953,-889.3629;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;76;-3079.907,734.7513;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-4197.416,2546.569;Inherit;False;Property;_Smoothness;Smoothness;20;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-3063.907,990.751;Inherit;False;Property;_Mul;Mul;4;0;Create;True;0;0;0;False;0;False;20;6.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewMatrixNode;23;-5926.679,1981.829;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-3536.936,-1130.236;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;145;-4147.237,2180.012;Inherit;False;Property;_SmoothnessMaxMin;SmoothnessMaxMin;19;0;Create;True;0;0;0;False;0;False;0.95,0.01;0.999,0.001;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;39;-5660.449,-47.78374;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-3750.305,2360.115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-2837.009,593.8522;Inherit;False;95;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;138;-3740.781,2687.901;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-5702.39,479.5527;Inherit;False;1;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-5735.679,2044.828;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;112;-4938.333,747.4464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2832.214,794.1385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;54;-6013.684,-1308.276;Inherit;False;1181.666;633.2292;ShaowColor;4;58;57;56;55;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-5059.109,847.3156;Inherit;False;Property;_FreIntensity;FreIntensity;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-5423.624,461.0518;Inherit;True;Property;_EmissionTex;EmissionTex;6;0;Create;True;0;0;0;False;0;False;-1;None;3e663fa77d5c95d49b811bbe73be97d3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;40;-5419.708,-70.59331;Inherit;True;Property;_ScanTex;ScanTex;14;0;Create;True;0;0;0;False;0;False;-1;None;2ef51388c05f48942ae53b2cd6f73d55;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;144;-3614.633,2217.105;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-3724.979,2508.439;Inherit;False;101;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;55;-5901.684,-1260.277;Inherit;False;Property;_ShaowColor;ShaowColor;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-5366.947,294.9044;Inherit;False;Property;_ScanlineIntensity;ScanlineIntensity;17;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;142;-5338.242,120.9131;Inherit;False;Property;_ScanColor;ScanColor;15;0;Create;True;0;0;0;False;0;False;0.990566,0.990566,0.990566,1;0.382328,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;131;-3815.89,2148.534;Inherit;False;101;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;156;-3524.623,2464.239;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;27;-5554.722,2032.744;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2567.906,590.7523;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-5516.652,2154.042;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-4797.755,758.2698;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-5872.912,-1085.533;Inherit;False;53;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-5341.652,2034.042;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-4941.449,-36.53507;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;72;-2343.906,542.7523;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-5385.955,-1157.094;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;-4782.259,930.9602;Inherit;False;Property;_EmissionColor;EmissionColor;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.2047242,0.01960783,0.6235294,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-4633.309,699.063;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectSpecularLight;128;-3356.083,2152.487;Inherit;True;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-5390.652,2227.042;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;139;-3348.819,2517.349;Inherit;True;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-4784.406,1133.322;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-2151.906,542.7523;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-5200.652,2038.042;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-3000.016,2143.25;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;111;-4722.433,-35.74126;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-5080.127,-1165.52;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2297.478,779.7144;Inherit;False;Property;_ShdowIntensity;ShdowIntensity;5;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-4440.504,745.0674;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;31;-5025.684,2007.618;Inherit;True;Property;_MatCapTex;MatCapTex;12;0;Create;True;0;0;0;False;0;False;-1;None;7ad6f39daccc4314999cf8fbccdc3880;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-4044.886,758.4194;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1979.362,538.3563;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2764.379,-9.981637;Inherit;True;58;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-4542.389,-39.26049;Inherit;False;ScanColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-2749.062,2136.007;Inherit;False;ReflectColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2775.326,316.6824;Inherit;True;53;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1721.577,814.5628;Inherit;True;130;ReflectColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2608.741,-1157.397;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;68;-1752.812,379.1592;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-1704.851,1042.434;Inherit;False;105;ScanColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1722.714,601.3143;Inherit;True;117;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-4679.721,2013.471;Inherit;False;MatCap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;97;-2367.162,-1175.952;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-645.0035,714.8372;Inherit;False;Property;_MatCapIntensity;MatCapIntensity;13;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;-1182.133,379.0091;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-628.8751,625.5946;Inherit;False;32;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;121;-731.2781,381.995;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-2012.144,-1179.071;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-386.537,629.1612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-56.52671,597.2303;Inherit;False;98;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-149.417,379.0624;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;151.5724,381.2316;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;393.3905,372.3451;Inherit;False;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;1426.356,468.392;Inherit;False;83;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;1694.652,291.1699;Inherit;False;117;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-3585.778,2359.325;Inherit;False;Constant;_Float4;Float 4;22;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;45;1698.149,473.3283;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;102;-7080.18,-1052.774;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-6868.047,-1049.434;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;124;-4230.09,843.4968;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2112.254,254.9896;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Body;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;100;0;155;0
WireConnection;91;0;90;0
WireConnection;91;1;89;1
WireConnection;92;0;91;0
WireConnection;101;0;100;0
WireConnection;15;1;14;1
WireConnection;15;2;14;2
WireConnection;15;3;14;3
WireConnection;108;0;15;0
WireConnection;93;0;92;0
WireConnection;93;1;92;1
WireConnection;51;1;158;0
WireConnection;122;0;108;0
WireConnection;94;0;93;0
WireConnection;94;1;92;2
WireConnection;79;3;80;0
WireConnection;136;0;153;0
WireConnection;136;1;137;1
WireConnection;136;2;137;2
WireConnection;136;3;137;3
WireConnection;148;0;134;1
WireConnection;114;0;115;1
WireConnection;114;1;115;2
WireConnection;123;1;108;0
WireConnection;123;0;122;0
WireConnection;116;0;115;3
WireConnection;107;0;50;0
WireConnection;107;1;51;0
WireConnection;95;0;94;0
WireConnection;76;0;79;0
WireConnection;76;1;78;0
WireConnection;53;0;107;0
WireConnection;39;0;38;0
WireConnection;39;2;114;0
WireConnection;39;1;116;0
WireConnection;146;0;148;0
WireConnection;146;1;132;0
WireConnection;138;0;136;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;112;0;123;0
WireConnection;75;0;76;0
WireConnection;75;1;77;0
WireConnection;5;1;43;0
WireConnection;40;1;39;0
WireConnection;144;0;145;2
WireConnection;144;1;145;1
WireConnection;144;2;146;0
WireConnection;156;0;138;0
WireConnection;27;0;25;0
WireConnection;73;0;74;0
WireConnection;73;1;75;0
WireConnection;126;0;112;0
WireConnection;126;1;127;0
WireConnection;29;0;27;0
WireConnection;29;1;26;0
WireConnection;141;0;40;0
WireConnection;141;1;142;0
WireConnection;141;2;60;0
WireConnection;141;3;5;1
WireConnection;72;0;73;0
WireConnection;57;0;55;0
WireConnection;57;1;56;0
WireConnection;125;0;5;0
WireConnection;125;1;126;0
WireConnection;128;0;131;0
WireConnection;128;1;144;0
WireConnection;128;2;156;0
WireConnection;139;0;149;0
WireConnection;71;0;72;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;140;0;128;0
WireConnection;140;1;139;0
WireConnection;111;0;141;0
WireConnection;58;0;57;0
WireConnection;21;0;125;0
WireConnection;21;1;19;0
WireConnection;21;2;42;0
WireConnection;31;1;30;0
WireConnection;117;0;21;0
WireConnection;69;0;71;0
WireConnection;69;1;70;0
WireConnection;105;0;111;0
WireConnection;130;0;140;0
WireConnection;68;0;63;0
WireConnection;68;1;62;0
WireConnection;68;2;69;0
WireConnection;32;0;31;0
WireConnection;97;1;91;0
WireConnection;97;0;96;0
WireConnection;120;0;68;0
WireConnection;120;1;118;0
WireConnection;120;2;133;0
WireConnection;120;3;147;0
WireConnection;121;0;120;0
WireConnection;98;0;97;0
WireConnection;85;0;33;0
WireConnection;85;1;87;0
WireConnection;81;0;121;0
WireConnection;81;1;85;0
WireConnection;82;0;81;0
WireConnection;82;1;84;0
WireConnection;83;0;82;0
WireConnection;45;0;106;0
WireConnection;103;0;102;0
WireConnection;0;2;157;0
WireConnection;0;13;45;0
ASEEND*/
//CHKSM=ACBF563133EDC18597724EB3FC55B7DB87A7B6DB