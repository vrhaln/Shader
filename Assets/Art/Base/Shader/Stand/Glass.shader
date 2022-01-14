// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Glass"
{
	Properties
	{
		_MainColor("Main Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_SpecularColor("Specular Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_Shininess("Shininess", Range( 0.01 , 1)) = 0.1
		_Matcap("Matcap", 2D) = "white" {}
		_RefractMatcap("RefractMatcap", 2D) = "white" {}
		_Thinknessmap("Thinknessmap", 2D) = "black" {}
		_Noise("Noise", 2D) = "white" {}
		_RefreactIntensity("RefreactIntensity", Float) = 0
		_RefracColor("RefracColor", Color) = (0,0,0,0)
		_Color_Intendsity("Color_Intendsity", Float) = 0
		_NoiseIntensity("NoiseIntensity", Float) = 0
		_ThinknessIntensity("ThinknessIntensity", Range( 0 , 1)) = 0
		_NoisesizeMin("Noise size Min", Range( 0 , 1)) = 0
		_NoisesizeMax("Noise size Max", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
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

		uniform sampler2D _Matcap;
		uniform sampler2D _Thinknessmap;
		uniform float4 _Thinknessmap_ST;
		uniform float _ThinknessIntensity;
		uniform float4 _RefracColor;
		uniform float _Color_Intendsity;
		uniform sampler2D _RefractMatcap;
		uniform float _RefreactIntensity;
		uniform float _NoisesizeMin;
		uniform float _NoisesizeMax;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _NoiseIntensity;
		uniform float4 _MainColor;
		uniform float4 _SpecularColor;
		uniform float _Shininess;

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
			float4 temp_output_42_0_g1 = _MainColor;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToWorld26 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 1 ) ).xyz;
			float3 normalizeResult27 = normalize( objToWorld26 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 break29 = cross( normalizeResult27 , mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz );
			float2 appendResult30 = (float2(-break29.y , break29.x));
			float2 Matcap35 = (appendResult30*0.5 + 0.5);
			float4 tex2DNode12 = tex2D( _Matcap, Matcap35 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult41 = dot( ase_worldNormal , ase_worldViewDir );
			float smoothstepResult42 = smoothstep( 0.0 , 1.0 , dotResult41);
			float2 uv_Thinknessmap = i.uv_texcoord * _Thinknessmap_ST.xy + _Thinknessmap_ST.zw;
			float clampResult76 = clamp( ( ( 1.0 - smoothstepResult42 ) + ( tex2D( _Thinknessmap, uv_Thinknessmap ).r * _ThinknessIntensity ) ) , 0.0 , 1.0 );
			float Thickness55 = clampResult76;
			float dotResult82 = dot( ase_worldNormal , ase_worldViewDir );
			float smoothstepResult83 = smoothstep( _NoisesizeMin , _NoisesizeMax , dotResult82);
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float clampResult74 = clamp( ( ( 1.0 - ( smoothstepResult83 + tex2D( _Noise, uv_Noise ).r ) ) * Thickness55 * _NoiseIntensity ) , 0.0 , 1.0 );
			float Noise77 = clampResult74;
			float clampResult92 = clamp( ( Noise77 - Thickness55 ) , 0.0 , 1.0 );
			float clampResult50 = clamp( ( 0.0 + max( tex2DNode12.r , ( Thickness55 + clampResult92 ) ) ) , 0.0 , 1.0 );
			float4 temp_output_43_0_g1 = _SpecularColor;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g2 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float3 normalizeResult64_g1 = normalize( (WorldNormalVector( i , float3(0,0,1) )) );
			float dotResult19_g1 = dot( normalizeResult4_g2 , normalizeResult64_g1 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_40_0_g1 = ( ase_lightColor * ase_lightAtten );
			float dotResult14_g1 = dot( normalizeResult64_g1 , ase_worldlightDir );
			UnityGI gi34_g1 = gi;
			float3 diffNorm34_g1 = normalizeResult64_g1;
			gi34_g1 = UnityGI_Base( data, 1, diffNorm34_g1 );
			float3 indirectDiffuse34_g1 = gi34_g1.indirect.diffuse + diffNorm34_g1 * 0.0001;
			c.rgb = ( ( float4( (temp_output_43_0_g1).rgb , 0.0 ) * (temp_output_43_0_g1).a * pow( max( dotResult19_g1 , 0.0 ) , ( _Shininess * 128.0 ) ) * temp_output_40_0_g1 ) + ( ( ( temp_output_40_0_g1 * max( dotResult14_g1 , 0.0 ) ) + float4( indirectDiffuse34_g1 , 0.0 ) ) * float4( (temp_output_42_0_g1).rgb , 0.0 ) ) ).rgb;
			c.a = ( (temp_output_42_0_g1).a * clampResult50 );
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
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToWorld26 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 1 ) ).xyz;
			float3 normalizeResult27 = normalize( objToWorld26 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 break29 = cross( normalizeResult27 , mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz );
			float2 appendResult30 = (float2(-break29.y , break29.x));
			float2 Matcap35 = (appendResult30*0.5 + 0.5);
			float4 tex2DNode12 = tex2D( _Matcap, Matcap35 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult41 = dot( ase_worldNormal , ase_worldViewDir );
			float smoothstepResult42 = smoothstep( 0.0 , 1.0 , dotResult41);
			float2 uv_Thinknessmap = i.uv_texcoord * _Thinknessmap_ST.xy + _Thinknessmap_ST.zw;
			float clampResult76 = clamp( ( ( 1.0 - smoothstepResult42 ) + ( tex2D( _Thinknessmap, uv_Thinknessmap ).r * _ThinknessIntensity ) ) , 0.0 , 1.0 );
			float Thickness55 = clampResult76;
			float temp_output_45_0 = ( Thickness55 * _RefreactIntensity );
			float clampResult54 = clamp( temp_output_45_0 , 0.0 , 1.0 );
			float4 lerpResult53 = lerp( ( ( 1.0 - Thickness55 ) * ( _RefracColor * _Color_Intendsity ) ) , tex2D( _RefractMatcap, ( Matcap35 + temp_output_45_0 ) ) , clampResult54);
			float dotResult82 = dot( ase_worldNormal , ase_worldViewDir );
			float smoothstepResult83 = smoothstep( _NoisesizeMin , _NoisesizeMax , dotResult82);
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float clampResult74 = clamp( ( ( 1.0 - ( smoothstepResult83 + tex2D( _Noise, uv_Noise ).r ) ) * Thickness55 * _NoiseIntensity ) , 0.0 , 1.0 );
			float Noise77 = clampResult74;
			float clampResult92 = clamp( ( Noise77 - Thickness55 ) , 0.0 , 1.0 );
			o.Emission = ( tex2DNode12 + lerpResult53 + clampResult92 ).rgb;
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
Version=18100
-1515;64;1354;867;5526.365;3461.071;6.750602;True;True
Node;AmplifyShaderEditor.CommentaryNode;128;-4237.466,357.0201;Inherit;False;1559.187;700.4775;Thickness;11;40;39;41;42;124;60;125;43;61;76;55;Thickness;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;40;-4173.695,583.2692;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;39;-4187.465,407.0201;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;41;-3955.748,493.8678;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;126;-4288.205,-1334.113;Inherit;False;2585.205;841.2357;Noise;20;80;81;82;87;86;83;63;85;89;75;70;72;74;15;17;16;18;13;19;77;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;60;-3864.622,707.5728;Inherit;True;Property;_Thinknessmap;Thinknessmap;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;124;-3847.149,941.4976;Inherit;False;Property;_ThinknessIntensity;ThinknessIntensity;13;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;42;-3764.38,538.1242;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;127;-4270.074,-345.8087;Inherit;False;1940.093;512.9659;Matcap UV2;12;25;26;23;22;24;27;28;29;31;30;33;35;Matcap UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;81;-3238.265,-1107.864;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;80;-3252.035,-1284.113;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;43;-3584.185,594.4654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-3510.818,856.2366;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3265.662,-815.0249;Inherit;False;Property;_NoisesizeMax;Noise size Max;15;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;25;-4220.074,-295.8088;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-3259.182,-921.8463;Inherit;False;Property;_NoisesizeMin;Noise size Min;14;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-3364.889,688.5115;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;82;-3008.315,-1215.266;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;22;-3888.006,-15.84294;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;23;-3793.589,-113.9359;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.TransformPositionNode;26;-4004.965,-285.4953;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;63;-2934.838,-886.22;Inherit;True;Property;_Noise;Noise;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;76;-3143.188,708.7032;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;83;-2841.689,-1174.364;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-2902.28,690.2248;Inherit;True;Thickness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-2643.192,-1127.982;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;27;-3739.787,-228.1303;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-3680.589,-53.93578;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-2577.459,-698.2899;Inherit;False;55;Thickness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2576.181,-608.8774;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;89;-2416.682,-1103.855;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;28;-3515.787,-171.1303;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;29;-3332.716,-149.2515;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-2232.043,-889.9219;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;31;-3082.183,-57.31367;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;74;-2079.945,-886.0583;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2918.183,-126.3136;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1927,-876.4684;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-1318.705,-77.75432;Inherit;True;77;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;33;-2751.182,-83.31366;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1321.915,133.1521;Inherit;True;55;Thickness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-2553.98,-61.13318;Inherit;False;Matcap;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;90;-1017.858,52.19591;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1322.118,820.0516;Inherit;True;Property;_RefreactIntensity;RefreactIntensity;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-1301.359,713.6032;Inherit;False;55;Thickness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;92;-832.4113,78.75964;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1026.096,-165.1526;Inherit;True;55;Thickness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-1005.412,-333.9177;Inherit;False;35;Matcap;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;51;-996.8334,208.4896;Inherit;False;Property;_RefracColor;RefracColor;10;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-708.9348,-351.0999;Inherit;True;Property;_Matcap;Matcap;5;0;Create;True;0;0;False;0;False;-1;None;2d561e336fc518143995181d9405bfd3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-999.6832,384.0355;Inherit;False;Property;_Color_Intendsity;Color_Intendsity;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-789.3123,192.8479;Inherit;False;55;Thickness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-1334.771,403.365;Inherit;False;35;Matcap;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-367.8725,103.1893;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1047.13,736.5519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;49;-52.47712,118.7195;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;99;-612.2299,190.011;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-942.6146,528.2635;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-708.4465,303.6866;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;37;-741.1913,425.3289;Inherit;True;Property;_RefractMatcap;RefractMatcap;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;95;277.1833,132.2341;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;54;-804.278,672.5456;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-473.4117,236.8056;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;50;562.8413,134.6046;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;-302.8484,442.6431;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;115;547.9055,411.1683;Inherit;True;Blinn-Phong Light;0;;1;cf814dba44d007a4e958d2ddd5813da6;0;3;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;43;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;909.7275,121.5803;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-4030.789,-912.6624;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;17;-3891.066,-903.9001;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-3471.228,-955.8293;Inherit;False;matcap_uv;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;18;-3703.066,-868.9001;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-122.244,-130.7655;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;13;-4238.205,-874.5695;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;15;-4143.789,-972.6624;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1159.085,-34.38395;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Glass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;42;0;41;0
WireConnection;43;0;42;0
WireConnection;125;0;60;1
WireConnection;125;1;124;0
WireConnection;61;0;43;0
WireConnection;61;1;125;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;26;0;25;0
WireConnection;76;0;61;0
WireConnection;83;0;82;0
WireConnection;83;1;86;0
WireConnection;83;2;87;0
WireConnection;55;0;76;0
WireConnection;85;0;83;0
WireConnection;85;1;63;1
WireConnection;27;0;26;0
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;89;0;85;0
WireConnection;28;0;27;0
WireConnection;28;1;24;0
WireConnection;29;0;28;0
WireConnection;72;0;89;0
WireConnection;72;1;75;0
WireConnection;72;2;70;0
WireConnection;31;0;29;1
WireConnection;74;0;72;0
WireConnection;30;0;31;0
WireConnection;30;1;29;0
WireConnection;77;0;74;0
WireConnection;33;0;30;0
WireConnection;35;0;33;0
WireConnection;90;0;78;0
WireConnection;90;1;91;0
WireConnection;92;0;90;0
WireConnection;12;1;21;0
WireConnection;67;0;57;0
WireConnection;67;1;92;0
WireConnection;45;0;56;0
WireConnection;45;1;44;0
WireConnection;49;0;12;1
WireConnection;49;1;67;0
WireConnection;99;0;96;0
WireConnection;38;0;36;0
WireConnection;38;1;45;0
WireConnection;58;0;51;0
WireConnection;58;1;59;0
WireConnection;37;1;38;0
WireConnection;95;1;49;0
WireConnection;54;0;45;0
WireConnection;97;0;99;0
WireConnection;97;1;58;0
WireConnection;50;0;95;0
WireConnection;53;0;97;0
WireConnection;53;1;37;0
WireConnection;53;2;54;0
WireConnection;123;0;115;57
WireConnection;123;1;50;0
WireConnection;16;0;15;0
WireConnection;16;1;13;0
WireConnection;17;0;16;0
WireConnection;19;0;18;0
WireConnection;18;0;17;0
WireConnection;47;0;12;0
WireConnection;47;1;53;0
WireConnection;47;2;92;0
WireConnection;0;2;47;0
WireConnection;0;9;123;0
WireConnection;0;13;115;0
ASEEND*/
//CHKSM=ED2474244469D37FBD8E8DA155317264393C491E