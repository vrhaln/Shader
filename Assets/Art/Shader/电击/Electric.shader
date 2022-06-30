// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Particle/Flow"
{
	Properties
	{
		[Toggle(_WCONTROLMASKTEXOFFSET_ON)] _WControlMaskTexOffset("WControlMaskTexOffset", Float) = 0
		[Toggle(_TCONTROLMAINTEXOFFSET_ON)] _TControlMainTexOffset("TControlMainTexOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskRange("MaskRange", Range( 0 , 1)) = 0
		_MaskOffset("MaskOffset", Vector) = (0,0,0,0)
		_MainTexOffset("MainTexOffset", Vector) = (0,0,0,0)
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_DisturbTexPanner("DisturbTexPanner", Vector) = (0,0,1,0)
		_MainDisturbMul("MainDisturbMul", Range( 0 , 1)) = 0.2
		_MaskDisturbMul("MaskDisturbMul", Range( 0 , 1)) = 0.2
		_Soft("Soft", Range( 0.51 , 1)) = 0.51
		[Enum(UnityEngine.Rendering.CompareFunction)]_Ztest("Ztest", Float) = 4
		_VertexOffset("VertexOffset", Float) = 1
		_Mask2("Mask2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		ZTest [_Ztest]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _WCONTROLMASKTEXOFFSET_ON
		#pragma shader_feature_local _TCONTROLMAINTEXOFFSET_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
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

		uniform float _Ztest;
		uniform sampler2D _MaskTex;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbTexPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _MaskDisturbMul;
		uniform float4 _MaskTex_ST;
		uniform float2 _MaskOffset;
		uniform sampler2D _Mask2;
		uniform float4 _Mask2_ST;
		uniform float _VertexOffset;
		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform float2 _MainTexOffset;
		uniform float _MainDisturbMul;
		uniform float _Soft;
		uniform float _MaskRange;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime5 = _Time.y * _DisturbTexPanner.z;
			float2 appendResult7 = (float2(_DisturbTexPanner.x , _DisturbTexPanner.y));
			float4 uvs_DisturbTex = v.texcoord;
			uvs_DisturbTex.xy = v.texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uvs_DisturbTex.xy);
			float Disturb52 = tex2Dlod( _DisturbTex, float4( panner2, 0, 0.0) ).r;
			float4 uvs_MaskTex = v.texcoord;
			uvs_MaskTex.xy = v.texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float UV1_W47 = v.texcoord.z;
			#ifdef _WCONTROLMASKTEXOFFSET_ON
				float2 staticSwitch66 = ( uvs_MaskTex.xy + ( _MaskOffset * UV1_W47 ) );
			#else
				float2 staticSwitch66 = uvs_MaskTex.xy;
			#endif
			float2 uv_Mask2 = v.texcoord * _Mask2_ST.xy + _Mask2_ST.zw;
			float temp_output_44_0 = ( tex2Dlod( _MaskTex, float4( ( ( Disturb52 * _MaskDisturbMul ) + staticSwitch66 ), 0, 0.0) ).r * tex2Dlod( _Mask2, float4( uv_Mask2, 0, 0.0) ).r );
			float MaskRange71 = temp_output_44_0;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 VertexOffset56 = ( MaskRange71 * ase_vertexNormal * (0.5 + (UV1_W47 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) * _VertexOffset );
			v.vertex.xyz += VertexOffset56;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime29 = _Time.y * _MainTexPanner.z;
			float2 appendResult31 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner32 = ( mulTime29 * appendResult31 + uvs_MainTex.xy);
			float UV1_T48 = i.uv_texcoord.w;
			#ifdef _TCONTROLMAINTEXOFFSET_ON
				float2 staticSwitch62 = ( i.uv_texcoord.xy + ( _MainTexOffset * UV1_T48 ) );
			#else
				float2 staticSwitch62 = panner32;
			#endif
			float mulTime5 = _Time.y * _DisturbTexPanner.z;
			float2 appendResult7 = (float2(_DisturbTexPanner.x , _DisturbTexPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uvs_DisturbTex.xy);
			float Disturb52 = tex2D( _DisturbTex, panner2 ).r;
			float4 tex2DNode1 = tex2D( _MainTex, ( staticSwitch62 + ( Disturb52 * _MainDisturbMul ) ) );
			float smoothstepResult13 = smoothstep( ( 1.0 - _Soft ) , _Soft , tex2DNode1.r);
			float4 uvs_MaskTex = i.uv_texcoord;
			uvs_MaskTex.xy = i.uv_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float UV1_W47 = i.uv_texcoord.z;
			#ifdef _WCONTROLMASKTEXOFFSET_ON
				float2 staticSwitch66 = ( uvs_MaskTex.xy + ( _MaskOffset * UV1_W47 ) );
			#else
				float2 staticSwitch66 = uvs_MaskTex.xy;
			#endif
			float2 uv_Mask2 = i.uv_texcoord * _Mask2_ST.xy + _Mask2_ST.zw;
			float temp_output_44_0 = ( tex2D( _MaskTex, ( ( Disturb52 * _MaskDisturbMul ) + staticSwitch66 ) ).r * tex2D( _Mask2, uv_Mask2 ).r );
			c.rgb = 0;
			c.a = saturate( ( i.vertexColor.a * smoothstepResult13 * (( _MaskRange * -1.0 ) + (temp_output_44_0 - 0.0) * (1.0 - ( _MaskRange * -1.0 )) / (1.0 - 0.0)) ) );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float mulTime29 = _Time.y * _MainTexPanner.z;
			float2 appendResult31 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner32 = ( mulTime29 * appendResult31 + uvs_MainTex.xy);
			float UV1_T48 = i.uv_texcoord.w;
			#ifdef _TCONTROLMAINTEXOFFSET_ON
				float2 staticSwitch62 = ( i.uv_texcoord.xy + ( _MainTexOffset * UV1_T48 ) );
			#else
				float2 staticSwitch62 = panner32;
			#endif
			float mulTime5 = _Time.y * _DisturbTexPanner.z;
			float2 appendResult7 = (float2(_DisturbTexPanner.x , _DisturbTexPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uvs_DisturbTex.xy);
			float Disturb52 = tex2D( _DisturbTex, panner2 ).r;
			float4 tex2DNode1 = tex2D( _MainTex, ( staticSwitch62 + ( Disturb52 * _MainDisturbMul ) ) );
			o.Emission = ( _MainColor * tex2DNode1.r * i.vertexColor ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
163;368;1427;651;2776.104;606.3503;2.69688;True;True
Node;AmplifyShaderEditor.CommentaryNode;51;-3974.719,-81.41709;Inherit;False;1322.543;444.4728;Comment;7;52;20;2;5;3;7;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;4;-3924.719,113.8318;Inherit;False;Property;_DisturbTexPanner;DisturbTexPanner;11;0;Create;True;0;0;0;False;0;False;0,0,1;0,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;46;-3514.468,1313.631;Inherit;False;762.4135;312.1938;Comment;3;47;48;37;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-3661.091,247.1843;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-3887.571,-31.41709;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;7;-3639.56,128.0008;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-3464.468,1363.631;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;2;-3416.677,92.72729;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-3044.975,1407.298;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2702.396,1140.176;Inherit;False;47;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;34;-2714.081,986.522;Inherit;False;Property;_MaskOffset;MaskOffset;7;0;Create;True;0;0;0;False;0;False;0,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;20;-3197.515,66.01826;Inherit;True;Property;_DisturbTex;DisturbTex;10;0;Create;True;0;0;0;False;0;False;-1;None;14522995895c6b446a9da1bb19051195;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-2676.829,833.0255;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-2880.277,88.77338;Inherit;False;Disturb;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2438.339,1070.963;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2550.358,635.8112;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;54;-2095.714,369.5739;Inherit;False;52;Disturb;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-3044.975,1482.298;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2197.415,466.1328;Inherit;False;Property;_MaskDisturbMul;MaskDisturbMul;13;0;Create;True;0;0;0;False;0;False;0.2;0.34;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2219.547,917.7072;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;66;-1987.921,744.8402;Inherit;False;Property;_WControlMaskTexOffset;WControlMaskTexOffset;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;64;-2746.316,-362.9124;Inherit;False;Property;_MainTexOffset;MainTexOffset;8;0;Create;True;0;0;0;False;0;False;0,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;33;-2932.827,-804.4203;Inherit;False;Property;_MainTexPanner;MainTexPanner;4;0;Create;True;0;0;0;False;0;False;0,0,1;0,-2,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2748.631,-227.2584;Inherit;False;48;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1839.593,393.5536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-2589.833,-525.6829;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;29;-2669.198,-671.0681;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2484.573,-296.4717;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;-2647.667,-790.2512;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1547.356,545.4576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-2767.155,-1005.371;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1391.364,510.7933;Inherit;True;Property;_MaskTex;MaskTex;5;0;Create;True;0;0;0;False;0;False;-1;None;fb59b05cf31b1b5458789f199763496f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-1390.197,759.6858;Inherit;True;Property;_Mask2;Mask2;17;0;Create;True;0;0;0;False;0;False;-1;None;fb68460c2fb4b0b48bea41776f2f3622;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-2279.133,-467.1829;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;32;-2389.156,-813.8141;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2163.224,-12.99269;Inherit;False;Property;_MainDisturbMul;MainDisturbMul;12;0;Create;True;0;0;0;False;0;False;0.2;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-2065.757,-96.54351;Inherit;False;52;Disturb;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-937.8578,550.1326;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-1334.417,1305.206;Inherit;False;1276.799;729.5629;Comment;7;56;39;42;40;41;50;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;62;-2064.202,-585.101;Inherit;False;Property;_TControlMainTexOffset;TControlMainTexOffset;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1844.963,-76.69322;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-1225.375,1691.44;Inherit;False;47;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1055.115,815.6807;Inherit;False;Property;_MaskRange;MaskRange;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1526.693,-91.80225;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-681.0475,452.6828;Inherit;False;MaskRange;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-972.8513,900.0696;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1217.855,220.032;Inherit;False;Property;_Soft;Soft;14;0;Create;True;0;0;0;False;0;False;0.51;0.51;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-1003.688,1408.461;Inherit;False;71;MaskRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1024.342,1891.584;Inherit;False;Property;_VertexOffset;VertexOffset;16;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1188.201,-92.81776;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;None;7c661b189605d9646a2d6f8d081b46e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;15;-833.7699,189.3638;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;42;-1039.128,1696.62;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-754.0792,867.4045;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;40;-1038.662,1540.879;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;27;-452.1977,550.2849;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;10;-407.3562,20.03379;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-582.0764,166.861;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-639.4206,1638.773;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-455.7221,1629.922;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;8;-492.0994,-219.2477;Inherit;False;Property;_MainColor;MainColor;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;32.64645,32.64645,32.64645,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-27.42097,138.0316;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-3862.199,-778.7272;Inherit;False;214;166;Enum;1;38;Enum;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-3812.199,-728.7272;Inherit;False;Property;_Ztest;Ztest;15;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;295.0619,277.4228;Inherit;False;56;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;26;316.3184,128.4889;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-16.00006,-49.70454;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;653.9283,-77.80714;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Particle/Flow;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;True;38;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;3
WireConnection;7;0;4;1
WireConnection;7;1;4;2
WireConnection;2;0;3;0
WireConnection;2;2;7;0
WireConnection;2;1;5;0
WireConnection;47;0;37;3
WireConnection;20;1;2;0
WireConnection;52;0;20;1
WireConnection;35;0;34;0
WireConnection;35;1;49;0
WireConnection;48;0;37;4
WireConnection;68;0;67;0
WireConnection;68;1;35;0
WireConnection;66;1;17;0
WireConnection;66;0;68;0
WireConnection;25;0;54;0
WireConnection;25;1;24;0
WireConnection;29;0;33;3
WireConnection;65;0;64;0
WireConnection;65;1;63;0
WireConnection;31;0;33;1
WireConnection;31;1;33;2
WireConnection;19;0;25;0
WireConnection;19;1;66;0
WireConnection;12;1;19;0
WireConnection;70;0;69;0
WireConnection;70;1;65;0
WireConnection;32;0;16;0
WireConnection;32;2;31;0
WireConnection;32;1;29;0
WireConnection;44;0;12;1
WireConnection;44;1;43;1
WireConnection;62;1;32;0
WireConnection;62;0;70;0
WireConnection;21;0;53;0
WireConnection;21;1;22;0
WireConnection;18;0;62;0
WireConnection;18;1;21;0
WireConnection;71;0;44;0
WireConnection;1;1;18;0
WireConnection;15;0;14;0
WireConnection;42;0;50;0
WireConnection;59;0;28;0
WireConnection;59;1;60;0
WireConnection;27;0;44;0
WireConnection;27;3;59;0
WireConnection;13;0;1;1
WireConnection;13;1;15;0
WireConnection;13;2;14;0
WireConnection;39;0;72;0
WireConnection;39;1;40;0
WireConnection;39;2;42;0
WireConnection;39;3;41;0
WireConnection;56;0;39;0
WireConnection;11;0;10;4
WireConnection;11;1;13;0
WireConnection;11;2;27;0
WireConnection;26;0;11;0
WireConnection;9;0;8;0
WireConnection;9;1;1;1
WireConnection;9;2;10;0
WireConnection;0;2;9;0
WireConnection;0;9;26;0
WireConnection;0;11;57;0
ASEEND*/
//CHKSM=7092098F68A9529CD23CA4575CBA3D462B244C0F