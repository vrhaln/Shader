// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Glass2"
{
	Properties
	{
		_BlendContrast("BlendContrast", Range( 0.1 , 1)) = 0.1
		_GlassOpacityIntensity("GlassOpacityIntensity", Float) = 0
		_glassTilling("glassTilling", Float) = 1
		_GlassColor("GlassColor", Color) = (1,1,1,1)
		_GlassNormal("GlassNormal", 2D) = "bump" {}
		_Smootness("Smootness", Float) = 0
		_HighlightColor("HighlightColor", Color) = (1,1,1,1)
		_Hightlightsize("Hightlightsize", Float) = 0
		_Tex1Tilling("Tex1Tilling", Float) = 1
		_SurfaceTex("SurfaceTex", 2D) = "white" {}
		_Surface1Normal("Surface1Normal", 2D) = "bump" {}
		_SurfaceBaseColor("SurfaceBaseColor", Color) = (0,0,0,0)
		_SurfaceShaowColor("SurfaceShaowColor", Color) = (0,0,0,0)
		_Tex2Tilling("Tex2Tilling", Float) = 1
		_SurfaceTex2("SurfaceTex2", 2D) = "white" {}
		_Surface2Normal("Surface2Normal", 2D) = "bump" {}
		_SurfaceBaseColor2("SurfaceBaseColor2", Color) = (0,0,0,0)
		_SurfaceShaowColor2("SurfaceShaowColor2", Color) = (0,0,0,0)
		_MaxDistance("MaxDistance", Float) = 1
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_Float2("Float 2", Float) = 1
		_Float3("Float 3", Float) = 0
		_Float5("Float 5", Float) = 1
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

		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
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
			float4 vertexColor : COLOR;
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

		uniform float _MaxDistance;
		uniform float _Float2;
		uniform float _Float3;
		uniform float3 _Vector0;
		uniform float _Float5;
		uniform float4 _GlassColor;
		uniform float _GlassOpacityIntensity;
		uniform float _BlendContrast;
		uniform sampler2D _SurfaceTex;
		uniform float _Tex1Tilling;
		uniform sampler2D _SurfaceTex2;
		uniform float _Tex2Tilling;
		uniform sampler2D _GlassNormal;
		uniform float _glassTilling;
		uniform sampler2D _Surface1Normal;
		uniform sampler2D _Surface2Normal;
		uniform float _Smootness;
		uniform float4 _SurfaceShaowColor;
		uniform sampler2D SurfaceTexSample;
		uniform float4 SurfaceTexSample_ST;
		uniform float4 _SurfaceBaseColor;
		uniform float4 _SurfaceShaowColor2;
		uniform float4 _SurfaceTex2_ST;
		uniform float4 _SurfaceBaseColor2;
		uniform float4 _HighlightColor;
		uniform float _Hightlightsize;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 break277 = ase_worldPos;
			float clampResult271 = clamp( cos( ( ( _Time.y + ( _Float2 * sqrt( ( ( break277.x * break277.x ) + ( break277.y * break277.y ) + ( break277.z * 0.0 ) ) ) ) ) * _Float3 ) ) , 0.0 , 1.0 );
			float4 appendResult238 = (float4(0.0 , 0.0 , ( _MaxDistance * clampResult271 ) , 0.0));
			float clampResult291 = clamp( ( length( ( ase_worldPos - _Vector0 ) ) * _Float5 ) , 0.0 , 1.0 );
			v.vertex.xyz += ( appendResult238 * ( 1.0 - clampResult291 ) ).xyz;
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
			float GlassOpacity195 = ( _GlassColor.a * _GlassOpacityIntensity );
			float temp_output_332_0 = ( 1.0 + i.vertexColor.r );
			float temp_output_333_0 = ( 1.0 + i.vertexColor.g );
			float temp_output_335_0 = ( 1.0 + i.vertexColor.b );
			float temp_output_338_0 = ( max( max( temp_output_332_0 , temp_output_333_0 ) , temp_output_335_0 ) - _BlendContrast );
			float temp_output_344_0 = max( ( temp_output_332_0 - temp_output_338_0 ) , 0.0 );
			float temp_output_342_0 = max( ( temp_output_333_0 - temp_output_338_0 ) , 0.0 );
			float temp_output_343_0 = max( ( temp_output_335_0 - temp_output_338_0 ) , 0.0 );
			float4 appendResult346 = (float4(temp_output_344_0 , temp_output_342_0 , temp_output_343_0 , 0.0));
			float4 BlendWeight348 = ( appendResult346 / ( temp_output_344_0 + temp_output_342_0 + temp_output_343_0 ) );
			float4 break390 = BlendWeight348;
			float2 temp_cast_0 = (_Tex1Tilling).xx;
			float2 uv_TexCoord178 = i.uv_texcoord * temp_cast_0;
			float2 UV1179 = uv_TexCoord178;
			float4 tex2DNode153 = tex2D( _SurfaceTex, UV1179 );
			float Surface1Opacity383 = tex2DNode153.a;
			float2 temp_cast_1 = (_Tex2Tilling).xx;
			float2 uv_TexCoord323 = i.uv_texcoord * temp_cast_1;
			float2 UV2322 = uv_TexCoord323;
			float4 tex2DNode301 = tex2D( _SurfaceTex2, UV2322 );
			float Surface2Opacity384 = tex2DNode301.a;
			float Opacity386 = ( ( GlassOpacity195 * break390.x ) + ( Surface1Opacity383 * break390.y ) + ( Surface2Opacity384 * break390.z ) );
			SurfaceOutputStandard s202 = (SurfaceOutputStandard ) 0;
			s202.Albedo = _GlassColor.rgb;
			float2 temp_cast_3 = (_glassTilling).xx;
			float2 uv_TexCoord380 = i.uv_texcoord * temp_cast_3;
			float2 UV0381 = uv_TexCoord380;
			float3 GlassNormal378 = UnpackNormal( tex2D( _GlassNormal, UV0381 ) );
			float4 break368 = BlendWeight348;
			float3 Surface1Normal376 = UnpackNormal( tex2D( _Surface1Normal, UV1179 ) );
			float3 Surface2Normal377 = UnpackNormal( tex2D( _Surface2Normal, UV2322 ) );
			float3 Normal373 = ( ( GlassNormal378 * break368.x ) + ( Surface1Normal376 * break368.y ) + ( Surface2Normal377 * break368.z ) );
			s202.Normal = WorldNormalVector( i , Normal373 );
			s202.Emission = float3( 0,0,0 );
			s202.Metallic = 0.0;
			s202.Smoothness = _Smootness;
			s202.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi202 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g202 = UnityGlossyEnvironmentSetup( s202.Smoothness, data.worldViewDir, s202.Normal, float3(0,0,0));
			gi202 = UnityGlobalIllumination( data, s202.Occlusion, s202.Normal, g202 );
			#endif

			float3 surfResult202 = LightingStandard ( s202, viewDir, gi202 ).rgb;
			surfResult202 += s202.Emission;

			#ifdef UNITY_PASS_FORWARDADD//202
			surfResult202 -= s202.Emission;
			#endif//202
			float3 GlassColor196 = surfResult202;
			float4 break351 = BlendWeight348;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_142_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 temp_cast_5 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch161 = temp_cast_5;
			#else
				float3 staticSwitch161 = temp_output_142_0;
			#endif
			float3 LightColor162 = staticSwitch161;
			float2 uvSurfaceTexSample = i.uv_texcoord * SurfaceTexSample_ST.xy + SurfaceTexSample_ST.zw;
			float4 ShaowColor166 = ( _SurfaceShaowColor * tex2D( SurfaceTexSample, uvSurfaceTexSample ) );
			float4 BaseColor165 = ( _SurfaceBaseColor * tex2DNode153 );
			float3 break143 = temp_output_142_0;
			float LightAtten159 = max( max( break143.x , break143.y ) , break143.z );
			float3 WorldNormal152 = normalize( (WorldNormalVector( i , Normal373 )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g11 = dot( WorldNormal152 , ase_worldlightDir );
			float4 lerpResult173 = lerp( ShaowColor166 , BaseColor165 , ( LightAtten159 * (dotResult5_g11*0.5 + 0.5) ));
			float4 Surfacecolor177 = max( ( float4( LightColor162 , 0.0 ) * lerpResult173 ) , float4( 0,0,0,0 ) );
			float2 uv_SurfaceTex2 = i.uv_texcoord * _SurfaceTex2_ST.xy + _SurfaceTex2_ST.zw;
			float4 ShaowColor2305 = ( _SurfaceShaowColor2 * tex2D( _SurfaceTex2, uv_SurfaceTex2 ) );
			float dotResult404 = dot( WorldNormal152 , ase_worldlightDir );
			float clampResult406 = clamp( dotResult404 , 0.0 , 1.0 );
			float smoothstepResult409 = smoothstep( 0.0 , 1.0 , pow( clampResult406 , _Hightlightsize ));
			float4 HightLightColor411 = ( _HighlightColor * smoothstepResult409 );
			float4 BaseColor2306 = ( ( _SurfaceBaseColor2 * tex2DNode301 ) + HightLightColor411 );
			float dotResult5_g10 = dot( WorldNormal152 , ase_worldlightDir );
			float4 lerpResult314 = lerp( ShaowColor2305 , BaseColor2306 , ( UNITY_LIGHTMODEL_AMBIENT + ( LightAtten159 * (dotResult5_g10*0.5 + 0.5) ) ));
			float4 Surfacecolor2318 = max( ( float4( LightColor162 , 0.0 ) * lerpResult314 ) , float4( 0,0,0,0 ) );
			float4 FinalColor359 = ( float4( ( GlassColor196 * break351.x ) , 0.0 ) + ( Surfacecolor177 * break351.y ) + ( Surfacecolor2318 * break351.z ) );
			c.rgb = FinalColor359.rgb;
			c.a = Opacity386;
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
				half4 color : COLOR0;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
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
2177;65;1694;893;3803.173;2075.002;2.4564;True;True
Node;AmplifyShaderEditor.CommentaryNode;328;-4244.062,275.4519;Inherit;False;2482.057;926.3203;BlendWeight;19;349;348;347;346;345;344;343;342;341;340;339;338;337;336;335;334;333;332;362;BlendWeight;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;349;-4171.899,555.9349;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;362;-3918.813,407.3933;Inherit;False;Constant;_Float0;Float 0;20;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;332;-3685.887,516.3002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;333;-3701.328,652.9272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;335;-3699.024,781.1949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;334;-3452.272,616.526;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;337;-3331.26,755.438;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;336;-3466.368,941.8729;Inherit;False;Property;_BlendContrast;BlendContrast;1;0;Create;True;0;0;False;0;False;0.1;0.01900554;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;338;-3168.994,895.775;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;321;-3330.229,-3404.766;Inherit;False;Property;_Tex2Tilling;Tex2Tilling;14;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;341;-2849.922,785.243;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;339;-2851.496,904.72;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;340;-2845.941,664.3651;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;379;-3322.035,-3725.479;Inherit;False;Property;_glassTilling;glassTilling;3;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-3314.389,-3570.451;Inherit;False;Property;_Tex1Tilling;Tex1Tilling;9;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;178;-3114.297,-3597.427;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;344;-2686.291,663.9691;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;342;-2683.291,786.9691;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;323;-3140.732,-3431.742;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;343;-2683.291,906.9691;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;380;-3118.538,-3753.455;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;345;-2456.367,885.388;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;381;-2839.044,-3753.526;Inherit;False;UV0;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;322;-2861.238,-3431.813;Inherit;False;UV2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;-2834.803,-3597.498;Inherit;False;UV1;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;399;-2423.376,1562.564;Inherit;False;828.8174;733.2639;Comment;9;190;382;375;374;181;204;378;376;377;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;346;-2407.841,671.1141;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;347;-2233.894,771.8111;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;382;-2390.376,1640.413;Inherit;False;381;UV0;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-2391.857,1843.717;Inherit;False;179;UV1;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;375;-2389.504,2054.046;Inherit;False;322;UV2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;181;-2167.982,1848.803;Inherit;True;Property;_Surface1Normal;Surface1Normal;11;0;Create;True;0;0;False;0;False;-1;None;f8301a4af0b843f43bb31cb630542854;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;348;-1949.652,718.1551;Inherit;False;BlendWeight;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;374;-2166.023,2065.828;Inherit;True;Property;_Surface2Normal;Surface2Normal;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;363;-4139.031,2369.094;Inherit;False;1461.724;462.7566;Normal;10;373;372;371;370;369;368;367;366;365;364;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;204;-2164.134,1612.564;Inherit;True;Property;_GlassNormal;GlassNormal;5;0;Create;True;0;0;False;0;False;-1;None;2aab2b9fb283e6646ad7f1df2f799dc1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;378;-1820.523,1654.12;Inherit;False;GlassNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;376;-1823.048,1903.184;Inherit;False;Surface1Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;364;-4111.878,2522.599;Inherit;False;348;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;377;-1824.559,2102.01;Inherit;False;Surface2Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;367;-3514.236,2410.771;Inherit;False;378;GlassNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;365;-3513.366,2664.626;Inherit;False;377;Surface2Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;-3508.142,2538.072;Inherit;False;376;Surface1Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;368;-3878.328,2529.32;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;370;-3294.85,2551.875;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;-3298.643,2414.356;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;-3296.556,2689.664;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;372;-3037.789,2541.803;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;373;-2876.695,2544.543;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;-4496.794,-3597.328;Inherit;False;373;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;144;-4199.525,-3652.443;Inherit;False;504.303;432.5138;WorldNormal&ViewDir;4;164;163;152;148;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;148;-4161.243,-3590.954;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-3939.485,-3594.331;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;401;-1966.077,-4083.188;Inherit;False;2226.411;694.3837;HightLightColor;10;411;410;409;408;407;406;405;404;403;402;HightLightColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;403;-1930.497,-3855.477;Inherit;False;152;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;402;-1930.497,-3759.477;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;404;-1562.497,-3823.477;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;139;-4186.263,-2446.159;Inherit;False;1513.141;690.5745;LightAtten;10;162;161;159;157;155;147;143;142;141;140;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;405;-1297.723,-3698.799;Inherit;False;Property;_Hightlightsize;Hightlightsize;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;406;-1274.496,-3855.477;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;141;-4119.975,-1950.505;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation;140;-4136.263,-2155.365;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-3866.52,-2084.82;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;407;-1070.077,-3859.188;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;125.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;143;-3583.321,-2057.858;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;408;-750.0771,-4035.188;Inherit;False;Property;_HighlightColor;HighlightColor;7;0;Create;True;0;0;False;0;False;1,1,1,1;0.03773582,0.03773582,0.03773582,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;409;-766.0771,-3843.188;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;-1082.996,-2830.766;Inherit;False;322;UV2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;298;-925.9488,-3121.447;Inherit;False;919.8992;508.5779;SurfaceBaseColor2;7;306;304;301;300;384;412;413;SurfaceBaseColor2;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;-414.0771,-3955.188;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;147;-3313.017,-2086.967;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;300;-849.8217,-3071.447;Inherit;False;Property;_SurfaceBaseColor2;SurfaceBaseColor2;17;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;145;-3100.073,-3119.464;Inherit;False;919.8992;508.5779;SurfaceBaseColor;5;165;160;153;150;383;SurfaceBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;155;-3166.068,-2033.649;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;149;-4198.95,-3116.656;Inherit;False;1009.513;513.5418;SurfaceShaowColor;4;166;158;156;151;SurfaceShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-3236.777,-2859.932;Inherit;False;179;UV1;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;307;-2165.357,-1627.265;Inherit;False;1845.121;682.3715;SurfaceColor2;13;318;317;316;315;314;313;312;311;310;309;308;414;415;SurfaceColor2;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;296;-2024.826,-3118.639;Inherit;False;1009.513;513.5418;SurfaceShaowColor2;4;305;303;302;299;SurfaceShaowColor2;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;301;-883.6108,-2855.098;Inherit;True;Property;_SurfaceTex2;SurfaceTex2;15;0;Create;True;0;0;False;0;False;-1;None;bc3f3bccedf6ff946bdb41259943917d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;411;-110.0771,-3923.188;Inherit;False;HightLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;150;-3023.946,-3069.464;Inherit;False;Property;_SurfaceBaseColor;SurfaceBaseColor;12;0;Create;True;0;0;False;0;False;0,0,0,0;0.9339623,0.7520236,0.4625756,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-525.239,-2937.031;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;412;-576.6506,-2794.735;Inherit;False;411;HightLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;154;-4158.736,-1606.503;Inherit;False;1845.121;682.3715;SurfaceColor;11;176;175;174;173;172;171;170;169;168;167;177;SurfaceColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;205;-1469.153,795.2236;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;151;-4086.95,-3068.656;Inherit;False;Property;_SurfaceShaowColor;SurfaceShaowColor;13;0;Create;True;0;0;False;0;False;0,0,0,0;0.990566,0.7679494,0.359781,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;302;-1954.825,-3083.639;Inherit;False;Property;_SurfaceShaowColor2;SurfaceShaowColor2;18;0;Create;True;0;0;False;0;False;0,0,0,0;0.8313726,0.7254902,0.5372549,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;156;-4150.95,-2876.656;Inherit;True;Global;SurfaceTexSample;SurfaceTexSample;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;308;-2162.257,-1194.362;Inherit;False;152;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-2897.127,-2052.884;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;299;-1937.825,-2876.639;Inherit;True;Global;SurfaceTexSample2;SurfaceTexSample2;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;301;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;153;-3057.735,-2853.115;Inherit;True;Property;_SurfaceTex;SurfaceTex;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-1592.825,-2894.639;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-3766.95,-2892.656;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;277;-1215.127,828.274;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;157;-3705.914,-2320.917;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-4112.636,-1167.601;Inherit;False;152;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-2699.363,-2935.048;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;413;-330.769,-2889.968;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-1997.98,-1272.966;Inherit;False;159;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;309;-1987.242,-1167.557;Inherit;True;Half Lambert Term;-1;;10;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-919.3536,839.9858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-918.3536,950.9858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-921.3536,720.9858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;161;-3464.335,-2339.472;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;166;-3586.95,-2892.656;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;415;-1793.873,-1284.855;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;306;-208.9419,-2966.954;Inherit;False;BaseColor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-3858.358,-1262.205;Inherit;False;159;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;169;-3866.62,-1160.796;Inherit;True;Half Lambert Term;-1;;11;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;305;-1401.825,-2898.639;Inherit;False;ShaowColor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;-1759.603,-1203.893;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;-2470.066,-2921.971;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-3541.981,-1178.132;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-3109.318,-2342.592;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;414;-1454.873,-1202.855;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1509.214,-1404.135;Inherit;False;305;ShaowColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-3511.591,-1477.373;Inherit;False;166;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;-754.3535,833.9858;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;-1507.447,-1307.235;Inherit;False;306;BaseColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-3507.825,-1408.474;Inherit;False;165;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;-3236.291,-1556.504;Inherit;True;162;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;229;-605.8373,839.7893;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;400;-3559.923,-759.394;Inherit;False;1239.297;554.5985;Glass;8;398;203;199;194;202;200;196;195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;314;-1271.47,-1343.031;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-1242.913,-1577.266;Inherit;True;162;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;173;-3264.848,-1322.27;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-665.107,697.0045;Inherit;False;Property;_Float2;Float 2;21;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-511.3014,741.784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;-936.3652,-1403.382;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;264;-496.4471,611.1796;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;-3231.869,-367.9955;Inherit;False;Property;_GlassOpacityIntensity;GlassOpacityIntensity;2;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-2929.743,-1382.621;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;-3199.843,-709.394;Inherit;False;373;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-3175.292,-527.4285;Inherit;False;Property;_Smootness;Smootness;6;0;Create;True;0;0;False;0;False;0;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;194;-3509.923,-614.4662;Inherit;False;Property;_GlassColor;GlassColor;4;0;Create;True;0;0;False;0;False;1,1,1,1;0.6989847,0.7455837,0.765,0.509804;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;269;-190.6045,864.0029;Inherit;False;Property;_Float3;Float 3;22;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;350;-4166.61,1599.049;Inherit;False;1462.174;467.2252;Base_Color;10;360;359;358;357;356;355;354;353;352;351;Base_Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;278;145.4458,1170.064;Inherit;False;Property;_Vector0;Vector 0;20;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;317;-701.3603,-1392.538;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;265;-306.4471,677.1796;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;176;-2694.738,-1371.777;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;202;-2927.386,-694.4872;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;385;-4119.321,3049.631;Inherit;False;1461.724;462.7566;Opacity;10;395;394;393;392;391;390;389;388;387;386;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-2900.969,-458.7955;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;286;115.5552,1019.893;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;383;-2646.316,-2722.902;Inherit;False;Surface1Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;-1.890076,834.457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;384;-471.2941,-2704.036;Inherit;False;Surface2Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;288;301.5554,1043.893;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-2544.626,-456.423;Inherit;False;GlassOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;-2548.308,-639.7321;Inherit;False;GlassColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;360;-4140.121,1807.901;Inherit;False;348;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-2518.008,-1360.072;Inherit;False;Surfacecolor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;318;-544.2383,-1369.486;Inherit;False;Surfacecolor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;387;-4092.169,3203.136;Inherit;False;348;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;388;-3488.433,3218.609;Inherit;False;383;Surface1Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;353;-3568.79,1651.589;Inherit;False;196;GlassColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;294;400.8836,1143.008;Inherit;False;Property;_Float5;Float 5;23;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;260;152.5895,757.745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;354;-3569.63,1924.736;Inherit;False;318;Surfacecolor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;390;-3858.619,3209.857;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;351;-3916.33,1781.964;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LengthOpNode;289;427.5553,1026.893;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;352;-3570.695,1787.953;Inherit;False;177;Surfacecolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;395;-3493.657,3345.163;Inherit;False;384;Surface2Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;389;-3494.527,3091.308;Inherit;False;195;GlassOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;355;-3339.752,1657.107;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;391;-3278.934,3094.893;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;323.7285,613.4169;Inherit;False;Property;_MaxDistance;MaxDistance;19;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;-3276.847,3370.201;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;547.8836,1123.008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;-3275.141,3232.412;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;271;338.4827,755.1825;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;-3337.666,1932.416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;-3335.959,1794.627;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;394;-3018.08,3222.34;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;749.2674,883.2847;Inherit;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;291;744.0984,1006.165;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;358;-3078.898,1784.555;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;590.5572,680.2682;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;293;952.5423,880.9755;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;359;-2907.329,1791.96;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;238;851.4585,507.1771;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;386;-2856.986,3225.08;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-3935.444,-3392.493;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;164;-4147.576,-3395.833;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;396;1240.35,107.5345;Inherit;False;386;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;1206.967,490.0963;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;361;1241.213,204.2696;Inherit;False;359;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1610.577,-39.47596;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Glass2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;332;0;362;0
WireConnection;332;1;349;1
WireConnection;333;0;362;0
WireConnection;333;1;349;2
WireConnection;335;0;362;0
WireConnection;335;1;349;3
WireConnection;334;0;332;0
WireConnection;334;1;333;0
WireConnection;337;0;334;0
WireConnection;337;1;335;0
WireConnection;338;0;337;0
WireConnection;338;1;336;0
WireConnection;341;0;333;0
WireConnection;341;1;338;0
WireConnection;339;0;335;0
WireConnection;339;1;338;0
WireConnection;340;0;332;0
WireConnection;340;1;338;0
WireConnection;178;0;191;0
WireConnection;344;0;340;0
WireConnection;342;0;341;0
WireConnection;323;0;321;0
WireConnection;343;0;339;0
WireConnection;380;0;379;0
WireConnection;345;0;344;0
WireConnection;345;1;342;0
WireConnection;345;2;343;0
WireConnection;381;0;380;0
WireConnection;322;0;323;0
WireConnection;179;0;178;0
WireConnection;346;0;344;0
WireConnection;346;1;342;0
WireConnection;346;2;343;0
WireConnection;347;0;346;0
WireConnection;347;1;345;0
WireConnection;181;1;190;0
WireConnection;348;0;347;0
WireConnection;374;1;375;0
WireConnection;204;1;382;0
WireConnection;378;0;204;0
WireConnection;376;0;181;0
WireConnection;377;0;374;0
WireConnection;368;0;364;0
WireConnection;370;0;366;0
WireConnection;370;1;368;1
WireConnection;369;0;367;0
WireConnection;369;1;368;0
WireConnection;371;0;365;0
WireConnection;371;1;368;2
WireConnection;372;0;369;0
WireConnection;372;1;370;0
WireConnection;372;2;371;0
WireConnection;373;0;372;0
WireConnection;148;0;397;0
WireConnection;152;0;148;0
WireConnection;404;0;403;0
WireConnection;404;1;402;0
WireConnection;406;0;404;0
WireConnection;142;0;140;0
WireConnection;142;1;141;1
WireConnection;407;0;406;0
WireConnection;407;1;405;0
WireConnection;143;0;142;0
WireConnection;409;0;407;0
WireConnection;410;0;408;0
WireConnection;410;1;409;0
WireConnection;147;0;143;0
WireConnection;147;1;143;1
WireConnection;155;0;147;0
WireConnection;155;1;143;2
WireConnection;301;1;324;0
WireConnection;411;0;410;0
WireConnection;304;0;300;0
WireConnection;304;1;301;0
WireConnection;159;0;155;0
WireConnection;153;1;146;0
WireConnection;303;0;302;0
WireConnection;303;1;299;0
WireConnection;158;0;151;0
WireConnection;158;1;156;0
WireConnection;277;0;205;0
WireConnection;160;0;150;0
WireConnection;160;1;153;0
WireConnection;413;0;304;0
WireConnection;413;1;412;0
WireConnection;309;3;308;0
WireConnection;211;0;277;1
WireConnection;211;1;277;1
WireConnection;212;0;277;2
WireConnection;209;0;277;0
WireConnection;209;1;277;0
WireConnection;161;1;142;0
WireConnection;161;0;157;0
WireConnection;166;0;158;0
WireConnection;306;0;413;0
WireConnection;169;3;167;0
WireConnection;305;0;303;0
WireConnection;312;0;310;0
WireConnection;312;1;309;0
WireConnection;165;0;160;0
WireConnection;172;0;168;0
WireConnection;172;1;169;0
WireConnection;162;0;161;0
WireConnection;414;0;415;0
WireConnection;414;1;312;0
WireConnection;213;0;209;0
WireConnection;213;1;211;0
WireConnection;213;2;212;0
WireConnection;229;0;213;0
WireConnection;314;0;311;0
WireConnection;314;1;313;0
WireConnection;314;2;414;0
WireConnection;173;0;171;0
WireConnection;173;1;170;0
WireConnection;173;2;172;0
WireConnection;262;0;261;0
WireConnection;262;1;229;0
WireConnection;316;0;315;0
WireConnection;316;1;314;0
WireConnection;175;0;174;0
WireConnection;175;1;173;0
WireConnection;317;0;316;0
WireConnection;265;0;264;0
WireConnection;265;1;262;0
WireConnection;176;0;175;0
WireConnection;202;0;194;0
WireConnection;202;1;398;0
WireConnection;202;4;203;0
WireConnection;200;0;194;4
WireConnection;200;1;199;0
WireConnection;383;0;153;4
WireConnection;270;0;265;0
WireConnection;270;1;269;0
WireConnection;384;0;301;4
WireConnection;288;0;286;0
WireConnection;288;1;278;0
WireConnection;195;0;200;0
WireConnection;196;0;202;0
WireConnection;177;0;176;0
WireConnection;318;0;317;0
WireConnection;260;0;270;0
WireConnection;390;0;387;0
WireConnection;351;0;360;0
WireConnection;289;0;288;0
WireConnection;355;0;353;0
WireConnection;355;1;351;0
WireConnection;391;0;389;0
WireConnection;391;1;390;0
WireConnection;393;0;395;0
WireConnection;393;1;390;2
WireConnection;295;0;289;0
WireConnection;295;1;294;0
WireConnection;392;0;388;0
WireConnection;392;1;390;1
WireConnection;271;0;260;0
WireConnection;356;0;354;0
WireConnection;356;1;351;2
WireConnection;357;0;352;0
WireConnection;357;1;351;1
WireConnection;394;0;391;0
WireConnection;394;1;392;0
WireConnection;394;2;393;0
WireConnection;291;0;295;0
WireConnection;358;0;355;0
WireConnection;358;1;357;0
WireConnection;358;2;356;0
WireConnection;267;0;234;0
WireConnection;267;1;271;0
WireConnection;293;0;292;0
WireConnection;293;1;291;0
WireConnection;359;0;358;0
WireConnection;238;2;267;0
WireConnection;386;0;394;0
WireConnection;163;0;164;0
WireConnection;287;0;238;0
WireConnection;287;1;293;0
WireConnection;0;9;396;0
WireConnection;0;13;361;0
WireConnection;0;11;287;0
ASEEND*/
//CHKSM=B2F18CA7C9A2513C8D22DB907863887B498A2CF9