// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/HalfLambertLerp"
{
	Properties
	{
		_HighlightColor("HighlightColor", Color) = (1,1,1,1)
		_Hightlightsize("Hightlightsize", Float) = 0
		_SurfaceTex("SurfaceTex", 2D) = "white" {}
		_SurfaceBaseColor("SurfaceBaseColor", Color) = (0,0,0,0)
		_SurfaceShaowColor("SurfaceShaowColor", Color) = (0,0,0,0)
		_InsideTex("InsideTex", 2D) = "white" {}
		_InsideBaseColor("InsideBaseColor", Color) = (0,0,0,0)
		_InsideShaowColor("InsideShaowColor", Color) = (0,0,0,0)
		_ThicknessMax("ThicknessMax", Float) = 0
		_ThicknessMin("ThicknessMin", Float) = 0
		_InsideskinColor("InsideskinColor", Color) = (0.6969161,1,0,0)
		_InsideskinOffer("InsideskinOffer", Float) = 0.1
		_InsideskinOffer2("InsideskinOffer2", Float) = 0.5
		_InsideskinBlend("InsideskinBlend", Float) = 0.8
		_Scanline1("Scanline1", 2D) = "white" {}
		_ScanlineColor("ScanlineColor", Color) = (0,0,0,0)
		_Scanline1Tilling("Scanline 1 Tilling", Float) = 0
		_Scanline1Speed("Scanline 1 Speed", Float) = 0
		_Scanline1Width("Scanline 1 Width", Range( 0 , 1)) = 0
		_Scanline1Hardness("Scanline 1 Hardness", Float) = 0
		_Scanline1Alpha("Scanline 1 Alpha", Range( 0 , 1)) = 1
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
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			float4 vertexColor : COLOR;
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

		uniform sampler2D _Scanline1;
		uniform float _Scanline1Tilling;
		uniform float _Scanline1Speed;
		uniform float _Scanline1Width;
		uniform float _Scanline1Hardness;
		uniform float4 _ScanlineColor;
		uniform float _Scanline1Alpha;
		uniform float4 _InsideShaowColor;
		uniform sampler2D _InsideTex;
		uniform float4 _InsideTex_ST;
		uniform float4 _InsideBaseColor;
		uniform float4 _InsideskinColor;
		uniform float _InsideskinBlend;
		uniform float _ThicknessMin;
		uniform float _ThicknessMax;
		uniform float _InsideskinOffer;
		uniform float4 _SurfaceShaowColor;
		uniform sampler2D _SurfaceTex;
		uniform float4 _SurfaceTex_ST;
		uniform float4 _SurfaceBaseColor;
		uniform float4 _HighlightColor;
		uniform float _Hightlightsize;
		uniform float _InsideskinOffer2;

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
			float3 temp_output_90_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 temp_cast_1 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch105 = temp_cast_1;
			#else
				float3 staticSwitch105 = temp_output_90_0;
			#endif
			float3 LightColor107 = staticSwitch105;
			float2 uv_InsideTex = i.uv_texcoord * _InsideTex_ST.xy + _InsideTex_ST.zw;
			float4 InsideShaowColor122 = ( _InsideShaowColor * tex2D( _InsideTex, uv_InsideTex ) );
			float2 UV136 = i.uv_texcoord;
			float4 InsideBaseColor121 = ( _InsideBaseColor * tex2D( _InsideTex, UV136 ) );
			float3 break91 = temp_output_90_0;
			float LightAtten101 = max( max( break91.x , break91.y ) , break91.z );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 WorldNormal96 = ase_normWorldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g16 = dot( WorldNormal96 , ase_worldlightDir );
			float4 lerpResult130 = lerp( InsideShaowColor122 , InsideBaseColor121 , ( LightAtten101 * (dotResult5_g16*0.5 + 0.5) ));
			float4 Insidecolor134 = max( ( float4( LightColor107 , 0.0 ) * lerpResult130 ) , float4( 0,0,0,0 ) );
			float smoothstepResult35 = smoothstep( _ThicknessMin , _ThicknessMax , i.vertexColor.r);
			float smoothstepResult197 = smoothstep( 0.0 , _InsideskinBlend , ( smoothstepResult35 * _InsideskinOffer ));
			float clampResult184 = clamp( smoothstepResult197 , 0.0 , 1.0 );
			float4 lerpResult30 = lerp( Insidecolor134 , _InsideskinColor , clampResult184);
			float2 uv_SurfaceTex = i.uv_texcoord * _SurfaceTex_ST.xy + _SurfaceTex_ST.zw;
			float4 ShaowColor104 = ( _SurfaceShaowColor * tex2D( _SurfaceTex, uv_SurfaceTex ) );
			float dotResult170 = dot( WorldNormal96 , ase_worldlightDir );
			float clampResult172 = clamp( dotResult170 , 0.0 , 1.0 );
			float smoothstepResult175 = smoothstep( 0.0 , 1.0 , pow( clampResult172 , _Hightlightsize ));
			float4 HightLightColor177 = ( _HighlightColor * smoothstepResult175 );
			float4 BaseColor106 = ( ( _SurfaceBaseColor * tex2D( _SurfaceTex, UV136 ) ) + HightLightColor177 );
			float dotResult5_g17 = dot( WorldNormal96 , ase_worldlightDir );
			float4 lerpResult84 = lerp( ShaowColor104 , BaseColor106 , ( UNITY_LIGHTMODEL_AMBIENT + ( LightAtten101 * (dotResult5_g17*0.5 + 0.5) ) ));
			float4 Surfacecolor110 = max( ( float4( LightColor107 , 0.0 ) * lerpResult84 ) , float4( 0,0,0,0 ) );
			float4 lerpResult187 = lerp( lerpResult30 , Surfacecolor110 , ( 1.0 - step( smoothstepResult35 , _InsideskinOffer2 ) ));
			c.rgb = lerpResult187.rgb;
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
			float3 ase_worldPos = i.worldPos;
			float3 objToWorld221 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float mulTime8_g18 = _Time.y * _Scanline1Speed;
			float2 appendResult10_g18 = (float2(0.5 , (( ase_worldPos.z - objToWorld221.z )*_Scanline1Tilling + mulTime8_g18)));
			float clampResult16_g18 = clamp( ( ( tex2D( _Scanline1, appendResult10_g18 ).r - _Scanline1Width ) * _Scanline1Hardness ) , 0.0 , 1.0 );
			float temp_output_213_0 = clampResult16_g18;
			float4 Scanline219 = ( temp_output_213_0 * _ScanlineColor );
			float ScanlineAlpha217 = ( temp_output_213_0 * _Scanline1Alpha );
			o.Emission = ( Scanline219 * ScanlineAlpha217 ).rgb;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
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
Version=18500
-1701;69;1595;907;3712.331;1274.55;2.441181;True;False
Node;AmplifyShaderEditor.CommentaryNode;75;-7655.931,-3028.305;Inherit;False;504.303;432.5138;WorldNormal&ViewDir;4;109;108;96;93;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;93;-7617.649,-2966.816;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-7395.891,-2970.193;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;167;-7659.712,-3977.168;Inherit;False;2226.411;694.3837;HightLightColor;10;177;176;175;174;173;172;171;170;169;168;HightLightColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-7624.132,-3749.458;Inherit;False;96;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;168;-7624.132,-3653.458;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;170;-7256.132,-3717.458;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;74;-7642.669,-1822.021;Inherit;False;1513.141;690.5745;LightAtten;10;107;105;103;101;97;92;91;90;89;88;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;172;-6968.131,-3749.458;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-6991.358,-3592.78;Inherit;False;Property;_Hightlightsize;Hightlightsize;1;0;Create;True;0;0;False;0;False;0;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;89;-7592.669,-1531.226;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;88;-7576.381,-1326.367;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-6708.896,-2926.081;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-7322.926,-1460.681;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;173;-6763.712,-3753.169;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;125.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;174;-6443.712,-3929.168;Inherit;False;Property;_HighlightColor;HighlightColor;0;0;Create;True;0;0;False;0;False;1,1,1,1;0.1981132,0.1642545,0.06074226,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;175;-6459.712,-3737.169;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;113;-4292.864,-2481.235;Inherit;False;1385.849;511.3552;InsideBaseColor;5;121;119;115;118;138;InsideBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;91;-7039.727,-1433.72;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-6475.403,-2929.152;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-6630.769,-2202.933;Inherit;False;136;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;-6107.712,-3849.169;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;77;-6484.39,-2483.311;Inherit;False;919.8992;508.5779;SurfaceBaseColor;6;106;100;95;94;178;179;SurfaceBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-4266.023,-2194.043;Inherit;False;136;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;92;-6769.422,-1462.828;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;114;-5416.032,-2481.014;Inherit;False;1009.513;513.5418;InsideShaowColor;4;122;120;117;116;InsideShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;118;-4030.636,-2216.467;Inherit;True;Property;_InsideTex;InsideTex;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;94;-6442.052,-2216.961;Inherit;True;Property;_SurfaceTex;SurfaceTex;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;117;-5304.032,-2433.014;Inherit;False;Property;_InsideShaowColor;InsideShaowColor;8;0;Create;True;0;0;False;0;False;0,0,0,0;0.8301887,0.7248771,0.5364898,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;112;-7615.142,-982.3653;Inherit;False;1845.121;682.3715;SurfaceColor;13;78;79;81;82;83;84;85;86;87;110;229;230;231;SurfaceColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;115;-4004.951,-2425.872;Inherit;False;Property;_InsideBaseColor;InsideBaseColor;7;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;95;-6408.263,-2433.311;Inherit;False;Property;_SurfaceBaseColor;SurfaceBaseColor;4;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;97;-6622.473,-1409.511;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-5368.032,-2241.014;Inherit;True;Property;_InsideTexSample;InsideTexSample;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;118;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-5803.712,-3817.169;Inherit;False;HightLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;76;-7655.356,-2492.517;Inherit;False;1009.513;513.5418;SurfaceShaowColor;4;104;102;99;98;SurfaceShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;123;-7613.286,-170.8687;Inherit;False;1845.121;682.3715;InsideColor;10;134;133;132;131;130;129;128;127;125;124;InsideColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-7563.286,273.2334;Inherit;False;96;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-7162.32,-1696.779;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-6137.798,-2083.852;Inherit;False;177;HightLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;98;-7607.356,-2252.517;Inherit;True;Property;_SurfaceTexSample;SurfaceTexSample;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;94;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;78;-7611.448,-434.9037;Inherit;False;96;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;99;-7543.356,-2444.517;Inherit;False;Property;_SurfaceShaowColor;SurfaceShaowColor;5;0;Create;True;0;0;False;0;False;0,0,0,0;0.8313726,0.7254902,0.5372549,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-4984.032,-2257.014;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-6083.68,-2298.895;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-6353.532,-1428.745;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-3665.321,-2290.298;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;105;-6920.74,-1715.334;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-5922.286,-2195.229;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-3180.492,-2296.228;Inherit;False;InsideBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-4776.032,-2257.014;Inherit;False;InsideShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;228;-7355.128,276.4365;Inherit;False;Half Lambert Term;-1;;16;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-7223.356,-2268.517;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;229;-7421.411,-524.7845;Inherit;True;Half Lambert Term;-1;;17;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-7438.59,-634.6738;Inherit;False;101;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-7312.907,173.4303;Inherit;False;101;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-6996.53,257.5028;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-5854.383,-2285.818;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-7190.065,-557.3862;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-7015.356,-2268.517;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;230;-7253.914,-681.8764;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;207;-5798.698,-1795.394;Inherit;False;1560.77;664.1224;Scanline;15;217;215;214;219;218;213;216;210;223;212;209;208;211;222;221;Scanline;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-6565.723,-1718.453;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-6954.374,147.1604;Inherit;False;121;InsideBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-6957.139,52.26153;Inherit;False;122;InsideShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1893.766,-290.606;Inherit;False;Property;_ThicknessMin;ThicknessMin;10;0;Create;True;0;0;False;0;False;0;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;222;-5710.76,-1650.847;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;131;-6690.838,-120.8687;Inherit;True;107;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-6957.231,-662.3362;Inherit;False;106;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;231;-6911.273,-563.1395;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1892.129,-204.2839;Inherit;False;Property;_ThicknessMax;ThicknessMax;9;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;130;-6719.395,113.3646;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformPositionNode;221;-5721.782,-1497.687;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;81;-6958.997,-759.2351;Inherit;False;104;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;17;-2542.072,-392.8177;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-6384.291,53.01415;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;35;-1678.761,-353.3311;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-5505.03,-1215.063;Inherit;False;Property;_Scanline1Hardness;Scanline 1 Hardness;20;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-5486.001,-1389.966;Inherit;False;Property;_Scanline1Speed;Scanline 1 Speed;18;0;Create;True;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;223;-5471.316,-1570.205;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-6692.696,-932.3653;Inherit;True;107;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;84;-6721.253,-698.132;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-5566.841,-1304.335;Inherit;False;Property;_Scanline1Width;Scanline 1 Width;19;0;Create;True;0;0;False;0;False;0;0.855;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;210;-5484.5,-1758.79;Inherit;True;Property;_Scanline1;Scanline1;15;0;Create;True;0;0;False;0;False;None;8d171d0041e0c4742a9ba5ebc7ee803c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;181;-1646.823,-208.6823;Inherit;False;Property;_InsideskinOffer;InsideskinOffer;12;0;Create;True;0;0;False;0;False;0.1;17.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-5482.001,-1469.966;Inherit;False;Property;_Scanline1Tilling;Scanline 1 Tilling;17;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;133;-6149.286,63.85765;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;213;-5127.352,-1645.464;Inherit;False;Scanline;-1;;18;b8171af3f930d1e40b77351a055ebce8;0;6;25;SAMPLER2D;0;False;21;FLOAT;0;False;18;FLOAT;2;False;19;FLOAT;1;False;20;FLOAT;0;False;26;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-1474.361,-351.7003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;198;-1645.198,-134.9491;Inherit;False;Property;_InsideskinBlend;InsideskinBlend;14;0;Create;True;0;0;False;0;False;0.8;8.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-5042.259,-1268.717;Inherit;False;Property;_Scanline1Alpha;Scanline 1 Alpha;21;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-6386.148,-758.4825;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;216;-5042.466,-1452.914;Inherit;False;Property;_ScanlineColor;ScanlineColor;16;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.2301676,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;194;-1490.477,-37.73097;Inherit;False;Property;_InsideskinOffer2;InsideskinOffer2;13;0;Create;True;0;0;False;0;False;0.5;0.999;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;-4762.64,-1638.914;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;87;-6151.143,-747.639;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-5992.164,86.90993;Inherit;False;Insidecolor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;-4749.292,-1375.26;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;197;-1337.104,-329.805;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;-4603.111,-1637.365;Inherit;False;Scanline;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;193;-1271.645,-158.7041;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;186;-1414.644,-558.3382;Inherit;False;Property;_InsideskinColor;InsideskinColor;11;0;Create;True;0;0;False;0;False;0.6969161,1,0,0;0.8207547,0.8119546,0.3445621,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-4595.219,-1384.777;Inherit;False;ScanlineAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-1407.147,-657.4039;Inherit;False;134;Insidecolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;184;-1176.682,-378.9662;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-5994.021,-724.5867;Inherit;False;Surfacecolor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;30;-1055.792,-465.2372;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;195;-1011.281,-144.1317;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;-796.853,-304.0303;Inherit;False;217;ScanlineAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1032.467,-259.887;Inherit;False;110;Surfacecolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;-775.6108,-395.7821;Inherit;False;219;Scanline;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;140;-1934.098,196.3403;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;-2186.219,-270.1335;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-7391.85,-2768.355;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;26;-1256.469,75.26517;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;8;-1729.88,30.36189;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1481.575,120.0104;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-1879.148,300.0038;Inherit;False;Constant;_depth;depth;11;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1681.826,195.3099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-565.8246,-334.0414;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;187;-717.4132,-172.8633;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;108;-7603.982,-2771.695;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;44;-2557.262,-192.7181;Inherit;True;Property;_Mask;Mask;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-427.5573,-369.5492;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/HalfLambertLerp;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;96;0;93;0
WireConnection;170;0;169;0
WireConnection;170;1;168;0
WireConnection;172;0;170;0
WireConnection;90;0;89;0
WireConnection;90;1;88;1
WireConnection;173;0;172;0
WireConnection;173;1;171;0
WireConnection;175;0;173;0
WireConnection;91;0;90;0
WireConnection;136;0;40;0
WireConnection;176;0;174;0
WireConnection;176;1;175;0
WireConnection;92;0;91;0
WireConnection;92;1;91;1
WireConnection;118;1;138;0
WireConnection;94;1;137;0
WireConnection;97;0;92;0
WireConnection;97;1;91;2
WireConnection;177;0;176;0
WireConnection;120;0;117;0
WireConnection;120;1;116;0
WireConnection;100;0;95;0
WireConnection;100;1;94;0
WireConnection;101;0;97;0
WireConnection;119;0;115;0
WireConnection;119;1;118;0
WireConnection;105;1;90;0
WireConnection;105;0;103;0
WireConnection;179;0;100;0
WireConnection;179;1;178;0
WireConnection;121;0;119;0
WireConnection;122;0;120;0
WireConnection;228;3;124;0
WireConnection;102;0;99;0
WireConnection;102;1;98;0
WireConnection;229;3;78;0
WireConnection;128;0;125;0
WireConnection;128;1;228;0
WireConnection;106;0;179;0
WireConnection;83;0;79;0
WireConnection;83;1;229;0
WireConnection;104;0;102;0
WireConnection;107;0;105;0
WireConnection;231;0;230;0
WireConnection;231;1;83;0
WireConnection;130;0;127;0
WireConnection;130;1;129;0
WireConnection;130;2;128;0
WireConnection;132;0;131;0
WireConnection;132;1;130;0
WireConnection;35;0;17;1
WireConnection;35;1;36;0
WireConnection;35;2;37;0
WireConnection;223;0;222;3
WireConnection;223;1;221;3
WireConnection;84;0;81;0
WireConnection;84;1;82;0
WireConnection;84;2;231;0
WireConnection;133;0;132;0
WireConnection;213;25;210;0
WireConnection;213;21;223;0
WireConnection;213;18;209;0
WireConnection;213;19;212;0
WireConnection;213;20;211;0
WireConnection;213;26;208;0
WireConnection;183;0;35;0
WireConnection;183;1;181;0
WireConnection;86;0;85;0
WireConnection;86;1;84;0
WireConnection;218;0;213;0
WireConnection;218;1;216;0
WireConnection;87;0;86;0
WireConnection;134;0;133;0
WireConnection;215;0;213;0
WireConnection;215;1;214;0
WireConnection;197;0;183;0
WireConnection;197;2;198;0
WireConnection;219;0;218;0
WireConnection;193;0;35;0
WireConnection;193;1;194;0
WireConnection;217;0;215;0
WireConnection;184;0;197;0
WireConnection;110;0;87;0
WireConnection;30;0;135;0
WireConnection;30;1;186;0
WireConnection;30;2;184;0
WireConnection;195;0;193;0
WireConnection;43;0;17;1
WireConnection;43;1;44;1
WireConnection;109;0;108;0
WireConnection;26;0;18;0
WireConnection;18;0;8;0
WireConnection;18;1;141;0
WireConnection;141;0;140;0
WireConnection;141;1;142;0
WireConnection;226;0;220;0
WireConnection;226;1;224;0
WireConnection;187;0;30;0
WireConnection;187;1;111;0
WireConnection;187;2;195;0
WireConnection;0;2;226;0
WireConnection;0;13;187;0
ASEEND*/
//CHKSM=4710749D473E801FC258CAC630B8241BDA21B392