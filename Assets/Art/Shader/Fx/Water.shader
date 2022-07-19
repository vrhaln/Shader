// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Fx/Water"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[Toggle(_UV2CONTROLOFFSET_ON)] _UV2ControlOffset("UV2ControlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_RampTex("RampTex", 2D) = "white" {}
		_Rotater("Rotater", Range( 0 , 360)) = 0
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		[HDR]_Color1("Color1", Color) = (1,1,1,1)
		[HDR]_Color2("Color2", Color) = (1,1,1,1)
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,1)
		[Toggle(_UV1_WCONTORLEDGEWIDTH_ON)] _UV1_WContorlEdgeWidth("UV1_WContorlEdgeWidth", Float) = 0
		_EdgeWidth("EdgeWidth", Range( 0 , 2)) = 0.1
		_EdgeSoft("EdgeSoft", Range( 0.51 , 1)) = 0.675
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		_DissolveTex("DissolveTex", 2D) = "white" {}
		_OneMinus("OneMinus", Range( 0 , 1)) = 0
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		[Toggle(_DISTURBON_ON)] _DisturbOn("DisturbOn", Float) = 0
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_DisturbPanner("DisturbPanner", Vector) = (0,0,1,0)
		_DisturbStr("DisturbStr", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		[Toggle(_SOFTPARTICLE_ON)] _SoftParticle("SoftParticle", Float) = 0
		_FadeRange("FadeRange", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _UV2CONTROLOFFSET_ON
		#pragma shader_feature_local _DISTURBON_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma shader_feature_local _SOFTPARTICLE_ON
		#pragma shader_feature_local _UV1_WCONTORLEDGEWIDTH_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 uv2_texcoord2;
			float4 screenPos;
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
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform float _Rotater;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _DisturbStr;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _EdgeSoft;
		uniform sampler2D _DissolveTex;
		uniform float3 _DissolutionTexPanner;
		uniform float4 _DissolveTex_ST;
		uniform float _OneMinus;
		uniform float _Dissolution;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FadeRange;
		uniform float _EdgeWidth;
		uniform sampler2D _RampTex;
		uniform float4 _RampTex_ST;
		uniform float4 _EdgeColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float VertexA116 = i.vertexColor.a;
			float mulTime65 = _Time.y * _MainTexPanner.z;
			float2 appendResult67 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner68 = ( mulTime65 * appendResult67 + uvs_MainTex.xy);
			float UV2_W34 = i.uv2_texcoord2.z;
			float UV2_T33 = i.uv2_texcoord2.w;
			float2 appendResult70 = (float2(UV2_W34 , UV2_T33));
			#ifdef _UV2CONTROLOFFSET_ON
				float2 staticSwitch69 = ( uvs_MainTex.xy + appendResult70 );
			#else
				float2 staticSwitch69 = panner68;
			#endif
			float2 temp_cast_3 = (0.5).xx;
			float cos63 = cos( ( (0.0 + (_Rotater - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float sin63 = sin( ( (0.0 + (_Rotater - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float2 rotator63 = mul( staticSwitch69 - temp_cast_3 , float2x2( cos63 , -sin63 , sin63 , cos63 )) + temp_cast_3;
			float mulTime86 = _Time.y * _DisturbPanner.z;
			float2 appendResult85 = (float2(_DisturbPanner.x , _DisturbPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner87 = ( mulTime86 * appendResult85 + uvs_DisturbTex.xy);
			#ifdef _DISTURBON_ON
				float staticSwitch93 = ( tex2D( _DisturbTex, panner87 ).r * _DisturbStr );
			#else
				float staticSwitch93 = 0.0;
			#endif
			float DisturbColor94 = staticSwitch93;
			float4 tex2DNode1 = tex2D( _MainTex, ( rotator63 + DisturbColor94 ) );
			float MainTexG54 = tex2DNode1.g;
			float Color1A142 = ( MainTexG54 * _Color1.a );
			float MainTexB111 = tex2DNode1.b;
			float Color2A144 = ( MainTexB111 * _Color2.a );
			float MainTexR79 = tex2DNode1.r;
			float mulTime50 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult51 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			float2 panner53 = ( mulTime50 * appendResult51 + uvs_DissolveTex.xy);
			float4 tex2DNode2 = tex2D( _DissolveTex, ( panner53 + DisturbColor94 ) );
			float lerpResult22 = lerp( tex2DNode2.r , ( 1.0 - tex2DNode2.r ) , _OneMinus);
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch38 = i.uv_texcoord.w;
			#else
				float staticSwitch38 = _Dissolution;
			#endif
			float UV1_T39 = staticSwitch38;
			float2 uv_MaskTex = i.uv_texcoord * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float Mask167 = tex2D( _MaskTex, uv_MaskTex ).r;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth172 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth172 = abs( ( screenDepth172 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FadeRange ) );
			#ifdef _SOFTPARTICLE_ON
				float staticSwitch174 = distanceDepth172;
			#else
				float staticSwitch174 = 1.0;
			#endif
			float SoftParticle176 = saturate( staticSwitch174 );
			float temp_output_169_0 = ( ( lerpResult22 - (-1.0 + (UV1_T39 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) * Mask167 * SoftParticle176 );
			#ifdef _UV1_WCONTORLEDGEWIDTH_ON
				float staticSwitch41 = i.uv_texcoord.z;
			#else
				float staticSwitch41 = _EdgeWidth;
			#endif
			float UV1_W42 = staticSwitch41;
			float smoothstepResult161 = smoothstep( ( 1.0 - _EdgeSoft ) , _EdgeSoft , ( distance( 0.5 , temp_output_169_0 ) / UV1_W42 ));
			float clampResult13 = clamp( ( ( ( 1.0 - smoothstepResult161 ) * MainTexG54 ) + MainTexR79 ) , 0.0 , 1.0 );
			float Edge120 = clampResult13;
			float EdgeA146 = ( _EdgeColor.a * Edge120 );
			float Dissolve123 = step( 0.5 , temp_output_169_0 );
			float clampResult165 = clamp( ( VertexA116 * ( ( ( ( ( Color1A142 * ( 1.0 - MainTexB111 ) ) + Color2A144 ) * ( 1.0 - MainTexR79 ) ) + EdgeA146 ) * Dissolve123 ) ) , 0.0 , 1.0 );
			c.rgb = 0;
			c.a = clampResult165;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float mulTime65 = _Time.y * _MainTexPanner.z;
			float2 appendResult67 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner68 = ( mulTime65 * appendResult67 + uvs_MainTex.xy);
			float UV2_W34 = i.uv2_texcoord2.z;
			float UV2_T33 = i.uv2_texcoord2.w;
			float2 appendResult70 = (float2(UV2_W34 , UV2_T33));
			#ifdef _UV2CONTROLOFFSET_ON
				float2 staticSwitch69 = ( uvs_MainTex.xy + appendResult70 );
			#else
				float2 staticSwitch69 = panner68;
			#endif
			float2 temp_cast_0 = (0.5).xx;
			float cos63 = cos( ( (0.0 + (_Rotater - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float sin63 = sin( ( (0.0 + (_Rotater - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float2 rotator63 = mul( staticSwitch69 - temp_cast_0 , float2x2( cos63 , -sin63 , sin63 , cos63 )) + temp_cast_0;
			float mulTime86 = _Time.y * _DisturbPanner.z;
			float2 appendResult85 = (float2(_DisturbPanner.x , _DisturbPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner87 = ( mulTime86 * appendResult85 + uvs_DisturbTex.xy);
			#ifdef _DISTURBON_ON
				float staticSwitch93 = ( tex2D( _DisturbTex, panner87 ).r * _DisturbStr );
			#else
				float staticSwitch93 = 0.0;
			#endif
			float DisturbColor94 = staticSwitch93;
			float4 tex2DNode1 = tex2D( _MainTex, ( rotator63 + DisturbColor94 ) );
			float MainTexG54 = tex2DNode1.g;
			float4 Color1128 = ( MainTexG54 * _Color1 );
			float MainTexB111 = tex2DNode1.b;
			float4 Color2131 = ( MainTexB111 * _Color2 );
			float mulTime50 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult51 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			float2 panner53 = ( mulTime50 * appendResult51 + uvs_DissolveTex.xy);
			float4 tex2DNode2 = tex2D( _DissolveTex, ( panner53 + DisturbColor94 ) );
			float lerpResult22 = lerp( tex2DNode2.r , ( 1.0 - tex2DNode2.r ) , _OneMinus);
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch38 = i.uv_texcoord.w;
			#else
				float staticSwitch38 = _Dissolution;
			#endif
			float UV1_T39 = staticSwitch38;
			float2 uv_MaskTex = i.uv_texcoord * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float Mask167 = tex2D( _MaskTex, uv_MaskTex ).r;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth172 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth172 = abs( ( screenDepth172 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FadeRange ) );
			#ifdef _SOFTPARTICLE_ON
				float staticSwitch174 = distanceDepth172;
			#else
				float staticSwitch174 = 1.0;
			#endif
			float SoftParticle176 = saturate( staticSwitch174 );
			float temp_output_169_0 = ( ( lerpResult22 - (-1.0 + (UV1_T39 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) * Mask167 * SoftParticle176 );
			#ifdef _UV1_WCONTORLEDGEWIDTH_ON
				float staticSwitch41 = i.uv_texcoord.z;
			#else
				float staticSwitch41 = _EdgeWidth;
			#endif
			float UV1_W42 = staticSwitch41;
			float smoothstepResult161 = smoothstep( ( 1.0 - _EdgeSoft ) , _EdgeSoft , ( distance( 0.5 , temp_output_169_0 ) / UV1_W42 ));
			float MainTexR79 = tex2DNode1.r;
			float clampResult13 = clamp( ( ( ( 1.0 - smoothstepResult161 ) * MainTexG54 ) + MainTexR79 ) , 0.0 , 1.0 );
			float Edge120 = clampResult13;
			float4 uvs_RampTex = i.uv_texcoord;
			uvs_RampTex.xy = i.uv_texcoord.xy * _RampTex_ST.xy + _RampTex_ST.zw;
			float4 RampColor182 = tex2D( _RampTex, uvs_RampTex.xy );
			float4 EdgeColor139 = ( _EdgeColor * Edge120 );
			float3 VertexRGB115 = (i.vertexColor).rgb;
			o.Emission = ( ( ( ( ( ( Color1128 * ( 1.0 - MainTexB111 ) ) + Color2131 ) * ( 1.0 - Edge120 ) ) * RampColor182 ) + EdgeColor139 ) * float4( VertexRGB115 , 0.0 ) ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
279;371;1240;741;544.4738;-1520.572;1.51139;True;True
Node;AmplifyShaderEditor.CommentaryNode;82;-210.8152,-2248.895;Inherit;False;1861.461;712.423;DisturbColor;12;94;93;92;91;90;89;88;87;86;85;84;83;DisturbColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;83;-106.5913,-1945.562;Inherit;False;Property;_DisturbPanner;DisturbPanner;21;0;Create;True;0;0;0;False;0;False;0,0,1;0.5,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;85;144.4077,-1992.562;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-53.40718,-2105.805;Inherit;False;0;90;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;86;141.4077,-1838.562;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;87;326.0896,-2024.424;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;90;565.2236,-2036.27;Inherit;True;Property;_DisturbTex;DisturbTex;20;0;Create;True;0;0;0;False;0;False;-1;None;91ccffe1e18c25542844cbe4789cc399;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;686.3447,-1818.225;Inherit;False;Property;_DisturbStr;DisturbStr;22;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;918.8209,-1942.519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;125;-3474.939,932.693;Inherit;False;3097.716;733.9368;Comment;19;123;3;5;22;21;48;47;2;95;96;53;51;52;50;49;163;168;169;179;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;91;942.4198,-2087.295;Inherit;False;Constant;_0;0;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;49;-3424.939,1188.802;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;17;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;93;1130.487,-1999.666;Inherit;False;Property;_DisturbOn;DisturbOn;19;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;1968.942,-1349.239;Inherit;False;1143.907;365.912;Comment;3;34;33;32;UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-3326.757,1037.559;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;1421.363,-1997.762;Inherit;False;DisturbColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;50;-3130.941,1303.802;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;170;-598.3755,3019.849;Inherit;False;1080.439;324.1655;SoftParticle;6;176;175;174;173;172;171;SoftParticle;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-3127.941,1149.802;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;35;1973.42,-1900.065;Inherit;False;1252.226;378.732;Comment;7;42;41;39;38;37;36;11;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;53;-2955.362,1055.54;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2919.47,1196.454;Inherit;False;94;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-537.0365,3207.828;Inherit;False;Property;_FadeRange;FadeRange;25;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;2023.42,-1823.332;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;2233.985,-1606.277;Inherit;False;Property;_Dissolution;Dissolution;18;0;Create;True;0;0;0;False;0;False;0.15;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;1997.972,-1285.318;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;172;-357.5115,3188.014;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-328.4245,3092.53;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-2686.889,1061.021;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;2465.016,-1172.265;Inherit;False;UV2_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;38;2603.009,-1698.429;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;14;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;114;-3492.048,-1471.202;Inherit;False;2725.201;757.9998;Comment;22;64;72;71;65;57;70;66;58;67;59;68;60;69;62;61;98;63;104;1;54;79;111;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;2466.481,-1266.956;Inherit;False;UV2_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-3410.048,-829.2022;Inherit;False;33;UV2_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;177;-1324.044,3056.566;Inherit;False;585.804;280;Comment;2;166;167;Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;64;-3442.048,-1261.202;Inherit;False;Property;_MainTexPanner;MainTexPanner;7;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;2;-2527.619,1030.201;Inherit;True;Property;_DissolveTex;DissolveTex;15;0;Create;True;0;0;0;False;0;False;-1;6fda4a099411a18468456111546c16ee;ea5bde1b09d133a44b2e9839724c0950;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;2946.251,-1681.639;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-3410.048,-925.2022;Inherit;False;34;UV2_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;174;-93.77832,3099.775;Inherit;False;Property;_SoftParticle;SoftParticle;24;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;166;-1274.044,3106.566;Inherit;True;Property;_MaskTex;MaskTex;23;0;Create;True;0;0;0;False;0;False;-1;None;8f5b9bfb4786b5047b0a4610286148ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;70;-3186.048,-893.2022;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;175;138.1763,3121.597;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2474.586,1260.333;Inherit;False;Property;_OneMinus;OneMinus;16;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;-3202.048,-1149.202;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-2164.217,1119.248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-3394.048,-1421.202;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2083.123,1258.135;Inherit;False;39;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-3266.048,-1053.202;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;58;-2834.048,-1053.202;Inherit;False;Property;_Rotater;Rotater;6;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-3202.048,-1309.202;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;268.956,3104.385;Inherit;False;SoftParticle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-962.2402,3106.709;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-2994.048,-1021.202;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;5;-1888.27,1259.896;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-1972.304,1065.363;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;2280.438,-1851.646;Inherit;False;Property;_EdgeWidth;EdgeWidth;12;0;Create;True;0;0;0;False;0;False;0.1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;60;-2562.048,-1037.202;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;360;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;68;-3010.048,-1341.202;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-1646.524,1209.133;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-1603.659,1537.267;Inherit;False;176;SoftParticle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2530.048,-1149.202;Inherit;False;Constant;_Float11;Float 11;26;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-1616.054,1429.232;Inherit;False;167;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;69;-2834.048,-1213.202;Inherit;False;Property;_UV2ControlOffset;UV2ControlOffset;3;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;126;-1356.887,1968.539;Inherit;False;2118.712;908.1445;Comment;14;10;120;13;81;76;80;74;109;8;9;162;7;161;164;EdgeColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;41;2582.247,-1842.274;Inherit;False;Property;_UV1_WContorlEdgeWidth;UV1_WContorlEdgeWidth;11;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;62;-2386.048,-1037.202;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;2949.794,-1839.929;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1319.166,2043.747;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;63;-2115.225,-1194.555;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2097.486,-1048.89;Inherit;False;94;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-1365.178,1221.062;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1117.232,2298.025;Inherit;False;42;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;8;-1142.855,2046.779;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-1761.047,-1177.701;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1087.797,2423.597;Inherit;False;Property;_EdgeSoft;EdgeSoft;13;0;Create;True;0;0;0;False;0;False;0.675;1;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1387.174,-1160.765;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;-1;None;4ba4abb46f74e014798f91ae439b34c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;10;-865.8889,2047.557;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;162;-777.5063,2426.627;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-989.8469,-1071.887;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;161;-596.5461,2112.98;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-988.4385,-1188.569;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;164;-352.2156,2123.482;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-329.7712,2215.825;Inherit;False;54;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-115.1303,2398.619;Inherit;False;79;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-113.9533,2124.727;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;127;-3468.24,-489.1165;Inherit;False;1005.816;635.1721;Comment;6;128;110;19;20;141;142;Color1;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-992.8817,-964.1551;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;130;-2399.306,-483.6283;Inherit;False;899.6936;618.8465;Comment;6;131;99;100;113;143;144;Color2;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;103.8291,2176.95;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-3420.054,-426.7668;Inherit;False;54;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-3452.079,-295.0433;Inherit;False;Property;_Color1;Color1;8;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.9716981,0.5546013,0.640255,0.7294118;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-3156.389,-141.4175;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;13;315.9114,2201.158;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;99;-2367.675,-323.8207;Inherit;False;Property;_Color2;Color2;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.972549,0.5058824,0.6039216,0.8509804;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;113;-2352.67,-436.0776;Inherit;False;111;MainTexB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;138;-1411.664,-480.9131;Inherit;False;872.2663;610.2704;Comment;6;139;15;133;122;145;146;EdgeColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-2817.013,-139.64;Inherit;False;Color1A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;581.2706,2193.33;Inherit;True;Edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-2064.302,-134.252;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;294.5461,-10.8902;Inherit;False;111;MainTexB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-3156.415,-386.4694;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-2811.018,-399.1817;Inherit;True;Color1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;413.0911,-162.3883;Inherit;False;142;Color1A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-1352.776,-135.1099;Inherit;False;120;Edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1817.411,-129.4986;Inherit;False;Color2A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;185;-706.8738,-1476.696;Inherit;False;826.1543;280;Comment;3;181;180;182;RampColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;15;-1361.664,-430.9131;Inherit;False;Property;_EdgeColor;EdgeColor;10;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;2.996078,2.996078,2.996078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;150;467.4542,-10.64582;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;272.7862,-548.1828;Inherit;False;111;MainTexB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-2062.568,-428.4304;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;782.9521,311.0401;Inherit;False;79;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-1817.503,-421.9575;Inherit;False;Color2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;103;463.3751,-542.63;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;441.0478,-643.8181;Inherit;False;128;Color1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;674.1854,-103.1917;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;643.8691,127.5484;Inherit;False;144;Color2A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-1051.979,-144.7807;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;181;-656.8738,-1418.607;Inherit;False;0;180;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;132;656.9052,-400.0424;Inherit;False;131;Color2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;811.7171,-239.8101;Inherit;False;120;Edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;652.4977,-635.2971;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;155;1001.21,314.7343;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-862.9329,-146.3607;Inherit;False;EdgeA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;119;1982.438,-799.1333;Inherit;False;683.5728;267.8302;Comment;4;24;116;115;29;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;163;-1063.083,1145.654;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;180;-445.1589,-1426.696;Inherit;True;Property;_RampTex;RampTex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;151;963.1584,75.5647;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;1177.403,492.5866;Inherit;False;146;EdgeA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;136;1008.306,-238.2573;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;-104.7194,-1425.867;Inherit;False;RampColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;1218.197,250.3524;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;950.818,-488.8759;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;24;2032.438,-744.8078;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-695.8948,1139.987;Inherit;True;Dissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1048.626,-372.879;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;2222.527,-647.3031;Inherit;False;VertexA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;1199.012,-290.8337;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;1207.225,-68.07504;Inherit;False;182;RampColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;1470.506,473.048;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;2236.974,-749.1333;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;1472.84,710.2968;Inherit;True;123;Dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-873.8126,-373.9617;Inherit;False;EdgeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;1352.984,-2.095951;Inherit;False;139;EdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;1454.239,-232.9046;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;2442.011,-746.8985;Inherit;False;VertexRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;1738.068,529.1409;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;1686.433,222.6146;Inherit;True;116;VertexA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;2043.968,442.3288;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;1614.504,-150.5788;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;1627.475,95.02206;Inherit;False;115;VertexRGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;43;3300.106,-1901.184;Inherit;False;448;277.753;Enum;2;45;44;Enum;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;45;3353.586,-1851.185;Inherit;False;Property;_CullMode;CullMode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;1753.62,718.7125;Inherit;False;176;SoftParticle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1901.543,-110.6644;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;165;2306.651,442.7209;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;667.7177,-1705.793;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;3350.106,-1753.431;Inherit;False;Property;_ZTestMode;ZTestMode;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2819.717,-108.9045;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Fx/Water;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;True;44;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;45;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;85;0;83;1
WireConnection;85;1;83;2
WireConnection;86;0;83;3
WireConnection;87;0;84;0
WireConnection;87;2;85;0
WireConnection;87;1;86;0
WireConnection;90;1;87;0
WireConnection;92;0;90;1
WireConnection;92;1;88;0
WireConnection;93;1;91;0
WireConnection;93;0;92;0
WireConnection;94;0;93;0
WireConnection;50;0;49;3
WireConnection;51;0;49;1
WireConnection;51;1;49;2
WireConnection;53;0;52;0
WireConnection;53;2;51;0
WireConnection;53;1;50;0
WireConnection;172;0;171;0
WireConnection;95;0;53;0
WireConnection;95;1;96;0
WireConnection;33;0;32;4
WireConnection;38;1;37;0
WireConnection;38;0;36;4
WireConnection;34;0;32;3
WireConnection;2;1;95;0
WireConnection;39;0;38;0
WireConnection;174;1;173;0
WireConnection;174;0;172;0
WireConnection;70;0;71;0
WireConnection;70;1;72;0
WireConnection;175;0;174;0
WireConnection;65;0;64;3
WireConnection;21;0;2;1
WireConnection;67;0;64;1
WireConnection;67;1;64;2
WireConnection;176;0;175;0
WireConnection;167;0;166;1
WireConnection;59;0;57;0
WireConnection;59;1;70;0
WireConnection;5;0;47;0
WireConnection;22;0;2;1
WireConnection;22;1;21;0
WireConnection;22;2;48;0
WireConnection;60;0;58;0
WireConnection;68;0;66;0
WireConnection;68;2;67;0
WireConnection;68;1;65;0
WireConnection;3;0;22;0
WireConnection;3;1;5;0
WireConnection;69;1;68;0
WireConnection;69;0;59;0
WireConnection;41;1;11;0
WireConnection;41;0;36;3
WireConnection;62;0;60;0
WireConnection;42;0;41;0
WireConnection;63;0;69;0
WireConnection;63;1;61;0
WireConnection;63;2;62;0
WireConnection;169;0;3;0
WireConnection;169;1;168;0
WireConnection;169;2;179;0
WireConnection;8;0;9;0
WireConnection;8;1;169;0
WireConnection;104;0;63;0
WireConnection;104;1;98;0
WireConnection;1;1;104;0
WireConnection;10;0;8;0
WireConnection;10;1;109;0
WireConnection;162;0;7;0
WireConnection;54;0;1;2
WireConnection;161;0;10;0
WireConnection;161;1;162;0
WireConnection;161;2;7;0
WireConnection;79;0;1;1
WireConnection;164;0;161;0
WireConnection;76;0;164;0
WireConnection;76;1;74;0
WireConnection;111;0;1;3
WireConnection;81;0;76;0
WireConnection;81;1;80;0
WireConnection;141;0;110;0
WireConnection;141;1;19;4
WireConnection;13;0;81;0
WireConnection;142;0;141;0
WireConnection;120;0;13;0
WireConnection;143;0;113;0
WireConnection;143;1;99;4
WireConnection;20;0;110;0
WireConnection;20;1;19;0
WireConnection;128;0;20;0
WireConnection;144;0;143;0
WireConnection;150;0;159;0
WireConnection;100;0;113;0
WireConnection;100;1;99;0
WireConnection;131;0;100;0
WireConnection;103;0;112;0
WireConnection;148;0;147;0
WireConnection;148;1;150;0
WireConnection;145;0;15;4
WireConnection;145;1;122;0
WireConnection;102;0;129;0
WireConnection;102;1;103;0
WireConnection;155;0;160;0
WireConnection;146;0;145;0
WireConnection;163;1;169;0
WireConnection;180;1;181;0
WireConnection;151;0;148;0
WireConnection;151;1;149;0
WireConnection;136;0;137;0
WireConnection;182;0;180;0
WireConnection;153;0;151;0
WireConnection;153;1;155;0
WireConnection;101;0;102;0
WireConnection;101;1;132;0
WireConnection;123;0;163;0
WireConnection;133;0;15;0
WireConnection;133;1;122;0
WireConnection;116;0;24;4
WireConnection;135;0;101;0
WireConnection;135;1;136;0
WireConnection;156;0;153;0
WireConnection;156;1;154;0
WireConnection;29;0;24;0
WireConnection;139;0;133;0
WireConnection;184;0;135;0
WireConnection;184;1;183;0
WireConnection;115;0;29;0
WireConnection;158;0;156;0
WireConnection;158;1;124;0
WireConnection;30;0;117;0
WireConnection;30;1;158;0
WireConnection;134;0;184;0
WireConnection;134;1;140;0
WireConnection;25;0;134;0
WireConnection;25;1;118;0
WireConnection;165;0;30;0
WireConnection;0;2;25;0
WireConnection;0;9;165;0
ASEEND*/
//CHKSM=C843F2B5B949309251740B2582EEC95BA188E774