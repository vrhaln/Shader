// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Toonface"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_ShadowColor("ShadowColor", Color) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_ShadowIntensity("ShadowIntensity", Float) = 1
		_SDFFaceLightmap1("SDFFaceLightmap", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
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
		uniform sampler2D _SDFFaceLightmap1;
		uniform sampler2D _TextureSample1;
		uniform float _ShadowIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float3 objToWorldDir178 = mul( unity_ObjectToWorld, float4( float3(0,0,1), 0 ) ).xyz;
			float2 appendResult180 = (float2(objToWorldDir178.x , objToWorldDir178.z));
			float2 normalizeResult185 = normalize( appendResult180 );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 appendResult171 = (float2(ase_worldlightDir.x , ase_worldlightDir.z));
			float2 normalizeResult172 = normalize( appendResult171 );
			float dotResult192 = dot( normalizeResult185 , normalizeResult172 );
			float3 objToWorldDir168 = mul( unity_ObjectToWorld, float4( float3(1,0,0), 0 ) ).xyz;
			float2 appendResult170 = (float2(objToWorldDir168.x , objToWorldDir168.z));
			float2 normalizeResult173 = normalize( appendResult170 );
			float dotResult174 = dot( normalizeResult173 , normalizeResult172 );
			float temp_output_184_0 = ( dotResult174 > 0.0 ? 1.0 : 0.0 );
			float temp_output_182_0 = ( ( acos( dotResult174 ) / UNITY_PI ) * 2.0 );
			float2 uv_TexCoord183 = i.uv_texcoord * float2( -1,1 );
			float SDFFace196 = ( step( 0.0 , dotResult192 ) * step( ( temp_output_184_0 > 0.0 ? ( 1.0 - temp_output_182_0 ) : ( temp_output_182_0 - 1.0 ) ) , ( temp_output_184_0 > 0.0 ? tex2D( _SDFFaceLightmap1, uv_TexCoord183 ).r : tex2D( _TextureSample1, i.uv_texcoord ).r ) ) );
			float smoothstepResult136 = smoothstep( 0.5 , 0.55 , SDFFace196);
			float4 lerpResult142 = lerp( ( tex2D( _Albedo, uv_Albedo ) * _BaseColor ) , ( tex2D( _Albedo, uv_Albedo ) * _ShadowColor ) , ( smoothstepResult136 * _ShadowIntensity ));
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
Version=18935
293;136;1906;1045;8195.415;3069.871;6.341988;True;True
Node;AmplifyShaderEditor.CommentaryNode;166;-3474.887,945.4836;Inherit;False;3266.803;1470.405;SDFFace;32;200;199;198;197;196;195;194;193;192;191;190;189;188;187;186;185;184;183;182;181;180;179;178;177;176;174;173;172;171;170;169;168;SDFFace;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;167;-3697.342,1267.753;Inherit;False;Constant;_HeadRight1;_HeadRight;30;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;169;-3343.038,1460.212;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformDirectionNode;168;-3398.198,1254.999;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;171;-3008.807,1483.494;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;170;-3013.159,1259.042;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;173;-2813.327,1256.003;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;172;-2817.753,1476.473;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;174;-2486.979,1453.069;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;175;-3717.777,1003.121;Inherit;False;Constant;_HeadForward1;_HeadForward;30;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PiNode;177;-2337.518,2070.313;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ACosOpNode;176;-2221.791,1673.213;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;179;-2142.617,2042.932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;178;-3408.231,1008.056;Inherit;False;Object;World;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-2993.884,1930.235;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-1997.164,2047.457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;181;-2995.678,1703.015;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;180;-3020.566,1039.094;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;185;-2813.747,1035.815;Inherit;True;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Compare;184;-2000.919,1572.669;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;188;-1814.568,2093.359;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;187;-2704.353,1955.267;Inherit;True;Property;_SDFFaceLightmap1;SDFFaceLightmap;5;0;Create;True;0;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;659bc803eb9b58c43a4ca93450cfea65;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;186;-1823.718,2005.503;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;189;-2720.795,1674.416;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;165dda08aa18ecb4b9e19a2fc6f84f4b;165dda08aa18ecb4b9e19a2fc6f84f4b;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;190;-1497.39,1655.112;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;191;-1503.116,1957.161;Inherit;True;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;192;-2443.638,1091.494;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;193;-2162.992,1065.887;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;194;-1167.366,1816.249;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-867.624,1727.975;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;-524.7701,1704.29;Inherit;True;SDFFace;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-3248.208,-1044.451;Inherit;False;2044.064;1093.32;Albedo;13;162;136;135;2;99;101;164;138;163;140;141;93;142;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-2605.587,-229.104;Inherit;True;196;SDFFace;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;136;-2359.91,-236.367;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;164;-2772.573,-652.6326;Inherit;True;Global;Albedo;Albedo;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;138;-2713.477,-432.5793;Inherit;False;Property;_ShadowColor;ShadowColor;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6603774,0.3926143,0.3021538,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2370.935,-977.6735;Inherit;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;101;-2204.067,-733.0766;Inherit;False;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;141;-2093.837,-142.7275;Inherit;False;Property;_ShadowIntensity;ShadowIntensity;4;0;Create;True;0;0;0;False;0;False;1;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1828.794,-375.1974;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-2366.989,-599.6624;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1916.856,-753.6636;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;142;-1681.196,-618.4066;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-1443.409,-605.5453;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-2265.246,1324.502;Inherit;False;debug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;198;-3259.306,1656.296;Inherit;False;Constant;_Vector0;Vector 0;31;0;Create;True;0;0;0;False;0;False;1,2.22;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;199;-974.7032,1341.565;Inherit;False;197;debug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;-1066.338,1181.119;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-153.8086,-145.0938;Inherit;False;93;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;162;-2063.373,-366.0429;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;147.4875,-197.7108;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;ASE/Toonface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;168;0;167;0
WireConnection;171;0;169;1
WireConnection;171;1;169;3
WireConnection;170;0;168;1
WireConnection;170;1;168;3
WireConnection;173;0;170;0
WireConnection;172;0;171;0
WireConnection;174;0;173;0
WireConnection;174;1;172;0
WireConnection;176;0;174;0
WireConnection;179;0;176;0
WireConnection;179;1;177;0
WireConnection;178;0;175;0
WireConnection;182;0;179;0
WireConnection;180;0;178;1
WireConnection;180;1;178;3
WireConnection;185;0;180;0
WireConnection;184;0;174;0
WireConnection;188;0;182;0
WireConnection;187;1;183;0
WireConnection;186;0;182;0
WireConnection;189;1;181;0
WireConnection;190;0;184;0
WireConnection;190;2;187;1
WireConnection;190;3;189;1
WireConnection;191;0;184;0
WireConnection;191;2;186;0
WireConnection;191;3;188;0
WireConnection;192;0;185;0
WireConnection;192;1;172;0
WireConnection;193;1;192;0
WireConnection;194;0;191;0
WireConnection;194;1;190;0
WireConnection;195;0;193;0
WireConnection;195;1;194;0
WireConnection;196;0;195;0
WireConnection;136;0;135;0
WireConnection;140;0;136;0
WireConnection;140;1;141;0
WireConnection;163;0;164;0
WireConnection;163;1;138;0
WireConnection;99;0;2;0
WireConnection;99;1;101;0
WireConnection;142;0;99;0
WireConnection;142;1;163;0
WireConnection;142;2;140;0
WireConnection;93;0;142;0
WireConnection;0;2;94;0
ASEEND*/
//CHKSM=41C1626ED84D76E9D4DBF9A98242005620E8CB40