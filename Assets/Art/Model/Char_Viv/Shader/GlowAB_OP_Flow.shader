// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/GlowAB_OP_Flow_lattice"
{
	Properties
	{
		[Toggle(_UV1_WCONTORLEMISSION_ON)] _UV1_WContorlEmission("UV1_WContorlEmission", Float) = 0
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		[Toggle(_UV2_WCONTORLOFFSET_ON)] _UV2_WContorlOffset("UV2_WContorlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_MaskTex("MaskTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (0,0,0,0)
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		_NoiseTex("NoiseTex", 2D) = "black" {}
		_NoisePanner("NoisePanner", Vector) = (0,0,1,0)
		_NoiseEmissionStr("NoiseEmissionStr", Float) = 1
		_EmissionStr("EmissionStr", Float) = 1
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		_DissolutionSoft("DissolutionSoft", Range( 0.51 , 1)) = 0.3935294
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[Toggle(_FADE_ON)] _Fade("Fade", Float) = 0
		_FadeRange("FadeRange", Float) = 1
		_FadeHardnss("FadeHardnss", Float) = 1
		_MainOpacity("MainOpacity", Range( 0 , 1)) = 1
		_DissolutionTex("DissolutionTex", 2D) = "white" {}
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		_RampTex("RampTex", 2D) = "black" {}
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		_VertexNoisePanner("VertexNoisePanner", Vector) = (0,0,1,0)
		_VertexOffsetIntensity("VertexOffsetIntensity", Float) = 0.1
		_VertexOffsetStr("VertexOffsetStr", Float) = 1
		_VerTexOffsetDir("VerTexOffsetDir", Vector) = (0,1,0,0)
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
		#pragma shader_feature_local _UV2_WCONTORLOFFSET_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma shader_feature_local _FADE_ON
		#pragma shader_feature_local _UV1_WCONTORLEMISSION_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv2_texcoord2;
			float4 uv_texcoord;
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

		uniform float _ZTestMode;
		uniform float _CullMode;
		uniform sampler2D _VertexOffsetTex;
		uniform float3 _VertexNoisePanner;
		uniform float4 _VertexOffsetTex_ST;
		uniform float3 _VerTexOffsetDir;
		uniform float _VertexOffsetIntensity;
		uniform float _VertexOffsetStr;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform sampler2D _RampTex;
		uniform float _DissolutionSoft;
		uniform sampler2D _DissolutionTex;
		uniform float3 _DissolutionTexPanner;
		uniform float4 _DissolutionTex_ST;
		uniform float _Dissolution;
		uniform float _FadeRange;
		uniform float _FadeHardnss;
		uniform float _MainOpacity;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		uniform float4 _MainColor;
		uniform float _EmissionStr;
		uniform sampler2D _NoiseTex;
		uniform float3 _NoisePanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseEmissionStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime133 = _Time.y * _VertexNoisePanner.z;
			float2 appendResult132 = (float2(_VertexNoisePanner.x , _VertexNoisePanner.y));
			float4 uvs_VertexOffsetTex = v.texcoord;
			uvs_VertexOffsetTex.xy = v.texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
			float2 panner134 = ( mulTime133 * appendResult132 + uvs_VertexOffsetTex.xy);
			float3 ase_vertexNormal = v.normal.xyz;
			float3 worldToObj127 = mul( unity_WorldToObject, float4( ( ase_vertexNormal - _VerTexOffsetDir ), 1 ) ).xyz;
			float mulTime31 = _Time.y * _MainTexPanner.z;
			float2 appendResult30 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uv2s_MainTex = v.texcoord1;
			uv2s_MainTex.xy = v.texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner27 = ( mulTime31 * appendResult30 + uv2s_MainTex.xy);
			float2 break33 = panner27;
			#ifdef _UV2_WCONTORLOFFSET_ON
				float staticSwitch53 = v.texcoord1.z;
			#else
				float staticSwitch53 = 0.0;
			#endif
			float2 appendResult34 = (float2(break33.x , ( break33.y + staticSwitch53 )));
			float4 tex2DNode1 = tex2Dlod( _MainTex, float4( appendResult34, 0, 0.0) );
			float MainTexG69 = tex2DNode1.g;
			float3 VertexOffset120 = ( (-1.0 + (tex2Dlod( _VertexOffsetTex, float4( panner134, 0, 0.0) ).r - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * worldToObj127 * _VertexOffsetIntensity * _VertexOffsetStr * MainTexG69 );
			v.vertex.xyz += VertexOffset120;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime31 = _Time.y * _MainTexPanner.z;
			float2 appendResult30 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uv2s_MainTex = i.uv2_texcoord2;
			uv2s_MainTex.xy = i.uv2_texcoord2.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner27 = ( mulTime31 * appendResult30 + uv2s_MainTex.xy);
			float2 break33 = panner27;
			#ifdef _UV2_WCONTORLOFFSET_ON
				float staticSwitch53 = i.uv2_texcoord2.z;
			#else
				float staticSwitch53 = 0.0;
			#endif
			float2 appendResult34 = (float2(break33.x , ( break33.y + staticSwitch53 )));
			float4 tex2DNode1 = tex2D( _MainTex, appendResult34 );
			float MainTexR167 = tex2DNode1.r;
			float mulTime164 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult163 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolutionTex = i.uv_texcoord;
			uvs_DissolutionTex.xy = i.uv_texcoord.xy * _DissolutionTex_ST.xy + _DissolutionTex_ST.zw;
			float2 panner165 = ( mulTime164 * appendResult163 + uvs_DissolutionTex.xy);
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch23 = i.uv_texcoord.w;
			#else
				float staticSwitch23 = _Dissolution;
			#endif
			float UV1_T83 = staticSwitch23;
			float smoothstepResult9 = smoothstep( ( 1.0 - _DissolutionSoft ) , _DissolutionSoft , ( tex2D( _DissolutionTex, panner165 ).r + 1.0 + ( UV1_T83 * -2.0 ) ));
			float2 appendResult113 = (float2(smoothstepResult9 , 0.0));
			float lerpResult112 = lerp( MainTexR167 , 0.0 , tex2D( _RampTex, appendResult113 ).a);
			#ifdef _FADE_ON
				float staticSwitch51 = saturate( ( ( ( 1.0 - i.uv_texcoord.xy.y ) - ( _FadeRange * 0.1 ) ) * _FadeHardnss ) );
			#else
				float staticSwitch51 = 1.0;
			#endif
			float VFade160 = staticSwitch51;
			float2 uv_MaskTex = i.uv_texcoord * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float VertexColorA77 = i.vertexColor.a;
			float FinalOpacity95 = ( ( saturate( ( lerpResult112 * VFade160 ) ) * _MainOpacity ) * tex2D( _MaskTex, uv_MaskTex ).r * VertexColorA77 );
			float4 VertexColorRGB75 = i.vertexColor;
			float mulTime63 = _Time.y * _NoisePanner.z;
			float2 appendResult60 = (float2(_NoisePanner.x , _NoisePanner.y));
			float4 uvs_NoiseTex = i.uv_texcoord;
			uvs_NoiseTex.xy = i.uv_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner57 = ( mulTime63 * appendResult60 + uvs_NoiseTex.xy);
			float NoiseColor91 = ( tex2D( _NoiseTex, panner57 ).r * _NoiseEmissionStr );
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
				o.customPack1.xyzw = customInputData.uv2_texcoord2;
				o.customPack1.xyzw = v.texcoord1;
				o.customPack2.xyzw = customInputData.uv_texcoord;
				o.customPack2.xyzw = v.texcoord;
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
				surfIN.uv2_texcoord2 = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
173;55;1717;848;5313.088;1143.561;4.842418;True;True
Node;AmplifyShaderEditor.CommentaryNode;80;-2611.824,-1848;Inherit;False;2041.728;802.9839;MainTex;21;150;151;70;69;139;68;1;34;35;33;53;54;38;27;28;30;31;29;152;167;171;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;93;-4029.789,-1809.215;Inherit;False;1252.226;378.732;Comment;3;23;83;5;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;29;-2561.824,-1637.757;Inherit;False;Property;_MainTexPanner;MainTexPanner;7;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-3979.789,-1732.483;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-3708.905,-1497.129;Inherit;False;Property;_Dissolution;Dissolution;13;0;Create;True;0;0;0;False;0;False;0.15;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-2584.765,-3.47905;Inherit;False;4018.056;1905.382;Comment;36;89;95;101;100;6;112;114;113;9;51;52;42;50;49;40;45;13;43;111;102;105;106;107;84;156;157;158;159;161;163;164;165;168;169;170;173;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2508.641,-1798;Inherit;False;1;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;162;-2853.096,281.5292;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;22;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;23;-3326.951,-1604.793;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-2313.825,-1530.757;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2310.825,-1684.757;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;159;-2483.657,1086.721;Inherit;False;1874.681;472.4592;Comment;3;160;44;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-3001.563,-1596.436;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2363.137,-1421.28;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;164;-2608.408,411.2293;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2433.657,1145.24;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-2281.246,1282.746;Inherit;False;Property;_FadeRange;FadeRange;18;0;Create;True;0;0;0;False;0;False;1;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;166;-2776.304,137.0569;Inherit;False;0;102;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-2431.74,-1323.773;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;27;-2138.245,-1779.019;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;163;-2595.475,294.3273;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-2373.894,636.5463;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;53;-2142.137,-1401.28;Inherit;False;Property;_UV2_WContorlOffset;UV2_WContorlOffset;2;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2101.413,1285.605;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-2130.805,1161.987;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;165;-2399.35,227.788;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;33;-1967.932,-1652.376;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2394.718,557.8037;Inherit;False;83;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1853.524,1427.609;Inherit;False;Property;_FadeHardnss;FadeHardnss;19;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2147.055,442.5564;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;102;-2211.798,236.7034;Inherit;True;Property;_DissolutionTex;DissolutionTex;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-2090.469,561.0815;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-1790.838,-1554.456;Inherit;False;2;2;0;FLOAT;4.53;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1981.022,665.2763;Inherit;False;Property;_DissolutionSoft;DissolutionSoft;14;0;Create;True;0;0;0;False;0;False;0.3935294;0.3935294;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-1903.499,1190.043;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1651.943,-1649.16;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1604.293,1207.199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-1751.389,378.4708;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;156;-1615.45,468.7836;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;-1405.235,1260.202;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1437.486,-1622.272;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;None;fb9cffdf6690ab04ba7492306f4ed0e3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-1382.823,1170.477;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-1363.257,411.8041;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;90;-2603.798,-951.4779;Inherit;False;2303.827;850.5757;NoiseColor;9;91;66;55;67;57;60;63;58;59;NoiseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;143;1071.519,-2275.602;Inherit;False;2287.448;1243.274;VertexOffset;17;120;142;118;129;122;125;123;127;117;128;126;119;134;131;132;133;130;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;51;-1175.657,1205.202;Inherit;False;Property;_Fade;Fade;17;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-981.4873,-1748.268;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1090.038,416.9398;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;59;-2553.798,-748.4777;Inherit;False;Property;_NoisePanner;NoisePanner;9;0;Create;True;0;0;0;False;0;False;0,0,1;0,0.2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;130;1121.519,-2072.602;Inherit;False;Property;_VertexNoisePanner;VertexNoisePanner;25;0;Create;True;0;0;0;False;0;False;0,0,1;0,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-917.967,1205.376;Inherit;False;VFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-701.7498,179.6302;Inherit;False;167;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-841.4875,286.0307;Inherit;False;Constant;_Float5;Float 5;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-932.4299,384.4757;Inherit;True;Property;_RampTex;RampTex;23;0;Create;True;0;0;0;False;0;False;-1;None;da2150fdbd9743b4a9ce23c537eeb33b;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;132;1343.52,-2057.602;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;112;-421.7812,419.0468;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;133;1309.519,-1963.602;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-2331.797,-733.4777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;1173.518,-2225.602;Inherit;False;0;117;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-2501.799,-901.4779;Inherit;False;0;55;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;161;-430.5078,652.7778;Inherit;False;160;VFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-500.0077,-1838.438;Inherit;False;498.0005;281.3341;VertexColor;3;24;77;75;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-2365.798,-639.4778;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;-2117.797,-739.4777;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;134;1557.52,-2063.602;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;126;1561.72,-1657.352;Inherit;False;Property;_VerTexOffsetDir;VerTexOffsetDir;28;0;Create;True;0;0;0;False;0;False;0,1,0;3.07,1.6,-0.07;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-29.47743,638.5006;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;119;1530.441,-1848.843;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;24;-450.0077,-1788.438;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;100;68.12213,946.7442;Inherit;False;Property;_MainOpacity;MainOpacity;20;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;1846.024,-1768.17;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;117;1978.567,-2065.55;Inherit;True;Property;_VertexOffsetTex;VertexOffsetTex;24;0;Create;True;0;0;0;False;0;False;-1;None;efccf27a2e7dd4a4c9a7b81f565bc7df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-232.3325,-1673.104;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-983.623,-1643.227;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;-1873.699,-776.0187;Inherit;True;Property;_NoiseTex;NoiseTex;8;0;Create;True;0;0;0;False;0;False;-1;None;62264991f621b774fa0ef0114b8c33c4;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;6;331.6807,655.2147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1806.486,-546.9477;Inherit;False;Property;_NoiseEmissionStr;NoiseEmissionStr;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3716.271,-1759.215;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;2257.114,-1185.273;Inherit;False;69;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;689.356,657.6406;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;129;2349.44,-2017.238;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;654.317,1098.956;Inherit;False;77;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;170;514.7104,773.6735;Inherit;True;Property;_MaskTex;MaskTex;4;0;Create;True;0;0;0;False;0;False;-1;None;39b54b302ebc56a4ba66a7f8466b122a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;21;-3344.676,-1753.314;Inherit;False;Property;_UV1_WContorlEmission;UV1_WContorlEmission;0;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;2243.954,-1590.186;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;26;0;Create;True;0;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;2268.614,-1388.927;Inherit;False;Property;_VertexOffsetStr;VertexOffsetStr;27;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1555.715,-735.7878;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;127;2133.42,-1773.252;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;944.7104,744.6735;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-233.0073,-1779.532;Inherit;False;VertexColorRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;2745.738,-1844.593;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-1362.783,-738.2488;Inherit;True;NoiseColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3007.872,-1754.657;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-148.1754,-329.1346;Inherit;True;91;NoiseColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-166.0121,-418.8661;Inherit;False;75;VertexColorRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-134.5659,-511.3314;Inherit;False;Property;_EmissionStr;EmissionStr;11;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;1183.226,720.2242;Inherit;True;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-174.3261,-700.9083;Inherit;False;Property;_MainColor;MainColor;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;85;-145.0413,-120.8253;Inherit;True;82;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;2911.637,-1846.732;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-971.3881,-1532.283;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-1010.247,-1425.55;Inherit;False;MainTexA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;150;-1606.992,-1263.536;Inherit;True;Property;_GradientColorTex;GradientColorTex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;171;-1279.237,-1355.697;Inherit;False;167;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-1051.505,-1281.118;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;152;-1278.822,-1260.039;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-799.5529,-1285.752;Inherit;True;MainTexRColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;2169.677,-1011.992;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;148;2462.877,-997.4921;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;720.668,-405.3606;Inherit;False;120;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;149;2158.223,-788.2534;Inherit;False;Property;_UVFadeRange;UVFadeRange;29;0;Create;True;0;0;0;False;0;False;4.06;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;208.4223,-525.0251;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;2883.973,-1001.182;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3971.789,-1339.027;Inherit;False;Property;_CullMode;CullMode;15;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-3975.268,-1241.273;Inherit;False;Property;_ZTestMode;ZTestMode;16;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATanOpNode;142;1970.203,-1679.434;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-2423.543,451.4607;Inherit;False;Constant;_Float6;Float 6;28;0;Create;True;0;0;0;False;0;False;0.5262662;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;206.547,-779.1283;Inherit;True;95;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;144;1934.649,-1027.358;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;994.5419,-830.6514;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/GlowAB_OP_Flow_lattice;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;True;37;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;12;-1;-1;-1;0;False;0;0;True;36;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;46;-4025.268,-1389.026;Inherit;False;235;263.753;Comment;0;;1,1,1,1;0;0
WireConnection;23;1;5;0
WireConnection;23;0;20;4
WireConnection;31;0;29;3
WireConnection;30;0;29;1
WireConnection;30;1;29;2
WireConnection;83;0;23;0
WireConnection;164;0;162;3
WireConnection;27;0;28;0
WireConnection;27;2;30;0
WireConnection;27;1;31;0
WireConnection;163;0;162;1
WireConnection;163;1;162;2
WireConnection;53;1;54;0
WireConnection;53;0;38;3
WireConnection;45;0;43;0
WireConnection;40;0;39;2
WireConnection;165;0;166;0
WireConnection;165;2;163;0
WireConnection;165;1;164;0
WireConnection;33;0;27;0
WireConnection;102;1;165;0
WireConnection;106;0;84;0
WireConnection;106;1;107;0
WireConnection;35;0;33;1
WireConnection;35;1;53;0
WireConnection;44;0;40;0
WireConnection;44;1;45;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;50;0;44;0
WireConnection;50;1;49;0
WireConnection;111;0;102;1
WireConnection;111;1;105;0
WireConnection;111;2;106;0
WireConnection;156;0;13;0
WireConnection;42;0;50;0
WireConnection;1;1;34;0
WireConnection;9;0;111;0
WireConnection;9;1;156;0
WireConnection;9;2;13;0
WireConnection;51;1;52;0
WireConnection;51;0;42;0
WireConnection;167;0;1;1
WireConnection;113;0;9;0
WireConnection;160;0;51;0
WireConnection;114;1;113;0
WireConnection;132;0;130;1
WireConnection;132;1;130;2
WireConnection;112;0;168;0
WireConnection;112;1;158;0
WireConnection;112;2;114;4
WireConnection;133;0;130;3
WireConnection;60;0;59;1
WireConnection;60;1;59;2
WireConnection;63;0;59;3
WireConnection;57;0;58;0
WireConnection;57;2;60;0
WireConnection;57;1;63;0
WireConnection;134;0;131;0
WireConnection;134;2;132;0
WireConnection;134;1;133;0
WireConnection;89;0;112;0
WireConnection;89;1;161;0
WireConnection;128;0;119;0
WireConnection;128;1;126;0
WireConnection;117;1;134;0
WireConnection;77;0;24;4
WireConnection;69;0;1;2
WireConnection;55;1;57;0
WireConnection;6;0;89;0
WireConnection;101;0;6;0
WireConnection;101;1;100;0
WireConnection;129;0;117;1
WireConnection;21;1;22;0
WireConnection;21;0;20;3
WireConnection;66;0;55;1
WireConnection;66;1;67;0
WireConnection;127;0;128;0
WireConnection;169;0;101;0
WireConnection;169;1;170;1
WireConnection;169;2;173;0
WireConnection;75;0;24;0
WireConnection;118;0;129;0
WireConnection;118;1;127;0
WireConnection;118;2;122;0
WireConnection;118;3;123;0
WireConnection;118;4;125;0
WireConnection;91;0;66;0
WireConnection;82;0;21;0
WireConnection;95;0;169;0
WireConnection;120;0;118;0
WireConnection;70;0;1;3
WireConnection;139;0;1;4
WireConnection;150;1;34;0
WireConnection;151;0;171;0
WireConnection;151;1;152;0
WireConnection;152;0;150;0
WireConnection;68;0;151;0
WireConnection;145;0;144;2
WireConnection;148;0;145;0
WireConnection;148;1;149;0
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;15;2;78;0
WireConnection;15;3;92;0
WireConnection;15;4;85;0
WireConnection;0;9;96;0
WireConnection;0;13;15;0
WireConnection;0;11;124;0
ASEEND*/
//CHKSM=100EB50D4CF878FFB77FB345C7C0B8E5D070AFE7