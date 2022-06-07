// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Particle/Elect"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_DisturbTex("DisturbTex", 2D) = "white" {}
		_MainDisturbMul("MainDisturbMul", Range( 0 , 1)) = 0.2
		_MaskDisturbMul("MaskDisturbMul", Range( 0 , 1)) = 0.2
		_Panner("Panner", Vector) = (0,0,1,0)
		_Soft("Soft", Range( 0.51 , 1)) = 0.51
		_Float0("Float 0", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
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

		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float3 _Panner;
		uniform sampler2D _DisturbTex;
		uniform float4 _DisturbTex_ST;
		uniform float _MainDisturbMul;
		uniform float _Soft;
		uniform sampler2D _Mask;
		uniform float _MaskDisturbMul;
		uniform float4 _Mask_ST;
		uniform float _Float0;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float mulTime5 = _Time.y * _Panner.z;
			float2 appendResult7 = (float2(_Panner.x , _Panner.y));
			float2 uv_DisturbTex = i.uv_texcoord * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uv_DisturbTex);
			float4 tex2DNode20 = tex2D( _DisturbTex, panner2 );
			float4 tex2DNode1 = tex2D( _MainTex, ( uv_MainTex + panner2 + ( tex2DNode20.r * _MainDisturbMul ) ) );
			float smoothstepResult13 = smoothstep( ( 1.0 - _Soft ) , _Soft , tex2DNode1.r);
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			c.rgb = 0;
			c.a = saturate( ( smoothstepResult13 * i.vertexColor.a * (_Float0 + (tex2D( _Mask, ( ( tex2DNode20.r * _MaskDisturbMul ) + uv_Mask ) ).r - 0.0) * (1.0 - _Float0) / (1.0 - 0.0)) ) );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float mulTime5 = _Time.y * _Panner.z;
			float2 appendResult7 = (float2(_Panner.x , _Panner.y));
			float2 uv_DisturbTex = i.uv_texcoord * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner2 = ( mulTime5 * appendResult7 + uv_DisturbTex);
			float4 tex2DNode20 = tex2D( _DisturbTex, panner2 );
			float4 tex2DNode1 = tex2D( _MainTex, ( uv_MainTex + panner2 + ( tex2DNode20.r * _MainDisturbMul ) ) );
			o.Emission = ( _MainColor * tex2DNode1.r * i.vertexColor ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
48;575;1403;661;3270.936;216.5989;2.086552;True;True
Node;AmplifyShaderEditor.Vector3Node;4;-3514.075,579.7834;Inherit;False;Property;_Panner;Panner;7;0;Create;True;0;0;0;False;0;False;0,0,1;0.3,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;5;-3250.447,713.1358;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-3476.927,434.5346;Inherit;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;7;-3228.916,593.9524;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;2;-3006.033,558.6789;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;20;-2508.942,21.25042;Inherit;True;Property;_DisturbTex;DisturbTex;4;0;Create;True;0;0;0;False;0;False;-1;None;59803f4ef84fcc544a64e42bc663af81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-2494.399,398.1446;Inherit;False;Property;_MaskDisturbMul;MaskDisturbMul;6;0;Create;True;0;0;0;False;0;False;0.2;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2494.934,239.9757;Inherit;False;Property;_MainDisturbMul;MainDisturbMul;5;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2060.397,485.054;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1953.592,-122.6904;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2081.577,259.1254;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2112.505,57.2382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1508.362,-66.42169;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1445.697,579.3347;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1227.019,188.8754;Inherit;False;Property;_Soft;Soft;8;0;Create;True;0;0;0;False;0;False;0.51;0.51;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-848.3851,158.2072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1168.869,589.5262;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;-1;None;eff7816d130842f46813a7d53c0d102a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-785.1471,753.5818;Inherit;False;Property;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1160.101,-72.00314;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;-1;None;1978497058fff684db6bfc37782dcf4d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-591.2401,135.7044;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;10;-408.9137,69.74065;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;27;-599.3538,617.2424;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-492.0994,-219.2477;Inherit;False;Property;_MainColor;MainColor;3;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;5.656854,2.784001,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-5.393911,138.0316;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;263.364,144.3589;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-18.98638,-91.51299;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;653.9283,-77.80714;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Particle/Elect;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;3
WireConnection;7;0;4;1
WireConnection;7;1;4;2
WireConnection;2;0;3;0
WireConnection;2;2;7;0
WireConnection;2;1;5;0
WireConnection;20;1;2;0
WireConnection;25;0;20;1
WireConnection;25;1;24;0
WireConnection;21;0;20;1
WireConnection;21;1;22;0
WireConnection;18;0;16;0
WireConnection;18;1;2;0
WireConnection;18;2;21;0
WireConnection;19;0;25;0
WireConnection;19;1;17;0
WireConnection;15;0;14;0
WireConnection;12;1;19;0
WireConnection;1;1;18;0
WireConnection;13;0;1;1
WireConnection;13;1;15;0
WireConnection;13;2;14;0
WireConnection;27;0;12;1
WireConnection;27;3;28;0
WireConnection;11;0;13;0
WireConnection;11;1;10;4
WireConnection;11;2;27;0
WireConnection;26;0;11;0
WireConnection;9;0;8;0
WireConnection;9;1;1;1
WireConnection;9;2;10;0
WireConnection;0;2;9;0
WireConnection;0;9;26;0
ASEEND*/
//CHKSM=79AE9691E71CE951B5D2B5515F6DD5A98CD91F58