// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/Shining Cross"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull Back
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
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

		uniform float _ZTestMode;
		uniform sampler2D _MainTex;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 temp_cast_0 = (0.5).xx;
			float4 tex2DNode7 = tex2D( _MainTex, ( i.uv_texcoord.xy + ( ( i.uv_texcoord.xy - temp_cast_0 ) * (-70.0 + (i.uv_texcoord.z - 0.0) * (25.0 - -70.0) / (1.0 - 0.0)) * saturate( ( ( 1.0 - distance( i.uv_texcoord.xy , float2( 0.5,0.5 ) ) ) - 0.5 ) ) ) ) );
			c.rgb = ( i.vertexColor * tex2DNode7 * 1.0 * i.uv_texcoord.w ).rgb;
			c.a = ( tex2DNode7.r * i.vertexColor.a );
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
-1688;327;1434;792;1406.598;462.5465;2.417707;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1212.403,467.7043;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;48;-1173.343,635.216;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;46;-886.3438,524.216;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-782.2418,735.9164;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;-600.1066,548.3063;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-412.5789,545.832;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-603.1841,-207.0732;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-573.8475,-40.49326;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-612.0545,72.77771;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;52;-190.3018,541.7557;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;-270.3063,161.0472;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-70;False;4;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;38;-298.566,-45.05903;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;65.16846,228.6197;Inherit;True;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;55;-26.94875,-149.5477;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;295.7466,123.3478;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;56;654.7986,-93.88309;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;452.3711,100.9768;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;f9f85f52c5ad25c48955458e0c2ad9a8;291014278e3da2444b71d9e0041c65cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;576.8188,316.6933;Inherit;False;Constant;_Emission;Emission;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;487.8117,426.6324;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;367.9951,-459.2635;Inherit;False;Property;_ZTestMode;ZTestMode;2;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;954.3756,-44.76822;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;981.3855,187.9498;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-329.8315,342.6197;Inherit;False;Property;_Change;Change;3;0;Create;True;0;0;0;False;0;False;0.52;-25;-25;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1357.306,-23.56844;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/Shining Cross;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;True;43;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;44;0
WireConnection;46;1;48;0
WireConnection;51;0;46;0
WireConnection;49;0;51;0
WireConnection;49;1;50;0
WireConnection;52;0;49;0
WireConnection;54;0;53;3
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;40;0;38;0
WireConnection;40;1;54;0
WireConnection;40;2;52;0
WireConnection;55;0;37;0
WireConnection;42;0;55;0
WireConnection;42;1;40;0
WireConnection;7;1;42;0
WireConnection;57;0;56;0
WireConnection;57;1;7;0
WireConnection;57;2;59;0
WireConnection;57;3;60;4
WireConnection;58;0;7;1
WireConnection;58;1;56;4
WireConnection;0;9;58;0
WireConnection;0;13;57;0
ASEEND*/
//CHKSM=043ED1F45B6CE3B49BF0FB9EFF45DE1A41A30285