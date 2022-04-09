// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/GlowAB_OP_Trail"
{
	Properties
	{
		[Toggle(_UV1_WCONTORLEMISSION_ON)] _UV1_WContorlEmission("UV1_WContorlEmission", Float) = 0
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		[Toggle(_UV2_WCONTORLOFFSET_ON)] _UV2_WContorlOffset("UV2_WContorlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (0,0,0,0)
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		_NoiseTex("NoiseTex", 2D) = "black" {}
		_NoisePanner("NoisePanner", Vector) = (0,0,1,0)
		_NoiseEmissionStr("NoiseEmissionStr", Float) = 1
		_EmissionStr("EmissionStr", Float) = 1
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		_Edge("Edge", Range( 0 , 1)) = 0.3935294
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[Toggle(_FADE_ON)] _Fade("Fade", Float) = 0
		_FadeRange("FadeRange", Float) = 1
		_FadeHardnss("FadeHardnss", Float) = 1
		_MainOpacity("MainOpacity", Range( 0 , 1)) = 1
		_DissolutionTex("DissolutionTex", 2D) = "white" {}
		_RampTex("RampTex", 2D) = "white" {}
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		_VertexNoisePanner("VertexNoisePanner", Vector) = (0,0,1,0)
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
			float4 uv_texcoord;
			float4 uv2_texcoord2;
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
		uniform float _VertexOffsetStr;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform sampler2D _RampTex;
		uniform float _Edge;
		uniform sampler2D _DissolutionTex;
		uniform float4 _DissolutionTex_ST;
		uniform float _Dissolution;
		uniform float _FadeRange;
		uniform float _FadeHardnss;
		uniform sampler2D _NoiseTex;
		uniform float3 _NoisePanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseEmissionStr;
		uniform float _MainOpacity;
		uniform float4 _MainColor;
		uniform float _EmissionStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime133 = _Time.y * _VertexNoisePanner.z;
			float2 appendResult132 = (float2(_VertexNoisePanner.x , _VertexNoisePanner.y));
			float4 uvs_VertexOffsetTex = v.texcoord;
			uvs_VertexOffsetTex.xy = v.texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
			float2 panner134 = ( mulTime133 * appendResult132 + uvs_VertexOffsetTex.xy);
			float3 ase_vertexNormal = v.normal.xyz;
			float3 objToWorld127 = mul( unity_ObjectToWorld, float4( ( ase_vertexNormal - _VerTexOffsetDir ), 1 ) ).xyz;
			float mulTime31 = _Time.y * _MainTexPanner.z;
			float2 appendResult30 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = v.texcoord;
			uvs_MainTex.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner27 = ( mulTime31 * appendResult30 + uvs_MainTex.xy);
			float2 break33 = panner27;
			#ifdef _UV2_WCONTORLOFFSET_ON
				float staticSwitch53 = v.texcoord1.z;
			#else
				float staticSwitch53 = 0.0;
			#endif
			float2 appendResult34 = (float2(break33.x , ( break33.y + staticSwitch53 )));
			float4 tex2DNode1 = tex2Dlod( _MainTex, float4( appendResult34, 0, 0.0) );
			float MainTexG69 = tex2DNode1.g;
			float3 VertexOffset120 = ( (-1.0 + (tex2Dlod( _VertexOffsetTex, float4( panner134, 0, 0.0) ).r - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * objToWorld127 * 0.01 * _VertexOffsetStr * MainTexG69 );
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
			float4 tex2DNode1 = tex2D( _MainTex, appendResult34 );
			float MainTexR68 = tex2DNode1.r;
			float2 uv_DissolutionTex = i.uv_texcoord * _DissolutionTex_ST.xy + _DissolutionTex_ST.zw;
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch23 = i.uv_texcoord.w;
			#else
				float staticSwitch23 = 1.0;
			#endif
			float UV1_T83 = staticSwitch23;
			float smoothstepResult9 = smoothstep( _Edge , 1.0 , ( ( tex2D( _DissolutionTex, uv_DissolutionTex ).r + 1.0 + ( ( _Dissolution * UV1_T83 ) * -2.0 ) ) * MainTexR68 ));
			float2 appendResult113 = (float2(smoothstepResult9 , 0.0));
			float lerpResult112 = lerp( 0.0 , MainTexR68 , ( tex2D( _RampTex, appendResult113 ).r * 5.0 ));
			#ifdef _FADE_ON
				float staticSwitch51 = saturate( ( ( ( 1.0 - i.uv_texcoord.xy.y ) - ( _FadeRange * 0.1 ) ) * _FadeHardnss ) );
			#else
				float staticSwitch51 = 1.0;
			#endif
			float VertexColorA77 = i.vertexColor.a;
			float mulTime63 = _Time.y * _NoisePanner.z;
			float2 appendResult60 = (float2(_NoisePanner.x , _NoisePanner.y));
			float4 uvs_NoiseTex = i.uv_texcoord;
			uvs_NoiseTex.xy = i.uv_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner57 = ( mulTime63 * appendResult60 + uvs_NoiseTex.xy);
			float NoiseColor91 = ( 0.0 + ( tex2D( _NoiseTex, panner57 ).r * _NoiseEmissionStr * MainTexR68 ) );
			float MainTexA139 = tex2DNode1.a;
			float FinalOpacity95 = ( saturate( ( lerpResult112 * staticSwitch51 * VertexColorA77 * NoiseColor91 * MainTexA139 ) ) * _MainOpacity );
			float4 VertexColorRGB75 = i.vertexColor;
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
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_texcoord2;
				o.customPack2.xyzw = v.texcoord1;
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
				surfIN.uv_texcoord = IN.customPack1.xyzw;
				surfIN.uv2_texcoord2 = IN.customPack2.xyzw;
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
-1874;181;1599;838;2493.895;274.4511;3.148309;True;True
Node;AmplifyShaderEditor.CommentaryNode;80;-2611.824,-1848;Inherit;False;1889.709;749.2399;MainTex;16;68;29;31;30;28;38;54;27;33;53;35;34;1;69;70;139;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;29;-2561.824,-1637.757;Inherit;False;Property;_MainTexPanner;MainTexPanner;5;0;Create;True;0;0;0;False;0;False;0,0,1;-0.5,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;31;-2313.825,-1530.757;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2310.825,-1684.757;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2508.641,-1798;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-3716.271,-1759.215;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2323.508,-1403.267;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-2138.245,-1779.019;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;93;-4029.789,-1809.215;Inherit;False;1252.226;378.732;Comment;2;23;83;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-3979.789,-1732.483;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-2392.111,-1305.76;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;23;-3334.2,-1594.982;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;33;-1967.932,-1640.536;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StaticSwitch;53;-2102.508,-1383.267;Inherit;False;Property;_UV2_WContorlOffset;UV2_WContorlOffset;2;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-1790.838,-1554.456;Inherit;False;2;2;0;FLOAT;4.53;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-3001.563,-1596.436;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-2584.765,-3.47905;Inherit;False;4018.056;1905.382;Comment;36;135;89;95;101;100;6;112;115;114;116;113;9;136;51;97;52;42;50;49;44;40;45;13;137;43;39;73;111;102;105;106;107;19;84;5;140;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2544.433,578.2538;Inherit;False;Property;_Dissolution;Dissolution;11;0;Create;True;0;0;0;False;0;False;0.15;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1587.935,-1644.986;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2487.208,825.915;Inherit;False;83;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;90;-2605.798,-951.4779;Inherit;False;1735.168;538.969;NoiseColor;10;55;71;58;59;60;63;57;65;66;67;NoiseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2156.243,678.3418;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1425.987,-1596.057;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;None;6440f74f512c3e841b9478c488bce8c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;107;-2176.889,797.0798;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-954.1152,-1705.74;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2138.821,434.3228;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;102;-2211.798,236.7034;Inherit;True;Property;_DissolutionTex;DissolutionTex;19;0;Create;True;0;0;0;False;0;False;-1;None;635482c46a80e8644b17ff47ebc23c12;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1958.461,687.5038;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;59;-2555.798,-748.4777;Inherit;False;Property;_NoisePanner;NoisePanner;7;0;Create;True;0;0;0;False;0;False;0,0,1;-0.5,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-1744.473,394.8247;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-2503.799,-901.4779;Inherit;False;0;55;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;63;-2367.798,-639.4778;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-2333.797,-733.4777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-1699.19,835.5087;Inherit;True;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2522.425,1186.21;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-2370.014,1323.716;Inherit;False;Property;_FadeRange;FadeRange;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;-2119.797,-739.4777;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-1555.854,396.5042;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1993.896,568.8615;Inherit;False;Property;_Edge;Edge;12;0;Create;True;0;0;0;False;0;False;0.3935294;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1808.486,-546.9477;Inherit;False;Property;_NoiseEmissionStr;NoiseEmissionStr;8;0;Create;True;0;0;0;False;0;False;1;1.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-2219.573,1202.957;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;-1875.699,-776.0187;Inherit;True;Property;_NoiseTex;NoiseTex;6;0;Create;True;0;0;0;False;0;False;-1;None;6b1d9a7c88f13da409d66f98ee5080ac;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1861.04,-978.3644;Inherit;False;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-1363.257,411.8041;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2190.181,1326.575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-1992.267,1231.013;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1942.292,1468.579;Inherit;False;Property;_FadeHardnss;FadeHardnss;17;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1551.403,-742.845;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-581.2078,-1838.438;Inherit;False;498.0005;281.3341;VertexColor;3;24;77;75;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1091.038,406.9398;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;130;1320.201,-1838.71;Inherit;False;Property;_VertexNoisePanner;VertexNoisePanner;22;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-1337.642,-839.8466;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;24;-531.2078,-1788.438;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1693.061,1248.169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-837.371,584.4456;Inherit;False;Constant;_Float5;Float 5;21;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-933.6345,366.406;Inherit;True;Property;_RampTex;RampTex;20;0;Create;True;0;0;0;False;0;False;-1;None;da2150fdbd9743b4a9ce23c537eeb33b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-602.1896,383.2115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-948.4038,-1384.76;Inherit;False;MainTexA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-1106.613,-838.7679;Inherit;False;NoiseColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;1372.2,-1991.71;Inherit;False;0;117;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-312.5325,-1673.104;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;-1494.003,1301.172;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;132;1542.202,-1823.71;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1471.591,1211.447;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;133;1508.201,-1729.71;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;-104.1731,1424.474;Inherit;False;139;MainTexA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;134;1756.202,-1829.71;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;112;-305.9862,513.8564;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-177.1653,1288.576;Inherit;False;91;NoiseColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-1254.017,1342.576;Inherit;False;77;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;119;1939.123,-1595.951;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;126;1975.402,-1430.46;Inherit;False;Property;_VerTexOffsetDir;VerTexOffsetDir;24;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;51;-1266.786,1177.691;Inherit;False;Property;_Fade;Fade;15;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;2225.706,-1543.278;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-957.1152,-1593.74;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;305.9719,971.405;Inherit;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;117;2177.249,-1831.658;Inherit;True;Property;_VertexOffsetTex;VertexOffsetTex;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;21;-3344.676,-1753.314;Inherit;False;Property;_UV1_WContorlEmission;UV1_WContorlEmission;0;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;2510.472,-1058.779;Inherit;False;69;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;650.6733,646.3845;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;471.1272,909.9553;Inherit;False;Property;_MainOpacity;MainOpacity;18;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;2528.077,-1264.281;Inherit;False;Constant;_Float6;Float 6;22;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;129;2548.122,-1783.346;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;127;2408.102,-1554.36;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;123;2497.077,-1153.281;Inherit;False;Property;_VertexOffsetStr;VertexOffsetStr;23;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;805.356,647.6406;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;2836.218,-1618.776;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-314.2073,-1779.532;Inherit;False;VertexColorRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3007.872,-1754.657;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-117.8856,-118.4885;Inherit;False;82;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-131.5659,-513.3314;Inherit;False;Property;_EmissionStr;EmissionStr;9;0;Create;True;0;0;0;False;0;False;1;2.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;3092.218,-1623.776;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;1069.842,638.191;Inherit;False;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-174.3261,-700.9083;Inherit;False;Property;_MainColor;MainColor;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;78;-332.0121,-404.8661;Inherit;False;75;VertexColorRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-131.1754,-316.1346;Inherit;False;91;NoiseColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-3975.268,-1241.273;Inherit;False;Property;_ZTestMode;ZTestMode;14;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;208.0686,-777.6067;Inherit;True;95;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-1508.705,573.2528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3971.789,-1339.027;Inherit;False;Property;_CullMode;CullMode;13;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;720.668,-405.3606;Inherit;False;120;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-946.1152,-1497.74;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;208.4223,-525.0251;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;3149.925,-1429.454;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;994.5419,-830.6514;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/GlowAB_OP_Trail;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;True;37;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;10;-1;-1;-1;0;False;0;0;True;36;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;46;-4025.268,-1389.026;Inherit;False;235;263.753;Comment;0;;1,1,1,1;0;0
WireConnection;31;0;29;3
WireConnection;30;0;29;1
WireConnection;30;1;29;2
WireConnection;27;0;28;0
WireConnection;27;2;30;0
WireConnection;27;1;31;0
WireConnection;23;1;22;0
WireConnection;23;0;20;4
WireConnection;33;0;27;0
WireConnection;53;1;54;0
WireConnection;53;0;38;3
WireConnection;35;0;33;1
WireConnection;35;1;53;0
WireConnection;83;0;23;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;19;0;5;0
WireConnection;19;1;84;0
WireConnection;1;1;34;0
WireConnection;68;0;1;1
WireConnection;106;0;19;0
WireConnection;106;1;107;0
WireConnection;111;0;102;1
WireConnection;111;1;105;0
WireConnection;111;2;106;0
WireConnection;63;0;59;3
WireConnection;60;0;59;1
WireConnection;60;1;59;2
WireConnection;57;0;58;0
WireConnection;57;2;60;0
WireConnection;57;1;63;0
WireConnection;137;0;111;0
WireConnection;137;1;73;0
WireConnection;40;0;39;2
WireConnection;55;1;57;0
WireConnection;9;0;137;0
WireConnection;9;1;13;0
WireConnection;45;0;43;0
WireConnection;44;0;40;0
WireConnection;44;1;45;0
WireConnection;66;0;55;1
WireConnection;66;1;67;0
WireConnection;66;2;71;0
WireConnection;113;0;9;0
WireConnection;65;1;66;0
WireConnection;50;0;44;0
WireConnection;50;1;49;0
WireConnection;114;1;113;0
WireConnection;115;0;114;1
WireConnection;115;1;116;0
WireConnection;139;0;1;4
WireConnection;91;0;65;0
WireConnection;77;0;24;4
WireConnection;42;0;50;0
WireConnection;132;0;130;1
WireConnection;132;1;130;2
WireConnection;133;0;130;3
WireConnection;134;0;131;0
WireConnection;134;2;132;0
WireConnection;134;1;133;0
WireConnection;112;1;73;0
WireConnection;112;2;115;0
WireConnection;51;1;52;0
WireConnection;51;0;42;0
WireConnection;128;0;119;0
WireConnection;128;1;126;0
WireConnection;69;0;1;2
WireConnection;89;0;112;0
WireConnection;89;1;51;0
WireConnection;89;2;97;0
WireConnection;89;3;135;0
WireConnection;89;4;140;0
WireConnection;117;1;134;0
WireConnection;21;1;22;0
WireConnection;21;0;20;3
WireConnection;6;0;89;0
WireConnection;129;0;117;1
WireConnection;127;0;128;0
WireConnection;101;0;6;0
WireConnection;101;1;100;0
WireConnection;118;0;129;0
WireConnection;118;1;127;0
WireConnection;118;2;122;0
WireConnection;118;3;123;0
WireConnection;118;4;125;0
WireConnection;75;0;24;0
WireConnection;82;0;21;0
WireConnection;120;0;118;0
WireConnection;95;0;101;0
WireConnection;136;1;73;0
WireConnection;70;0;1;3
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;15;2;78;0
WireConnection;15;3;92;0
WireConnection;15;4;85;0
WireConnection;0;9;96;0
WireConnection;0;13;15;0
WireConnection;0;11;124;0
ASEEND*/
//CHKSM=04D9DAFDC35641EB739BB661AE4CA6F5DD20702F