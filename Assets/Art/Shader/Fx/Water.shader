// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_EdgeWidth("EdgeWidth", Range( 0 , 2)) = 0.1
		[HDR]_EdgeColor("EdgeColor", Color) = (1,1,1,1)
		[Toggle(_UV2CONTROLOFFSET_ON)] _UV2ControlOffset("UV2ControlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_Color1("Color1", Color) = (1,1,1,1)
		[HDR]_Color2("Color2", Color) = (1,1,1,1)
		_Rotater("Rotater", Range( 0 , 360)) = 0
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		_DissolveTex("DissolveTex", 2D) = "white" {}
		_OneMinus("OneMinus", Range( 0 , 1)) = 0
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		[Toggle(_DISTURBON_ON)] _DisturbOn("DisturbOn", Float) = 0
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_DisturbPanner("DisturbPanner", Vector) = (0,0,1,0)
		_DisturbStr("DisturbStr", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		#pragma target 3.0
		#pragma shader_feature_local _UV2CONTROLOFFSET_ON
		#pragma shader_feature_local _DISTURBON_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
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

		uniform float _CullMode;
		uniform float _ZTestMode;
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
		uniform float4 _EdgeColor;
		uniform sampler2D _DissolveTex;
		uniform float3 _DissolutionTexPanner;
		uniform float4 _DissolveTex_ST;
		uniform float _OneMinus;
		uniform float _Dissolution;
		uniform float _EdgeWidth;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime50 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult51 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolveTex = i.uv_texcoord;
			uvs_DissolveTex.xy = i.uv_texcoord.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			float2 panner53 = ( mulTime50 * appendResult51 + uvs_DissolveTex.xy);
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
			float4 tex2DNode2 = tex2D( _DissolveTex, ( panner53 + DisturbColor94 ) );
			float lerpResult22 = lerp( tex2DNode2.r , ( 1.0 - tex2DNode2.r ) , _OneMinus);
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch38 = i.uv_texcoord.w;
			#else
				float staticSwitch38 = _Dissolution;
			#endif
			float UV1_T39 = staticSwitch38;
			float temp_output_3_0 = ( lerpResult22 - (-1.0 + (UV1_T39 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) );
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
			float4 tex2DNode1 = tex2D( _MainTex, ( rotator63 + DisturbColor94 ) );
			float MainTexA54 = tex2DNode1.g;
			float FoamMask79 = tex2DNode1.r;
			float clampResult13 = clamp( ( ( step( ( distance( 0.5 , temp_output_3_0 ) / _EdgeWidth ) , 0.5 ) * MainTexA54 ) + FoamMask79 ) , 0.0 , 1.0 );
			c.rgb = 0;
			c.a = saturate( ( i.vertexColor.a * step( 0.5 , temp_output_3_0 ) * ( MainTexA54 + clampResult13 ) ) );
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
			float temp_output_3_0 = ( lerpResult22 - (-1.0 + (UV1_T39 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) );
			float MainTexA54 = tex2DNode1.g;
			float FoamMask79 = tex2DNode1.r;
			float clampResult13 = clamp( ( ( step( ( distance( 0.5 , temp_output_3_0 ) / _EdgeWidth ) , 0.5 ) * MainTexA54 ) + FoamMask79 ) , 0.0 , 1.0 );
			float4 lerpResult16 = lerp( ( ( ( tex2DNode1.g * _Color1 ) * ( 1.0 - tex2DNode1.b ) ) + ( tex2DNode1.b * _Color2 ) ) , _EdgeColor , clampResult13);
			o.Emission = ( lerpResult16 * float4( (i.vertexColor).rgb , 0.0 ) ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
439;208;1240;1006;3989.91;1754.249;5.25316;True;True
Node;AmplifyShaderEditor.CommentaryNode;82;-3109.869,718.4437;Inherit;False;1861.461;712.423;DisturbColor;12;94;93;92;91;90;89;88;87;86;85;84;83;DisturbColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;83;-3005.645,1021.777;Inherit;False;Property;_DisturbPanner;DisturbPanner;19;0;Create;True;0;0;0;False;0;False;0,0,1;0,2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;86;-2757.646,1128.777;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-2952.461,861.5339;Inherit;False;0;90;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;85;-2754.646,974.777;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;87;-2572.964,942.915;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;90;-2333.83,931.0688;Inherit;True;Property;_DisturbTex;DisturbTex;18;0;Create;True;0;0;0;False;0;False;-1;None;91ccffe1e18c25542844cbe4789cc399;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;-2212.709,1149.114;Inherit;False;Property;_DisturbStr;DisturbStr;20;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1956.634,880.0439;Inherit;False;Constant;_0;0;32;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1980.233,1024.82;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;1510.72,-680.4518;Inherit;False;1143.907;365.912;Comment;3;34;33;32;UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;49;-1984.484,104.9461;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;14;0;Create;True;0;0;0;False;0;False;0,0,1;0,0.5,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;93;-1768.567,967.673;Inherit;False;Property;_DisturbOn;DisturbOn;17;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;1539.75,-616.5308;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1477.691,969.5765;Inherit;False;DisturbColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-1687.485,65.94608;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;35;1967.787,-1381.817;Inherit;False;1252.226;378.732;Comment;7;42;41;40;39;38;37;36;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;50;-1690.485,219.9462;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-1886.302,-46.29701;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;2006.794,-503.4775;Inherit;False;UV2_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;2008.259,-598.1688;Inherit;False;UV2_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-2086.176,-634.056;Inherit;False;33;UV2_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;64;-2118.176,-1066.056;Inherit;False;Property;_MainTexPanner;MainTexPanner;10;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;53;-1514.906,-28.316;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;2017.787,-1305.084;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;96;-1469.135,108.3636;Inherit;False;94;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;2228.352,-1088.029;Inherit;False;Property;_Dissolution;Dissolution;15;0;Create;True;0;0;0;False;0;False;0.15;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-2086.176,-730.056;Inherit;False;34;UV2_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1510.176,-858.056;Inherit;False;Property;_Rotater;Rotater;9;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-1878.176,-1114.056;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-1253.49,-4.488098;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-1862.176,-698.056;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-2070.176,-1226.056;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1942.176,-858.056;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;38;2597.376,-1180.181;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;11;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;-1878.176,-954.056;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;68;-1686.176,-1146.056;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1670.176,-826.056;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;60;-1238.176,-842.056;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;360;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;2940.618,-1163.391;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1011.85,-55.50867;Inherit;True;Property;_DissolveTex;DissolveTex;12;0;Create;True;0;0;0;False;0;False;-1;6fda4a099411a18468456111546c16ee;35858763e05da9d4a8b77560217d7992;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;69;-1510.176,-1018.056;Inherit;False;Property;_UV2ControlOffset;UV2ControlOffset;5;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PiNode;62;-1062.176,-842.056;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-783.8846,522.0375;Inherit;False;39;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-989.2101,152.5193;Inherit;False;Property;_OneMinus;OneMinus;13;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-676.7996,52.49895;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1206.176,-954.056;Inherit;False;Constant;_Float11;Float 11;26;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;5;-557.2693,526.446;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-462.9977,-5.168869;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-804.6143,-776.7439;Inherit;False;94;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;63;-791.3525,-999.4089;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-129.7099,635.3533;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-266.8028,396.7397;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-437.1754,-982.5549;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-63.30126,-965.6193;Inherit;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;0;False;0;False;-1;None;7d12bf6a5b668cf478bc06f0511527b1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;8;95.25101,597.3049;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;23.47373,893.0079;Inherit;False;Property;_EdgeWidth;EdgeWidth;3;0;Create;True;0;0;0;False;0;False;0.1;0.21;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;534.861,968.7492;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;293.1465,-855.9397;Inherit;True;MainTexA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;10;337.623,811.1266;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;558.9371,1064.448;Inherit;False;54;MainTexA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;17;686.0126,898.5374;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;291.1857,-578.4892;Inherit;True;FoamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;134.6082,-1432.791;Inherit;False;Property;_Color1;Color1;7;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.07435541,1.635527,2.251905,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;80;560.3008,1184.329;Inherit;False;79;FoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;838.1882,922.8943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;514.2913,-1463.202;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;1013.198,940.7014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;103;317.7808,-1165.442;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;99;302.3997,-1045.574;Inherit;False;Property;_Color2;Color2;8;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.6813225,2.367875,2.212749,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;646.6894,-1073.306;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;1501.966,408.0714;Inherit;False;54;MainTexA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;725.7077,-1294.186;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;13;1201.315,933.1215;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-166.649,278.4767;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;1024.028,-1147.765;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;24;1470.816,190.1121;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;6;78.14425,289.7438;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;1678.018,399.3825;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;618.2959,9.919665;Inherit;False;Property;_EdgeColor;EdgeColor;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;2.996078,2.996078,2.996078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1896.32,288.6693;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;1665.082,184.8981;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;16;1406.173,-95.55134;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;43;1367.803,-1382.123;Inherit;False;448;277.753;Comment;2;45;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-732.0873,-871.6545;Inherit;False;Constant;_Float4;Float 4;21;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;41;2576.614,-1324.026;Inherit;False;Property;_UV1_WContorlVertexOffset;UV1_WContorlVertexOffset;16;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;-246.3444,-860.0172;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;2281.305,-1331.817;Inherit;False;Constant;_Float3;Float 3;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-2231.336,1261.546;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;2944.161,-1321.681;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;1417.803,-1234.37;Inherit;False;Property;_ZTestMode;ZTestMode;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;356.775,-141.3538;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;77;2416.038,214.2058;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1946.414,-84.33561;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-418.2471,-769.2032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;1421.283,-1332.124;Inherit;False;Property;_CullMode;CullMode;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-705.7293,-678.6658;Inherit;False;Property;_Float5;Float 5;21;0;Create;True;0;0;0;False;0;False;6.63;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2629.984,-133.7851;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Water;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;True;44;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;45;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;86;0;83;3
WireConnection;85;0;83;1
WireConnection;85;1;83;2
WireConnection;87;0;84;0
WireConnection;87;2;85;0
WireConnection;87;1;86;0
WireConnection;90;1;87;0
WireConnection;92;0;90;1
WireConnection;92;1;88;0
WireConnection;93;1;91;0
WireConnection;93;0;92;0
WireConnection;94;0;93;0
WireConnection;51;0;49;1
WireConnection;51;1;49;2
WireConnection;50;0;49;3
WireConnection;33;0;32;4
WireConnection;34;0;32;3
WireConnection;53;0;52;0
WireConnection;53;2;51;0
WireConnection;53;1;50;0
WireConnection;67;0;64;1
WireConnection;67;1;64;2
WireConnection;95;0;53;0
WireConnection;95;1;96;0
WireConnection;70;0;71;0
WireConnection;70;1;72;0
WireConnection;38;1;37;0
WireConnection;38;0;36;4
WireConnection;65;0;64;3
WireConnection;68;0;66;0
WireConnection;68;2;67;0
WireConnection;68;1;65;0
WireConnection;59;0;57;0
WireConnection;59;1;70;0
WireConnection;60;0;58;0
WireConnection;39;0;38;0
WireConnection;2;1;95;0
WireConnection;69;1;68;0
WireConnection;69;0;59;0
WireConnection;62;0;60;0
WireConnection;21;0;2;1
WireConnection;5;0;47;0
WireConnection;22;0;2;1
WireConnection;22;1;21;0
WireConnection;22;2;48;0
WireConnection;63;0;69;0
WireConnection;63;1;61;0
WireConnection;63;2;62;0
WireConnection;3;0;22;0
WireConnection;3;1;5;0
WireConnection;104;0;63;0
WireConnection;104;1;98;0
WireConnection;1;1;104;0
WireConnection;8;0;9;0
WireConnection;8;1;3;0
WireConnection;54;0;1;2
WireConnection;10;0;8;0
WireConnection;10;1;11;0
WireConnection;17;0;10;0
WireConnection;17;1;18;0
WireConnection;79;0;1;1
WireConnection;76;0;17;0
WireConnection;76;1;74;0
WireConnection;20;0;1;2
WireConnection;20;1;19;0
WireConnection;81;0;76;0
WireConnection;81;1;80;0
WireConnection;103;0;1;3
WireConnection;100;0;1;3
WireConnection;100;1;99;0
WireConnection;102;0;20;0
WireConnection;102;1;103;0
WireConnection;13;0;81;0
WireConnection;101;0;102;0
WireConnection;101;1;100;0
WireConnection;6;0;7;0
WireConnection;6;1;3;0
WireConnection;73;0;55;0
WireConnection;73;1;13;0
WireConnection;30;0;24;4
WireConnection;30;1;6;0
WireConnection;30;2;73;0
WireConnection;29;0;24;0
WireConnection;16;0;101;0
WireConnection;16;1;15;0
WireConnection;16;2;13;0
WireConnection;41;1;40;0
WireConnection;41;0;36;3
WireConnection;107;1;105;0
WireConnection;42;0;41;0
WireConnection;77;0;30;0
WireConnection;25;0;16;0
WireConnection;25;1;29;0
WireConnection;0;2;25;0
WireConnection;0;9;77;0
ASEEND*/
//CHKSM=002C8388830419E245A80CD3A06717B32151664C