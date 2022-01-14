// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Toonface"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_ShadowColor("ShadowColor", Color) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_SDFFaceLightmap("SDFFaceLightmap", 2D) = "white" {}
		_ShadowIntensity("ShadowIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _BaseColor;
		uniform float4 _ShadowColor;
		uniform sampler2D _SDFFaceLightmap;
		uniform sampler2D _TextureSample0;
		uniform float _ShadowIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float3 _HeadForward = float3(0,0,1);
			float4 appendResult118 = (float4(_HeadForward.x , 0.0 , _HeadForward.z , 0.0));
			float4 normalizeResult116 = normalize( appendResult118 );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float4 appendResult121 = (float4(ase_worldlightDir.x , 0.0 , ase_worldlightDir.z , 0.0));
			float4 normalizeResult122 = normalize( appendResult121 );
			float dotResult124 = dot( normalizeResult116 , normalizeResult122 );
			float normalizeResult161 = normalize( dotResult124 );
			float3 _HeadRight = float3(1,0,0);
			float4 appendResult119 = (float4(_HeadRight.x , 0.0 , _HeadRight.z , 0.0));
			float4 normalizeResult120 = normalize( appendResult119 );
			float dotResult125 = dot( normalizeResult120 , normalizeResult122 );
			float normalizeResult147 = normalize( dotResult125 );
			float temp_output_154_0 = ( ( acos( dotResult125 ) / UNITY_PI ) * 2.0 );
			float2 uv_TexCoord103 = i.uv_texcoord * float2( -1,1 );
			float ToonFace134 = ( step( 0.0 , normalizeResult161 ) * step( ( normalizeResult147 > 0.0 ? ( 1.0 - temp_output_154_0 ) : ( temp_output_154_0 - 1.0 ) ) , ( normalizeResult147 > 0.0 ? tex2D( _SDFFaceLightmap, uv_TexCoord103 ).r : tex2D( _TextureSample0, i.uv_texcoord ).r ) ) );
			float smoothstepResult136 = smoothstep( 0.5 , 0.55 , ToonFace134);
			float4 lerpResult142 = lerp( ( tex2D( _Albedo, uv_Albedo ) * _BaseColor ) , ( tex2D( _Albedo, uv_Albedo ) * _ShadowColor ) , ( ( 1.0 - smoothstepResult136 ) * _ShadowIntensity ));
			float4 Albedo93 = lerpResult142;
			o.Emission = Albedo93.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1290;22;1270;813;835.3362;534.014;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;165;-3243.037,82.29613;Inherit;False;3014.413;1335.103;Toon Face;29;98;133;121;119;122;120;125;152;97;151;118;153;108;154;116;103;109;124;96;147;156;155;161;157;127;159;158;160;134;Toon Face;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;133;-2990.102,558.0493;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;98;-3185.328,313.8422;Inherit;False;Constant;_HeadRight;_HeadRight;30;0;Create;True;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;121;-2712.754,581.9062;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;119;-2708.745,358.2859;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;120;-2525.273,365.014;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;122;-2525.273,569.9312;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;125;-2192.394,499.3961;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ACosOpNode;151;-2039.046,1067.012;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;97;-3193.037,132.2961;Inherit;False;Constant;_HeadForward;_HeadForward;30;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PiNode;152;-2149.841,1223.647;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-2720.367,164.8991;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;153;-1915.205,1153.399;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-2763.827,839.8272;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-2767.727,1031.709;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;116;-2536.895,171.6271;Inherit;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-1757.203,1210.399;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;109;-2488.943,811.2283;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;165dda08aa18ecb4b9e19a2fc6f84f4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;124;-2199.609,268.7862;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;96;-2491.128,1012.354;Inherit;True;Property;_SDFFaceLightmap;SDFFaceLightmap;5;0;Create;True;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;165dda08aa18ecb4b9e19a2fc6f84f4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;156;-1584.204,1282.399;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;147;-1953.914,621.2396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;155;-1597.204,1153.399;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;157;-1375.128,1126.33;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;127;-1385.005,830.6457;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;161;-1929.669,299.5197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;159;-1088.279,711.2035;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;158;-1027.839,998.2424;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-782.6892,795.4774;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-3248.208,-1044.451;Inherit;False;2044.064;1093.32;Albedo;13;162;136;135;2;99;101;164;138;163;140;141;93;142;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-452.6252,769.4552;Inherit;False;ToonFace;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-2609.587,-246.104;Inherit;True;134;ToonFace;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;136;-2359.91,-236.367;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;164;-2772.573,-652.6326;Inherit;True;Global;Albedo;Albedo;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;141;-1979.019,-142.7275;Inherit;False;Property;_ShadowIntensity;ShadowIntensity;6;0;Create;True;0;0;False;0;False;0;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;101;-2204.067,-733.0766;Inherit;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;138;-2713.477,-432.5793;Inherit;False;Property;_ShadowColor;ShadowColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.6603774,0.3926143,0.3021538,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2370.935,-977.6735;Inherit;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;False;0;False;-1;None;f1bada3d9a11dcc418890a9d20d61b26;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;162;-2066.562,-251.227;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1916.856,-753.6636;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1715.572,-415.0641;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-2366.989,-599.6624;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;142;-1681.196,-618.4066;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-1420.409,-585.5453;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-153.8086,-145.0938;Inherit;False;93;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;147.4875,-197.7108;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Toonface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;121;0;133;1
WireConnection;121;2;133;3
WireConnection;119;0;98;1
WireConnection;119;2;98;3
WireConnection;120;0;119;0
WireConnection;122;0;121;0
WireConnection;125;0;120;0
WireConnection;125;1;122;0
WireConnection;151;0;125;0
WireConnection;118;0;97;1
WireConnection;118;2;97;3
WireConnection;153;0;151;0
WireConnection;153;1;152;0
WireConnection;116;0;118;0
WireConnection;154;0;153;0
WireConnection;109;1;108;0
WireConnection;124;0;116;0
WireConnection;124;1;122;0
WireConnection;96;1;103;0
WireConnection;156;0;154;0
WireConnection;147;0;125;0
WireConnection;155;0;154;0
WireConnection;157;0;147;0
WireConnection;157;2;155;0
WireConnection;157;3;156;0
WireConnection;127;0;147;0
WireConnection;127;2;96;1
WireConnection;127;3;109;1
WireConnection;161;0;124;0
WireConnection;159;1;161;0
WireConnection;158;0;157;0
WireConnection;158;1;127;0
WireConnection;160;0;159;0
WireConnection;160;1;158;0
WireConnection;134;0;160;0
WireConnection;136;0;135;0
WireConnection;162;0;136;0
WireConnection;99;0;2;0
WireConnection;99;1;101;0
WireConnection;140;0;162;0
WireConnection;140;1;141;0
WireConnection;163;0;164;0
WireConnection;163;1;138;0
WireConnection;142;0;99;0
WireConnection;142;1;163;0
WireConnection;142;2;140;0
WireConnection;93;0;142;0
WireConnection;0;2;94;0
ASEEND*/
//CHKSM=D205BA326E55E6BDD914B3663D1682D1653B846C