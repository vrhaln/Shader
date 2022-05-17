// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/WBFlash"
{
	Properties
	{
		_Nosie("Nosie", 2D) = "white" {}
		_RadialCenter("RadialCenter", Vector) = (1,1,0,0)
		_RadialTiling("RadialTiling", Vector) = (1,1,0,0)
		_RT("RT", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_Range("Range", Float) = 0.14
		_Vector0("Vector 0", Vector) = (0.5,0.5,0,0)
		_Vector2("Vector 2", Vector) = (0.5,0.5,0,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull [_CullMode]
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
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

		uniform float _CullMode;
		uniform float _ZTestMode;
		uniform sampler2D _RT;
		uniform float2 _Vector2;
		uniform float2 _Vector0;
		uniform float _Range;
		uniform sampler2D _Nosie;
		uniform float2 _RadialCenter;
		uniform float2 _RadialTiling;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult4 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float2 ScreenUV52 = appendResult4;
			float2 UVCenter271 = _Vector2;
			float2 UVCenter50 = _Vector0;
			float Range51 = _Range;
			float4 tex2DNode2 = tex2D( _RT, ( ScreenUV52 + ( ( ScreenUV52 - UVCenter271 ) * distance( ScreenUV52 , UVCenter50 ) * Range51 ) ) );
			float4 tex2DNode62 = tex2D( _RT, ( ScreenUV52 + ( ( ScreenUV52 - UVCenter271 ) * distance( ScreenUV52 , UVCenter50 ) * ( Range51 - 0.1 ) ) ) );
			float4 tex2DNode89 = tex2D( _RT, ( ScreenUV52 + ( ( ScreenUV52 - UVCenter271 ) * distance( ScreenUV52 , UVCenter50 ) * ( Range51 - 0.2 ) ) ) );
			float4 tex2DNode100 = tex2D( _RT, ( ScreenUV52 + ( ( ScreenUV52 - UVCenter271 ) * distance( ScreenUV52 , UVCenter50 ) * ( Range51 - 0.3 ) ) ) );
			float2 uv_TexCoord15 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_20_0 = ( uv_TexCoord15 - _RadialCenter );
			float2 appendResult22 = (float2(frac( ( atan2( (temp_output_20_0).x , (temp_output_20_0).y ) / 6.28318548202515 ) ) , length( temp_output_20_0 )));
			float2 RadialMath25 = ( appendResult22 * _RadialTiling );
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			c.rgb = ( tex2D( _Nosie, RadialMath25 ) * ( tex2D( _NoiseTex, uv_NoiseTex ).r + ( tex2DNode2 + tex2DNode62 + tex2DNode89 + tex2DNode100 ) ) ).rgb;
			c.a = saturate( ( tex2DNode2.a + ( tex2DNode62.a * 0.75 ) + ( tex2DNode89.a * 0.5 ) + ( tex2DNode100.a * 0.5 ) ) );
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
207;230;1227;724;2680.844;-468.3662;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;12;-1920.805,-1948.629;Inherit;False;2154;626.2493;Radial Math;15;17;15;24;23;22;21;20;19;18;16;14;13;25;44;45;Radial Math;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;17;-1892.552,-1794.407;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;2,2;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;19;-1519.798,-1613.461;Float;False;Property;_RadialCenter;RadialCenter;1;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1666.845,-1807.386;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1362.312,-1804.881;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;3;-2678.55,-249.374;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;46;-2523.262,673.8326;Inherit;False;Property;_Vector0;Vector 0;10;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;4;-2408.752,-219.774;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;70;-2504.238,373.833;Inherit;False;Property;_Vector2;Vector 2;11;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;21;-1152.804,-1804.629;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;23;-1152.804,-1884.629;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2126.789,854.0878;Inherit;False;Property;_Range;Range;9;0;Create;True;0;0;0;False;0;False;0.14;-0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-2197.582,-219.4586;Inherit;False;ScreenUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-1953.171,852.9756;Inherit;False;Range;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;16;-903.453,-1771.134;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;18;-908.265,-1885.65;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2248.199,391.105;Inherit;False;UVCenter2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2307.872,674.684;Inherit;False;UVCenter;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-2402.76,2377.379;Inherit;False;50;UVCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2175.982,1726.854;Inherit;False;51;Range;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-2432.198,3205.183;Inherit;False;50;UVCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-2461.678,2825.249;Inherit;False;52;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2194.597,2655.388;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;0.2;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-2233.507,266.8623;Inherit;False;52;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-2418.634,2996.478;Inherit;False;71;UVCenter2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-2218.29,2564.378;Inherit;False;51;Range;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-2432.24,1997.445;Inherit;False;52;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-2247.728,3392.182;Inherit;False;51;Range;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-2389.932,1159.921;Inherit;False;52;ScreenUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-2346.888,1331.15;Inherit;False;71;UVCenter2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-2389.196,2168.674;Inherit;False;71;UVCenter2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2152.289,1817.864;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-2224.035,3483.191;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;0.3;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2360.452,1539.855;Inherit;False;50;UVCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-744.634,-1882.473;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;-2018.034,3398.191;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;94;-2173.069,3131.542;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-2062.761,2119.174;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-1988.597,2570.388;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;83;-2143.631,2303.739;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;-2092.199,2946.978;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;13;-560.8042,-1804.629;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;24;-914.9904,-1543.835;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;58;-2101.323,1466.215;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-1889.473,395.9224;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;30;-1995.45,578.8134;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;-1946.289,1732.864;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-2020.453,1281.65;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1784.669,2119.235;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-1814.106,2947.039;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1636.489,394.3094;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;45;-528.373,-1507.033;Inherit;False;Property;_RadialTiling;RadialTiling;2;0;Create;True;0;0;0;False;0;False;1,1;10,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1742.361,1281.711;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-429.7993,-1643.337;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-1523.846,2017.778;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-1553.283,2845.582;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1481.538,1180.254;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-256.373,-1596.033;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1375.666,292.853;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-1519.634,-62.46581;Inherit;False;0;47;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-1219.163,1114.452;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;816d219bba243c44aa24402307a7f3e4;816d219bba243c44aa24402307a7f3e4;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;-938.1302,1603.149;Inherit;False;Constant;_Float3;Float 3;16;0;Create;True;0;0;0;False;0;False;0.75;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-103.135,-1646.041;Inherit;False;RadialMath;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-975.032,2230.793;Inherit;False;Constant;_Float4;Float 4;16;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-991.4054,3016.076;Inherit;False;Constant;_Float5;Float 5;16;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1196.03,266.4423;Inherit;True;Property;_RT;RT;4;0;Create;True;0;0;0;False;0;False;-1;816d219bba243c44aa24402307a7f3e4;816d219bba243c44aa24402307a7f3e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;100;-1290.908,2779.78;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;816d219bba243c44aa24402307a7f3e4;816d219bba243c44aa24402307a7f3e4;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;89;-1261.471,1951.976;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;816d219bba243c44aa24402307a7f3e4;816d219bba243c44aa24402307a7f3e4;True;0;False;white;Auto;False;Instance;2;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-733.4597,1551.521;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-325.8521,910.9479;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-739.8875,2905.187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-1223.788,-88.22425;Inherit;True;Property;_NoiseTex;NoiseTex;12;0;Create;True;0;0;0;False;0;False;-1;None;87e6295c89c24a841818393decf52aa0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1490.453,-368.5603;Inherit;False;25;RadialMath;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-717.8685,2111.435;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;7;-1912.093,-1176.882;Inherit;False;235;263.753;Comment;2;9;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;26;-1223.293,-391.6197;Inherit;True;Property;_Nosie;Nosie;0;0;Create;True;0;0;0;False;0;False;-1;None;0a4c77e4c2a232547856bd376a6b3a82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-25.90155,172.7405;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-281.7272,1642.229;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;184.3705,61.28357;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;43;-306.7222,-923.1066;Inherit;False;RadialUVDistortion;-1;;2;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;0.0;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1858.614,-1126.882;Inherit;False;Property;_CullMode;CullMode;7;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;78;14.38637,1594.56;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1862.093,-1029.128;Inherit;False;Property;_ZTestMode;ZTestMode;8;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;735.9091,188.4781;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/WBFlash;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;2;False;-1;7;True;9;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;3;-1;-1;-1;0;False;0;0;True;8;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;17;0
WireConnection;20;0;15;0
WireConnection;20;1;19;0
WireConnection;4;0;3;1
WireConnection;4;1;3;2
WireConnection;21;0;20;0
WireConnection;23;0;20;0
WireConnection;52;0;4;0
WireConnection;51;0;37;0
WireConnection;18;0;23;0
WireConnection;18;1;21;0
WireConnection;71;0;70;0
WireConnection;50;0;46;0
WireConnection;14;0;18;0
WireConnection;14;1;16;0
WireConnection;99;0;97;0
WireConnection;99;1;98;0
WireConnection;94;0;91;0
WireConnection;94;1;90;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;83;0;80;0
WireConnection;83;1;79;0
WireConnection;93;0;91;0
WireConnection;93;1;92;0
WireConnection;13;0;14;0
WireConnection;24;0;20;0
WireConnection;58;0;65;0
WireConnection;58;1;68;0
WireConnection;33;0;54;0
WireConnection;33;1;71;0
WireConnection;30;0;54;0
WireConnection;30;1;50;0
WireConnection;76;0;69;0
WireConnection;76;1;75;0
WireConnection;59;0;65;0
WireConnection;59;1;72;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;84;2;88;0
WireConnection;95;0;93;0
WireConnection;95;1;94;0
WireConnection;95;2;99;0
WireConnection;32;0;33;0
WireConnection;32;1;30;0
WireConnection;32;2;51;0
WireConnection;60;0;59;0
WireConnection;60;1;58;0
WireConnection;60;2;76;0
WireConnection;22;0;13;0
WireConnection;22;1;24;0
WireConnection;85;0;80;0
WireConnection;85;1;84;0
WireConnection;96;0;91;0
WireConnection;96;1;95;0
WireConnection;61;0;65;0
WireConnection;61;1;60;0
WireConnection;44;0;22;0
WireConnection;44;1;45;0
WireConnection;34;0;54;0
WireConnection;34;1;32;0
WireConnection;62;1;61;0
WireConnection;25;0;44;0
WireConnection;2;1;34;0
WireConnection;100;1;96;0
WireConnection;89;1;85;0
WireConnection;101;0;62;4
WireConnection;101;1;102;0
WireConnection;74;0;2;0
WireConnection;74;1;62;0
WireConnection;74;2;89;0
WireConnection;74;3;100;0
WireConnection;106;0;100;4
WireConnection;106;1;105;0
WireConnection;47;1;49;0
WireConnection;103;0;89;4
WireConnection;103;1;104;0
WireConnection;26;1;27;0
WireConnection;48;0;47;1
WireConnection;48;1;74;0
WireConnection;77;0;2;4
WireConnection;77;1;101;0
WireConnection;77;2;103;0
WireConnection;77;3;106;0
WireConnection;28;0;26;0
WireConnection;28;1;48;0
WireConnection;78;0;77;0
WireConnection;0;9;78;0
WireConnection;0;13;28;0
ASEEND*/
//CHKSM=26BC57E4A1435BBB66829776908940E2CDF81003