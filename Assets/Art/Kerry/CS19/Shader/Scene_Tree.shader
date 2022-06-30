// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Scene_Tree"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Roughness("Roughness", Range( 0 , 1)) = 1
		_BaseColor_Beaf("BaseColor_Beaf", 2D) = "white" {}
		_Normal_Beaf("Normal_Beaf", 2D) = "bump" {}
		_BaseColor_Branch("BaseColor_Branch", 2D) = "white" {}
		_Normal_Branch("Normal_Branch", 2D) = "bump" {}
		_SSSColor("SSSColor", Color) = (1,1,1,0)
		_SSSIntensity("SSSIntensity", Float) = 0
		_SSSDistort("SSSDistort", Range( 0 , 1)) = 0
		_GlobalWindSpeed("GlobalWindSpeed", Float) = 1
		_GlobalWindDirection("GlobalWindDirection", Vector) = (0,0,0,0)
		_GlobalWindIntensity("GlobalWindIntensity", Float) = 1
		_SmallWindSpeed("SmallWindSpeed", Float) = 1
		_SmallWindDirection("SmallWindDirection", Vector) = (0,0,1,0)
		_SmallWindIntensity("SmallWindIntensity", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "DisableBatching" = "True" }
		Cull Off
		AlphaToMask On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
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
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
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

		uniform float _GlobalWindSpeed;
		uniform float _GlobalWindIntensity;
		uniform float3 _GlobalWindDirection;
		uniform float3 _SmallWindDirection;
		uniform float _SmallWindSpeed;
		uniform float _SmallWindIntensity;
		uniform sampler2D _BaseColor_Beaf;
		uniform float4 _BaseColor_Beaf_ST;
		uniform sampler2D _BaseColor_Branch;
		uniform float4 _BaseColor_Branch_ST;
		uniform sampler2D _Normal_Beaf;
		uniform float4 _Normal_Beaf_ST;
		uniform sampler2D _Normal_Branch;
		uniform float4 _Normal_Branch_ST;
		uniform float _SSSDistort;
		uniform float4 _SSSColor;
		uniform float _SSSIntensity;
		uniform float _Roughness;
		uniform float _Cutoff = 0.5;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_55_0 = ( ( _GlobalWindSpeed * _Time.y ) * UNITY_PI );
			float temp_output_67_0 = ( _GlobalWindIntensity * 0.1 );
			float3 temp_output_2_0_g1 = _SmallWindDirection;
			float3 RotateAxis5_g1 = cross( temp_output_2_0_g1 , float3(0,1,0) );
			float3 wind_direction3_g1 = temp_output_2_0_g1;
			float3 wind_speed15_g1 = ( ( _Time.y * _SmallWindSpeed ) * float3(0.5,-0.5,-0.5) );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 temp_cast_0 = (1.0).xxx;
			float3 temp_output_31_0_g1 = abs( ( ( frac( ( ( ( wind_direction3_g1 * wind_speed15_g1 ) + ( ase_worldPos / 10.0 ) ) + 0.5 ) ) * 2.0 ) - temp_cast_0 ) );
			float3 temp_cast_1 = (3.0).xxx;
			float dotResult38_g1 = dot( ( ( temp_output_31_0_g1 * temp_output_31_0_g1 ) * ( temp_cast_1 - ( temp_output_31_0_g1 * 2.0 ) ) ) , wind_direction3_g1 );
			float BigTriangleWave40_g1 = dotResult38_g1;
			float3 temp_cast_2 = (1.0).xxx;
			float3 temp_output_54_0_g1 = abs( ( ( frac( ( ( wind_speed15_g1 + ( ase_worldPos / 2.0 ) ) + 0.5 ) ) * 2.0 ) - temp_cast_2 ) );
			float3 temp_cast_3 = (3.0).xxx;
			float SmallTriangleWave63_g1 = distance( ( ( temp_output_54_0_g1 * temp_output_54_0_g1 ) * ( temp_cast_3 - ( temp_output_54_0_g1 * 2.0 ) ) ) , float3(0,0,0) );
			float3 rotatedValue68_g1 = RotateAroundAxis( ( ase_worldPos - float3(0,0.1,0) ), ase_worldPos, RotateAxis5_g1, ( ( BigTriangleWave40_g1 + SmallTriangleWave63_g1 ) * ( 2.0 * UNITY_PI ) ) );
			float3 worldToObj75_g1 = mul( unity_WorldToObject, float4( rotatedValue68_g1, 1 ) ).xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 WindVertexOffset58 = ( ( v.color.r * ( sin( temp_output_55_0 ) * temp_output_67_0 ) * _GlobalWindDirection ) + ( _GlobalWindDirection * ( cos( temp_output_55_0 ) * temp_output_67_0 ) * v.color.g ) + ( v.color.g * ( worldToObj75_g1 - ase_vertex3Pos ) * _SmallWindIntensity ) );
			v.vertex.xyz += WindVertexOffset58;
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
			float2 uv_BaseColor_Beaf = i.uv_texcoord * _BaseColor_Beaf_ST.xy + _BaseColor_Beaf_ST.zw;
			float4 tex2DNode3 = tex2D( _BaseColor_Beaf, uv_BaseColor_Beaf );
			float lerpResult19 = lerp( tex2DNode3.a , 1.0 , i.vertexColor.a);
			float AlphaMask20 = lerpResult19;
			SurfaceOutputStandard s2 = (SurfaceOutputStandard ) 0;
			float2 uv_BaseColor_Branch = i.uv_texcoord * _BaseColor_Branch_ST.xy + _BaseColor_Branch_ST.zw;
			float4 lerpResult5 = lerp( tex2DNode3 , tex2D( _BaseColor_Branch, uv_BaseColor_Branch ) , i.vertexColor.a);
			float4 BaseColor6 = lerpResult5;
			s2.Albedo = BaseColor6.rgb;
			float2 uv_Normal_Beaf = i.uv_texcoord * _Normal_Beaf_ST.xy + _Normal_Beaf_ST.zw;
			float3 tex2DNode9 = UnpackNormal( tex2D( _Normal_Beaf, uv_Normal_Beaf ) );
			float3 appendResult23 = (float3(tex2DNode9.r , tex2DNode9.g , -tex2DNode9.b));
			float3 switchResult22 = (((i.ASEVFace>0)?(tex2DNode9):(appendResult23)));
			float2 uv_Normal_Branch = i.uv_texcoord * _Normal_Branch_ST.xy + _Normal_Branch_ST.zw;
			float3 lerpResult7 = lerp( switchResult22 , UnpackNormal( tex2D( _Normal_Branch, uv_Normal_Branch ) ) , i.vertexColor.a);
			float3 Normal11 = lerpResult7;
			s2.Normal = WorldNormalVector( i , Normal11 );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult26 = normalize( ( ase_worldlightDir + ( (WorldNormalVector( i , Normal11 )) * _SSSDistort ) ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult28 = dot( -normalizeResult26 , ase_worldViewDir );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 SSSColor37 = ( (( ( max( dotResult28 , 0.0 ) * ( i.vertexColor.b * ( 1.0 - i.vertexColor.a ) ) ) * _SSSColor * _SSSIntensity * BaseColor6 * float4( ase_lightColor.rgb , 0.0 ) )).rgb * (ase_lightAtten*0.5 + 0.5) );
			s2.Emission = SSSColor37;
			s2.Metallic = 0.0;
			s2.Smoothness = ( 1.0 - _Roughness );
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
			clip( AlphaMask20 - _Cutoff );
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
			AlphaToMask Off
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
350;1178;1285;741;2318.783;-1014.72;1.175553;True;False
Node;AmplifyShaderEditor.CommentaryNode;13;-2987.861,383.3393;Inherit;False;1354.402;746.6257;Normal;8;22;7;11;8;10;9;23;24;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;9;-2933.14,433.3393;Inherit;True;Property;_Normal_Beaf;Normal_Beaf;3;0;Create;True;0;0;False;0;False;-1;None;c74bb765f5262b840b32f39d83e0baea;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;24;-2622.754,560.1852;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-2492.635,499.7054;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;8;-2838.071,900.5646;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;22;-2358.498,438.2549;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-2937.861,650.975;Inherit;True;Property;_Normal_Branch;Normal_Branch;5;0;Create;True;0;0;False;0;False;-1;None;03625983268efe145a35f03d8b768c37;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-2162.405,620.3851;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;38;-3002.64,1265.726;Inherit;False;2804.097;891.4933;SSSColor;25;37;80;36;79;31;34;33;48;32;35;49;30;47;28;29;45;27;26;41;43;25;42;40;39;81;SSSColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1869.659,467.766;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-2944.893,1495.341;Inherit;False;11;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;40;-2783.893,1502.341;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;42;-2867.421,1674.612;Inherit;False;Property;_SSSDistort;SSSDistort;8;0;Create;True;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;25;-2789.413,1319.496;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2585.33,1516.35;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-2417.033,1427.74;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;26;-2269.195,1359.245;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2976.43,-466.8906;Inherit;False;936.4236;724.2257;BaseColor;7;6;5;1;3;4;19;20;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;1;-2826.64,50.335;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;29;-2146.43,1453.819;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;45;-2280.064,1726.98;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;59;-2992.054,2201.429;Inherit;False;2370.552;1214.154;Comment;24;76;75;58;72;70;57;77;74;71;78;56;61;63;69;68;67;53;64;55;65;54;52;51;50;Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;4;-2926.43,-199.2546;Inherit;True;Property;_BaseColor_Branch;BaseColor_Branch;4;0;Create;True;0;0;False;0;False;-1;None;8b372ee3711209142ad37c3a25d7d82e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-2921.708,-416.8906;Inherit;True;Property;_BaseColor_Beaf;BaseColor_Beaf;2;0;Create;True;0;0;False;0;False;-1;None;ddefea25c71fa5748a2411aa0ee06a0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;27;-2100.818,1325.955;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;-2969.53,2487.402;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2980.374,2382.735;Inherit;False;Property;_GlobalWindSpeed;GlobalWindSpeed;9;0;Create;True;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-2503.43,-298.921;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;28;-1906.208,1381.32;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;-2058.164,1861.144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;54;-2766.53,2556.402;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1916.521,1799.568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;30;-1751.756,1384.26;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-2720.53,2420.402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-2264.007,-266.7488;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2614.684,2778.82;Inherit;False;Constant;_Float2;Float 2;11;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-2521.53,2421.402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;35;-1555.004,1945.116;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;64;-2689.684,2678.82;Inherit;False;Property;_GlobalWindIntensity;GlobalWindIntensity;11;0;Create;True;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;-1558.753,1528.326;Inherit;False;Property;_SSSColor;SSSColor;6;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1558.778,1821.116;Inherit;False;6;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1603.207,1399.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1532.753,1714.326;Inherit;False;Property;_SSSIntensity;SSSIntensity;7;0;Create;True;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;76;-2319.865,3161.93;Inherit;False;Property;_SmallWindDirection;SmallWindDirection;13;0;Create;True;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2406.523,2752.547;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;53;-2309.657,2390.917;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;79;-1193.36,1688.212;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2319.629,3075.166;Inherit;False;Property;_SmallWindSpeed;SmallWindSpeed;12;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1162.219,1418.151;Inherit;False;5;5;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CosOpNode;68;-2360.764,2579.042;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;36;-1016.992,1423.859;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;56;-2010.534,2610.952;Inherit;False;Property;_GlobalWindDirection;GlobalWindDirection;10;0;Create;True;0;0;False;0;False;0,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2148.601,2747.907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;61;-1969.024,2313.564;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-2155.86,2489.021;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;71;-1978.871,2837.208;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;78;-1996.537,3262.698;Inherit;False;Property;_SmallWindIntensity;SmallWindIntensity;14;0;Create;True;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;81;-952.7737,1642.171;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;74;-1991.131,3108.66;Inherit;False;SimpleGrassWind;-1;;1;092ae7ae693310247ae46c8a50126a61;0;2;10;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1633.231,3055.823;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-759.0638,1444.363;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1717.733,2720.713;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1712.176,2445.177;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-579.6588,1435.525;Inherit;False;SSSColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1515.409,294.1933;Inherit;False;Property;_Roughness;Roughness;1;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1488.06,2587.044;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;19;-2484.802,-54.94687;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1336.809,131.2933;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1224.809,-65.70673;Inherit;False;6;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1186.982,254.7841;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-2273.802,-34.94687;Inherit;False;AlphaMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-1217.809,15.29327;Inherit;False;11;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1265.192,2388.16;Inherit;False;WindVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1381.12,45.47575;Inherit;False;37;SSSColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-473.2301,249.6601;Inherit;False;20;AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-480.0738,357.3803;Inherit;False;58;WindVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomStandardSurface;2;-939.5549,-3.307226;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4.702212,-65.83098;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Scene_Tree;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;True;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;9;3
WireConnection;23;0;9;1
WireConnection;23;1;9;2
WireConnection;23;2;24;0
WireConnection;22;0;9;0
WireConnection;22;1;23;0
WireConnection;7;0;22;0
WireConnection;7;1;10;0
WireConnection;7;2;8;4
WireConnection;11;0;7;0
WireConnection;40;0;39;0
WireConnection;43;0;40;0
WireConnection;43;1;42;0
WireConnection;41;0;25;0
WireConnection;41;1;43;0
WireConnection;26;0;41;0
WireConnection;27;0;26;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;5;2;1;4
WireConnection;28;0;27;0
WireConnection;28;1;29;0
WireConnection;47;0;45;4
WireConnection;49;0;45;3
WireConnection;49;1;47;0
WireConnection;30;0;28;0
WireConnection;52;0;50;0
WireConnection;52;1;51;0
WireConnection;6;0;5;0
WireConnection;55;0;52;0
WireConnection;55;1;54;0
WireConnection;48;0;30;0
WireConnection;48;1;49;0
WireConnection;67;0;64;0
WireConnection;67;1;65;0
WireConnection;53;0;55;0
WireConnection;31;0;48;0
WireConnection;31;1;32;0
WireConnection;31;2;33;0
WireConnection;31;3;34;0
WireConnection;31;4;35;1
WireConnection;68;0;55;0
WireConnection;36;0;31;0
WireConnection;69;0;68;0
WireConnection;69;1;67;0
WireConnection;63;0;53;0
WireConnection;63;1;67;0
WireConnection;81;0;79;0
WireConnection;74;10;75;0
WireConnection;74;2;76;0
WireConnection;77;0;71;2
WireConnection;77;1;74;0
WireConnection;77;2;78;0
WireConnection;80;0;36;0
WireConnection;80;1;81;0
WireConnection;70;0;56;0
WireConnection;70;1;69;0
WireConnection;70;2;71;2
WireConnection;57;0;61;1
WireConnection;57;1;63;0
WireConnection;57;2;56;0
WireConnection;37;0;80;0
WireConnection;72;0;57;0
WireConnection;72;1;70;0
WireConnection;72;2;77;0
WireConnection;19;0;3;4
WireConnection;19;2;1;4
WireConnection;18;0;17;0
WireConnection;20;0;19;0
WireConnection;58;0;72;0
WireConnection;2;0;14;0
WireConnection;2;1;15;0
WireConnection;2;2;44;0
WireConnection;2;3;16;0
WireConnection;2;4;18;0
WireConnection;0;10;21;0
WireConnection;0;13;2;0
WireConnection;0;11;60;0
ASEEND*/
//CHKSM=B9D4ACD111C81C5D562910E1CF20E22860FCC0BE