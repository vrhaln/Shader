// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Face"
{
	Properties
	{
		_PixStr("PixStr", Float) = 1
		_ExpressionTex("ExpressionTex", 2D) = "white" {}
		_ColumnsRows("Columns&Rows", Vector) = (2,2,0,0)
		_Frame("Frame", Int) = 1
		_MainColor("MainColor", Color) = (1,1,1,1)
		_ShaowColor("ShaowColor", Color) = (0,0,0,0)
		_ShadowRange("ShadowRange", Float) = 7
		_ShadowSoft("ShadowSoft", Range( 0.51 , 1)) = 7
		_RimOffset("RimOffset", Float) = 1
		_RimPower("Rim Power", Float) = 0.76
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
		_DisturIntensity("DisturIntensity", Range( 0 , 1)) = 0
		_DisturSpeed("DisturSpeed", Float) = 0.1
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
		uniform sampler2D _ExpressionTex;
		uniform float2 _ColumnsRows;
		uniform int _Frame;
		uniform sampler2D _DisturTex;
		uniform float4 _DisturTex_ST;
		uniform float _DisturSpeed;
		uniform float _DisturIntensity;
		uniform float _PixStr;
		uniform sampler2D _SDFFaceLightmap;
		uniform float _ShadowSoft;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _ShadowRange;
		uniform float _RimOffset;
		uniform float _RimPower;
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
		uniform float3 _FreScalePower;
		uniform float3 _FreScanTexPanner;
		uniform float2 _FreScanTexTiling;
		uniform float4 _EmissionColor;
		uniform float _MainEmisStr;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


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
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles287 = _ColumnsRows.x * _ColumnsRows.y;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset287 = 1.0f / _ColumnsRows.x;
			float fbrowsoffset287 = 1.0f / _ColumnsRows.y;
			// Speed of animation
			float fbspeed287 = _Time[ 1 ] * 0.0;
			// UV Tiling (col and row offset)
			float2 fbtiling287 = float2(fbcolsoffset287, fbrowsoffset287);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex287 = round( fmod( fbspeed287 + (float)_Frame, fbtotaltiles287) );
			fbcurrenttileindex287 += ( fbcurrenttileindex287 < 0) ? fbtotaltiles287 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox287 = round ( fmod ( fbcurrenttileindex287, _ColumnsRows.x ) );
			// Multiply Offset X by coloffset
			float fboffsetx287 = fblinearindextox287 * fbcolsoffset287;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy287 = round( fmod( ( fbcurrenttileindex287 - fblinearindextox287 ) / _ColumnsRows.x, _ColumnsRows.y ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy287 = (int)(_ColumnsRows.y-1) - fblinearindextoy287;
			// Multiply Offset Y by rowoffset
			float fboffsety287 = fblinearindextoy287 * fbrowsoffset287;
			// UV Offset
			float2 fboffset287 = float2(fboffsetx287, fboffsety287);
			// Flipbook UV
			half2 fbuv287 = i.uv_texcoord * fbtiling287 + fboffset287;
			// *** END Flipbook UV Animation vars ***
			float2 uv_DisturTex = i.uv_texcoord * _DisturTex_ST.xy + _DisturTex_ST.zw;
			float2 temp_cast_1 = (0.5).xx;
			float mulTime318 = _Time.y * _DisturSpeed;
			float3 _Vector1 = float3(500,500,0.2);
			float mulTime308 = _Time.y * _Vector1.z;
			float2 appendResult307 = (float2(_Vector1.x , _Vector1.y));
			float2 panner305 = ( mulTime308 * appendResult307 + i.uv_texcoord);
			float simplePerlin2D301 = snoise( panner305*0.01 );
			simplePerlin2D301 = simplePerlin2D301*0.5 + 0.5;
			float DisturUV151 = ( saturate( (-1.0 + (tex2D( _DisturTex, ( ( ( floor( ( ( uv_DisturTex - temp_cast_1 ) * 6.38 ) ) / 6.38 ) + 0.5 ) + mulTime318 ) ).r - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) * _DisturIntensity * 0.1 * simplePerlin2D301 );
			float2 temp_cast_2 = (0.5).xx;
			float temp_output_53_0 = ( _PixStr * 10.0 );
			float2 PixUV63 = ( ( ceil( ( ( ( fbuv287 + DisturUV151 ) - temp_cast_2 ) * temp_output_53_0 ) ) / temp_output_53_0 ) + 0.5 );
			float4 tex2DNode289 = tex2D( _ExpressionTex, PixUV63 );
			float4 Expression295 = tex2DNode289;
			float4 lerpResult157 = lerp( _MainColor , Expression295 , tex2DNode289.a);
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
			float smoothstepResult327 = smoothstep( ( 1.0 - _ShadowSoft ) , _ShadowSoft , pow( (dotResult5_g1*0.5 + 0.5) , _ShadowRange ));
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult332 = dot( WorldNormal127 , ase_worldViewDir );
			float4 lerpBlendMode142 = lerp(blendOpDest142,(( blendOpSrc142 > 0.5 ) ? max( blendOpDest142, 2.0 * ( blendOpSrc142 - 0.5 ) ) : min( blendOpDest142, 2.0 * blendOpSrc142 ) ),( ( 1.0 - ( saturate( ( LightAtten94 * min( SDFFace207 , smoothstepResult327 ) ) ) + pow( ( 1.0 - saturate( ( dotResult332 + _RimOffset ) ) ) , _RimPower ) ) ) * _ShdowIntensity ));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 MatCap82 = tex2D( _MatCapTex, ( ( (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy + 1.0 ) * 0.5 ) );
			float3 indirectNormal173 = WorldNormal127;
			float2 uv_SmoothTex = i.uv_texcoord * _SmoothTex_ST.xy + _SmoothTex_ST.zw;
			float lerpResult170 = lerp( _SmoothnessMaxMin.y , _SmoothnessMaxMin.x , ( ( 1.0 - tex2D( _SmoothTex, uv_SmoothTex ).r ) * _Smoothness ));
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
			float fresnelNdotV14 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode14 = ( _FreScalePower.x + _FreScalePower.y * pow( 1.0 - fresnelNdotV14, _FreScalePower.z ) );
			float temp_output_137_0 = saturate( fresnelNode14 );
			float4 temp_cast_6 = (temp_output_137_0).xxxx;
			float mulTime29 = _Time.y * _FreScanTexPanner.z;
			float2 appendResult30 = (float2(_FreScanTexPanner.x , _FreScanTexPanner.y));
			float2 uv_TexCoord31 = i.uv_texcoord * _FreScanTexTiling;
			float2 panner32 = ( mulTime29 * appendResult30 + uv_TexCoord31);
			float4 lerpResult283 = lerp( temp_cast_6 , tex2D( _ScanTex, panner32 ) , temp_output_137_0);
			float4 EmissionColor70 = ( ( ( _EyeEmissionColor * _EyeEmissStr * ( tex2DNode5.r + tex2DNode5.g + tex2DNode5.b ) ) * tex2D( _ScanTex, panner40 ) ) + ( saturate( ( ( 1.0 - fresnelNode14 ) + lerpResult283 ) ) * _EmissionColor * BaseColor61 ) );
			float3 temp_cast_7 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch96 = temp_cast_7;
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
70;217;1403;771;5609.232;-1356.929;1.949228;True;True
Node;AmplifyShaderEditor.RangedFloatNode;322;-8712.619,-4221.132;Inherit;False;Constant;_Float7;Float 7;34;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;313;-8715.646,-4580.974;Inherit;False;0;144;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;321;-8401.489,-4536.966;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-8398.03,-4334.208;Inherit;False;Constant;_Float6;Float 6;33;0;Create;True;0;0;0;False;0;False;6.38;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;-8251.615,-4456.336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;316;-8062.996,-4452.901;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;320;-8346.046,-4124.831;Inherit;False;Property;_DisturSpeed;DisturSpeed;36;0;Create;True;0;0;0;False;0;False;0.1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;317;-7935.293,-4445.565;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;152;-8121.72,-3921.805;Inherit;False;2579.736;1261.268;Distur;21;151;155;325;324;144;148;147;149;150;145;146;156;301;300;304;305;302;308;307;306;326;Distur;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;323;-7651.709,-4267.416;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;318;-8151.073,-4117.232;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;306;-7949.377,-3093.423;Inherit;False;Constant;_Vector1;Vector 1;33;0;Create;True;0;0;0;False;0;False;500,500,0.2;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;319;-7450.824,-4217.213;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;307;-7678.198,-3076.341;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;325;-7031.453,-3637.763;Inherit;False;Constant;_Float8;Float 8;34;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;302;-7783.198,-3216.341;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;308;-7698.198,-2984.341;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;144;-7082.935,-3902.345;Inherit;True;Property;_DisturTex;DisturTex;32;0;Create;True;0;0;0;False;0;False;-1;None;398e4e6b30b1eac45a3a8322d2e3dae8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;304;-7340.198,-3029.341;Inherit;False;Constant;_Float5;Float 5;33;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;324;-6770.085,-3731.876;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;305;-7499.198,-3168.341;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;301;-7045.13,-3180.708;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-6972.07,-3279.982;Inherit;False;Constant;_Float4;Float 4;33;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;326;-6466.839,-3600.401;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-7069.192,-3385.295;Inherit;False;Property;_DisturIntensity;DisturIntensity;35;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-6229.381,-3451.476;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;178;-4587.951,-1651.14;Inherit;False;3266.803;1470.405;SDFFace;33;204;202;201;200;198;194;185;186;214;159;207;206;243;197;195;196;192;191;190;193;188;189;183;184;182;181;179;158;248;244;281;180;187;SDFFace;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;288;-4409.804,-3087.463;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;294;-4362.625,-2801.485;Inherit;False;Property;_Frame;Frame;4;0;Create;True;0;0;0;False;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.Vector2Node;292;-4392.425,-2953.185;Inherit;False;Property;_ColumnsRows;Columns&Rows;3;0;Create;True;0;0;0;False;0;False;2,2;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-6013.191,-3495.986;Inherit;False;DisturUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;67;-4580.471,-2667.46;Inherit;False;2520.694;971.6614;BaseColor;11;295;289;296;61;157;3;298;53;48;310;1;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-4095.206,-2751.879;Inherit;False;151;DisturUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;287;-4134.197,-2975.37;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;179;-4456.101,-1136.412;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;180;-4569.614,-1340.157;Inherit;False;Constant;_HeadRight;_HeadRight;30;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;48;-3685.913,-2617.611;Inherit;False;Property;_PixStr;PixStr;0;0;Create;True;0;0;0;False;0;False;1;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-3689.704,-2754.391;Inherit;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;297;-3881.475,-2909.832;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;181;-4121.868,-1113.13;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;-4126.22,-1337.582;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;184;-3930.813,-1120.151;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;183;-3926.387,-1340.621;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-3531.182,-2611.167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;-3563.099,-2874.714;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-3397.018,-2874.884;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;185;-3600.039,-1143.556;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;50;-3242.29,-2866.81;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ACosOpNode;186;-3364.851,-927.4116;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;188;-3450.578,-526.3123;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-3090.868,-2866.343;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;187;-4573.049,-1583.789;Inherit;False;Constant;_HeadForward;_HeadForward;30;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;125;-928.5114,-3917.533;Inherit;False;889.9202;567.4797;WorldNormal&ViewDir;5;129;128;127;126;177;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;190;-3255.676,-553.6932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-3110.224,-549.168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;189;-4133.627,-1557.531;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;192;-4115.244,-610.7904;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;191;-4108.738,-893.6096;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;87;-2957.457,-3935.418;Inherit;False;1525.385;680.1929;LightAtten;10;97;96;95;94;93;92;91;90;89;88;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;177;-866.9501,-3863.963;Inherit;True;Property;_NormalMap;NormalMap;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2908.448,-2785.18;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Compare;281;-3113.979,-1023.956;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-2751.819,-2790.982;Inherit;False;PixUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;69;-8183.035,-1624.569;Inherit;False;3344.616;2234.507;EmissionColor;33;70;23;34;123;21;7;33;35;32;6;66;5;31;30;29;64;14;45;28;17;124;137;44;36;39;38;37;40;138;283;284;285;286;EmissionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;195;-3833.854,-922.2085;Inherit;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;165dda08aa18ecb4b9e19a2fc6f84f4b;True;0;False;white;Auto;False;Instance;197;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;200;-2936.778,-591.1222;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;89;-2891.169,-3439.764;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation;88;-2907.457,-3644.623;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;193;-3926.807,-1560.809;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;126;-504.6115,-3856.044;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;198;-2927.627,-503.2664;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;197;-3840.812,-640.0585;Inherit;True;Property;_SDFFaceLightmap;SDFFaceLightmap;12;0;Create;True;0;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;659bc803eb9b58c43a4ca93450cfea65;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;202;-2610.448,-941.5127;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;201;-2616.175,-639.4645;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-2637.714,-3574.078;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-3152.881,-2331.77;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;196;-3556.698,-1505.13;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;28;-8163.074,117.0857;Inherit;False;Property;_FreScanTexPanner;FreScanTexPanner;24;0;Create;True;0;0;0;False;0;False;0,0,1;0,2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-282.8538,-3859.421;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;45;-7972.895,-34.44643;Inherit;False;Property;_FreScanTexTiling;FreScanTexTiling;23;0;Create;True;0;0;0;False;0;False;1,1;1,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;106;-6106.423,978.3312;Inherit;False;3215.165;1714.936;FinalBaseColor;41;117;140;133;131;338;337;339;336;334;332;335;333;330;342;141;135;101;100;282;208;327;329;134;104;328;132;103;105;130;84;108;119;176;142;85;98;102;86;43;62;83;FinalBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;204;-2280.426,-780.3754;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;91;-2324.111,-3555.118;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;103;-6073.295,1689.033;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;243;-3276.051,-1530.737;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;289;-2945.328,-2354.969;Inherit;True;Property;_ExpressionTex;ExpressionTex;2;0;Create;True;0;0;0;False;0;False;-1;None;ced8334ea19b2cf428e1d5b679e531f4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-7957.073,134.4857;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-7755.872,2.685551;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;17;-7754.476,-337.1735;Inherit;False;Property;_FreScalePower;FreScalePower;22;0;Create;True;0;0;0;False;0;False;0,1.1,1.1;0.3,1.75,2.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;29;-7719.844,242.6854;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;92;-2084.208,-3576.225;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;333;-6032.198,2305.898;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-1980.683,-868.6494;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-5783.502,1779.3;Inherit;False;Property;_ShadowRange;ShadowRange;7;0;Create;True;0;0;0;False;0;False;7;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;328;-5870.03,1890.252;Inherit;False;Property;_ShadowSoft;ShadowSoft;8;0;Create;True;0;0;0;False;0;False;7;0.51;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-7403.875,114.6857;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;104;-5830.362,1693.569;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;-2626.572,-2388.009;Inherit;False;Expression;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;14;-7512.962,-327.7346;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;122;-8144.6,2515.558;Inherit;False;1603.713;554.2144;MatCap;10;74;73;75;76;77;78;79;80;81;82;MatCap;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-6022.314,2197.464;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;134;-5560.356,1709.554;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;44;-8053.701,-1076.689;Inherit;False;Property;_EyeScanTexTiling;EyeScanTexTiling;28;0;Create;True;0;0;0;False;0;False;1,1;1,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMaxOpNode;93;-1929.259,-3543.909;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-1637.829,-892.3345;Inherit;True;SDFFace;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;332;-5806.198,2256.898;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-5762.198,2414.898;Inherit;False;Property;_RimOffset;RimOffset;9;0;Create;True;0;0;0;False;0;False;1;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;160;-8158.302,977.4022;Inherit;False;1862.541;1251.331;ReflectColor;15;175;174;173;172;171;170;169;168;167;166;165;164;163;162;161;ReflectColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;329;-5538.03,1828.252;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;137;-7109.356,-319.1381;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;296;-2999.479,-2065.761;Inherit;False;295;Expression;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;36;-8072.285,-805.9526;Inherit;False;Property;_EyeScanTexPanner;EyeScanTexPanner;29;0;Create;True;0;0;0;False;0;False;0,0,1;0,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;74;-8011.845,2565.558;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SamplerNode;33;-7165.858,60.08353;Inherit;True;Property;_ScanTex;ScanTex;21;0;Create;True;0;0;0;False;0;False;-1;None;4ce5c6694c9418847bb143ef1b41b417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;64;-7951.547,-1551.917;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;3;-2973.597,-1956.311;Inherit;False;Property;_MainColor;MainColor;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.6352941,0.8274511,0.7686275,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;73;-8094.599,2696.166;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;161;-8103.109,1359.284;Inherit;True;Property;_SmoothTex;SmoothTex;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;208;-5276.866,1691.205;Inherit;False;207;SDFFace;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;334;-5556.198,2312.898;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1668.318,-3542.142;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;327;-5347.03,1805.252;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;283;-6862.141,-312.1346;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;157;-2538.105,-2045.188;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-7724.069,-1570.107;Inherit;True;Property;_EyeEmissionTex;EyeEmissionTex;25;0;Create;True;0;0;0;False;0;False;-1;None;e686a5c859f3a5a438c7390d44a54f76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-7734.062,-970.3787;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;38;-7717.462,-818.9786;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;37;-7723.975,-700.1838;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-7820.845,2628.558;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;284;-7105.179,-549.9404;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;40;-7385.383,-838.306;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;336;-5322.198,2314.898;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;282;-5104.04,1694.274;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-5283.482,1588.94;Inherit;False;94;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-7682.799,-1202.99;Inherit;False;Property;_EyeEmissStr;EyeEmissStr;27;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;164;-7812.174,1385.651;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-2262.82,-2055.376;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;163;-8071.549,1696.906;Inherit;False;Property;_ReflectFre;ReflectFre;17;0;Create;True;0;0;0;False;0;False;0,1,5;0,20,4;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;6;-7653.824,-1375.101;Inherit;False;Property;_EyeEmissionColor;EyeEmissionColor;26;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;23.96863,23.96863,23.96863,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-7319.231,-1491.45;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;285;-6561.935,-461.7942;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-8070.747,1561.004;Inherit;False;Property;_Smoothness;Smoothness;18;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-7434.818,2750.772;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;76;-7678.888,2634.474;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-7648.929,1377.525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;337;-5156.198,2315.898;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;339;-5160.729,2430.064;Inherit;False;Property;_RimPower;Rim Power;10;0;Create;True;0;0;0;False;0;False;0.76;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-4946.61,1612.966;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;110;-4601.624,-3931.903;Inherit;False;1181.666;633.2292;ShaowColor;4;115;114;113;112;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;286;-6324.489,-448.6907;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-7308.818,2823.773;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-7119.518,-866.3074;Inherit;True;Property;_TextureSample0;Texture Sample 0;21;0;Create;True;0;0;0;False;0;False;-1;None;fd67039a540e4ae43878e96bc497d2d5;True;0;False;black;Auto;False;Instance;33;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;123;-6678.782,210.9083;Inherit;True;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-7426.818,2617.772;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;21;-6691.048,-7.658012;Inherit;False;Property;_EmissionColor;EmissionColor;19;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.4758651,0.4227483,0.7169812,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;165;-8045.861,1197.422;Inherit;False;Property;_SmoothnessMaxMin;SmoothnessMaxMin;16;0;Create;True;0;0;0;False;0;False;0.95,0.01;0.95,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-7077.539,-1403.387;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;166;-7862.552,1681.112;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-7647.179,1136.988;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-7285.818,2621.772;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;171;-7601.553,1683.997;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;135;-4737.92,1612.573;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-6032.496,-354.9836;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-6629.921,-1097.307;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;338;-4958.429,2315.963;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-4460.853,-3709.159;Inherit;False;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;170;-7510.613,1232.563;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-7518.807,1531.748;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;112;-4489.625,-3883.903;Inherit;False;Property;_ShaowColor;ShaowColor;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.0862745,0.2696881,0.2941177,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;342;-4560.192,1632.036;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-5809.761,-680.0847;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-3973.897,-3780.72;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectSpecularLight;173;-7292.336,1166.012;Inherit;True;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;172;-7288.91,1536.247;Inherit;True;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;81;-7110.849,2591.347;Inherit;True;Property;_MatCapTex;MatCapTex;30;0;Create;True;0;0;0;False;0;False;-1;None;1ef873e94bdd29e408d495dfbc12fd01;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-3668.069,-3789.146;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-4434.762,1880.361;Inherit;False;Property;_ShdowIntensity;ShdowIntensity;13;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-5505.066,-678.1794;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2477.108,-3810.176;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-6756.243,2642.577;Inherit;False;MatCap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-6898.641,1160.66;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;141;-4339.818,1645.48;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-4137.761,1693.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-6647.686,1153.417;Inherit;False;ReflectColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3941.795,1462.669;Inherit;False;82;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-3940.417,1571.229;Inherit;False;Property;_MatCapIntensity;MatCapIntensity;31;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-4305.389,2037.65;Inherit;False;70;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-4416.972,1182.212;Inherit;True;114;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-4434.491,1414.706;Inherit;True;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-4339.327,2125.008;Inherit;False;Property;_MainEmisStr;MainEmisStr;20;0;Create;True;0;0;0;False;0;False;1;0.65;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;96;-2235.527,-3828.731;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-4038.996,2038.407;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-1880.509,-3831.85;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-3708.233,1409.809;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;142;-3944.741,1228.463;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-3992.843,1773.404;Inherit;False;175;ReflectColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-3525.439,1384.131;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-3609.621,1768.679;Inherit;False;97;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-3333.228,1382.884;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-3110.25,1383.057;Inherit;False;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;149;-7865.719,-3702.874;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;129;-490.9446,-3660.923;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;150;-7312.52,-3722.674;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-3378.306,-1272.122;Inherit;False;debug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;146;-8071.72,-3720.274;Inherit;False;Property;_DisturTexPanner;DisturTexPanner;34;0;Create;True;0;0;0;False;0;False;0,0,1;0,0.2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1999.51,1051.198;Inherit;False;105;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformDirectionNode;244;-4360.295,-1595.569;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;148;-7520.516,-3594.674;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;248;-4366.262,-1356.625;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-2931.655,-2562.78;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;f519aaee9ae44c34ea4a3de02041e033;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-278.8127,-3657.583;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-3892.111,-2068.549;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;298;-3678.877,-2137.182;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-5546.985,2022.362;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-5768.623,2041.918;Inherit;False;Property;_Mul;Mul;11;0;Create;True;0;0;0;False;0;False;20;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;-7664.517,-3834.673;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;159;-2087.763,-1255.059;Inherit;False;158;debug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;145;-7881.54,-3871.805;Inherit;False;Property;_DisturTexTiling;DisturTexTiling;33;0;Create;True;0;0;0;False;0;False;1,1;0.5,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;214;-4315.369,-900.3286;Inherit;False;Constant;_Vector0;Vector 0;31;0;Create;True;0;0;0;False;0;False;1,2.22;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1607.738,816.5211;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Face;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;68;-1935.621,-2660.059;Inherit;False;1351.513;637.3128;Pixelation;0;Pixelation;1,1,1,1;0;0
WireConnection;321;0;313;0
WireConnection;321;1;322;0
WireConnection;314;0;321;0
WireConnection;314;1;315;0
WireConnection;316;0;314;0
WireConnection;317;0;316;0
WireConnection;317;1;315;0
WireConnection;323;0;317;0
WireConnection;323;1;322;0
WireConnection;318;0;320;0
WireConnection;319;0;323;0
WireConnection;319;1;318;0
WireConnection;307;0;306;1
WireConnection;307;1;306;2
WireConnection;308;0;306;3
WireConnection;144;1;319;0
WireConnection;324;0;144;1
WireConnection;324;3;325;0
WireConnection;305;0;302;0
WireConnection;305;2;307;0
WireConnection;305;1;308;0
WireConnection;301;0;305;0
WireConnection;301;1;304;0
WireConnection;326;0;324;0
WireConnection;155;0;326;0
WireConnection;155;1;156;0
WireConnection;155;2;300;0
WireConnection;155;3;301;0
WireConnection;151;0;155;0
WireConnection;287;0;288;0
WireConnection;287;1;292;1
WireConnection;287;2;292;2
WireConnection;287;4;294;0
WireConnection;297;0;287;0
WireConnection;297;1;153;0
WireConnection;181;0;179;1
WireConnection;181;1;179;3
WireConnection;182;0;180;1
WireConnection;182;1;180;3
WireConnection;184;0;181;0
WireConnection;183;0;182;0
WireConnection;53;0;48;0
WireConnection;54;0;297;0
WireConnection;54;1;55;0
WireConnection;49;0;54;0
WireConnection;49;1;53;0
WireConnection;185;0;183;0
WireConnection;185;1;184;0
WireConnection;50;0;49;0
WireConnection;186;0;185;0
WireConnection;51;0;50;0
WireConnection;51;1;53;0
WireConnection;190;0;186;0
WireConnection;190;1;188;0
WireConnection;194;0;190;0
WireConnection;189;0;187;1
WireConnection;189;1;187;3
WireConnection;56;0;51;0
WireConnection;56;1;55;0
WireConnection;281;0;185;0
WireConnection;63;0;56;0
WireConnection;195;1;191;0
WireConnection;200;0;194;0
WireConnection;193;0;189;0
WireConnection;126;0;177;0
WireConnection;198;0;194;0
WireConnection;197;1;192;0
WireConnection;202;0;281;0
WireConnection;202;2;197;1
WireConnection;202;3;195;1
WireConnection;201;0;281;0
WireConnection;201;2;200;0
WireConnection;201;3;198;0
WireConnection;90;0;88;0
WireConnection;90;1;89;1
WireConnection;196;0;193;0
WireConnection;196;1;184;0
WireConnection;127;0;126;0
WireConnection;204;0;201;0
WireConnection;204;1;202;0
WireConnection;91;0;90;0
WireConnection;243;1;196;0
WireConnection;289;1;310;0
WireConnection;30;0;28;1
WireConnection;30;1;28;2
WireConnection;31;0;45;0
WireConnection;29;0;28;3
WireConnection;92;0;91;0
WireConnection;92;1;91;1
WireConnection;206;0;243;0
WireConnection;206;1;204;0
WireConnection;32;0;31;0
WireConnection;32;2;30;0
WireConnection;32;1;29;0
WireConnection;104;3;103;0
WireConnection;295;0;289;0
WireConnection;14;1;17;1
WireConnection;14;2;17;2
WireConnection;14;3;17;3
WireConnection;134;0;104;0
WireConnection;134;1;132;0
WireConnection;93;0;92;0
WireConnection;93;1;91;2
WireConnection;207;0;206;0
WireConnection;332;0;330;0
WireConnection;332;1;333;0
WireConnection;329;0;328;0
WireConnection;137;0;14;0
WireConnection;33;1;32;0
WireConnection;334;0;332;0
WireConnection;334;1;335;0
WireConnection;94;0;93;0
WireConnection;327;0;134;0
WireConnection;327;1;329;0
WireConnection;327;2;328;0
WireConnection;283;0;137;0
WireConnection;283;1;33;0
WireConnection;283;2;137;0
WireConnection;157;0;3;0
WireConnection;157;1;296;0
WireConnection;157;2;289;4
WireConnection;5;1;64;0
WireConnection;39;0;44;0
WireConnection;38;0;36;1
WireConnection;38;1;36;2
WireConnection;37;0;36;3
WireConnection;75;0;74;0
WireConnection;75;1;73;0
WireConnection;284;0;14;0
WireConnection;40;0;39;0
WireConnection;40;2;38;0
WireConnection;40;1;37;0
WireConnection;336;0;334;0
WireConnection;282;0;208;0
WireConnection;282;1;327;0
WireConnection;164;0;161;1
WireConnection;61;0;157;0
WireConnection;124;0;5;1
WireConnection;124;1;5;2
WireConnection;124;2;5;3
WireConnection;285;0;284;0
WireConnection;285;1;283;0
WireConnection;76;0;75;0
WireConnection;167;0;164;0
WireConnection;167;1;162;0
WireConnection;337;0;336;0
WireConnection;101;0;100;0
WireConnection;101;1;282;0
WireConnection;286;0;285;0
WireConnection;35;1;40;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;7;0;6;0
WireConnection;7;1;66;0
WireConnection;7;2;124;0
WireConnection;166;1;163;1
WireConnection;166;2;163;2
WireConnection;166;3;163;3
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;171;0;166;0
WireConnection;135;0;101;0
WireConnection;138;0;286;0
WireConnection;138;1;21;0
WireConnection;138;2;123;0
WireConnection;34;0;7;0
WireConnection;34;1;35;0
WireConnection;338;0;337;0
WireConnection;338;1;339;0
WireConnection;170;0;165;2
WireConnection;170;1;165;1
WireConnection;170;2;167;0
WireConnection;342;0;135;0
WireConnection;342;1;338;0
WireConnection;23;0;34;0
WireConnection;23;1;138;0
WireConnection;113;0;112;0
WireConnection;113;1;115;0
WireConnection;173;0;168;0
WireConnection;173;1;170;0
WireConnection;173;2;171;0
WireConnection;172;0;169;0
WireConnection;81;1;80;0
WireConnection;114;0;113;0
WireConnection;70;0;23;0
WireConnection;82;0;81;0
WireConnection;174;0;173;0
WireConnection;174;1;172;0
WireConnection;141;0;342;0
WireConnection;140;0;141;0
WireConnection;140;1;117;0
WireConnection;175;0;174;0
WireConnection;96;1;90;0
WireConnection;96;0;95;0
WireConnection;119;0;62;0
WireConnection;119;1;43;0
WireConnection;97;0;96;0
WireConnection;85;0;83;0
WireConnection;85;1;86;0
WireConnection;142;0;98;0
WireConnection;142;1;102;0
WireConnection;142;2;140;0
WireConnection;84;0;142;0
WireConnection;84;1;85;0
WireConnection;84;2;176;0
WireConnection;84;3;119;0
WireConnection;130;0;84;0
WireConnection;130;1;108;0
WireConnection;105;0;130;0
WireConnection;149;0;146;1
WireConnection;149;1;146;2
WireConnection;150;0;147;0
WireConnection;150;2;149;0
WireConnection;150;1;148;0
WireConnection;244;0;187;0
WireConnection;148;0;146;3
WireConnection;248;0;180;0
WireConnection;128;0;129;0
WireConnection;131;1;133;0
WireConnection;147;0;145;0
WireConnection;0;13;71;0
ASEEND*/
//CHKSM=8C96FFA3006C1578264FC7F428ECCE2A701980DC