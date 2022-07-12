// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Fx/AB_FLow"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[Toggle(_UV2CONTROLOFFSET_ON)] _UV2ControlOffset("UV2ControlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_Rotater("Rotater", Range( 0 , 360)) = 0
		[HDR]_MainColor("MainColor", Color) = (0,0,0,0)
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		_RampTex("RampTex", 2D) = "white" {}
		_FadeTex("FadeTex", 2D) = "white" {}
		[Toggle(_DISSOLUTIONON_ON)] _DissolutionOn("DissolutionOn", Float) = 0
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		_DissolutionTex("DissolutionTex", 2D) = "white" {}
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		_DissolutionSoft("DissolutionSoft", Range( 0.51 , 1)) = 0.3935294
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		[Toggle(_DISTURBON_ON)] _DisturbOn("DisturbOn", Float) = 0
		[Toggle(_UV3_XCONTORLDISTURB_ON)] _UV3_XContorlDisturb("UV3_XContorlDisturb", Float) = 0
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_DisturbPanner("DisturbPanner", Vector) = (0,0,1,0)
		_DisturbStr("DisturbStr", Float) = 0
		[Toggle(_VERTEXOFFSETON_ON)] _VertexOffsetOn("VertexOffsetOn", Float) = 0
		[Toggle(_UV1_WCONTORLVTOFFSET_ON)] _UV1_WContorlVtOffset("UV1_WContorlVtOffset", Float) = 0
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		_VertexOffsetTexPanner("VertexOffsetTexPanner", Vector) = (0,0,1,0)
		_VertexOffsetStr("VertexOffsetStr", Float) = 1
		[Toggle(_SOFTPARTICLE_ON)] _SoftParticle("SoftParticle", Float) = 0
		_FadeRange("FadeRange", Float) = 1
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
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
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _VERTEXOFFSETON_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma shader_feature_local _DISSOLUTIONON_ON
		#pragma shader_feature_local _UV2CONTROLOFFSET_ON
		#pragma shader_feature_local _DISTURBON_ON
		#pragma shader_feature_local _UV3_XCONTORLDISTURB_ON
		#pragma shader_feature_local _SOFTPARTICLE_ON
		#pragma shader_feature_local _UV1_WCONTORLVTOFFSET_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 uv2_texcoord2;
			float2 uv3_texcoord3;
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
		uniform sampler2D _VertexOffsetTex;
		uniform float3 _VertexOffsetTexPanner;
		uniform float4 _VertexOffsetTex_ST;
		uniform float _VertexOffsetStr;
		uniform float _Dissolution;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform float _Rotater;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _DisturbStr;
		uniform float _DissolutionSoft;
		uniform sampler2D _DissolutionTex;
		uniform float3 _DissolutionTexPanner;
		uniform float4 _DissolutionTex_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FadeRange;
		uniform sampler2D _FadeTex;
		uniform float4 _FadeTex_ST;
		uniform float4 _MainColor;
		uniform sampler2D _RampTex;
		uniform float4 _RampTex_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 temp_cast_0 = (0.0).xxx;
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
			float UV1_T83 = staticSwitch23;
			#ifdef _VERTEXOFFSETON_ON
				float3 staticSwitch191 = ( tex2Dlod( _VertexOffsetTex, float4( panner131, 0, 0.0) ).r * ase_vertexNormal * 0.1 * _VertexOffsetStr * ( 1.0 - UV1_T83 ) );
			#else
				float3 staticSwitch191 = temp_cast_0;
			#endif
			float3 VertexOffset137 = staticSwitch191;
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
			float UV2_W152 = i.uv2_texcoord2.z;
			float UV2_T160 = i.uv2_texcoord2.w;
			float2 appendResult157 = (float2(UV2_W152 , UV2_T160));
			#ifdef _UV2CONTROLOFFSET_ON
				float2 staticSwitch154 = ( uvs_MainTex.xy + appendResult157 );
			#else
				float2 staticSwitch154 = panner27;
			#endif
			float2 temp_cast_0 = (0.5).xx;
			float cos193 = cos( ( (0.0 + (_Rotater - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float sin193 = sin( ( (0.0 + (_Rotater - 0.0) * (2.0 - 0.0) / (360.0 - 0.0)) * UNITY_PI ) );
			float2 rotator193 = mul( staticSwitch154 - temp_cast_0 , float2x2( cos193 , -sin193 , sin193 , cos193 )) + temp_cast_0;
			float mulTime173 = _Time.y * _DisturbPanner.z;
			float2 appendResult174 = (float2(_DisturbPanner.x , _DisturbPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner175 = ( mulTime173 * appendResult174 + uvs_DisturbTex.xy);
			#ifdef _UV3_XCONTORLDISTURB_ON
				float staticSwitch205 = i.uv3_texcoord3.x;
			#else
				float staticSwitch205 = 1.0;
			#endif
			float UV3_X200 = staticSwitch205;
			#ifdef _DISTURBON_ON
				float staticSwitch179 = ( tex2D( _DisturbTex, panner175 ).r * _DisturbStr * UV3_X200 );
			#else
				float staticSwitch179 = 0.0;
			#endif
			float DisturbColor167 = staticSwitch179;
			float4 tex2DNode1 = tex2D( _MainTex, ( rotator193 + DisturbColor167 ) );
			float MainTexR68 = tex2DNode1.r;
			float mulTime122 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult121 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolutionTex = i.uv_texcoord;
			uvs_DissolutionTex.xy = i.uv_texcoord.xy * _DissolutionTex_ST.xy + _DissolutionTex_ST.zw;
			float2 panner124 = ( mulTime122 * appendResult121 + uvs_DissolutionTex.xy);
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch23 = i.uv_texcoord.w;
			#else
				float staticSwitch23 = _Dissolution;
			#endif
			float UV1_T83 = staticSwitch23;
			float smoothstepResult9 = smoothstep( ( 1.0 - _DissolutionSoft ) , _DissolutionSoft , ( tex2D( _DissolutionTex, ( DisturbColor167 + panner124 ) ).r + 1.0 + ( UV1_T83 * -2.0 ) ));
			float lerpResult112 = lerp( 0.0 , MainTexR68 , ( smoothstepResult9 * 5.0 ));
			#ifdef _DISSOLUTIONON_ON
				float staticSwitch162 = lerpResult112;
			#else
				float staticSwitch162 = MainTexR68;
			#endif
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth187 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth187 = abs( ( screenDepth187 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FadeRange ) );
			#ifdef _SOFTPARTICLE_ON
				float staticSwitch51 = distanceDepth187;
			#else
				float staticSwitch51 = 1.0;
			#endif
			float SoftParticle189 = saturate( staticSwitch51 );
			float VertexColorA77 = i.vertexColor.a;
			float2 uv_FadeTex = i.uv_texcoord * _FadeTex_ST.xy + _FadeTex_ST.zw;
			float FadeTexR142 = tex2D( _FadeTex, uv_FadeTex ).r;
			float FinalOpacity95 = saturate( ( staticSwitch162 * SoftParticle189 * VertexColorA77 * FadeTexR142 ) );
			float4 VertexColorRGB75 = i.vertexColor;
			float4 uvs_RampTex = i.uv_texcoord;
			uvs_RampTex.xy = i.uv_texcoord.xy * _RampTex_ST.xy + _RampTex_ST.zw;
			float4 MainColor91 = ( MainTexR68 * tex2D( _RampTex, uvs_RampTex.xy ) );
			#ifdef _UV1_WCONTORLVTOFFSET_ON
				float staticSwitch21 = i.uv_texcoord.z;
			#else
				float staticSwitch21 = 1.0;
			#endif
			float UV1_W82 = staticSwitch21;
			c.rgb = ( _MainColor * VertexColorRGB75 * MainColor91 * UV1_W82 ).rgb;
			c.a = saturate( FinalOpacity95 );
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
				float2 customPack3 : TEXCOORD3;
				float3 worldPos : TEXCOORD4;
				float4 screenPos : TEXCOORD5;
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
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_texcoord2;
				o.customPack2.xyzw = v.texcoord1;
				o.customPack3.xy = customInputData.uv3_texcoord3;
				o.customPack3.xy = v.texcoord2;
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
				surfIN.uv3_texcoord3 = IN.customPack3.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
369;251;1322;768;1187.944;-1139.302;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;169;-5061.914,455.8446;Inherit;False;1861.461;712.423;DisturbColor;12;167;166;171;172;173;174;175;177;178;179;180;201;DisturbColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;203;-4060.576,-533.9757;Inherit;False;1124.562;519.4683;Comment;4;200;202;205;206;UV3;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;171;-4957.69,759.1779;Inherit;False;Property;_DisturbPanner;DisturbPanner;19;0;Create;True;0;0;0;False;0;False;0,0,1;-0.5,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;202;-3994.059,-358.6486;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;206;-3956.111,-473.67;Inherit;False;Constant;_Float12;Float 12;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;174;-4706.691,712.1779;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;151;-4025.395,-1142.584;Inherit;False;1143.907;365.912;Comment;3;160;152;38;UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;205;-3694.111,-444.67;Inherit;False;Property;_UV3_XContorlDisturb;UV3_XContorlDisturb;17;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;173;-4709.691,866.1779;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;172;-4904.507,598.9349;Inherit;False;0;166;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-3374.938,-421.3047;Inherit;False;UV3_X;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-3996.365,-1078.663;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;175;-4525.01,680.3159;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-3529.321,-965.6096;Inherit;False;UV2_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;166;-4285.875,668.4697;Inherit;True;Property;_DisturbTex;DisturbTex;18;0;Create;True;0;0;0;False;0;False;-1;None;14522995895c6b446a9da1bb19051195;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;178;-4164.755,886.5152;Inherit;False;Property;_DisturbStr;DisturbStr;20;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-4183.382,998.9465;Inherit;False;200;UV3_X;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-3527.857,-1060.301;Inherit;False;UV2_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;80;-2611.824,-2316.12;Inherit;False;2488.804;796.0402;MainTex;22;70;69;68;1;170;181;193;196;154;194;159;27;195;28;30;31;158;157;161;153;29;207;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;94;-3150.239,422.7572;Inherit;False;4022.833;1852.103;Comment;36;145;98;125;147;74;103;95;6;89;97;150;162;112;163;146;73;115;9;116;111;144;13;106;102;105;107;124;84;122;123;121;120;182;183;188;190;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-2514.756,-1662.183;Inherit;False;160;UV2_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-2517.486,-1756.831;Inherit;False;152;UV2_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;-4029.789,-1809.215;Inherit;False;1252.226;378.732;Comment;7;23;83;5;82;21;22;20;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-3908.679,617.4449;Inherit;False;Constant;_0;0;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-3932.278,762.2213;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;29;-2561.824,-2105.876;Inherit;False;Property;_MainTexPanner;MainTexPanner;7;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;31;-2313.825,-1998.876;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3769.224,-1515.427;Inherit;False;Property;_Dissolution;Dissolution;13;0;Create;True;0;0;0;False;0;False;0.15;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;120;-3081.241,831.2411;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;15;0;Create;True;0;0;0;False;0;False;0,0,1;-0.5,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2508.641,-2266.12;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;195;-1939.375,-1887.204;Inherit;False;Property;_Rotater;Rotater;5;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;179;-3720.612,705.074;Inherit;False;Property;_DisturbOn;DisturbOn;16;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;157;-2283.213,-1735.265;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-3979.789,-1732.483;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;158;-2373.718,-1893.599;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2310.825,-2152.876;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-2129.145,-2184.739;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;23;-3433.2,-1587.579;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;11;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-2098.762,-1864.906;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;122;-2787.242,946.2411;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;123;-2983.059,679.998;Inherit;False;0;102;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;207;-1666.604,-1881.482;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;360;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-3429.736,706.9774;Inherit;False;DisturbColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-2784.242,792.2411;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-3056.958,-1590.79;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;154;-1954.75,-2068.359;Inherit;False;Property;_UV2ControlOffset;UV2ControlOffset;3;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PiNode;196;-1490.313,-1881.489;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-1632.339,-1982.5;Inherit;False;Constant;_Float11;Float 11;26;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;124;-2611.663,697.979;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-2686.151,545.7786;Inherit;False;167;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2574.404,1004.793;Inherit;False;83;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;188;-1272.496,1576.554;Inherit;False;1080.439;324.1655;SoftParticle;6;189;51;187;52;43;209;SoftParticle;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;-2379.151,640.7786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;193;-1378.421,-2031.266;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-2548.189,1108.655;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-1591.122,-1761.188;Inherit;False;167;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;102;-2236.871,662.9398;Inherit;True;Property;_DissolutionTex;DissolutionTex;12;0;Create;True;0;0;0;False;0;False;-1;None;4ecbbeaf0ea80f04aa5f22f67103e69c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-2269.67,1004.331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2107.969,1054.098;Inherit;False;Property;_DissolutionSoft;DissolutionSoft;14;0;Create;True;0;0;0;False;0;False;0.3935294;1;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2163.894,860.5591;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-1118.779,-2030.309;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1211.157,1764.533;Inherit;False;Property;_FadeRange;FadeRange;27;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-889.8948,-2094.755;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;-1;None;4694f6fa8cee3c34f8f59fbc20704c80;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;144;-1803.972,948.0927;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-1790.104,811.2529;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1002.545,1649.235;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;187;-1031.632,1744.719;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;164;-2593.921,2466.331;Inherit;False;2079.392;1060.927;VertexOffset;15;137;133;191;143;136;132;140;126;134;131;139;128;130;129;127;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;51;-767.8988,1656.48;Inherit;False;Property;_SoftParticle;SoftParticle;26;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-1539.37,918.7987;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-49.7229,-1838.438;Inherit;False;498.0005;281.3341;VertexColor;3;75;77;24;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1154.548,1042.3;Inherit;False;Constant;_Float5;Float 5;21;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-412.7863,-2153.076;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;165;-211.8256,2535.596;Inherit;False;736.4326;280;FadeTex;2;142;119;FadeTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;209;-535.9442,1678.302;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;127;-2543.921,2681.715;Inherit;False;Property;_VertexOffsetTexPanner;VertexOffsetTexPanner;24;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-841.5482,977.3003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;24;0.2770872,-1788.438;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;119;-161.8256,2585.596;Inherit;True;Property;_FadeTex;FadeTex;9;0;Create;True;0;0;0;False;0;False;-1;None;a1b8d8791b5ee394ca2a09a825786114;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;73;-1814.616,1173.497;Inherit;False;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-643.4948,962.9972;Inherit;False;Constant;_Float9;Float 9;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;130;-2224.027,2778.331;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;128;-2190.026,2684.331;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;-516.0894,845.3393;Inherit;False;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;189;-405.1645,1661.09;Inherit;False;SoftParticle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;112;-527.3167,1011.487;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;300.607,2611.615;Inherit;False;FadeTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;218.9524,-1673.104;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;90;-2498.941,-647.7783;Inherit;False;2227.146;782.8557;MainColor;5;148;91;71;149;184;MainColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-2360.028,2516.331;Inherit;False;0;126;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;190;-225.2671,1138.991;Inherit;False;189;SoftParticle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;162;-268.5611,959.7405;Inherit;False;Property;_DissolutionOn;DissolutionOn;10;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-1766.321,3275.139;Inherit;False;83;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-209.7535,1333.518;Inherit;False;142;FadeTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;184;-1844.389,-356.2634;Inherit;False;0;148;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;131;-1976.025,2678.331;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-237.6361,1235.806;Inherit;False;77;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3716.271,-1759.215;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-1574.728,3157.568;Inherit;False;Property;_VertexOffsetStr;VertexOffsetStr;25;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;126;-1720.243,2642.189;Inherit;True;Property;_VertexOffsetTex;VertexOffsetTex;23;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;132;-1602.728,2883.568;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;148;-1539.229,-370.248;Inherit;True;Property;_RampTex;RampTex;8;0;Create;True;0;0;0;False;0;False;-1;None;2930154a9e362c747a9cd8f860c4bcd9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;140;-1520.715,3279.832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1560.728,3050.568;Inherit;False;Constant;_Float7;Float 7;25;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;49.80009,1019.094;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1326.458,-466.7523;Inherit;False;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;21;-3420.962,-1751.425;Inherit;False;Property;_UV1_WContorlVtOffset;UV1_WContorlVtOffset;22;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-1072.11,-393.847;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1287.728,2805.568;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-1244.281,2659.539;Inherit;False;Constant;_Float2;Float 2;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;336.8301,1013.601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;536.4009,996.0136;Inherit;False;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3053.415,-1749.079;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;191;-1091.71,2724.582;Inherit;False;Property;_VertexOffsetOn;VertexOffsetOn;21;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-803.9272,-405.2676;Inherit;False;MainColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;217.2776,-1779.532;Inherit;False;VertexColorRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;192.0562,-947.6176;Inherit;True;95;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-4525.035,-1801.048;Inherit;False;448;277.753;Comment;2;36;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-154.1754,-402.1346;Inherit;False;91;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-752.0217,2733.224;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-166.3018,-501.6696;Inherit;False;75;VertexColorRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-138.8856,-299.5632;Inherit;False;82;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-174.3261,-700.9083;Inherit;False;Property;_MainColor;MainColor;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;2.996078,2.996078,2.996078,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-399.9999,-1896.37;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-1517.566,3403.544;Inherit;False;142;FadeTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-1190.724,1313.959;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1565.819,1195.544;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4471.555,-1751.049;Inherit;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-1815.854,1266.236;Inherit;False;69;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-2533.892,1221.801;Inherit;False;Constant;_Float8;Float 8;27;0;Create;True;0;0;0;False;0;False;0.57;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;208;577.9229,-729.6465;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-399.9081,-2023.446;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-2535.341,895.1389;Inherit;False;Constant;_Float10;Float 10;27;0;Create;True;0;0;0;False;0;False;0.61;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;247.5879,-592.9905;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-4475.035,-1653.295;Inherit;False;Property;_ZTestMode;ZTestMode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-2363.776,868.5873;Inherit;False;Constant;_Float6;Float 6;23;0;Create;True;0;0;0;False;0;False;0.58;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;216.2339,-150.8215;Inherit;False;137;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;832.2584,-770.3762;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Fx/AB_FLow;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;141;0;True;37;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;True;36;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;174;0;171;1
WireConnection;174;1;171;2
WireConnection;205;1;206;0
WireConnection;205;0;202;1
WireConnection;173;0;171;3
WireConnection;200;0;205;0
WireConnection;175;0;172;0
WireConnection;175;2;174;0
WireConnection;175;1;173;0
WireConnection;160;0;38;4
WireConnection;166;1;175;0
WireConnection;152;0;38;3
WireConnection;177;0;166;1
WireConnection;177;1;178;0
WireConnection;177;2;201;0
WireConnection;31;0;29;3
WireConnection;179;1;180;0
WireConnection;179;0;177;0
WireConnection;157;0;153;0
WireConnection;157;1;161;0
WireConnection;30;0;29;1
WireConnection;30;1;29;2
WireConnection;27;0;28;0
WireConnection;27;2;30;0
WireConnection;27;1;31;0
WireConnection;23;1;5;0
WireConnection;23;0;20;4
WireConnection;159;0;158;0
WireConnection;159;1;157;0
WireConnection;122;0;120;3
WireConnection;207;0;195;0
WireConnection;167;0;179;0
WireConnection;121;0;120;1
WireConnection;121;1;120;2
WireConnection;83;0;23;0
WireConnection;154;1;27;0
WireConnection;154;0;159;0
WireConnection;196;0;207;0
WireConnection;124;0;123;0
WireConnection;124;2;121;0
WireConnection;124;1;122;0
WireConnection;183;0;182;0
WireConnection;183;1;124;0
WireConnection;193;0;154;0
WireConnection;193;1;194;0
WireConnection;193;2;196;0
WireConnection;102;1;183;0
WireConnection;106;0;84;0
WireConnection;106;1;107;0
WireConnection;170;0;193;0
WireConnection;170;1;181;0
WireConnection;1;1;170;0
WireConnection;144;0;13;0
WireConnection;111;0;102;1
WireConnection;111;1;105;0
WireConnection;111;2;106;0
WireConnection;187;0;43;0
WireConnection;51;1;52;0
WireConnection;51;0;187;0
WireConnection;9;0;111;0
WireConnection;9;1;144;0
WireConnection;9;2;13;0
WireConnection;68;0;1;1
WireConnection;209;0;51;0
WireConnection;115;0;9;0
WireConnection;115;1;116;0
WireConnection;130;0;127;3
WireConnection;128;0;127;1
WireConnection;128;1;127;2
WireConnection;189;0;209;0
WireConnection;112;0;146;0
WireConnection;112;1;73;0
WireConnection;112;2;115;0
WireConnection;142;0;119;1
WireConnection;77;0;24;4
WireConnection;162;1;163;0
WireConnection;162;0;112;0
WireConnection;131;0;129;0
WireConnection;131;2;128;0
WireConnection;131;1;130;0
WireConnection;126;1;131;0
WireConnection;148;1;184;0
WireConnection;140;0;139;0
WireConnection;89;0;162;0
WireConnection;89;1;190;0
WireConnection;89;2;97;0
WireConnection;89;3;150;0
WireConnection;21;1;22;0
WireConnection;21;0;20;3
WireConnection;149;0;71;0
WireConnection;149;1;148;0
WireConnection;133;0;126;1
WireConnection;133;1;132;0
WireConnection;133;2;134;0
WireConnection;133;3;136;0
WireConnection;133;4;140;0
WireConnection;6;0;89;0
WireConnection;95;0;6;0
WireConnection;82;0;21;0
WireConnection;191;1;192;0
WireConnection;191;0;133;0
WireConnection;91;0;149;0
WireConnection;75;0;24;0
WireConnection;137;0;191;0
WireConnection;70;0;1;3
WireConnection;208;0;96;0
WireConnection;69;0;1;2
WireConnection;15;0;16;0
WireConnection;15;1;78;0
WireConnection;15;2;92;0
WireConnection;15;3;85;0
WireConnection;0;9;208;0
WireConnection;0;13;15;0
WireConnection;0;11;138;0
ASEEND*/
//CHKSM=97F543E8F7157D59C1A5B1136D07FD60C8298DB7