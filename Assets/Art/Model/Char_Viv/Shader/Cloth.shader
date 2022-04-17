// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Cloth"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_RCHANELISALPHA_ON)] _RChanelIsAlpha("RChanelIsAlpha", Float) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_MainColor("MainColor", Color) = (1,1,1,1)
		_ShaowColor("ShaowColor", Color) = (0,0,0,1)
		_Power("Power", Float) = 7
		_Mul("Mul", Float) = 20
		_ShdowIntensity("ShdowIntensity", Range( 0 , 1)) = 1
		_NormalMap("NormalMap", 2D) = "bump" {}
		_EmisTex("EmisTex", 2D) = "white" {}
		[HDR]_EmissColor("EmissColor", Color) = (1,1,1,1)
		_BaseEmissStr("BaseEmissStr", Float) = 1
		_AnimaEmisStr("AnimaEmisStr", Range( 0 , 1)) = 1
		_ScanTex("ScanTex", 2D) = "black" {}
		_ScanColor("ScanColor", Color) = (0.990566,0.990566,0.990566,1)
		_ScanPanner("ScanPanner", Vector) = (0,0,0,0)
		_ScanlineIntensity("ScanlineIntensity", Range( 0 , 1)) = 1
		_Fresnel("Fresnel", Vector) = (0,1,5,0)
		_FreStr("FreStr", Float) = 1
		_IORTex("IORTex", 2D) = "white" {}
		_IOR("IOR", Float) = 3
		_NoiseTiling1("NoiseTiling1", Vector) = (0.5,0.5,0,0)
		_NoiseTiling2("NoiseTiling2", Vector) = (2,2.5,0,0)
		_AEmisStr("AEmisStr", Float) = 1
		_BEmisStr("BEmisStr", Float) = 1
		_MatCapTex("MatCapTex", 2D) = "black" {}
		_MatCapIntensity("MatCapIntensity", Range( 0 , 1)) = 1
		_SmoothTex("SmoothTex", 2D) = "white" {}
		_SmoothnessMaxMin("SmoothnessMaxMin", Vector) = (0.95,0.01,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_ReflectIntensity("ReflectIntensity", Range( 0 , 1)) = 0.5
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _RCHANELISALPHA_ON
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
			half ASEVFace : VFACE;
			float3 worldPos;
			float3 viewDir;
			float2 uv2_texcoord2;
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
		uniform float4 _MainTex_ST;
		uniform float _Opacity;
		uniform float4 _ShaowColor;
		uniform float4 _MainColor;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Power;
		uniform float _Mul;
		uniform float _ShdowIntensity;
		uniform float2 _SmoothnessMaxMin;
		uniform sampler2D _SmoothTex;
		uniform float4 _SmoothTex_ST;
		uniform float _Smoothness;
		uniform sampler2D _MatCapTex;
		uniform float _MatCapIntensity;
		uniform float _ReflectIntensity;
		uniform sampler2D _IORTex;
		uniform float4 _IORTex_ST;
		uniform float4 _NoiseTiling1;
		uniform float _IOR;
		uniform float _AEmisStr;
		uniform float4 _NoiseTiling2;
		uniform float _BEmisStr;
		uniform sampler2D _EmisTex;
		uniform float4 _EmisTex_ST;
		uniform float3 _Fresnel;
		uniform float _FreStr;
		uniform float4 _EmissColor;
		uniform sampler2D _ScanTex;
		uniform float3 _ScanPanner;
		uniform float4 _ScanColor;
		uniform float _ScanlineIntensity;
		uniform float _AnimaEmisStr;
		uniform float _BaseEmissStr;

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
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float MainTexAlpha71 = tex2DNode1.a;
			float MainTexRChanel154 = tex2DNode1.r;
			#ifdef _RCHANELISALPHA_ON
				float staticSwitch157 = MainTexRChanel154;
			#else
				float staticSwitch157 = MainTexAlpha71;
			#endif
			float lerpResult51 = lerp( 1.0 , staticSwitch157 , _Opacity);
			float FinalOpacity181 = saturate( lerpResult51 );
			float4 BaseColor129 = ( tex2DNode1 * _MainColor );
			float4 ShaowColor134 = ( _ShaowColor * BaseColor129 );
			float4 blendOpSrc116 = ShaowColor134;
			float4 blendOpDest116 = BaseColor129;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_92_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 break93 = temp_output_92_0;
			float LightAtten96 = max( max( break93.x , break93.y ) , break93.z );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 newWorldNormal162 = (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) ));
			float3 appendResult185 = (float3(newWorldNormal162.x , newWorldNormal162.y , -newWorldNormal162.z));
			float3 switchResult186 = (((i.ASEVFace>0)?(newWorldNormal162):(appendResult185)));
			float3 WorldNormal163 = switchResult186;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g1 = dot( WorldNormal163 , ase_worldlightDir );
			float4 lerpBlendMode116 = lerp(blendOpDest116,( blendOpSrc116 * blendOpDest116 ),( ( 1.0 - saturate( ( LightAtten96 * ( pow( (dotResult5_g1*0.5 + 0.5) , _Power ) * _Mul ) ) ) ) * _ShdowIntensity ));
			float3 indirectNormal229 = WorldNormal163;
			float2 uv_SmoothTex = i.uv_texcoord * _SmoothTex_ST.xy + _SmoothTex_ST.zw;
			float Smoothness307 = ( tex2D( _SmoothTex, uv_SmoothTex ).r * _Smoothness );
			float lerpResult225 = lerp( _SmoothnessMaxMin.y , _SmoothnessMaxMin.x , Smoothness307);
			Unity_GlossyEnvironmentData g229 = UnityGlossyEnvironmentSetup( lerpResult225, data.worldViewDir, indirectNormal229, float3(0,0,0));
			float3 indirectSpecular229 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal229, g229 );
			UnityGI gi228 = gi;
			float3 diffNorm228 = WorldNormal163;
			gi228 = UnityGI_Base( data, 1, diffNorm228 );
			float3 indirectDiffuse228 = gi228.indirect.diffuse + diffNorm228 * 0.0001;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float2 MatCapUV271 = ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy + 1.0 ) * 0.5 );
			float4 _Vector3 = float4(0.5,0.5,0.5,1);
			float2 appendResult273 = (float2(_Vector3.x , _Vector3.y));
			float2 appendResult280 = (float2(_Vector3.z , _Vector3.w));
			float4 _Vector2 = float4(0.5,0.5,0,1);
			float2 appendResult276 = (float2(_Vector2.x , _Vector2.y));
			float2 appendResult277 = (float2(_Vector2.z , _Vector2.w));
			float4 lerpResult296 = lerp( tex2D( _MatCapTex, ( ( MatCapUV271 * appendResult273 ) + appendResult280 ) ) , tex2D( _MatCapTex, ( ( MatCapUV271 * appendResult276 ) + appendResult277 ) ) , Smoothness307);
			float4 _Vector1 = float4(0.5,0.5,0.5,0.5);
			float2 appendResult282 = (float2(_Vector1.x , _Vector1.y));
			float2 appendResult286 = (float2(_Vector1.z , _Vector1.w));
			float4 lerpResult300 = lerp( lerpResult296 , tex2D( _MatCapTex, ( ( MatCapUV271 * appendResult282 ) + appendResult286 ) ) , Smoothness307);
			float4 _Vector0 = float4(0.5,0.5,0,0.5);
			float2 appendResult287 = (float2(_Vector0.x , _Vector0.y));
			float2 appendResult295 = (float2(_Vector0.z , _Vector0.w));
			float4 lerpResult301 = lerp( lerpResult300 , tex2D( _MatCapTex, ( ( MatCapUV271 * appendResult287 ) + appendResult295 ) ) , Smoothness307);
			float4 MatCap302 = lerpResult301;
			float4 ReflectColor234 = ( ( float4( ( indirectSpecular229 * indirectDiffuse228 ) , 0.0 ) + ( MatCap302 * _MatCapIntensity ) ) * _ReflectIntensity );
			float2 uv_IORTex = i.uv_texcoord * _IORTex_ST.xy + _IORTex_ST.zw;
			float2 appendResult193 = (float2(_NoiseTiling1.x , _NoiseTiling1.y));
			float2 appendResult194 = (float2(_NoiseTiling1.z , _NoiseTiling1.w));
			float3 normalizeResult21 = normalize( i.viewDir );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentPos19 = mul( ase_worldToTangent, ase_worldNormal);
			float3 normalizeResult22 = normalize( worldToTangentPos19 );
			float3 break24 = refract( normalizeResult21 , normalizeResult22 , ( 1.0 / _IOR ) );
			float2 appendResult26 = (float2(break24.x , break24.y));
			float2 temp_output_30_0 = ( appendResult26 / break24.z );
			float2 appendResult197 = (float2(_NoiseTiling2.x , _NoiseTiling2.y));
			float2 appendResult196 = (float2(_NoiseTiling2.z , _NoiseTiling2.w));
			float temp_output_43_0 = ( ( tex2D( _IORTex, ( (uv_IORTex*appendResult193 + appendResult194) + temp_output_30_0 ) ).r * _AEmisStr ) * ( tex2D( _IORTex, ( (uv_IORTex*appendResult197 + appendResult196) + temp_output_30_0 ) ).r * _BEmisStr ) );
			float2 uv_EmisTex = i.uv_texcoord * _EmisTex_ST.xy + _EmisTex_ST.zw;
			float IORColor63 = ( temp_output_43_0 * tex2D( _EmisTex, uv_EmisTex ).r );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV41 = dot( WorldNormal163, ase_worldViewDir );
			float fresnelNode41 = ( _Fresnel.x + _Fresnel.y * pow( 1.0 - fresnelNdotV41, _Fresnel.z ) );
			float FreColor60 = saturate( fresnelNode41 );
			float lerpResult207 = lerp( 0.0 , IORColor63 , saturate( ( ( 1.0 - FreColor60 ) * _FreStr ) ));
			float mulTime248 = _Time.y * _ScanPanner.z;
			float2 appendResult249 = (float2(_ScanPanner.x , _ScanPanner.y));
			float2 panner250 = ( mulTime248 * appendResult249 + i.uv2_texcoord2);
			float4 ScanColor256 = saturate( ( tex2D( _ScanTex, panner250 ).r * _ScanColor * _ScanlineIntensity ) );
			float4 EmissionColor174 = ( ( ( lerpResult207 * _EmissColor ) + ScanColor256 ) * _AnimaEmisStr * _BaseEmissStr );
			float3 temp_cast_3 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch98 = temp_cast_3;
			#else
				float3 staticSwitch98 = temp_output_92_0;
			#endif
			float3 LightColor99 = staticSwitch98;
			float4 FinalBaseColor127 = ( ( ( saturate( lerpBlendMode116 )) + ReflectColor234 + EmissionColor174 ) * float4( LightColor99 , 0.0 ) );
			c.rgb = FinalBaseColor127.rgb;
			c.a = FinalOpacity181;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
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
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
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
Version=18935
-2049;247;1916;950;6108.514;-2700.843;2.803826;True;True
Node;AmplifyShaderEditor.CommentaryNode;167;-8769.537,-2922.674;Inherit;False;5449.623;3535.527;EmissionColor;18;174;190;215;56;218;48;207;210;175;205;206;214;176;59;62;257;258;259;EmissionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;260;-8862.835,3061.554;Inherit;False;3247.732;1985.19;MatCap;42;302;301;300;299;298;297;296;295;294;293;292;291;290;289;288;287;286;285;284;283;282;281;280;279;278;277;276;275;274;273;272;271;270;269;268;267;266;265;264;263;262;261;MatCap;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-10573.3,-2143.341;Inherit;False;1650.118;681.2457;WorldNormal&ViewDir;8;165;164;163;162;160;185;186;188;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;62;-8714.326,-2731.983;Inherit;False;4704.647;1203.248;IORColor;35;49;42;39;43;34;35;37;36;33;32;31;29;30;28;26;24;23;20;21;22;19;16;17;18;15;63;65;189;192;193;194;195;196;197;201;IORColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewMatrixNode;261;-8663.912,3136.761;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldNormalVector;262;-8746.666,3267.369;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;160;-10546.53,-2061.503;Inherit;True;Property;_NormalMap;NormalMap;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;15;-8659.326,-2220.78;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;162;-10252.53,-2058.93;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-8480.532,-1932.999;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;18;-8449.317,-2440.387;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;17;-8479.03,-1830.618;Inherit;False;Property;_IOR;IOR;22;0;Create;True;0;0;0;False;0;False;3;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;19;-8382.944,-2228.486;Inherit;False;World;Tangent;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-8472.912,3199.76;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;22;-8116.944,-2220.486;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-8200.532,-1912.999;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;-8253.884,3308.974;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;265;-8291.955,3187.676;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;21;-8137.079,-2376.473;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;188;-9963.247,-1913.597;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;267;-8078.884,3188.974;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-8127.884,3381.974;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RefractOpVec;23;-7887.153,-2247.975;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;185;-9793.762,-1994.714;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;-7937.884,3192.974;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;192;-7093.403,-2546.063;Inherit;False;Property;_NoiseTiling1;NoiseTiling1;23;0;Create;True;0;0;0;False;0;False;0.5,0.5,0,0;0.5,0.9,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-7669.896,-2235.26;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SwitchByFaceNode;186;-9574.648,-2051.066;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;195;-7096.403,-2358.063;Inherit;False;Property;_NoiseTiling2;NoiseTiling2;24;0;Create;True;0;0;0;False;0;False;2,2.5,0,0;1.81,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;271;-7773.22,3191.467;Inherit;False;MatCapUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-9303.056,-2064.742;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;59;-8693.26,-1308.303;Inherit;False;2104.219;700.5641;FreColor;8;57;44;41;40;38;60;66;183;FreColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-7032.49,-2681.983;Inherit;False;0;37;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;303;-5416.567,3084.712;Inherit;False;892.3916;563.8984;SmoothnessContorl;4;307;306;304;221;SmoothnessContorl;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;270;-7694.16,4624.768;Inherit;False;Constant;_Vector3;Vector 3;24;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;269;-7672.649,4178.344;Inherit;False;Constant;_Vector2;Vector 2;24;0;Create;True;0;0;0;False;0;False;0.5,0.5,0,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;194;-6908.403,-2459.063;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;196;-6887.903,-2260.563;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;197;-6886.903,-2355.563;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;193;-6907.403,-2554.063;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-7260.76,-2256.559;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;273;-7391.953,4568.076;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-7456.291,4466.312;Inherit;False;271;MatCapUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;274;-7629.938,3749.36;Inherit;False;Constant;_Vector1;Vector 1;24;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,0.5;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;276;-7370.442,4121.652;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;29;-6678.53,-2596.596;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;-7432.781,4037.888;Inherit;False;271;MatCapUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-6913.919,-2143.583;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;38;-8606.663,-1013.226;Inherit;False;Property;_Fresnel;Fresnel;19;0;Create;True;0;0;0;False;0;False;0,1,5;0,0.5,1.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;304;-5357.877,3256.712;Inherit;True;Property;_SmoothTex;SmoothTex;29;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;31;-6699.994,-2417.848;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-5338.055,3493.287;Inherit;False;Property;_Smoothness;Smoothness;31;0;Create;True;0;0;0;False;0;False;1;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-8606.591,-1243.899;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;280;-7392.408,4730.046;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;277;-7370.898,4283.622;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;281;-7619.756,3324.056;Inherit;False;Constant;_Vector0;Vector 0;24;0;Create;True;0;0;0;False;0;False;0.5,0.5,0,0.5;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;89;-3164.479,-2183.306;Inherit;False;1525.385;680.1929;LightAtten;10;99;98;97;96;95;94;93;92;91;90;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;279;-7218.323,4488.858;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-6402.528,-2199.211;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;283;-7390.07,3608.904;Inherit;False;271;MatCapUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-7196.813,4042.434;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;41;-8289.567,-1258.303;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;282;-7327.731,3692.668;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;257;-8627.99,-453.1382;Inherit;False;1801.059;576.8789;Comment;11;246;247;248;249;250;251;252;253;254;255;256;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-6436.218,-2463.87;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-4961.231,3403.139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;-7154.102,3613.45;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;-7358.22,3179.467;Inherit;False;271;MatCapUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-5638.969,-2141.606;Inherit;False;Property;_BEmisStr;BEmisStr;26;0;Create;True;0;0;0;False;0;False;1;6.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;286;-7328.187,3854.638;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;287;-7317.55,3267.364;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-5636.094,-2301.875;Inherit;False;Property;_AEmisStr;AEmisStr;25;0;Create;True;0;0;0;False;0;False;1;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;288;-6995.022,4045.735;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;36;-6015.426,-2233.511;Inherit;True;Property;_TextureSample0;Texture Sample 0;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;37;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;57;-7601.294,-1199.475;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-6018.323,-2482.711;Inherit;True;Property;_IORTex;IORTex;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-4774.648,3406.266;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;246;-8579.99,-236.19;Inherit;False;Property;_ScanPanner;ScanPanner;16;0;Create;True;0;0;0;False;0;False;0,0,0;-0.1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;90;-3114.479,-1892.511;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;91;-3098.191,-1687.651;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;289;-7016.532,4492.159;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-7144.6,3187.861;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;292;-6952.311,3616.751;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;-6684.448,4765.789;Inherit;False;307;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;293;-6748.478,4002.163;Inherit;True;Property;_TextureSample1;Texture Sample 1;27;0;Create;True;0;0;0;False;0;False;299;None;ab0f21a74fec8694fbf6290094566ae5;True;0;False;black;Auto;False;Instance;299;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;201;-5487.074,-2021.904;Inherit;False;0;189;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-5392.5,-2261.885;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-7397.479,-1206.703;Inherit;True;FreColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;249;-8386.99,-267.19;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-2844.734,-1821.966;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;295;-7318.004,3429.334;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;294;-6779.131,4451.634;Inherit;True;Property;_TextureSample2;Texture Sample 2;27;0;Create;True;0;0;0;False;0;False;299;None;ab0f21a74fec8694fbf6290094566ae5;True;0;False;black;Auto;False;Instance;299;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;248;-8400.99,-164.1902;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-5406.283,-2486.696;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;247;-8544.892,-403.1383;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;296;-6296.694,4233.627;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;297;-6736.245,3564.034;Inherit;True;Property;_TextureSample3;Texture Sample 3;27;0;Create;True;0;0;0;False;0;False;299;None;ab0f21a74fec8694fbf6290094566ae5;True;0;False;black;Auto;False;Instance;299;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;176;-6228.367,-840.1969;Inherit;False;60;FreColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;250;-8208.327,-334.9477;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;100;-8652.173,909.3572;Inherit;False;4797.417;1871.557;FinalBaseColor;21;127;126;124;120;116;115;114;113;112;111;110;109;108;107;106;105;104;103;102;101;178;FinalBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;-6941.508,3215.862;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;93;-2531.132,-1803.006;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-5144.97,-2317.686;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;189;-5208.339,-2048.278;Inherit;True;Property;_EmisTex;EmisTex;10;0;Create;True;0;0;0;False;0;False;-1;None;e2f6d7f666b845f4ab53b2ff8185cc43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;128;-3206.615,-1172.249;Inherit;False;1433.131;591.2055;BaseColor;6;154;71;129;50;1;3;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-6029.064,-713.8585;Inherit;False;Property;_FreStr;FreStr;20;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-8610.179,1742.375;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;220;-4348.729,3147.983;Inherit;False;2446.695;1310.092;ReflectColor;15;234;233;232;231;230;229;228;227;226;225;224;121;123;119;308;ReflectColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-7914.82,7.740333;Inherit;False;Property;_ScanlineIntensity;ScanlineIntensity;17;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;300;-6238.107,3707.15;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-4799.325,-2178.478;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;94;-2291.229,-1824.113;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;214;-5986.582,-833.0741;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;252;-7886.114,-166.2508;Inherit;False;Property;_ScanColor;ScanColor;15;0;Create;True;0;0;0;False;0;False;0.990566,0.990566,0.990566,1;0.504717,0.5680811,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;251;-7967.583,-357.7572;Inherit;True;Property;_ScanTex;ScanTex;14;0;Create;True;0;0;0;False;0;False;-1;None;6fda4a099411a18468456111546c16ee;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;299;-6679.96,3164.188;Inherit;True;Property;_MatCapTex;MatCapTex;27;0;Create;True;0;0;0;False;0;False;-1;None;ab0f21a74fec8694fbf6290094566ae5;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;-8354.181,1998.376;Inherit;False;Property;_Power;Power;6;0;Create;True;0;0;0;False;0;False;7;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-5780.822,-842.0436;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;301;-6183.657,3255.283;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-4522.313,-2321.709;Inherit;False;IORColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;103;-8370.181,1758.375;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;95;-2136.281,-1791.797;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-3171.615,-1119.249;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;e2f6d7f666b845f4ab53b2ff8185cc43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;224;-4205.441,3375.943;Inherit;False;Property;_SmoothnessMaxMin;SmoothnessMaxMin;30;0;Create;True;0;0;0;False;0;False;0.95,0.01;0.999,0.001;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;-7489.321,-323.6992;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;308;-4030.822,3517.866;Inherit;False;307;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-2599.857,-954.859;Inherit;False;Property;_MainColor;MainColor;4;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.3947574,0.233001,0.6415094,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-2288.192,-1106.524;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-1875.34,-1790.031;Inherit;True;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;105;-8098.181,1774.376;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;255;-7270.306,-322.9052;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-5605.937,-1114.025;Inherit;False;63;IORColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;302;-5863.137,3152.801;Inherit;True;MatCap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;210;-5522.482,-853.537;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-3577.083,3673.18;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-8082.181,2030.376;Inherit;False;Property;_Mul;Mul;7;0;Create;True;0;0;0;False;0;False;20;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;225;-3709.814,3403.563;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;227;-3904.941,3336.524;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-7855.281,1633.476;Inherit;False;96;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;207;-5261.958,-1163.775;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-3439.892,3950.19;Inherit;False;302;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;48;-5076.008,-941.4964;Inherit;False;Property;_EmissColor;EmissColor;11;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.08235294,0,0.3294118,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectDiffuseLighting;228;-3350.121,3678.492;Inherit;True;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-2049.755,-1119.584;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;130;-1622.124,-1171.275;Inherit;False;1181.666;633.2292;ShaowColor;4;134;133;132;131;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-3471.354,4083.246;Inherit;False;Property;_MatCapIntensity;MatCapIntensity;28;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-7850.486,1833.763;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;229;-3445.134,3340.477;Inherit;True;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;256;-7050.929,-333.9164;Inherit;False;ScanColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-2729.07,3378.568;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;258;-5062.449,-733.286;Inherit;False;256;ScanColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;132;-1487.694,-1051.5;Inherit;False;Property;_ShaowColor;ShaowColor;5;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-3070.415,3949.76;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-7586.179,1630.376;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-1476.998,-836.084;Inherit;False;129;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;-4764.139,-1187.724;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-4422.785,-449.6913;Inherit;False;Property;_BaseEmissStr;BaseEmissStr;12;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-4528.264,-676.2776;Inherit;False;Property;_AnimaEmisStr;AnimaEmisStr;13;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-2610.236,3663.552;Inherit;False;Property;_ReflectIntensity;ReflectIntensity;32;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;259;-4474.139,-1124.622;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;232;-2529.088,3377.954;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-994.3943,-1020.094;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;109;-7362.178,1582.377;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-4237.107,-1103.997;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;111;-7170.178,1582.377;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-688.5662,-1028.52;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-2327.16,3369.763;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;180;-3663.43,964.3444;Inherit;False;1757.696;766.3817;FinalOpacity;10;181;69;51;52;45;14;67;157;156;72;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2821.33,-841.2681;Inherit;False;MainTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-7315.75,1819.339;Inherit;False;Property;_ShdowIntensity;ShdowIntensity;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-2684.127,-2058.065;Inherit;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-2825.822,-1073.95;Inherit;False;MainTexRChanel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-6968.336,1589.143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;98;-2442.549,-2076.62;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;-3579.631,1469.867;Inherit;False;154;MainTexRChanel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-2158.887,3350.51;Inherit;True;ReflectColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-3922.529,-1088.394;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-3593.047,1273.316;Inherit;False;71;MainTexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-7635.891,1389.105;Inherit;True;129;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-7647.845,1076.917;Inherit;True;134;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-3049.097,1018.966;Inherit;True;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;157;-3330.574,1308.953;Inherit;False;Property;_RChanelIsAlpha;RChanelIsAlpha;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-6712.282,1896.349;Inherit;False;174;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-3053.762,1466.802;Inherit;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;0;False;0;False;1;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-6706.849,1673.296;Inherit;True;234;ReflectColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;116;-6694.599,1395.451;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-2087.531,-2079.739;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;51;-2717.053,1065.883;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-6137.459,1703.922;Inherit;False;99;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;-6230.168,1404.839;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;69;-2446.225,1059.171;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-5889.023,1398.093;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-5398.007,1434;Inherit;False;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;181;-2228.298,1049.194;Inherit;True;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-9699.431,-1703.568;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-3570.196,1054.266;Inherit;True;65;IORAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;1054.207,588.0831;Inherit;False;127;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;-8235.953,-1016.032;Inherit;False;Property;_FreColor;FreColor;18;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.3812499,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-7861.137,-939.2531;Inherit;False;FreAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-3240.222,1142.125;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-7907.629,-1220.729;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-4503.608,-2075.734;Inherit;False;IORAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;1051.07,489.5036;Inherit;False;181;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;165;-10011.5,-1702.753;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1300.391,280.691;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Cloth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;162;0;160;0
WireConnection;19;0;15;0
WireConnection;263;0;261;0
WireConnection;263;1;262;0
WireConnection;22;0;19;0
WireConnection;20;0;16;0
WireConnection;20;1;17;0
WireConnection;265;0;263;0
WireConnection;21;0;18;0
WireConnection;188;0;162;3
WireConnection;267;0;265;0
WireConnection;267;1;264;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;23;2;20;0
WireConnection;185;0;162;1
WireConnection;185;1;162;2
WireConnection;185;2;188;0
WireConnection;268;0;267;0
WireConnection;268;1;266;0
WireConnection;24;0;23;0
WireConnection;186;0;162;0
WireConnection;186;1;185;0
WireConnection;271;0;268;0
WireConnection;163;0;186;0
WireConnection;194;0;192;3
WireConnection;194;1;192;4
WireConnection;196;0;195;3
WireConnection;196;1;195;4
WireConnection;197;0;195;1
WireConnection;197;1;195;2
WireConnection;193;0;192;1
WireConnection;193;1;192;2
WireConnection;26;0;24;0
WireConnection;26;1;24;1
WireConnection;273;0;270;1
WireConnection;273;1;270;2
WireConnection;276;0;269;1
WireConnection;276;1;269;2
WireConnection;29;0;28;0
WireConnection;29;1;193;0
WireConnection;29;2;194;0
WireConnection;30;0;26;0
WireConnection;30;1;24;2
WireConnection;31;0;28;0
WireConnection;31;1;197;0
WireConnection;31;2;196;0
WireConnection;280;0;270;3
WireConnection;280;1;270;4
WireConnection;277;0;269;3
WireConnection;277;1;269;4
WireConnection;279;0;275;0
WireConnection;279;1;273;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;278;0;272;0
WireConnection;278;1;276;0
WireConnection;41;0;183;0
WireConnection;41;1;38;1
WireConnection;41;2;38;2
WireConnection;41;3;38;3
WireConnection;282;0;274;1
WireConnection;282;1;274;2
WireConnection;33;0;29;0
WireConnection;33;1;30;0
WireConnection;306;0;304;1
WireConnection;306;1;221;0
WireConnection;284;0;283;0
WireConnection;284;1;282;0
WireConnection;286;0;274;3
WireConnection;286;1;274;4
WireConnection;287;0;281;1
WireConnection;287;1;281;2
WireConnection;288;0;278;0
WireConnection;288;1;277;0
WireConnection;36;1;32;0
WireConnection;57;0;41;0
WireConnection;37;1;33;0
WireConnection;307;0;306;0
WireConnection;289;0;279;0
WireConnection;289;1;280;0
WireConnection;291;0;285;0
WireConnection;291;1;287;0
WireConnection;292;0;284;0
WireConnection;292;1;286;0
WireConnection;293;1;288;0
WireConnection;42;0;36;1
WireConnection;42;1;35;0
WireConnection;60;0;57;0
WireConnection;249;0;246;1
WireConnection;249;1;246;2
WireConnection;92;0;90;0
WireConnection;92;1;91;1
WireConnection;295;0;281;3
WireConnection;295;1;281;4
WireConnection;294;1;289;0
WireConnection;248;0;246;3
WireConnection;39;0;37;1
WireConnection;39;1;34;0
WireConnection;296;0;294;0
WireConnection;296;1;293;0
WireConnection;296;2;290;0
WireConnection;297;1;292;0
WireConnection;250;0;247;0
WireConnection;250;2;249;0
WireConnection;250;1;248;0
WireConnection;298;0;291;0
WireConnection;298;1;295;0
WireConnection;93;0;92;0
WireConnection;43;0;39;0
WireConnection;43;1;42;0
WireConnection;189;1;201;0
WireConnection;300;0;296;0
WireConnection;300;1;297;0
WireConnection;300;2;290;0
WireConnection;49;0;43;0
WireConnection;49;1;189;1
WireConnection;94;0;93;0
WireConnection;94;1;93;1
WireConnection;214;0;176;0
WireConnection;251;1;250;0
WireConnection;299;1;298;0
WireConnection;205;0;214;0
WireConnection;205;1;206;0
WireConnection;301;0;300;0
WireConnection;301;1;299;0
WireConnection;301;2;290;0
WireConnection;63;0;49;0
WireConnection;103;3;101;0
WireConnection;95;0;94;0
WireConnection;95;1;93;2
WireConnection;254;0;251;1
WireConnection;254;1;252;0
WireConnection;254;2;253;0
WireConnection;50;0;1;0
WireConnection;50;1;3;0
WireConnection;96;0;95;0
WireConnection;105;0;103;0
WireConnection;105;1;102;0
WireConnection;255;0;254;0
WireConnection;302;0;301;0
WireConnection;210;0;205;0
WireConnection;225;0;224;2
WireConnection;225;1;224;1
WireConnection;225;2;308;0
WireConnection;207;1;175;0
WireConnection;207;2;210;0
WireConnection;228;0;226;0
WireConnection;129;0;50;0
WireConnection;106;0;105;0
WireConnection;106;1;104;0
WireConnection;229;0;227;0
WireConnection;229;1;225;0
WireConnection;256;0;255;0
WireConnection;230;0;229;0
WireConnection;230;1;228;0
WireConnection;123;0;121;0
WireConnection;123;1;119;0
WireConnection;108;0;107;0
WireConnection;108;1;106;0
WireConnection;215;0;207;0
WireConnection;215;1;48;0
WireConnection;259;0;215;0
WireConnection;259;1;258;0
WireConnection;232;0;230;0
WireConnection;232;1;123;0
WireConnection;133;0;132;0
WireConnection;133;1;131;0
WireConnection;109;0;108;0
WireConnection;190;0;259;0
WireConnection;190;1;56;0
WireConnection;190;2;218;0
WireConnection;111;0;109;0
WireConnection;134;0;133;0
WireConnection;233;0;232;0
WireConnection;233;1;231;0
WireConnection;71;0;1;4
WireConnection;154;0;1;1
WireConnection;114;0;111;0
WireConnection;114;1;110;0
WireConnection;98;1;92;0
WireConnection;98;0;97;0
WireConnection;234;0;233;0
WireConnection;174;0;190;0
WireConnection;157;1;72;0
WireConnection;157;0;156;0
WireConnection;116;0;113;0
WireConnection;116;1;112;0
WireConnection;116;2;114;0
WireConnection;99;0;98;0
WireConnection;51;0;52;0
WireConnection;51;1;157;0
WireConnection;51;2;45;0
WireConnection;120;0;116;0
WireConnection;120;1;115;0
WireConnection;120;2;178;0
WireConnection;69;0;51;0
WireConnection;126;0;120;0
WireConnection;126;1;124;0
WireConnection;127;0;126;0
WireConnection;181;0;69;0
WireConnection;164;0;165;0
WireConnection;66;0;41;0
WireConnection;65;0;43;0
WireConnection;0;9;182;0
WireConnection;0;13;166;0
ASEEND*/
//CHKSM=22E746BF5F27BA3517C0CE924FB4F6A553BDC5F5