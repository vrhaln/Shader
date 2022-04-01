// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/FreGlowAB"
{
	Properties
	{
		_Fre("Fre", Vector) = (0,1,5,0)
		[Toggle(_ONEMINUS_ON)] _OneMinus("OneMinus", Float) = 0
		_EmissStr("EmissStr", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_DepthFadeRangeStr("DepthFadeRangeStr", Vector) = (1,0.2,0,0)
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		_Dis("Dis", Float) = 0.25
		_Hardness("Hardness", Float) = 1
		_Opacity("Opacity", Range( 0 , 1)) = 0.56
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ONEMINUS_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			float4 screenPosition35;
			float2 uv_texcoord;
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
		uniform float _Dis;
		uniform float _Hardness;
		uniform float3 _Fre;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float3 _DepthFadeRangeStr;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform float _Opacity;
		uniform float _EmissStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos35 = ase_vertex3Pos;
			float4 ase_screenPos35 = ComputeScreenPos( UnityObjectToClipPos( vertexPos35 ) );
			o.screenPosition35 = ase_screenPos35;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV27 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode27 = ( _Fre.x + _Fre.y * pow( 1.0 - fresnelNdotV27, _Fre.z ) );
			float4 ase_screenPos35 = i.screenPosition35;
			float4 ase_screenPosNorm35 = ase_screenPos35 / ase_screenPos35.w;
			ase_screenPosNorm35.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm35.z : ase_screenPosNorm35.z * 0.5 + 0.5;
			float screenDepth35 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm35.xy ));
			float distanceDepth35 = abs( ( screenDepth35 - LinearEyeDepth( ase_screenPosNorm35.z ) ) / ( _DepthFadeRangeStr.x ) );
			float temp_output_38_0 = ( fresnelNode27 + ( saturate( ( 1.0 - distanceDepth35 ) ) * _DepthFadeRangeStr.y ) );
			#ifdef _ONEMINUS_ON
				float staticSwitch47 = ( 1.0 - temp_output_38_0 );
			#else
				float staticSwitch47 = temp_output_38_0;
			#endif
			float mulTime51 = _Time.y * _MainTexPanner.z;
			float2 appendResult52 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner54 = ( mulTime51 * appendResult52 + uv_MainTex);
			float2 break55 = panner54;
			float2 appendResult56 = (float2(break55.x , break55.y));
			float smoothstepResult62 = smoothstep( _Dis , ( _Dis + 0.01 + _Hardness ) , ( staticSwitch47 * tex2D( _MainTex, appendResult56 ).r ));
			float temp_output_31_0 = saturate( smoothstepResult62 );
			float lerpResult44 = lerp( temp_output_31_0 , 1.0 , _Opacity);
			c.rgb = ( i.vertexColor * temp_output_31_0 * _EmissStr ).rgb;
			c.a = ( i.vertexColor.a * lerpResult44 );
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
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
-4;259;1906;1021;4619.555;506.3333;3.978822;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;36;-1927.363,409.794;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;42;-1970.761,579.3863;Inherit;False;Property;_DepthFadeRangeStr;DepthFadeRangeStr;5;0;Create;True;0;0;0;False;0;False;1,0.2,0;2,0.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DepthFade;35;-1735.086,528.2829;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;50;-1824.854,1207.457;Inherit;False;Property;_MainTexPanner;MainTexPanner;6;0;Create;True;0;0;0;False;0;False;0,0,1;-1,-1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;39;-1473.902,518.8364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;29;-1376.651,254.8698;Inherit;False;Property;_Fre;Fre;1;0;Create;True;0;0;0;False;0;False;0,1,5;0,60,1.4;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-1771.67,1047.212;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;51;-1576.855,1314.456;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-1573.855,1160.457;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;40;-1281.022,527.3292;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;27;-1178.361,221.7765;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;54;-1383.274,1060.193;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1115.57,599.315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-755.4568,222.2478;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;55;-1154.261,1056.476;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;56;-870.4978,1056.271;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;48;-349.2424,321.6757;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;6.030945,570.2145;Inherit;False;Property;_Hardness;Hardness;8;0;Create;True;0;0;0;False;0;False;1;3.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-672.213,1031.293;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;-1;None;b10a457d0ceff6f43b4172111e3aad9a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;47;-62.90527,215.2595;Inherit;False;Property;_OneMinus;OneMinus;2;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;36.99316,500.4163;Inherit;False;Constant;_1;1;10;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;88.99316,409.4163;Inherit;False;Property;_Dis;Dis;7;0;Create;True;0;0;0;False;0;False;0.25;-1.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;250.534,278.1837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;291.9932,476.4163;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;62;423.9932,322.4163;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;532.0533,664.8182;Inherit;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;0;False;0;False;0.56;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;650.6029,518.1494;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;603.7791,269.3752;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;519.1978,68.88568;Inherit;False;Property;_EmissStr;EmissStr;3;0;Create;True;0;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-1699.63,-504.3889;Inherit;False;235;268.8913;Comment;2;43;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;44;974.701,429.0896;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;24;527.5236,-120.3028;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-1678.63,-454.3889;Inherit;False;Property;_ZTestMode;ZTestMode;11;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;1304.305,334.1561;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1030.692,-68.59571;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;142.7316,665.1422;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1676.967,-356.4976;Inherit;False;Property;_CullMode;CullMode;10;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1874.5,-101.7822;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/FreGlowAB;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;1;36;0
WireConnection;35;0;42;1
WireConnection;39;0;35;0
WireConnection;51;0;50;3
WireConnection;52;0;50;1
WireConnection;52;1;50;2
WireConnection;40;0;39;0
WireConnection;27;1;29;1
WireConnection;27;2;29;2
WireConnection;27;3;29;3
WireConnection;54;0;53;0
WireConnection;54;2;52;0
WireConnection;54;1;51;0
WireConnection;41;0;40;0
WireConnection;41;1;42;2
WireConnection;38;0;27;0
WireConnection;38;1;41;0
WireConnection;55;0;54;0
WireConnection;56;0;55;0
WireConnection;56;1;55;1
WireConnection;48;0;38;0
WireConnection;57;1;56;0
WireConnection;47;1;38;0
WireConnection;47;0;48;0
WireConnection;61;0;47;0
WireConnection;61;1;57;1
WireConnection;64;0;63;0
WireConnection;64;1;65;0
WireConnection;64;2;66;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;62;2;64;0
WireConnection;31;0;62;0
WireConnection;44;0;31;0
WireConnection;44;1;45;0
WireConnection;44;2;46;0
WireConnection;33;0;24;4
WireConnection;33;1;44;0
WireConnection;30;0;24;0
WireConnection;30;1;31;0
WireConnection;30;2;32;0
WireConnection;0;9;33;0
WireConnection;0;13;30;0
ASEEND*/
//CHKSM=C980A347D914AEEE7F319B04AA46722BD5DC36FF