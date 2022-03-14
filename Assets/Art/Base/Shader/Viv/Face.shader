// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Face"
{
	Properties
	{
		_PixStr("PixStr", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1,1,1,1)
		_Power("Power", Float) = 7
		_Mul("Mul", Float) = 20
		_ShaowColor("ShaowColor", Color) = (0,0,0,0)
		_ShdowIntensity("ShdowIntensity", Range( 0 , 1)) = 1
		_EmissionTex("EmissionTex", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,1)
		_MainEmisStr("MainEmisStr", Range( 0 , 3)) = 1
		_ScanTex("ScanTex", 2D) = "white" {}
		_ScanlineIntensity("ScanlineIntensity", Range( 0 , 1)) = 1
		_FreScalePower("FreScalePower", Vector) = (0,1.1,1.1,0)
		_FreScanTexTiling("FreScanTexTiling", Vector) = (1,1,0,0)
		_FreScanTexPanner("FreScanTexPanner", Vector) = (0,0,1,0)
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
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
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

		uniform float4 _EyeEmissionColor;
		uniform float _EyeEmissStr;
		uniform sampler2D _EmissionTex;
		uniform float _PixStr;
		uniform sampler2D _ScanTex;
		uniform float3 _EyeScanTexPanner;
		uniform float2 _EyeScanTexTiling;
		uniform float3 _FreScalePower;
		uniform float3 _FreScanTexPanner;
		uniform float2 _FreScanTexTiling;
		uniform float4 _EmissionColor;
		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform sampler2D _DisturTex;
		uniform float3 _DisturTexPanner;
		uniform float2 _DisturTexTiling;
		uniform float _DisturIntensity;
		uniform float _MainEmisStr;
		uniform float4 _ShaowColor;
		uniform float _ScanlineIntensity;
		uniform float _Power;
		uniform float _Mul;
		uniform float _ShdowIntensity;
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
			float2 temp_cast_0 = (0.5).xx;
			float temp_output_53_0 = ( _PixStr * 10.0 );
			float2 PixUV63 = ( ( ceil( ( ( i.uv_texcoord - temp_cast_0 ) * temp_output_53_0 ) ) / temp_output_53_0 ) + 0.5 );
			float4 tex2DNode5 = tex2D( _EmissionTex, PixUV63 );
			float mulTime37 = _Time.y * _EyeScanTexPanner.z;
			float2 appendResult38 = (float2(_EyeScanTexPanner.x , _EyeScanTexPanner.y));
			float2 uv_TexCoord39 = i.uv_texcoord * _EyeScanTexTiling;
			float2 panner40 = ( mulTime37 * appendResult38 + uv_TexCoord39);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV14 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode14 = ( 0.0 + _FreScalePower.y * pow( 1.0 - fresnelNdotV14, _FreScalePower.z ) );
			float mulTime29 = _Time.y * _FreScanTexPanner.z;
			float2 appendResult30 = (float2(_FreScanTexPanner.x , _FreScanTexPanner.y));
			float2 uv_TexCoord31 = i.uv_texcoord * _FreScanTexTiling;
			float2 panner32 = ( mulTime29 * appendResult30 + uv_TexCoord31);
			float mulTime148 = _Time.y * _DisturTexPanner.z;
			float2 appendResult149 = (float2(_DisturTexPanner.x , _DisturTexPanner.y));
			float2 uv_TexCoord147 = i.uv_texcoord * _DisturTexTiling;
			float2 panner150 = ( mulTime148 * appendResult149 + uv_TexCoord147);
			float DisturUV151 = ( tex2D( _DisturTex, panner150 ).r * _DisturIntensity );
			float4 tex2DNode1 = tex2D( _MainTex, ( PixUV63 + DisturUV151 ) );
			float4 lerpResult157 = lerp( _MainColor , tex2DNode1 , tex2DNode1.a);
			float4 BaseColor61 = lerpResult157;
			float4 EmissionColor70 = ( ( ( _EyeEmissionColor * _EyeEmissStr * ( tex2DNode5.r + tex2DNode5.g + tex2DNode5.b ) ) * tex2D( _ScanTex, panner40 ) ) + ( ( saturate( ( 1.0 - fresnelNode14 ) ) * tex2D( _ScanTex, panner32 ) ) * _EmissionColor * BaseColor61 * 2.0 ) );
			float4 temp_output_119_0 = ( EmissionColor70 * _MainEmisStr );
			float4 ShaowColor114 = ( _ShaowColor * BaseColor61 );
			float4 blendOpSrc136 = temp_output_119_0;
			float4 blendOpDest136 = ShaowColor114;
			float4 blendOpSrc121 = temp_output_119_0;
			float4 blendOpDest121 = BaseColor61;
			float4 lerpBlendMode121 = lerp(blendOpDest121,( blendOpSrc121 * blendOpDest121 ),_ScanlineIntensity);
			float4 blendOpSrc142 = ( saturate( ( blendOpSrc136 * blendOpDest136 ) ));
			float4 blendOpDest142 = ( saturate( lerpBlendMode121 ));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_90_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 break91 = temp_output_90_0;
			float LightAtten94 = max( max( break91.x , break91.y ) , break91.z );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 WorldNormal127 = ase_normWorldNormal;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g1 = dot( WorldNormal127 , ase_worldlightDir );
			float4 lerpBlendMode142 = lerp(blendOpDest142,min( blendOpSrc142 , blendOpDest142 ),( ( 1.0 - saturate( ( LightAtten94 * ( pow( (dotResult5_g1*0.5 + 0.5) , _Power ) * _Mul ) ) ) ) * _ShdowIntensity ));
			float2 temp_output_76_0 = (mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz).xy;
			float4 MatCap82 = tex2D( _MatCapTex, ( ( temp_output_76_0 + 1.0 ) * 0.5 ) );
			float3 temp_cast_3 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch96 = temp_cast_3;
			#else
				float3 staticSwitch96 = temp_output_90_0;
			#endif
			float3 LightColor97 = staticSwitch96;
			float4 FinalBaseColor105 = ( ( ( saturate( lerpBlendMode142 )) + ( MatCap82 * _MatCapIntensity ) ) * float4( LightColor97 , 0.0 ) );
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
50;497;1647;909;-3239.35;-759.4952;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;68;-4668.995,-952.5189;Inherit;False;1351.513;637.3128;Pixelation;10;56;63;48;55;52;54;53;49;50;51;Pixelation;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-4618.995,-717.0536;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-4549.187,-544.694;Inherit;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-4468.492,-446.6501;Inherit;False;Property;_PixStr;PixStr;0;0;Create;True;0;0;0;False;0;False;1;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;152;-8173.436,893.4002;Inherit;False;1951.807;639.1318;Distur;10;155;151;144;150;149;148;147;145;146;156;Distur;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-4295.76,-450.206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;-4327.677,-713.7533;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;146;-8123.436,1094.932;Inherit;False;Property;_DisturTexPanner;DisturTexPanner;26;0;Create;True;0;0;0;False;0;False;0,0,1;0.1,0.2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;145;-7933.256,943.4002;Inherit;False;Property;_DisturTexTiling;DisturTexTiling;25;0;Create;True;0;0;0;False;0;False;1,1;0.5,0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;148;-7572.232,1220.532;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;149;-7917.435,1112.332;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-4161.595,-713.9232;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;-7716.233,980.5322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CeilOpNode;50;-4028.209,-710.1172;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;150;-7364.236,1092.532;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;144;-7133.596,1061.038;Inherit;True;Property;_DisturTex;DisturTex;24;0;Create;True;0;0;0;False;0;False;-1;None;82fda0a3fc07d4148bbfc5d3d66b0994;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;156;-7143.822,1272.793;Inherit;False;Property;_DisturIntensity;DisturIntensity;27;0;Create;True;0;0;0;False;0;False;0;0.0025;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-3889.951,-705.3823;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-3703.817,-888.9625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-6738.539,1161.528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-3573.983,-893.4903;Inherit;False;PixUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;67;-3227.543,-948.5724;Inherit;False;1309.754;677.8403;BaseColor;7;3;153;65;154;1;61;157;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-6552.628,1094.545;Inherit;False;DisturUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-3205.771,-750.1029;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-3209.055,-654.7723;Inherit;False;151;DisturUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;-1623.768,-983.7263;Inherit;False;1525.385;680.1929;LightAtten;10;97;96;95;94;93;92;91;90;89;88;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;69;-8183.035,-1624.569;Inherit;False;3344.616;2234.507;EmissionColor;32;70;23;34;22;123;21;7;33;35;32;6;66;5;31;30;24;29;64;14;45;28;17;124;137;44;36;39;38;37;40;138;139;EmissionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightColorNode;89;-1557.48,-488.0722;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-2987.055,-726.7723;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;28;-8163.074,117.0857;Inherit;False;Property;_FreScanTexPanner;FreScanTexPanner;17;0;Create;True;0;0;0;False;0;False;0,0,1;0,2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;88;-1573.768,-692.931;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;125;491.0654,-902.4517;Inherit;False;504.303;432.5138;WorldNormal&ViewDir;4;129;128;127;126;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;45;-7972.895,-34.44643;Inherit;False;Property;_FreScanTexTiling;FreScanTexTiling;16;0;Create;True;0;0;0;False;0;False;1,1;1,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;17;-7754.476,-337.1735;Inherit;False;Property;_FreScalePower;FreScalePower;15;0;Create;True;0;0;0;False;0;False;0,1.1,1.1;0,1.35,2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;3;-2730.128,-564.2324;Inherit;False;Property;_MainColor;MainColor;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.9245283,0.8285522,0.75445,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-2816.533,-759.8744;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;f519aaee9ae44c34ea4a3de02041e033;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1304.025,-622.3866;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;36;-8072.285,-805.9526;Inherit;False;Property;_EyeScanTexPanner;EyeScanTexPanner;21;0;Create;True;0;0;0;False;0;False;0,0,1;0,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;14;-7494.762,-326.4346;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-7957.073,134.4857;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-7755.872,2.685551;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;29;-7611.871,242.6854;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-8047.547,-1578.917;Inherit;False;63;PixUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;126;529.3477,-840.9628;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;44;-8053.701,-1076.689;Inherit;False;Property;_EyeScanTexTiling;EyeScanTexTiling;20;0;Create;True;0;0;0;False;0;False;1,1;1,100;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;32;-7403.875,114.6857;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;122;-4715.933,550.1787;Inherit;False;1603.713;554.2144;MatCap;11;74;73;75;76;77;78;79;80;81;82;158;MatCap;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;24;-7141.125,-315.6312;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-2458.188,-750.7289;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;91;-990.4224,-603.4259;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;38;-7717.462,-818.9786;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-7734.062,-970.3787;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;751.1055,-844.3397;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;37;-7723.975,-700.1838;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;106;182.0061,670.9802;Inherit;False;3060.93;1714.936;FinalBaseColor;28;62;43;102;98;101;105;130;108;84;121;85;83;86;119;100;104;103;131;132;133;134;135;136;117;140;141;142;143;FinalBaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;5;-7724.069,-1570.107;Inherit;True;Property;_EmissionTex;EmissionTex;7;0;Create;True;0;0;0;False;0;False;-1;None;e686a5c859f3a5a438c7390d44a54f76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewMatrixNode;74;-4583.179,600.1786;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;221.824,1513.298;Inherit;False;127;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-7319.231,-1491.45;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;137;-6905.926,-316.4381;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;73;-4665.933,730.7867;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;6;-7653.824,-1375.101;Inherit;False;Property;_EyeEmissionColor;EyeEmissionColor;18;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;11.29412,13.05098,16,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-7102.958,93.18354;Inherit;True;Property;_ScanTex;ScanTex;13;0;Create;True;0;0;0;False;0;False;-1;None;4ce5c6694c9418847bb143ef1b41b417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;40;-7385.383,-838.306;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-7682.799,-1202.99;Inherit;False;Property;_EyeEmissStr;EyeEmissStr;19;0;Create;True;0;0;0;False;0;False;0;0.4;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;92;-750.5193,-624.5335;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-2160.79,-786.064;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-6565.381,176.6332;Inherit;False;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;132;476.6169,1767.564;Inherit;False;Property;_Power;Power;3;0;Create;True;0;0;0;False;0;False;7;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-6569.606,-32.25405;Inherit;False;Property;_EmissionColor;EmissionColor;8;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.7921569,0.518115,0.309804,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;139;-6283.66,108.944;Inherit;True;Constant;_Float4;Float 4;23;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;93;-595.5703,-592.2168;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-6581.99,-283.521;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;104;464.7572,1517.834;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-7119.518,-866.3074;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;0;False;0;False;-1;None;fd67039a540e4ae43878e96bc497d2d5;True;0;False;black;Auto;False;Instance;33;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-7077.539,-1403.387;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-4392.179,663.1787;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;76;-4250.222,669.0948;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-6206.808,-284.3993;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;134;734.7632,1533.819;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-4006.152,785.3926;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;745.6666,1801.369;Inherit;False;Property;_Mul;Mul;4;0;Create;True;0;0;0;False;0;False;20;4.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-334.6294,-590.4506;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-6629.921,-1097.307;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;110;-3231.302,-1612.965;Inherit;False;1181.666;633.2292;ShaowColor;4;115;114;113;112;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-3880.152,858.3927;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-5809.761,-680.0847;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-3090.53,-1390.221;Inherit;False;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;995.3058,1652.812;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;994.4275,1410.729;Inherit;False;94;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;112;-3119.302,-1564.965;Inherit;False;Property;_ShaowColor;ShaowColor;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.7529412,0.7439777,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-3998.152,652.3926;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-5505.066,-678.1794;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2603.573,-1461.782;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-3857.152,656.3926;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;1243.414,1397.573;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;358.1944,947.8331;Inherit;False;70;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-2297.745,-1470.208;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;81;-3682.183,625.9675;Inherit;True;Property;_MatCapTex;MatCapTex;22;0;Create;True;0;0;0;False;0;False;-1;None;1ef873e94bdd29e408d495dfbc12fd01;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;294.2572,1066.191;Inherit;False;Property;_MainEmisStr;MainEmisStr;9;0;Create;True;0;0;0;False;0;False;1;2.49;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;135;1475.78,1345.625;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;674.9545,1014.411;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3327.577,677.1976;Inherit;False;MatCap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;141;1661.973,1347.699;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;984.3704,1317.258;Inherit;False;Property;_ScanlineIntensity;ScanlineIntensity;14;0;Create;True;0;0;0;False;0;False;1;0.019;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;915.6161,812.171;Inherit;True;114;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;916.0771,1125.003;Inherit;True;61;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;117;1583.88,1601.37;Inherit;False;Property;_ShdowIntensity;ShdowIntensity;6;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1143.419,-858.4844;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;121;1385.037,1096.936;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;136;1402.669,831.59;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;1674.703,1846.412;Inherit;False;82;MatCap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;96;-901.8384,-877.039;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;86;1687.539,2049.753;Inherit;False;Property;_MatCapIntensity;MatCapIntensity;23;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;1886.289,1364.074;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;142;2085.984,1172.687;Inherit;True;Darken;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;2008.876,1888.725;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-546.8203,-880.158;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;2452.571,1454.328;Inherit;False;97;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;2417.888,1165.554;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;2710.05,1165.592;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;2976.771,1163.054;Inherit;False;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-598.6173,1202.308;Inherit;False;Property;_Metallic;Metallic;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-4199.667,844.1428;Inherit;False;debug;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-599.8104,1555.648;Inherit;False;Property;_Smoothness;Smoothness;12;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;129;543.0146,-645.8417;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;12;-608.4634,1333.873;Inherit;True;Property;_SmoothnessTex;SmoothnessTex;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;159;3775.784,1101.806;Inherit;False;158;debug;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;3258.849,1043.747;Inherit;False;105;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;755.1465,-642.5017;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-261.2592,1374.057;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3926.854,726.316;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Face;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;48;0
WireConnection;54;0;52;0
WireConnection;54;1;55;0
WireConnection;148;0;146;3
WireConnection;149;0;146;1
WireConnection;149;1;146;2
WireConnection;49;0;54;0
WireConnection;49;1;53;0
WireConnection;147;0;145;0
WireConnection;50;0;49;0
WireConnection;150;0;147;0
WireConnection;150;2;149;0
WireConnection;150;1;148;0
WireConnection;144;1;150;0
WireConnection;51;0;50;0
WireConnection;51;1;53;0
WireConnection;56;0;51;0
WireConnection;56;1;55;0
WireConnection;155;0;144;1
WireConnection;155;1;156;0
WireConnection;63;0;56;0
WireConnection;151;0;155;0
WireConnection;154;0;65;0
WireConnection;154;1;153;0
WireConnection;1;1;154;0
WireConnection;90;0;88;0
WireConnection;90;1;89;1
WireConnection;14;2;17;2
WireConnection;14;3;17;3
WireConnection;30;0;28;1
WireConnection;30;1;28;2
WireConnection;31;0;45;0
WireConnection;29;0;28;3
WireConnection;32;0;31;0
WireConnection;32;2;30;0
WireConnection;32;1;29;0
WireConnection;24;0;14;0
WireConnection;157;0;3;0
WireConnection;157;1;1;0
WireConnection;157;2;1;4
WireConnection;91;0;90;0
WireConnection;38;0;36;1
WireConnection;38;1;36;2
WireConnection;39;0;44;0
WireConnection;127;0;126;0
WireConnection;37;0;36;3
WireConnection;5;1;64;0
WireConnection;124;0;5;1
WireConnection;124;1;5;2
WireConnection;124;2;5;3
WireConnection;137;0;24;0
WireConnection;33;1;32;0
WireConnection;40;0;39;0
WireConnection;40;2;38;0
WireConnection;40;1;37;0
WireConnection;92;0;91;0
WireConnection;92;1;91;1
WireConnection;61;0;157;0
WireConnection;93;0;92;0
WireConnection;93;1;91;2
WireConnection;22;0;137;0
WireConnection;22;1;33;0
WireConnection;104;3;103;0
WireConnection;35;1;40;0
WireConnection;7;0;6;0
WireConnection;7;1;66;0
WireConnection;7;2;124;0
WireConnection;75;0;74;0
WireConnection;75;1;73;0
WireConnection;76;0;75;0
WireConnection;138;0;22;0
WireConnection;138;1;21;0
WireConnection;138;2;123;0
WireConnection;138;3;139;0
WireConnection;134;0;104;0
WireConnection;134;1;132;0
WireConnection;94;0;93;0
WireConnection;34;0;7;0
WireConnection;34;1;35;0
WireConnection;23;0;34;0
WireConnection;23;1;138;0
WireConnection;131;0;134;0
WireConnection;131;1;133;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;70;0;23;0
WireConnection;113;0;112;0
WireConnection;113;1;115;0
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;101;0;100;0
WireConnection;101;1;131;0
WireConnection;114;0;113;0
WireConnection;81;1;80;0
WireConnection;135;0;101;0
WireConnection;119;0;62;0
WireConnection;119;1;43;0
WireConnection;82;0;81;0
WireConnection;141;0;135;0
WireConnection;121;0;119;0
WireConnection;121;1;102;0
WireConnection;121;2;143;0
WireConnection;136;0;119;0
WireConnection;136;1;98;0
WireConnection;96;1;90;0
WireConnection;96;0;95;0
WireConnection;140;0;141;0
WireConnection;140;1;117;0
WireConnection;142;0;136;0
WireConnection;142;1;121;0
WireConnection;142;2;140;0
WireConnection;85;0;83;0
WireConnection;85;1;86;0
WireConnection;97;0;96;0
WireConnection;84;0;142;0
WireConnection;84;1;85;0
WireConnection;130;0;84;0
WireConnection;130;1;108;0
WireConnection;105;0;130;0
WireConnection;158;0;76;0
WireConnection;128;0;129;0
WireConnection;13;0;12;1
WireConnection;13;1;11;0
WireConnection;0;13;71;0
ASEEND*/
//CHKSM=71DC688770C88E1C8375BDED01DB1067B37BE6D1