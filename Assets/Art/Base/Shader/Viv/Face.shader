// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Face"
{
	Properties
	{
		_PixStr("PixStr", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,1)
		_ShaowColor("ShaowColor", Color) = (0,0,0,0)
		_Power("Power", Float) = 7
		_Mul("Mul", Float) = 20
		_SDFFaceLightmap("SDFFaceLightmap", 2D) = "white" {}
		_ShdowIntensity("ShdowIntensity", Range( 0 , 1)) = 1
		_NormalMap("NormalMap", 2D) = "bump" {}
		_SmoothTex("SmoothTex", 2D) = "black" {}
		_SmoothnessMaxMin("SmoothnessMaxMin", Vector) = (0.95,0.01,0,0)
		_ReflectFre("ReflectFre", Vector) = (0,1,5,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,1)
		_MainEmisStr("MainEmisStr", Range( 0 , 2)) = 1
		_ScanTex("ScanTex", 2D) = "white" {}
		_FreScalePower("FreScalePower", Vector) = (0,1.1,1.1,0)
		_FreScanTexTiling("FreScanTexTiling", Vector) = (1,1,0,0)
		_FreScanTexPanner("FreScanTexPanner", Vector) = (0,0,1,0)
		_EyeEmissionTex("EyeEmissionTex", 2D) = "white" {}
		[HDR]_EyeEmissionColor("EyeEmissionColor", Color) = (1,1,1,1)
		_EyeEmissStr("EyeEmissStr", Range( 0 , 2)) = 0
		_EyeScanTexTiling("EyeScanTexTiling", Vector) = (1,1,0,0)
		_EyeScanTexPanner("EyeScanTexPanner", Vector) = (0,0,1,0)
		_MatCapTex("MatCapTex", 2D) = "black" {}
		_MatCapIntensity("MatCapIntensity", Float) = 1
		_DisturTex("DisturTex", 2D) = "white" {}
		_DisturTexTiling("DisturTexTiling", Vector) = (1,1,0,0)
		_DisturTexPanner("DisturTexPanner", Vector) = (0,0,1,0)
		_DisturIntensity("DisturIntensity", Range( 0 , 1)) = 0
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
			float2 uv_texcoord;
			float3 worldPos;
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

		uniform float4 _ShaowColor;
		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform float _PixStr;
		uniform sampler2D _DisturTex;
		uniform float3 _DisturTexPanner;
		uniform float2 _DisturTexTiling;
		uniform float _DisturIntensity;
		uniform sampler2D _SDFFaceLightmap;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Power;
		uniform float _Mul;
		uniform float _ShdowIntensity;
		uniform sampler2D _MatCapTex;
		uniform float _MatCapIntensity;
		uniform float2 _SmoothnessMaxMin;
		uniform sampler2D _SmoothTex;
		uniform float4 _SmoothTex_ST;
		uniform float _Smoothness;
		uniform float3 _ReflectFre;
		uniform float4 _EyeEmissionColor;
		uniform float _EyeEmissStr;
		uniform sampler2D _EyeEmissionTex;
		uniform sampler2D _ScanTex;
		uniform float3 _EyeScanTexPanner;
		uniform float2 _EyeScanTexTiling;
		uniform float3 _FreScanTexPanner;
		uniform float2 _FreScanTexTiling;
		uniform float3 _FreScalePower;
		uniform float4 _EmissionColor;
		uniform float _MainEmisStr;

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
			float2 temp_cast_0 = (0.5).xx;
			float temp_output_53_0 = ( _PixStr * 10.0 );
			float2 PixUV63 = ( ( ceil( ( ( i.uv_texcoord - temp_cast_0 ) * temp_output_53_0 ) ) / temp_output_53_0 ) + 0.5 );
			float mulTime148 = _Time.y * _DisturTexPanner.z;
			float2 appendResult149 = (float2(_DisturTexPanner.x , _DisturTexPanner.y));
			float2 uv_TexCoord147 = i.uv_texcoord * _DisturTexTiling;
			float2 panner150 = ( mulTime148 * appendResult149 + uv_TexCoord147);
			float DisturUV151 = ( tex2D( _DisturTex, panner150 ).r * _DisturIntensity );
			float4 tex2DNode1 = tex2D( _MainTex, ( PixUV63 + DisturUV151 ) );
			float4 lerpResult157 = lerp( _MainColor , tex2DNode1 , tex2DNode1.a);
			float4 BaseColor61 = lerpResult157;
			float4 ShaowColor114 = ( _ShaowColor * BaseColor61 );
			float4 blendOpSrc142 = ShaowColor114;
			float4 blendOpDest142 = BaseColor61;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_90_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 break91 = temp_output_90_0;
			float LightAtten94 = max( max( break91.x , break91.y ) , break91.z );
			float3 _HeadForward = float3(0,0,1);
			float2 appendResult189 = (float2(_HeadForward.x , _HeadForward.z));
			float2 normalizeResult193 = normalize( appendResult189 );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 appendResult181 = (float2(ase_worldlightDir.x , ase_worldlightDir.z));
			float2 normalizeResult184 = normalize( appendResult181 );
			float dotResult196 = dot( normalizeResult193 , normalizeResult184 );
			float3 _HeadRight = float3(1,0,0);
			float2 appendResult182 = (float2(_HeadRight.x , _HeadRight.z));
			float2 normalizeResult183 = normalize( appendResult182 );
			float dotResult185 = dot( normalizeResult183 , normalizeResult184 );
			float temp_output_281_0 = ( dotResult185 > 0.0 ? 1.0 : 0.0 );
			float temp_output_194_0 = ( ( acos( dotResult185 ) / UNITY_PI ) * 2.0 );
			float2 uv_TexCoord192 = i.uv_texcoord * float2( -1,1 );
			float SDFFace207 = ( step( 0.0 , dotResult196 ) * step( ( temp_output_281_0 > 0.0 ? ( 1.0 - temp_output_194_0 ) : ( temp_output_194_0 - 1.0 ) ) , ( temp_output_281_0 > 0.0 ? tex2D( _SDFFaceLightmap, uv_TexCoord192 ).r : tex2D( _SDFFaceLightmap, i.uv_texcoord ).r ) ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 WorldNormal127 = normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) );
			float dotResult5_g1 = dot( WorldNormal127 , ase_worldlightDir );
			float4 lerpBlendMode142 = lerp(blendOpDest142,(( blendOpSrc142 > 0.5 ) ? max( blendOpDest142, 2.0 * ( blendOpSrc142 - 0.5 ) ) : min( blendOpDest142, 2.0 * blendOpSrc142 ) ),( ( 1.0 - saturate( ( LightAtten94 * min( SDFFace207 , ( pow( (dotResult5_g1*0.5 + 0.5) , _Power ) * _Mul ) ) ) ) ) * _ShdowIntensity ));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 MatCap82 = tex2D( _MatCapTex, ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy + 1.0 ) * 0.5 ) );
			float3 indirectNormal173 = WorldNormal127;
			float2 uv_SmoothTex = i.uv_texcoord * _SmoothTex_ST.xy + _SmoothTex_ST.zw;
			float lerpResult170 = lerp( _SmoothnessMaxMin.y , _SmoothnessMaxMin.x , ( ( 1.0 - tex2D( _SmoothTex, uv_SmoothTex ).r ) * _Smoothness ));
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV166 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode166 = ( _ReflectFre.x + _ReflectFre.y * pow( 1.0 - fresnelNdotV166, _ReflectFre.z ) );
			float clampResult171 = clamp( fresnelNode166 , 0.0 , 1.0 );
			Unity_GlossyEnvironmentData g173 = UnityGlossyEnvironmentSetup( lerpResult170, data.worldViewDir, indirectNormal173, float3(0,0,0));
			float3 indirectSpecular173 = UnityGI_IndirectSpecular( data, clampResult171, indirectNormal173, g173 );
			UnityGI gi172 = gi;
			float3 diffNorm172 = WorldNormal127;
			gi172 = UnityGI_Base( data, 1, diffNorm172 );
			float3 indirectDiffuse172 = gi172.indirect.diffuse + diffNorm172 * 0.0001;
			float3 ReflectColor175 = ( indirectSpecular173 * indirectDiffuse172 );
			float4 tex2DNode5 = tex2D( _EyeEmissionTex, PixUV63 );
			float mulTime37 = _Time.y * _EyeScanTexPanner.z;
			float2 appendResult38 = (float2(_EyeScanTexPanner.x , _EyeScanTexPanner.y));
			float2 uv_TexCoord39 = i.uv_texcoord * _EyeScanTexTiling;
			float2 panner40 = ( mulTime37 * appendResult38 + uv_TexCoord39);
			float mulTime29 = _Time.y * _FreScanTexPanner.z;
			float2 appendResult30 = (float2(_FreScanTexPanner.x , _FreScanTexPanner.y));
			float2 uv_TexCoord31 = i.uv_texcoord * _FreScanTexTiling;
			float2 panner32 = ( mulTime29 * appendResult30 + uv_TexCoord31);
			float fresnelNdotV14 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode14 = ( _FreScalePower.x + _FreScalePower.y * pow( 1.0 - fresnelNdotV14, _FreScalePower.z ) );
			float4 lerpResult283 = lerp( float4( 0,0,0,0 ) , tex2D( _ScanTex, panner32 ) , saturate( fresnelNode14 ));
			float4 EmissionColor70 = ( ( ( _EyeEmissionColor * _EyeEmissStr * ( tex2DNode5.r + tex2DNode5.g + tex2DNode5.b ) ) * tex2D( _ScanTex, panner40 ) ) + ( lerpResult283 * _EmissionColor * BaseColor61 ) );
			float3 temp_cast_4 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch96 = temp_cast_4;
			#else
				float3 staticSwitch96 = temp_output_90_0;
			#endif
			float3 LightColor97 = staticSwitch96;
			float4 FinalBaseColor105 = ( ( ( saturate( lerpBlendMode142 )) + ( MatCap82 * _MatCapIntensity ) + float4( ReflectColor175 , 0.0 ) + ( EmissionColor70 * _MainEmisStr ) ) * float4( LightColor97 , 0.0 ) );
			c.rgb = FinalBaseColor105.rgb;
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
0;288;1906;1039;8506.54;1301.174;2.070261;True;True
Node;AmplifyShaderEditor.CommentaryNode;178;-5650.447,2050.918;Inherit;False;3266.803;1470.405;SDFFace;33;204;202;201;200;198;194;185;186;0;214;71;159;207;206;243;197;195;196;192;191;190;193;188;189;183;184;182;181;179;158;248;244;281;SDFFace;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;68;-4668.995,-952.5189;Inherit;False;1351.513;637.3128;Pixelation;10;56;63;48;55;52;54;53;49;50;51;Pixelation;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;180;-5779.94,2353.178;Inherit;False;Constant;_HeadRight;_HeadRight;30;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;179;-5518.597,2565.646;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;181;-5184.366,2588.928;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-4549.187,-544.694;Inherit;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;-5188.718,2364.476;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-4468.492,-446.6501;Inherit;False;Property;_PixStr;PixStr;0;0;Create;True;0;0;0;False;0;False;1;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-4618.995,-717.0536;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;152;-8173.436,893.4002;Inherit;False;1951.807;639.1318;Distur;10;155;151;144;150;149;148;147;145;146;156;Distur;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;183;-4988.886,2361.437;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;184;-4993.312,2581.907;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;146;-8123.436,1094.932;Inherit;False;Property;_DisturTexPanner;DisturTexPanner;28;0;Create;True;0;0;0;False;0;False;0,0,1;0.1,0.2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;145;-7933.256,943.4002;Inherit;False;Property;_DisturTexTiling;DisturTexTiling;27;0;Create;True;0;0;0;False;0;False;1,1;0.5,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;-4327.677,-713.7533;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-4295.76,-450.206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;185;-4662.538,2558.503;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;148;-7572.232,1220.532;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;149;-7917.435,1112.332;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;-7716.233,980.5322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-4161.595,-713.9232;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CeilOpNode;50;-4028.209,-710.1172;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;150;-7364.236,1092.532;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PiNode;188;-4513.077,3175.747;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ACosOpNode;186;-4397.35,2778.647;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;190;-4318.176,3148.366;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-3889.951,-705.3823;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;187;-5783.376,2109.546;Inherit;False;Constant;_HeadForward;_HeadForward;30;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;156;-7143.822,1272.793;Inherit;False;Property;_DisturIntensity;DisturIntensity;29;0;Create;True;0;0;0;False;0;False;0;0.0025;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;144;-7133.596,1061.038;Inherit;True;Property;_DisturTex;DisturTex;26;0;Create;True;0;0;0;False;0;False;-1;None;82fda0a3fc07d4148bbfc5d3d66b0994;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-3703.817,-888.9625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-6738.539,1161.528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;-1623.768,-983.7263;Inherit;False;1525.385;680.1929;LightAtten;10;97;96;95;94;93;92;91;90;89;88;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-4172.723,3152.891;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;192;-5169.443,3035.669;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;125;491.0654,-902.4517;Inherit;False;504.303;432.5138;WorldNormal&ViewDir;4;129;128;127;126;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;189;-5196.125,2144.528;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;191;-5171.237,2808.449;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;177;167.0095,-848.8813;Inherit;True;Property;_NormalMap;NormalMap;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;198;-3990.127,3198.793;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;89;-1557.48,-488.0722;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-3573.983,-893.4903;Inherit;False;PixUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;67;-3227.543,-948.5724;Inherit;False;1309.754;677.8403;BaseColor;7;3;153;65;154;1;61;157;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;88;-1573.768,-692.931;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;195;-4896.354,2779.85;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;165dda08aa18ecb4b9e19a2fc6f84f4b;True;0;False;white;Auto;False;Instance;197;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-6552.628,1094.545;Inherit;False;DisturUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;281;-4176.478,2678.103;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;200;-3999.277,3110.937;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;193;-4989.306,2141.249;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;126;529.3477,-840.9628;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;197;-4879.912,3060.701;Inherit;True;Property;_SDFFaceLightmap;SDFFaceLightmap;6;0;Create;True;0;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;659bc803eb9b58c43a4ca93450cfea65;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;-3205.771,-750.1029;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-3209.055,-654.7723;Inherit;False;151;DisturUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;196;-4619.197,2196.928;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;69;-8183.035,-1624.569;Inherit;False;3344.616;2234.507;EmissionColor;30;70;23;34;123;21;7;33;35;32;6;66;5;31;30;29;64;14;45;28;17;124;137;44;36;39;38;37;40;138;283;EmissionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.Compare;201;-3678.674,3062.595;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;202;-3672.948,2760.546;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1304.025,-622.3866;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;106;182.0061,670.9802;Inherit;False;3060.93;1714.936;FinalBaseColor;28;43;102;98;101;105;130;108;84;85;83;86;119;100;104;103;131;132;133;134;135;117;140;141;142;176;62;208;282;FinalBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;751.1055,-844.3397;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;221.824,1513.298;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;45;-7972.895,-34.44643;Inherit;False;Property;_FreScanTexTiling;FreScanTexTiling;17;0;Create;True;0;0;0;False;0;False;1,1;1,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BreakToComponentsNode;91;-990.4224,-603.4259;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;122;-4715.933,550.1787;Inherit;False;1603.713;554.2144;MatCap;10;74;73;75;76;77;78;79;80;81;82;MatCap;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;243;-4338.551,2171.321;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-2987.055,-726.7723;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;204;-3342.924,2921.683;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;28;-8163.074,117.0857;Inherit;False;Property;_FreScanTexPanner;FreScanTexPanner;18;0;Create;True;0;0;0;False;0;False;0,0,1;0,2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;17;-7754.476,-337.1735;Inherit;False;Property;_FreScalePower;FreScalePower;16;0;Create;True;0;0;0;False;0;False;0,1.1,1.1;0,1.18,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;30;-7957.073,134.4857;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;92;-750.5193,-624.5335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewMatrixNode;74;-4583.179,600.1786;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.Vector2Node;44;-8053.701,-1076.689;Inherit;False;Property;_EyeScanTexTiling;EyeScanTexTiling;22;0;Create;True;0;0;0;False;0;False;1,1;1,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;36;-8072.285,-805.9526;Inherit;False;Property;_EyeScanTexPanner;EyeScanTexPanner;23;0;Create;True;0;0;0;False;0;False;0,0,1;0,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;3;-2730.128,-564.2324;Inherit;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;64;-8047.547,-1578.917;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-7719.844,242.6854;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-3043.182,2833.409;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-7755.872,2.685551;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;104;464.7572,1517.834;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;476.6169,1767.564;Inherit;False;Property;_Power;Power;4;0;Create;True;0;0;0;False;0;False;7;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;73;-4665.933,730.7867;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-2816.533,-759.8744;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;f519aaee9ae44c34ea4a3de02041e033;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;160;-8186.867,2069.94;Inherit;False;1862.541;1251.331;ReflectColor;15;175;174;173;172;171;170;169;168;167;166;165;164;163;162;161;ReflectColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;134;734.7632,1533.819;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;14;-7512.962,-327.7346;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-4392.179,663.1787;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;157;-2458.188,-750.7289;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;37;-7723.975,-700.1838;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-7734.062,-970.3787;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;161;-8131.675,2451.822;Inherit;True;Property;_SmoothTex;SmoothTex;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;133;745.6666,1801.369;Inherit;False;Property;_Mul;Mul;5;0;Create;True;0;0;0;False;0;False;20;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-2700.328,2809.724;Inherit;True;SDFFace;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-7724.069,-1570.107;Inherit;True;Property;_EyeEmissionTex;EyeEmissionTex;19;0;Create;True;0;0;0;False;0;False;-1;None;e686a5c859f3a5a438c7390d44a54f76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;93;-595.5703,-592.2168;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-7717.462,-818.9786;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;32;-7403.875,114.6857;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-7073.057,63.28353;Inherit;True;Property;_ScanTex;ScanTex;15;0;Create;True;0;0;0;False;0;False;-1;None;4ce5c6694c9418847bb143ef1b41b417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-7653.824,-1375.101;Inherit;False;Property;_EyeEmissionColor;EyeEmissionColor;20;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;18.943,18.943,18.943,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-7682.799,-1202.99;Inherit;False;Property;_EyeEmissStr;EyeEmissStr;21;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;164;-7840.74,2478.189;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-334.6294,-590.4506;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;40;-7385.383,-838.306;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-4006.152,785.3926;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;163;-8100.115,2789.444;Inherit;False;Property;_ReflectFre;ReflectFre;11;0;Create;True;0;0;0;False;0;False;0,1,5;0,20,4;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-2160.79,-786.064;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;940.3058,1627.812;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-7319.231,-1491.45;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;913.1595,1475.811;Inherit;False;207;SDFFace;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-8099.313,2653.542;Inherit;False;Property;_Smoothness;Smoothness;12;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;76;-4250.222,669.0948;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;137;-7084.024,-325.5381;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-7677.495,2470.063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-6569.606,-32.25405;Inherit;False;Property;_EmissionColor;EmissionColor;13;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.7921569,0.518115,0.309804,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;165;-8074.427,2289.96;Inherit;False;Property;_SmoothnessMaxMin;SmoothnessMaxMin;10;0;Create;True;0;0;0;False;0;False;0.95,0.01;0.95,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FresnelNode;166;-7891.118,2773.65;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;283;-6708.628,-273.9237;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;110;-3231.302,-1612.965;Inherit;False;1181.666;633.2292;ShaowColor;4;115;114;113;112;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-6516.97,206.535;Inherit;False;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-3998.152,652.3926;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-7077.539,-1403.387;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMinOpNode;282;1108.583,1498.881;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-7119.518,-866.3074;Inherit;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;0;False;0;False;-1;None;fd67039a540e4ae43878e96bc497d2d5;True;0;False;black;Auto;False;Instance;33;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-3880.152,858.3927;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;906.5425,1373.547;Inherit;False;94;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;170;-7539.179,2325.101;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-3857.152,656.3926;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-6206.808,-284.3993;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-3090.53,-1390.221;Inherit;False;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-7675.745,2229.526;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-7547.373,2624.286;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;171;-7630.119,2776.535;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-6629.921,-1097.307;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;1243.414,1397.573;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;112;-3119.302,-1564.965;Inherit;False;Property;_ShaowColor;ShaowColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.08627451,0.2941177,0.2620063,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;173;-7320.902,2258.55;Inherit;True;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2603.573,-1461.782;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;81;-3682.183,625.9675;Inherit;True;Property;_MatCapTex;MatCapTex;24;0;Create;True;0;0;0;False;0;False;-1;None;7ad6f39daccc4314999cf8fbccdc3880;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-5809.761,-680.0847;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;172;-7317.476,2628.785;Inherit;True;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;135;1475.78,1345.625;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-6927.207,2253.198;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3327.577,677.1976;Inherit;False;MatCap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-2297.745,-1470.208;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;141;1661.973,1347.699;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1143.419,-858.4844;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-5505.066,-678.1794;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;117;1583.88,1601.37;Inherit;False;Property;_ShdowIntensity;ShdowIntensity;7;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-6676.252,2245.955;Inherit;False;ReflectColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;86;2096.774,1283.878;Inherit;False;Property;_MatCapIntensity;MatCapIntensity;25;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;1886.289,1364.074;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;2095.396,1175.317;Inherit;False;82;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;1717.22,914.8607;Inherit;True;114;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;1828.802,1730.299;Inherit;False;70;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;1794.865,1817.657;Inherit;False;Property;_MainEmisStr;MainEmisStr;14;0;Create;True;0;0;0;False;0;False;1;0.57;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;1726.701,1122.354;Inherit;True;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;96;-901.8384,-877.039;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-546.8203,-880.158;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;142;2069.306,922.8528;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;2095.195,1731.055;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;2141.349,1466.053;Inherit;False;175;ReflectColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;2334.959,1092.454;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;2524.571,1461.328;Inherit;False;97;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;2608.753,1076.779;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;2800.965,1075.532;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;2987.405,1075.705;Inherit;False;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformDirectionNode;248;-5573.758,2360.433;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-4440.805,2429.936;Inherit;False;debug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;755.1465,-642.5017;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;129;543.0146,-645.8417;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;71;-3241.896,2286.553;Inherit;False;105;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;-3150.261,2446.999;Inherit;False;158;debug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;244;-5583.791,2113.49;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;214;-5434.865,2761.73;Inherit;False;Constant;_Vector0;Vector 0;31;0;Create;True;0;0;0;False;0;False;1,2.22;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-2892.473,2055.296;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Face;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;181;0;179;1
WireConnection;181;1;179;3
WireConnection;182;0;180;1
WireConnection;182;1;180;3
WireConnection;183;0;182;0
WireConnection;184;0;181;0
WireConnection;54;0;52;0
WireConnection;54;1;55;0
WireConnection;53;0;48;0
WireConnection;185;0;183;0
WireConnection;185;1;184;0
WireConnection;148;0;146;3
WireConnection;149;0;146;1
WireConnection;149;1;146;2
WireConnection;147;0;145;0
WireConnection;49;0;54;0
WireConnection;49;1;53;0
WireConnection;50;0;49;0
WireConnection;150;0;147;0
WireConnection;150;2;149;0
WireConnection;150;1;148;0
WireConnection;186;0;185;0
WireConnection;190;0;186;0
WireConnection;190;1;188;0
WireConnection;51;0;50;0
WireConnection;51;1;53;0
WireConnection;144;1;150;0
WireConnection;56;0;51;0
WireConnection;56;1;55;0
WireConnection;155;0;144;1
WireConnection;155;1;156;0
WireConnection;194;0;190;0
WireConnection;189;0;187;1
WireConnection;189;1;187;3
WireConnection;198;0;194;0
WireConnection;63;0;56;0
WireConnection;195;1;191;0
WireConnection;151;0;155;0
WireConnection;281;0;185;0
WireConnection;200;0;194;0
WireConnection;193;0;189;0
WireConnection;126;0;177;0
WireConnection;197;1;192;0
WireConnection;196;0;193;0
WireConnection;196;1;184;0
WireConnection;201;0;281;0
WireConnection;201;2;200;0
WireConnection;201;3;198;0
WireConnection;202;0;281;0
WireConnection;202;2;197;1
WireConnection;202;3;195;1
WireConnection;90;0;88;0
WireConnection;90;1;89;1
WireConnection;127;0;126;0
WireConnection;91;0;90;0
WireConnection;243;1;196;0
WireConnection;154;0;65;0
WireConnection;154;1;153;0
WireConnection;204;0;201;0
WireConnection;204;1;202;0
WireConnection;30;0;28;1
WireConnection;30;1;28;2
WireConnection;92;0;91;0
WireConnection;92;1;91;1
WireConnection;29;0;28;3
WireConnection;206;0;243;0
WireConnection;206;1;204;0
WireConnection;31;0;45;0
WireConnection;104;3;103;0
WireConnection;1;1;154;0
WireConnection;134;0;104;0
WireConnection;134;1;132;0
WireConnection;14;1;17;1
WireConnection;14;2;17;2
WireConnection;14;3;17;3
WireConnection;75;0;74;0
WireConnection;75;1;73;0
WireConnection;157;0;3;0
WireConnection;157;1;1;0
WireConnection;157;2;1;4
WireConnection;37;0;36;3
WireConnection;39;0;44;0
WireConnection;207;0;206;0
WireConnection;5;1;64;0
WireConnection;93;0;92;0
WireConnection;93;1;91;2
WireConnection;38;0;36;1
WireConnection;38;1;36;2
WireConnection;32;0;31;0
WireConnection;32;2;30;0
WireConnection;32;1;29;0
WireConnection;33;1;32;0
WireConnection;164;0;161;1
WireConnection;94;0;93;0
WireConnection;40;0;39;0
WireConnection;40;2;38;0
WireConnection;40;1;37;0
WireConnection;61;0;157;0
WireConnection;131;0;134;0
WireConnection;131;1;133;0
WireConnection;124;0;5;1
WireConnection;124;1;5;2
WireConnection;124;2;5;3
WireConnection;76;0;75;0
WireConnection;137;0;14;0
WireConnection;167;0;164;0
WireConnection;167;1;162;0
WireConnection;166;1;163;1
WireConnection;166;2;163;2
WireConnection;166;3;163;3
WireConnection;283;1;33;0
WireConnection;283;2;137;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;7;0;6;0
WireConnection;7;1;66;0
WireConnection;7;2;124;0
WireConnection;282;0;208;0
WireConnection;282;1;131;0
WireConnection;35;1;40;0
WireConnection;170;0;165;2
WireConnection;170;1;165;1
WireConnection;170;2;167;0
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;138;0;283;0
WireConnection;138;1;21;0
WireConnection;138;2;123;0
WireConnection;171;0;166;0
WireConnection;34;0;7;0
WireConnection;34;1;35;0
WireConnection;101;0;100;0
WireConnection;101;1;282;0
WireConnection;173;0;168;0
WireConnection;173;1;170;0
WireConnection;173;2;171;0
WireConnection;113;0;112;0
WireConnection;113;1;115;0
WireConnection;81;1;80;0
WireConnection;23;0;34;0
WireConnection;23;1;138;0
WireConnection;172;0;169;0
WireConnection;135;0;101;0
WireConnection;174;0;173;0
WireConnection;174;1;172;0
WireConnection;82;0;81;0
WireConnection;114;0;113;0
WireConnection;141;0;135;0
WireConnection;70;0;23;0
WireConnection;175;0;174;0
WireConnection;140;0;141;0
WireConnection;140;1;117;0
WireConnection;96;1;90;0
WireConnection;96;0;95;0
WireConnection;97;0;96;0
WireConnection;142;0;98;0
WireConnection;142;1;102;0
WireConnection;142;2;140;0
WireConnection;119;0;62;0
WireConnection;119;1;43;0
WireConnection;85;0;83;0
WireConnection;85;1;86;0
WireConnection;84;0;142;0
WireConnection;84;1;85;0
WireConnection;84;2;176;0
WireConnection;84;3;119;0
WireConnection;130;0;84;0
WireConnection;130;1;108;0
WireConnection;105;0;130;0
WireConnection;248;0;180;0
WireConnection;128;0;129;0
WireConnection;244;0;187;0
WireConnection;0;13;71;0
ASEEND*/
//CHKSM=C9426BA85A796907D47F2861F1D89D533A2E2CD9