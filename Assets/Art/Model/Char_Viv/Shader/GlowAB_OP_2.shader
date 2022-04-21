// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/GlowAB_OP_2"
{
	Properties
	{
		[Toggle(_UV1_WCONTORLEMISSION_ON)] _UV1_WContorlEmission("UV1_WContorlEmission", Float) = 0
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		[Toggle(_UV2_WCONTORLOFFSET_ON)] _UV2_WContorlOffset("UV2_WContorlOffset", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		_MainColor("MainColor", Color) = (0,0,0,0)
		_DisturbTex("DisturbTex", 2D) = "black" {}
		_DisturbPanner("DisturbPanner", Vector) = (0,0,1,0)
		_DisturbTex2("DisturbTex2", 2D) = "white" {}
		_Disturb2Panner("Disturb2Panner", Vector) = (0,0,1,0)
		_MainDisturbStr("MainDisturbStr", Range( 0 , 1)) = 0
		_MaskDisturbStr("MaskDisturbStr", Range( 0 , 1)) = 0
		_NoiseTex("NoiseTex", 2D) = "black" {}
		_NoiseTiling("NoiseTiling", Vector) = (1,1,0,0)
		_ColumnsRows("Columns&Rows", Vector) = (1,1,0,0)
		_NoiseFlip("NoiseFlip", Vector) = (0,0,1,0)
		_NoiseEmissionStr("NoiseEmissionStr", Float) = 1
		_EmissionStr("EmissionStr", Float) = 1
		_InnerEmissStrRange("InnerEmissStrRange", Float) = 1
		_InnerEmissHardness("InnerEmissHardness", Float) = 0.5
		_InnerEmissStr("InnerEmissStr", Float) = 0
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		_Edge("Edge", Range( 0 , 1)) = 0.3935294
		[Toggle(_FADE_ON)] _Fade("Fade", Float) = 0
		_FadeRange("FadeRange", Float) = 1
		_FadeHardnss("FadeHardnss", Float) = 1
		_MainOpacity("MainOpacity", Range( 0 , 1)) = 1
		_DissolutionTex("DissolutionTex", 2D) = "white" {}
		_DissDisturbStr("DissDisturbStr", Float) = 0
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		_RampTex("RampTex", 2D) = "white" {}
		_FadeTex("FadeTex", 2D) = "white" {}
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		_VertexOffsetTexPanner("VertexOffsetTexPanner", Vector) = (0,0,1,0)
		_VertexOffsetStr("VertexOffsetStr", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_Fre("Fre", Vector) = (0,1,2.76,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull [_CullMode]
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma shader_feature_local _UV2_WCONTORLOFFSET_ON
		#pragma shader_feature_local _FADE_ON
		#pragma shader_feature_local _UV1_WCONTORLEMISSION_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 uv2_texcoord2;
			float3 worldPos;
			float3 worldNormal;
			float4 vertexColor : COLOR;
			float4 screenPos;
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

		uniform float _CullMode;
		uniform float _ZTestMode;
		uniform sampler2D _VertexOffsetTex;
		uniform float3 _VertexOffsetTexPanner;
		uniform float4 _VertexOffsetTex_ST;
		uniform float _VertexOffsetStr;
		uniform float _Dissolution;
		uniform sampler2D _FadeTex;
		uniform float4 _FadeTex_ST;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _MainDisturbStr;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		uniform float _MaskDisturbStr;
		uniform float3 _Fre;
		uniform sampler2D _RampTex;
		uniform float _Edge;
		uniform sampler2D _DissolutionTex;
		uniform float3 _DissolutionTexPanner;
		uniform float4 _DissolutionTex_ST;
		uniform sampler2D _DisturbTex2;
		uniform float3 _Disturb2Panner;
		uniform float4 _DisturbTex2_ST;
		uniform float _DissDisturbStr;
		uniform float _FadeRange;
		uniform float _FadeHardnss;
		uniform float _MainOpacity;
		uniform float4 _MainColor;
		uniform float _EmissionStr;
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseTiling;
		uniform float2 _ColumnsRows;
		uniform float3 _NoiseFlip;
		uniform float _NoiseEmissionStr;
		uniform float _InnerEmissStrRange;
		uniform float _InnerEmissHardness;
		uniform float _InnerEmissStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime130 = _Time.y * _VertexOffsetTexPanner.z;
			float2 appendResult128 = (float2(_VertexOffsetTexPanner.x , _VertexOffsetTexPanner.y));
			float4 uvs_VertexOffsetTex = v.texcoord;
			uvs_VertexOffsetTex.xy = v.texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
			float2 panner131 = ( mulTime130 * appendResult128 + uvs_VertexOffsetTex.xy);
			float3 ase_vertexNormal = v.normal.xyz;
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch23 = v.texcoord.w;
			#else
				float staticSwitch23 = _Dissolution;
			#endif
			float DissolutionControl83 = staticSwitch23;
			float2 uv_FadeTex = v.texcoord * _FadeTex_ST.xy + _FadeTex_ST.zw;
			float4 tex2DNode119 = tex2Dlod( _FadeTex, float4( uv_FadeTex, 0, 0.0) );
			float FadeTexR142 = tex2DNode119.r;
			float3 VertexOffset137 = ( tex2Dlod( _VertexOffsetTex, float4( panner131, 0, 0.0) ).r * ase_vertexNormal * 0.1 * _VertexOffsetStr * ( 1.0 - DissolutionControl83 ) * FadeTexR142 );
			v.vertex.xyz += VertexOffset137;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime31 = _Time.y * _MainTexPanner.z;
			float2 appendResult30 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner27 = ( mulTime31 * appendResult30 + uvs_MainTex.xy);
			float2 break33 = panner27;
			#ifdef _UV2_WCONTORLOFFSET_ON
				float staticSwitch53 = i.uv2_texcoord2.z;
			#else
				float staticSwitch53 = 0.0;
			#endif
			float2 appendResult34 = (float2(break33.x , ( break33.y + staticSwitch53 )));
			float mulTime153 = _Time.y * _DisturbPanner.z;
			float2 appendResult154 = (float2(_DisturbPanner.x , _DisturbPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner156 = ( mulTime153 * appendResult154 + uvs_DisturbTex.xy);
			float DisturbColor151 = tex2D( _DisturbTex, panner156 ).r;
			float4 tex2DNode1 = tex2D( _MainTex, ( appendResult34 + ( DisturbColor151 * _MainDisturbStr ) ) );
			float MainTexR68 = tex2DNode1.r;
			float4 uvs_MaskTex = i.uv_texcoord;
			uvs_MaskTex.xy = i.uv_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV233 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode233 = ( _Fre.x + _Fre.y * pow( 1.0 - fresnelNdotV233, _Fre.z ) );
			float MaskColor174 = ( tex2D( _MaskTex, ( uvs_MaskTex.xy + ( DisturbColor151 * _MaskDisturbStr ) ) ).r * saturate( ( 1.0 - fresnelNode233 ) ) );
			float lerpResult223 = lerp( 0.0 , MainTexR68 , MaskColor174);
			float FinalColor198 = lerpResult223;
			float MainTexG69 = tex2DNode1.g;
			float mulTime122 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult121 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolutionTex = i.uv_texcoord;
			uvs_DissolutionTex.xy = i.uv_texcoord.xy * _DissolutionTex_ST.xy + _DissolutionTex_ST.zw;
			float2 panner124 = ( mulTime122 * appendResult121 + uvs_DissolutionTex.xy);
			float mulTime219 = _Time.y * _Disturb2Panner.z;
			float2 appendResult220 = (float2(_Disturb2Panner.x , _Disturb2Panner.y));
			float4 uvs_DisturbTex2 = i.uv_texcoord;
			uvs_DisturbTex2.xy = i.uv_texcoord.xy * _DisturbTex2_ST.xy + _DisturbTex2_ST.zw;
			float2 panner222 = ( mulTime219 * appendResult220 + uvs_DisturbTex2.xy);
			float DisturbColor2217 = tex2D( _DisturbTex2, panner222 ).r;
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch23 = i.uv_texcoord.w;
			#else
				float staticSwitch23 = _Dissolution;
			#endif
			float DissolutionControl83 = staticSwitch23;
			float smoothstepResult9 = smoothstep( _Edge , 1.0 , ( tex2D( _DissolutionTex, ( panner124 + ( DisturbColor2217 * _DissDisturbStr ) ) ).r + 1.0 + ( DissolutionControl83 * -2.0 ) ));
			float2 appendResult113 = (float2(smoothstepResult9 , 0.0));
			float DissolutionColor147 = ( tex2D( _RampTex, appendResult113 ).r * 5.0 );
			float lerpResult112 = lerp( 0.0 , ( FinalColor198 * MainTexG69 ) , DissolutionColor147);
			#ifdef _FADE_ON
				float staticSwitch51 = saturate( ( ( ( 1.0 - i.uv_texcoord.xy.y ) - ( _FadeRange * 0.1 ) ) * _FadeHardnss ) );
			#else
				float staticSwitch51 = 1.0;
			#endif
			float VFade214 = staticSwitch51;
			float VertexColorA77 = i.vertexColor.a;
			float2 uv_FadeTex = i.uv_texcoord * _FadeTex_ST.xy + _FadeTex_ST.zw;
			float4 tex2DNode119 = tex2D( _FadeTex, uv_FadeTex );
			float FinalOpacity95 = ( saturate( ( lerpResult112 * VFade214 * VertexColorA77 * tex2DNode119.r ) ) * _MainOpacity );
			float4 VertexColorRGB75 = i.vertexColor;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult226 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 appendResult60 = (float2(_NoiseFlip.x , _NoiseFlip.y));
			float mulTime63 = _Time.y * _NoiseFlip.z;
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles184 = _ColumnsRows.x * _ColumnsRows.y;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset184 = 1.0f / _ColumnsRows.x;
			float fbrowsoffset184 = 1.0f / _ColumnsRows.y;
			// Speed of animation
			float fbspeed184 = mulTime63 * appendResult60.x;
			// UV Tiling (col and row offset)
			float2 fbtiling184 = float2(fbcolsoffset184, fbrowsoffset184);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex184 = round( fmod( fbspeed184 + 0.0, fbtotaltiles184) );
			fbcurrenttileindex184 += ( fbcurrenttileindex184 < 0) ? fbtotaltiles184 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox184 = round ( fmod ( fbcurrenttileindex184, _ColumnsRows.x ) );
			// Multiply Offset X by coloffset
			float fboffsetx184 = fblinearindextox184 * fbcolsoffset184;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy184 = round( fmod( ( fbcurrenttileindex184 - fblinearindextox184 ) / _ColumnsRows.x, _ColumnsRows.y ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy184 = (int)(_ColumnsRows.y-1) - fblinearindextoy184;
			// Multiply Offset Y by rowoffset
			float fboffsety184 = fblinearindextoy184 * fbrowsoffset184;
			// UV Offset
			float2 fboffset184 = float2(fboffsetx184, fboffsety184);
			// Flipbook UV
			half2 fbuv184 = ( frac( appendResult226 ) * _NoiseTiling ) * fbtiling184 + fboffset184;
			// *** END Flipbook UV Animation vars ***
			float lerpResult179 = lerp( ( 0.1 * FinalColor198 ) , ( tex2D( _NoiseTex, fbuv184 ).r * _NoiseEmissionStr ) , FinalColor198);
			float temp_output_205_0 = ( 1.0 - _InnerEmissStrRange );
			float FadeTexR142 = tex2DNode119.r;
			float smoothstepResult186 = smoothstep( temp_output_205_0 , ( temp_output_205_0 + _InnerEmissHardness ) , ( ( FinalColor198 - 0.51 ) * FadeTexR142 ));
			float NoiseColor91 = ( lerpResult179 + ( saturate( smoothstepResult186 ) * _InnerEmissStr ) );
			#ifdef _UV1_WCONTORLEMISSION_ON
				float staticSwitch21 = i.uv_texcoord.z;
			#else
				float staticSwitch21 = 1.0;
			#endif
			float UV1_W82 = staticSwitch21;
			c.rgb = ( _MainColor * _EmissionStr * VertexColorRGB75 * NoiseColor91 * UV1_W82 ).rgb;
			c.a = FinalOpacity95;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 

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
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float4 screenPos : TEXCOORD4;
				float3 worldNormal : TEXCOORD5;
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
				o.worldNormal = worldNormal;
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_texcoord2;
				o.customPack2.xyzw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.uv_texcoord = IN.customPack1.xyzw;
				surfIN.uv2_texcoord2 = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
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
Version=18935
-1200;214;1360;771;3557.248;4204.494;3.062079;True;True
Node;AmplifyShaderEditor.CommentaryNode;157;-8799.316,-424.3364;Inherit;False;2432.565;958.0535;DisturbColor;14;151;150;156;155;154;153;152;216;217;218;219;220;221;222;DisturbColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;152;-8749.317,-221.3363;Inherit;False;Property;_DisturbPanner;DisturbPanner;9;0;Create;True;0;0;0;False;0;False;0,0,1;0,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;80;-5687.596,-3608.665;Inherit;False;3039.506;1382.294;MainTex;26;172;70;68;69;1;168;34;171;35;170;33;53;54;38;27;31;28;30;29;177;178;175;197;198;223;224;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;-8697.318,-374.3364;Inherit;False;0;150;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;154;-8527.317,-206.3363;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;153;-8541.599,-86.54978;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;29;-5637.596,-3398.422;Inherit;False;Property;_MainTexPanner;MainTexPanner;6;0;Create;True;0;0;0;False;0;False;0,0,1;0,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;218;-8759,143.435;Inherit;False;Property;_Disturb2Panner;Disturb2Panner;11;0;Create;True;0;0;0;False;0;False;0,0,1;0,-0.01,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;156;-8293.213,-200.6092;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;220;-8537,158.435;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;221;-8707.001,-9.565106;Inherit;False;0;216;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;219;-8551.281,278.2216;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-5584.414,-3558.665;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;31;-5389.597,-3291.422;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-5386.597,-3445.422;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;150;-8082.586,-230.6762;Inherit;True;Property;_DisturbTex;DisturbTex;8;0;Create;True;0;0;0;False;0;False;-1;None;22ebc0de30a41d147a02739165871c48;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-7707.272,-238.9547;Inherit;False;DisturbColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-5467.883,-3066.425;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;176;-5671.374,-4438.063;Inherit;False;1388.966;606.2898;MaskColor;12;159;174;160;145;169;164;161;233;234;235;236;238;MaskColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-5399.28,-3163.932;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-5214.018,-3539.684;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;222;-8302.896,164.1621;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;33;-5043.704,-3401.201;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;149;-8851.622,-1745.631;Inherit;False;2725.426;858.501;DissolutionColor;22;147;102;116;115;9;84;114;113;13;111;105;106;124;123;121;122;120;206;207;208;209;210;DissolutionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;53;-5178.28,-3143.932;Inherit;False;Property;_UV2_WContorlOffset;UV2_WContorlOffset;2;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;238;-5277.199,-4045.298;Inherit;False;Property;_Fre;Fre;41;0;Create;True;0;0;0;False;0;False;0,1,2.76;0,7.66,2.38;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;93;-7054.574,-3591.882;Inherit;False;1252.226;378.732;Comment;7;23;83;5;82;21;22;20;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-5601.064,-4215.509;Inherit;False;151;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-5616.904,-4103.463;Inherit;False;Property;_MaskDisturbStr;MaskDisturbStr;13;0;Create;True;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;216;-8086.575,44.72266;Inherit;True;Property;_DisturbTex2;DisturbTex2;10;0;Create;True;0;0;0;False;0;False;-1;None;1eae6143ce30e2849b37136524e197f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;172;-5145.536,-2892.696;Inherit;False;Property;_MainDisturbStr;MainDisturbStr;12;0;Create;True;0;0;0;False;0;False;0;0.015;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-7688.723,50.21692;Inherit;False;DisturbColor2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-4866.611,-3315.121;Inherit;False;2;2;0;FLOAT;4.53;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-7004.574,-3515.15;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;159;-5592.013,-4388.063;Inherit;False;0;145;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-5268.066,-4204.841;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-6770.008,-3318.094;Inherit;False;Property;_Dissolution;Dissolution;24;0;Create;True;0;0;0;False;0;False;0.15;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;120;-8826.961,-1563.953;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;32;0;Create;True;0;0;0;False;0;False;0,0,1;0,-0.5,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;233;-5061.729,-4074.639;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-5074.3,-2998.799;Inherit;False;151;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;23;-6358.984,-3377.649;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;160;-5108.591,-4335.585;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;234;-4708.729,-4091.639;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;123;-8728.779,-1696.881;Inherit;False;0;102;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-4833.316,-2977.818;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;-8730.474,-1309.532;Inherit;False;217;DisturbColor2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;122;-8551.278,-1433.254;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-8720.163,-1215.968;Inherit;False;Property;_DissDisturbStr;DissDisturbStr;31;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-8527.345,-1540.156;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-4709.913,-3405.651;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;236;-4662.729,-4185.639;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-8429.377,-1285.394;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-4525.492,-3369.237;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;145;-4944.795,-4364.163;Inherit;True;Property;_MaskTex;MaskTex;4;0;Create;True;0;0;0;False;0;False;-1;None;fe2128bbcd534ce4a8c6ea750b68d5a6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-6026.347,-3379.103;Inherit;False;DissolutionControl;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;124;-8328.6,-1572.928;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;-4642.729,-4315.639;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-8742.606,-1076.848;Inherit;False;83;DissolutionControl;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-4392.862,-3385.277;Inherit;True;Property;_MainTex;MainTex;5;0;Create;True;0;0;0;False;0;False;-1;None;392c171f5aa09c24bb0f9c8142722010;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;210;-8708.316,-980.3955;Inherit;False;Constant;_DisStr;DisStr;28;0;Create;True;0;0;0;False;0;False;-2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;207;-8145.582,-1548.815;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-8401.011,-1046.051;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-5681.403,-1716.951;Inherit;False;4054.98;1905.382;Comment;25;95;101;100;6;142;89;112;119;51;97;52;98;42;74;50;44;49;45;40;43;39;148;201;214;215;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;102;-7941.771,-1588.65;Inherit;True;Property;_DissolutionTex;DissolutionTex;30;0;Create;True;0;0;0;False;0;False;-1;None;392c171f5aa09c24bb0f9c8142722010;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;105;-7810.883,-1358.957;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-4018.197,-3384.445;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-4514.508,-4339.375;Inherit;False;MaskColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-7706.788,-1204.666;Inherit;False;Property;_Edge;Edge;25;0;Create;True;0;0;0;False;0;False;0.3935294;0.362;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-5425.404,-1158.376;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;175;-3657.048,-3181.26;Inherit;False;174;MaskColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-3677.965,-3366.09;Inherit;False;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-3677.53,-3585.8;Inherit;False;Constant;_Float4;Float 4;40;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-7581.938,-1412.698;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-5286.425,-990.1625;Inherit;False;Property;_FadeRange;FadeRange;27;0;Create;True;0;0;0;False;0;False;1;2.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-5135.983,-1110.922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;228;-2654.203,-3706.756;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-7343.013,-1424.488;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-5106.591,-987.3033;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;223;-3403.729,-3314.575;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;226;-2413.768,-3678.148;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-4858.702,-845.2994;Inherit;False;Property;_FadeHardnss;FadeHardnss;28;0;Create;True;0;0;0;False;0;False;1;2.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-4908.677,-1082.865;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;90;-2610.118,-3587.826;Inherit;False;2825.268;1319.807;NoiseColor;32;57;91;65;189;179;191;199;180;66;190;55;67;186;195;204;184;182;185;58;187;63;60;205;194;202;59;211;212;213;227;230;232;NoiseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-7086.566,-1427.948;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;119;-4079.242,-634.3589;Inherit;True;Property;_FadeTex;FadeTex;34;0;Create;True;0;0;0;False;0;False;-1;None;21b93a22e93caab489ec4fefe73ae7cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;-3110.292,-3330.463;Inherit;False;FinalColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-2126.098,-3042.18;Inherit;True;198;FinalColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-3739.265,-614.9195;Inherit;False;FadeTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;232;-2510.856,-3326.615;Inherit;False;Property;_NoiseTiling;NoiseTiling;15;0;Create;True;0;0;0;False;0;False;1,1;20,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-4609.471,-1065.709;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;227;-2333.102,-3518.023;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-1908.909,-2614.823;Inherit;False;Property;_InnerEmissStrRange;InnerEmissStrRange;20;0;Create;True;0;0;0;False;0;False;1;1.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-6923.738,-1455.98;Inherit;True;Property;_RampTex;RampTex;33;0;Create;True;0;0;0;False;0;False;-1;None;da2150fdbd9743b4a9ce23c537eeb33b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;59;-2583.073,-3053.601;Inherit;False;Property;_NoiseFlip;NoiseFlip;17;0;Create;True;0;0;0;False;0;False;0,0,1;1,1,15;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;116;-6789.989,-1249.857;Inherit;False;Constant;_Float5;Float 5;21;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-2106.267,-2713.486;Inherit;False;Constant;_Float10;Float 10;35;0;Create;True;0;0;0;False;0;False;0.51;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;-1775.735,-2760.915;Inherit;False;142;FadeTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;205;-1675.102,-2608.339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-7113.824,-2908.038;Inherit;False;498.0005;281.3341;VertexColor;3;75;77;24;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;195;-1787.914,-2979.474;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;230;-2265.121,-3428.345;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;42;-4425.535,-1065.632;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-4016.24,-3233.208;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;185;-2575.644,-3191.151;Inherit;False;Property;_ColumnsRows;Columns&Rows;16;0;Create;True;0;0;0;False;0;False;1,1;4,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-6552.589,-1386.456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-2367.472,-3035.602;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-2386.054,-2934.116;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-4393.176,-1164.547;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-1913.198,-2496.941;Inherit;False;Property;_InnerEmissHardness;InnerEmissHardness;21;0;Create;True;0;0;0;False;0;False;0.5;3.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-4745.989,-1514.728;Inherit;False;198;FinalColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-1481.991,-2536.291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;51;-4172.248,-1138.121;Inherit;False;Property;_Fade;Fade;26;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;184;-2170.632,-3324.6;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;-1554.755,-2957.903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;144;-5682.406,450.7582;Inherit;False;1891.678;1053.213;VertexOffset;14;127;129;130;128;139;131;140;143;134;126;132;136;133;137;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-6398.747,-1387.189;Inherit;False;DissolutionColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;24;-7040.822,-2858.038;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;74;-4750.182,-1412.674;Inherit;False;69;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-6822.146,-2742.704;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;214;-3945.967,-1143.181;Inherit;False;VFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1888.506,-3189.296;Inherit;False;Property;_NoiseEmissionStr;NoiseEmissionStr;18;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-4510.283,-1242.537;Inherit;False;147;DissolutionColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-1470.55,-3505.962;Inherit;False;Constant;_Float6;Float 6;33;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;186;-1338.189,-2980.567;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;127;-5632.406,666.1418;Inherit;False;Property;_VertexOffsetTexPanner;VertexOffsetTexPanner;36;0;Create;True;0;0;0;False;0;False;0,0,1;0,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;199;-1524.284,-3392.05;Inherit;False;198;FinalColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-4498.147,-1485.366;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;-1919.019,-3408.367;Inherit;True;Property;_NoiseTex;NoiseTex;14;0;Create;True;0;0;0;False;0;False;-1;None;60a5d1bc92039e84e95740e39ae130d6;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;128;-5278.51,668.7578;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;130;-5312.511,762.7578;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-1262.183,-3454.073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-4049.834,-744.5806;Inherit;False;77;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;-3774.877,-1356.202;Inherit;False;214;VFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;191;-988.5027,-2996.893;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-5448.513,500.7583;Inherit;False;0;126;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1497.569,-3296.414;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-1026.965,-2712.2;Inherit;False;Property;_InnerEmissStr;InnerEmissStr;22;0;Create;True;0;0;0;False;0;False;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;112;-4140.615,-1447.712;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-748.6866,-3000.496;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;131;-5064.507,662.7578;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-6741.055,-3541.882;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;179;-1010.904,-3398.346;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-4848.803,1260.566;Inherit;False;83;DissolutionControl;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3560.754,-1453.057;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-4606.049,1387.971;Inherit;False;142;FadeTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;140;-4603.2,1265.259;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;21;-6369.46,-3535.981;Inherit;False;Property;_UV1_WContorlEmission;UV1_WContorlEmission;0;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-422.4548,-3384.927;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;126;-4808.726,626.6158;Inherit;True;Property;_VertexOffsetTex;VertexOffsetTex;35;0;Create;True;0;0;0;False;0;False;-1;None;bd1c52d775c09284eb17c646f4981cf0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;136;-4663.21,1141.995;Inherit;False;Property;_VertexOffsetStr;VertexOffsetStr;37;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-3245.099,-1270.175;Inherit;False;Property;_MainOpacity;MainOpacity;29;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;-3220.171,-1470.493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;132;-4691.21,867.9955;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;134;-4649.21,1034.995;Inherit;False;Constant;_Float7;Float 7;25;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-2950.871,-1486.49;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-4344.213,798.9944;Inherit;False;6;6;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-6032.656,-3537.324;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-6823.821,-2849.132;Inherit;False;VertexColorRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-161.5716,-3394.572;Inherit;False;NoiseColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-2663.417,-1507.569;Inherit;True;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-137.7815,-327.2659;Inherit;False;91;NoiseColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-7104.254,-2278.124;Inherit;False;448;277.753;Enum;3;36;37;141;Enum;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-125.8856,-251.5632;Inherit;False;82;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-4009.239,790.9055;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-144.3018,-415.6696;Inherit;False;75;VertexColorRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-148.3261,-703.9083;Inherit;False;Property;_MainColor;MainColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-100.5659,-513.3314;Inherit;False;Property;_EmissionStr;EmissionStr;19;0;Create;True;0;0;0;False;0;False;1;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1386.086,-3671.809;Inherit;True;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;178;-3207.991,-2970.997;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;208.4223,-525.0251;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-7077.254,-2117.37;Inherit;False;Property;_ZTestMode;ZTestMode;39;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-7073.774,-2215.125;Inherit;False;Property;_CullMode;CullMode;3;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-6900.979,-2212.529;Inherit;False;Property;_ZWriteMode;ZWriteMode;38;1;[Enum];Create;True;0;2;ZWriteOn;2;ZWriteOff;1;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;-2110.504,-3471.48;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;208.0686,-777.6067;Inherit;True;95;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;177;-3665.636,-2963.81;Inherit;True;Property;_StrokesTex;StrokesTex;40;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;225;-2554.995,-3894.648;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-4032.244,-3081.125;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-2576.024,-3544.723;Inherit;False;0;55;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;138;383.0607,-263.1085;Inherit;False;137;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;713.2584,-755.3762;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/GlowAB_OP_2;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;141;0;True;37;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;23;-1;-1;-1;0;False;0;0;True;36;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;154;0;152;1
WireConnection;154;1;152;2
WireConnection;153;0;152;3
WireConnection;156;0;155;0
WireConnection;156;2;154;0
WireConnection;156;1;153;0
WireConnection;220;0;218;1
WireConnection;220;1;218;2
WireConnection;219;0;218;3
WireConnection;31;0;29;3
WireConnection;30;0;29;1
WireConnection;30;1;29;2
WireConnection;150;1;156;0
WireConnection;151;0;150;1
WireConnection;27;0;28;0
WireConnection;27;2;30;0
WireConnection;27;1;31;0
WireConnection;222;0;221;0
WireConnection;222;2;220;0
WireConnection;222;1;219;0
WireConnection;33;0;27;0
WireConnection;53;1;54;0
WireConnection;53;0;38;3
WireConnection;216;1;222;0
WireConnection;217;0;216;1
WireConnection;35;0;33;1
WireConnection;35;1;53;0
WireConnection;169;0;161;0
WireConnection;169;1;164;0
WireConnection;233;1;238;1
WireConnection;233;2;238;2
WireConnection;233;3;238;3
WireConnection;23;1;5;0
WireConnection;23;0;20;4
WireConnection;160;0;159;0
WireConnection;160;1;169;0
WireConnection;234;0;233;0
WireConnection;171;0;170;0
WireConnection;171;1;172;0
WireConnection;122;0;120;3
WireConnection;121;0;120;1
WireConnection;121;1;120;2
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;236;0;234;0
WireConnection;208;0;206;0
WireConnection;208;1;209;0
WireConnection;168;0;34;0
WireConnection;168;1;171;0
WireConnection;145;1;160;0
WireConnection;83;0;23;0
WireConnection;124;0;123;0
WireConnection;124;2;121;0
WireConnection;124;1;122;0
WireConnection;235;0;145;1
WireConnection;235;1;236;0
WireConnection;1;1;168;0
WireConnection;207;0;124;0
WireConnection;207;1;208;0
WireConnection;106;0;84;0
WireConnection;106;1;210;0
WireConnection;102;1;207;0
WireConnection;68;0;1;1
WireConnection;174;0;235;0
WireConnection;111;0;102;1
WireConnection;111;1;105;0
WireConnection;111;2;106;0
WireConnection;40;0;39;2
WireConnection;9;0;111;0
WireConnection;9;1;13;0
WireConnection;45;0;43;0
WireConnection;223;0;224;0
WireConnection;223;1;197;0
WireConnection;223;2;175;0
WireConnection;226;0;228;1
WireConnection;226;1;228;2
WireConnection;44;0;40;0
WireConnection;44;1;45;0
WireConnection;113;0;9;0
WireConnection;198;0;223;0
WireConnection;142;0;119;1
WireConnection;50;0;44;0
WireConnection;50;1;49;0
WireConnection;227;0;226;0
WireConnection;114;1;113;0
WireConnection;205;0;202;0
WireConnection;195;0;182;0
WireConnection;195;1;194;0
WireConnection;230;0;227;0
WireConnection;230;1;232;0
WireConnection;42;0;50;0
WireConnection;69;0;1;2
WireConnection;115;0;114;1
WireConnection;115;1;116;0
WireConnection;60;0;59;1
WireConnection;60;1;59;2
WireConnection;63;0;59;3
WireConnection;204;0;205;0
WireConnection;204;1;187;0
WireConnection;51;1;52;0
WireConnection;51;0;42;0
WireConnection;184;0;230;0
WireConnection;184;1;185;1
WireConnection;184;2;185;2
WireConnection;184;3;60;0
WireConnection;184;5;63;0
WireConnection;213;0;195;0
WireConnection;213;1;212;0
WireConnection;147;0;115;0
WireConnection;77;0;24;4
WireConnection;214;0;51;0
WireConnection;186;0;213;0
WireConnection;186;1;205;0
WireConnection;186;2;204;0
WireConnection;98;0;201;0
WireConnection;98;1;74;0
WireConnection;55;1;184;0
WireConnection;128;0;127;1
WireConnection;128;1;127;2
WireConnection;130;0;127;3
WireConnection;211;0;180;0
WireConnection;211;1;199;0
WireConnection;191;0;186;0
WireConnection;66;0;55;1
WireConnection;66;1;67;0
WireConnection;112;1;98;0
WireConnection;112;2;148;0
WireConnection;189;0;191;0
WireConnection;189;1;190;0
WireConnection;131;0;129;0
WireConnection;131;2;128;0
WireConnection;131;1;130;0
WireConnection;179;0;211;0
WireConnection;179;1;66;0
WireConnection;179;2;199;0
WireConnection;89;0;112;0
WireConnection;89;1;215;0
WireConnection;89;2;97;0
WireConnection;89;3;119;1
WireConnection;140;0;139;0
WireConnection;21;1;22;0
WireConnection;21;0;20;3
WireConnection;65;0;179;0
WireConnection;65;1;189;0
WireConnection;126;1;131;0
WireConnection;6;0;89;0
WireConnection;101;0;6;0
WireConnection;101;1;100;0
WireConnection;133;0;126;1
WireConnection;133;1;132;0
WireConnection;133;2;134;0
WireConnection;133;3;136;0
WireConnection;133;4;140;0
WireConnection;133;5;143;0
WireConnection;82;0;21;0
WireConnection;75;0;24;0
WireConnection;91;0;65;0
WireConnection;95;0;101;0
WireConnection;137;0;133;0
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;15;2;78;0
WireConnection;15;3;92;0
WireConnection;15;4;85;0
WireConnection;70;0;1;3
WireConnection;0;9;96;0
WireConnection;0;13;15;0
WireConnection;0;11;138;0
ASEEND*/
//CHKSM=D6E5B0C2A675D72B7055542CE9BE8AA609FA6549