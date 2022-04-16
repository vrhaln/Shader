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
		_MatCapIntensityMaxMin("MatCapIntensityMaxMin", Vector) = (0.95,0.01,0,0)
		_BaseEmissStr("BaseEmissStr", Float) = 1
		_AnimaEmisStr("AnimaEmisStr", Range( 0 , 1)) = 1
		_SmoothTex("SmoothTex", 2D) = "white" {}
		[HDR]_EmissColor("EmissColor", Color) = (1,1,1,1)
		_SmoothnessMaxMin("SmoothnessMaxMin", Vector) = (0.95,0.01,0,0)
		_Fresnel("Fresnel", Vector) = (0,1,5,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_FreStr("FreStr", Float) = 1
		_ReflectIntensity("ReflectIntensity", Range( 0 , 1)) = 0.5
		_IORTex("IORTex", 2D) = "white" {}
		_IOR("IOR", Float) = 3
		_NoiseTiling1("NoiseTiling1", Vector) = (0.5,0.5,0,0)
		_NoiseTiling2("NoiseTiling2", Vector) = (2,2.5,0,0)
		_AEmisStr("AEmisStr", Float) = 1
		_BEmisStr("BEmisStr", Float) = 1
		_MatCapTex("MatCapTex", 2D) = "black" {}
		_MatCapIntensity("MatCapIntensity", Float) = 1
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
		uniform float2 _MatCapIntensityMaxMin;
		uniform float _ReflectIntensity;
		uniform float _MatCapIntensity;
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
			float Smoothness245 = tex2D( _SmoothTex, uv_SmoothTex ).r;
			float lerpResult225 = lerp( _SmoothnessMaxMin.y , _SmoothnessMaxMin.x , ( Smoothness245 * _Smoothness ));
			Unity_GlossyEnvironmentData g229 = UnityGlossyEnvironmentSetup( lerpResult225, data.worldViewDir, indirectNormal229, float3(0,0,0));
			float3 indirectSpecular229 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal229, g229 );
			UnityGI gi228 = gi;
			float3 diffNorm228 = WorldNormal163;
			gi228 = UnityGI_Base( data, 1, diffNorm228 );
			float3 indirectDiffuse228 = gi228.indirect.diffuse + diffNorm228 * 0.0001;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 MatCap85 = tex2D( _MatCapTex, ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy + 1.0 ) * 0.5 ) );
			float4 lerpResult242 = lerp( ( MatCap85 * _MatCapIntensityMaxMin.y ) , ( MatCap85 * _MatCapIntensityMaxMin.x ) , Smoothness245);
			float4 ReflectColor234 = ( ( float4( ( indirectSpecular229 * indirectDiffuse228 ) , 0.0 ) + ( lerpResult242 * _Smoothness ) ) * _ReflectIntensity );
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
			float4 EmissionColor174 = ( ( ( ( MatCap85 * _MatCapIntensity ) + lerpResult207 ) * _EmissColor ) * _AnimaEmisStr * _BaseEmissStr );
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
-1722;129;1599;826;7670.321;2190.627;1.549105;True;True
Node;AmplifyShaderEditor.CommentaryNode;167;-8692.489,-2194.988;Inherit;False;5312.646;2662.305;EmissionColor;20;59;62;174;175;176;56;190;205;206;207;210;214;215;48;121;213;123;218;119;219;EmissionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;62;-8637.278,-2004.297;Inherit;False;4704.647;1203.248;IORColor;35;49;42;39;43;34;35;37;36;33;32;31;29;30;28;26;24;23;20;21;22;19;16;17;18;15;63;65;189;192;193;194;195;196;197;201;IORColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-10573.3,-2143.341;Inherit;False;1650.118;681.2457;WorldNormal&ViewDir;8;165;164;163;162;160;185;186;188;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;15;-8582.278,-1493.094;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;160;-10546.53,-2061.503;Inherit;True;Property;_NormalMap;NormalMap;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;19;-8305.896,-1500.8;Inherit;False;World;Tangent;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-8403.484,-1205.313;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-8401.982,-1102.932;Inherit;False;Property;_IOR;IOR;22;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;162;-10252.53,-2058.93;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;18;-8372.27,-1712.701;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;22;-8039.895,-1492.8;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;188;-9963.247,-1913.597;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;21;-8060.03,-1648.787;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-8123.483,-1185.313;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RefractOpVec;23;-7810.104,-1520.289;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;185;-9793.762,-1994.714;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;186;-9574.648,-2051.066;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;75;-8620.226,3271.132;Inherit;False;1603.713;554.2144;MatCap;10;85;84;83;82;81;80;79;78;77;76;MatCap;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;195;-7019.354,-1630.377;Inherit;False;Property;_NoiseTiling2;NoiseTiling2;24;0;Create;True;0;0;0;False;0;False;2,2.5,0,0;0.2,0.2,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;192;-7016.354,-1818.377;Inherit;False;Property;_NoiseTiling1;NoiseTiling1;23;0;Create;True;0;0;0;False;0;False;0.5,0.5,0,0;0.1,0.1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-7592.846,-1507.574;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;197;-6809.854,-1627.877;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;59;-8616.212,-580.6173;Inherit;False;2104.219;700.5641;FreColor;8;57;44;41;40;38;60;66;183;FreColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;194;-6831.354,-1731.377;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;196;-6810.854,-1532.877;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-9303.056,-2064.742;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;76;-8572.226,3447.132;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;26;-7183.711,-1528.873;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;193;-6830.354,-1826.377;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewMatrixNode;77;-8492.228,3319.132;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-6955.441,-1954.297;Inherit;False;0;37;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-6836.87,-1415.898;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;29;-6601.481,-1868.91;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-8529.543,-516.213;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;38;-8529.615,-285.5404;Inherit;False;Property;_Fresnel;Fresnel;17;0;Create;True;0;0;0;False;0;False;0,1,5;0,1,2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-8300.228,3383.132;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;31;-6622.945,-1690.162;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;89;-3164.479,-2183.306;Inherit;False;1525.385;680.1929;LightAtten;10;99;98;97;96;95;94;93;92;91;90;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-8076.227,3495.132;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;79;-8108.227,3367.132;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;41;-8212.52,-530.6172;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-6359.169,-1736.184;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-6325.479,-1471.525;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;36;-5938.377,-1505.825;Inherit;True;Property;_TextureSample0;Texture Sample 0;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;37;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-5561.92,-1413.92;Inherit;False;Property;_BEmisStr;BEmisStr;26;0;Create;True;0;0;0;False;0;False;1;2.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;91;-3098.191,-1687.651;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;220;-3646.4,1026.057;Inherit;False;2446.695;1310.092;ReflectColor;25;243;242;241;240;239;238;237;236;235;234;233;232;231;230;229;228;227;226;225;224;223;222;221;244;245;ReflectColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-7948.228,3559.131;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-5559.045,-1574.189;Inherit;False;Property;_AEmisStr;AEmisStr;25;0;Create;True;0;0;0;False;0;False;1;5.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-7900.228,3367.132;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-5941.274,-1755.025;Inherit;True;Property;_IORTex;IORTex;21;0;Create;True;0;0;0;False;0;False;-1;None;21c21b70a3522a54f9fca75e5f9ddec2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;57;-7524.245,-471.7892;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;90;-3114.479,-1892.511;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-2844.734,-1821.966;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;244;-1888.088,2017.034;Inherit;True;Property;_SmoothTex;SmoothTex;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;201;-5410.025,-1294.218;Inherit;False;0;189;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-7320.43,-479.0175;Inherit;True;FreColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-5329.234,-1759.01;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-7756.228,3383.132;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-5315.45,-1534.199;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;100;-8652.173,909.3572;Inherit;False;4797.417;1871.557;FinalBaseColor;21;127;126;124;120;116;115;114;113;112;111;110;109;108;107;106;105;104;103;102;101;178;FinalBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;189;-5131.29,-1320.592;Inherit;True;Property;_EmisTex;EmisTex;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;93;-2531.132,-1803.006;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;176;-6306.158,-62.84465;Inherit;False;60;FreColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;245;-1485.116,2038.546;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;84;-7580.229,3351.132;Inherit;True;Property;_MatCapTex;MatCapTex;28;0;Create;True;0;0;0;False;0;False;-1;None;1ef873e94bdd29e408d495dfbc12fd01;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-5067.921,-1590;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;214;-6064.374,-55.72183;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-8610.179,1742.375;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-6106.856,63.4937;Inherit;False;Property;_FreStr;FreStr;19;0;Create;True;0;0;0;False;0;False;1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-7244.229,3346.561;Inherit;False;MatCap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-3570.977,2108.644;Inherit;False;Property;_Smoothness;Smoothness;18;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;128;-3206.615,-1172.249;Inherit;False;1433.131;591.2055;BaseColor;6;154;71;129;50;1;3;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;-3575.298,1471.463;Inherit;False;245;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-4722.276,-1450.792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;94;-2291.229,-1824.113;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-5858.614,-64.69135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-3181.607,1445.177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;224;-3601.72,1259.377;Inherit;False;Property;_SmoothnessMaxMin;SmoothnessMaxMin;16;0;Create;True;0;0;0;False;0;False;0.95,0.01;0.95,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;239;-3169.028,1767.815;Inherit;False;85;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-2599.857,-954.859;Inherit;False;Property;_MainColor;MainColor;4;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.3019608,0.3607843,0.509804,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;238;-3235.912,1857.159;Inherit;False;Property;_MatCapIntensityMaxMin;MatCapIntensityMaxMin;11;0;Create;True;0;0;0;False;0;False;0.95,0.01;0.95,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;102;-8354.181,1998.376;Inherit;False;Property;_Power;Power;6;0;Create;True;0;0;0;False;0;False;7;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-3171.615,-1119.249;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;3e663fa77d5c95d49b811bbe73be97d3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;103;-8370.181,1758.375;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-4445.264,-1594.023;Inherit;False;IORColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;95;-2136.281,-1791.797;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;210;-5600.274,-76.18476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;237;-2933.794,1993.658;Inherit;False;245;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-2895.344,1878.148;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;227;-3202.613,1214.599;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-2874.755,1551.255;Inherit;False;163;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;225;-3007.486,1281.638;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;-2892.163,1759.716;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-6059.982,-691.8328;Inherit;False;85;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-6039.091,-490.9064;Inherit;False;Property;_MatCapIntensity;MatCapIntensity;29;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-2288.192,-1106.524;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-1875.34,-1790.031;Inherit;True;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;105;-8098.181,1774.376;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-5683.729,-336.6736;Inherit;False;63;IORColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-8082.181,2030.376;Inherit;False;Property;_Mul;Mul;7;0;Create;True;0;0;0;False;0;False;20;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;228;-2647.793,1556.567;Inherit;True;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-7855.281,1633.476;Inherit;False;96;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-7850.486,1833.763;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-5633.152,-652.3928;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectSpecularLight;229;-2742.806,1218.552;Inherit;True;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;242;-2648.757,1798.117;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-2049.755,-1119.584;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;207;-5339.75,-386.4232;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;130;-1622.124,-1171.275;Inherit;False;1181.666;633.2292;ShaowColor;4;134;133;132;131;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;132;-1487.694,-1051.5;Inherit;False;Property;_ShaowColor;ShaowColor;5;0;Create;True;0;0;0;False;0;False;0,0,0,1;0.1614008,0.1646992,0.2924528,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;-4942.777,-171.3626;Inherit;False;Property;_EmissColor;EmissColor;15;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.08235294,0,0.3294118,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;219;-4949.275,-501.2931;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-2286.79,1806.803;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-7586.179,1630.376;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-2026.741,1256.643;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-1476.998,-836.084;Inherit;False;129;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-1877.583,1400.113;Inherit;False;Property;_ReflectIntensity;ReflectIntensity;20;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-4523.992,-162.2813;Inherit;False;Property;_AnimaEmisStr;AnimaEmisStr;13;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-994.3943,-1020.094;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;-4465.556,-375.5118;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;109;-7362.178,1582.377;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-4418.513,64.3051;Inherit;False;Property;_BaseEmissStr;BaseEmissStr;12;0;Create;True;0;0;0;False;0;False;1;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;232;-1826.76,1256.029;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;111;-7170.178,1582.377;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-1624.832,1247.838;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-4160.058,-376.3117;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-688.5662,-1028.52;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;180;-3544.253,2613.163;Inherit;False;1757.696;766.3817;FinalOpacity;10;181;69;51;52;45;14;67;157;156;72;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2821.33,-841.2681;Inherit;False;MainTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-2684.127,-2058.065;Inherit;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-2825.822,-1073.95;Inherit;False;MainTexRChanel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-7315.75,1819.339;Inherit;False;Property;_ShdowIntensity;ShdowIntensity;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-3845.48,-360.7081;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;98;-2442.549,-2076.62;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-3473.87,2922.135;Inherit;False;71;MainTexAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-7647.845,1076.917;Inherit;True;134;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-6968.336,1589.143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-7635.891,1389.105;Inherit;True;129;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;-3460.454,3118.686;Inherit;False;154;MainTexRChanel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-1456.559,1228.584;Inherit;True;ReflectColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2934.586,3115.621;Inherit;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-6712.282,1896.349;Inherit;False;174;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;116;-6694.599,1395.451;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;157;-3211.398,2957.772;Inherit;False;Property;_RChanelIsAlpha;RChanelIsAlpha;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-6706.849,1673.296;Inherit;True;234;ReflectColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2929.921,2667.785;Inherit;True;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-2087.531,-2079.739;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;-6230.168,1404.839;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;51;-2597.877,2714.702;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-6137.459,1703.922;Inherit;False;99;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-5889.023,1398.093;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;69;-2327.049,2707.99;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-5398.007,1434;Inherit;False;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;181;-2109.122,2698.013;Inherit;True;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-8158.905,-288.3461;Inherit;False;Property;_FreColor;FreColor;27;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.3812499,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;217;-5309.622,-96.9947;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-3121.046,2790.944;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;165;-10011.5,-1702.753;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;-9699.431,-1703.568;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;236;-3328.191,1391.007;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;-5143.612,-806.305;Inherit;False;60;FreColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-4426.559,-1348.048;Inherit;False;IORAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-7784.088,-211.5674;Inherit;False;FreAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-3451.019,2703.085;Inherit;True;65;IORAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;235;-2365.307,1341.119;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;1051.07,489.5036;Inherit;False;181;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;1054.207,588.0831;Inherit;False;127;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-7830.58,-493.0434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1300.391,280.691;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Cloth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;15;0
WireConnection;162;0;160;0
WireConnection;22;0;19;0
WireConnection;188;0;162;3
WireConnection;21;0;18;0
WireConnection;20;0;16;0
WireConnection;20;1;17;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;23;2;20;0
WireConnection;185;0;162;1
WireConnection;185;1;162;2
WireConnection;185;2;188;0
WireConnection;186;0;162;0
WireConnection;186;1;185;0
WireConnection;24;0;23;0
WireConnection;197;0;195;1
WireConnection;197;1;195;2
WireConnection;194;0;192;3
WireConnection;194;1;192;4
WireConnection;196;0;195;3
WireConnection;196;1;195;4
WireConnection;163;0;186;0
WireConnection;26;0;24;0
WireConnection;26;1;24;1
WireConnection;193;0;192;1
WireConnection;193;1;192;2
WireConnection;30;0;26;0
WireConnection;30;1;24;2
WireConnection;29;0;28;0
WireConnection;29;1;193;0
WireConnection;29;2;194;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;31;0;28;0
WireConnection;31;1;197;0
WireConnection;31;2;196;0
WireConnection;79;0;78;0
WireConnection;41;0;183;0
WireConnection;41;1;38;1
WireConnection;41;2;38;2
WireConnection;41;3;38;3
WireConnection;33;0;29;0
WireConnection;33;1;30;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;36;1;32;0
WireConnection;81;0;79;0
WireConnection;81;1;80;0
WireConnection;37;1;33;0
WireConnection;57;0;41;0
WireConnection;92;0;90;0
WireConnection;92;1;91;1
WireConnection;60;0;57;0
WireConnection;39;0;37;1
WireConnection;39;1;34;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;42;0;36;1
WireConnection;42;1;35;0
WireConnection;189;1;201;0
WireConnection;93;0;92;0
WireConnection;245;0;244;1
WireConnection;84;1;83;0
WireConnection;43;0;39;0
WireConnection;43;1;42;0
WireConnection;214;0;176;0
WireConnection;85;0;84;0
WireConnection;49;0;43;0
WireConnection;49;1;189;1
WireConnection;94;0;93;0
WireConnection;94;1;93;1
WireConnection;205;0;214;0
WireConnection;205;1;206;0
WireConnection;223;0;222;0
WireConnection;223;1;221;0
WireConnection;103;3;101;0
WireConnection;63;0;49;0
WireConnection;95;0;94;0
WireConnection;95;1;93;2
WireConnection;210;0;205;0
WireConnection;241;0;239;0
WireConnection;241;1;238;2
WireConnection;225;0;224;2
WireConnection;225;1;224;1
WireConnection;225;2;223;0
WireConnection;240;0;239;0
WireConnection;240;1;238;1
WireConnection;50;0;1;0
WireConnection;50;1;3;0
WireConnection;96;0;95;0
WireConnection;105;0;103;0
WireConnection;105;1;102;0
WireConnection;228;0;226;0
WireConnection;106;0;105;0
WireConnection;106;1;104;0
WireConnection;123;0;121;0
WireConnection;123;1;119;0
WireConnection;229;0;227;0
WireConnection;229;1;225;0
WireConnection;242;0;241;0
WireConnection;242;1;240;0
WireConnection;242;2;237;0
WireConnection;129;0;50;0
WireConnection;207;1;175;0
WireConnection;207;2;210;0
WireConnection;219;0;123;0
WireConnection;219;1;207;0
WireConnection;243;0;242;0
WireConnection;243;1;221;0
WireConnection;108;0;107;0
WireConnection;108;1;106;0
WireConnection;230;0;229;0
WireConnection;230;1;228;0
WireConnection;133;0;132;0
WireConnection;133;1;131;0
WireConnection;215;0;219;0
WireConnection;215;1;48;0
WireConnection;109;0;108;0
WireConnection;232;0;230;0
WireConnection;232;1;243;0
WireConnection;111;0;109;0
WireConnection;233;0;232;0
WireConnection;233;1;231;0
WireConnection;190;0;215;0
WireConnection;190;1;56;0
WireConnection;190;2;218;0
WireConnection;134;0;133;0
WireConnection;71;0;1;4
WireConnection;154;0;1;1
WireConnection;174;0;190;0
WireConnection;98;1;92;0
WireConnection;98;0;97;0
WireConnection;114;0;111;0
WireConnection;114;1;110;0
WireConnection;234;0;233;0
WireConnection;116;0;113;0
WireConnection;116;1;112;0
WireConnection;116;2;114;0
WireConnection;157;1;72;0
WireConnection;157;0;156;0
WireConnection;99;0;98;0
WireConnection;120;0;116;0
WireConnection;120;1;115;0
WireConnection;120;2;178;0
WireConnection;51;0;52;0
WireConnection;51;1;157;0
WireConnection;51;2;45;0
WireConnection;126;0;120;0
WireConnection;126;1;124;0
WireConnection;69;0;51;0
WireConnection;127;0;126;0
WireConnection;181;0;69;0
WireConnection;164;0;165;0
WireConnection;65;0;43;0
WireConnection;66;0;41;0
WireConnection;0;9;182;0
WireConnection;0;13;166;0
ASEEND*/
//CHKSM=FE0CBB02D56B0BD3CE4F378DDB5175DD55385248