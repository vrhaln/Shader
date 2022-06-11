// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Fog/Terrain"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (0,0,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 0
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 700
		_FogHeightStart("Fog Height Start", Float) = 0
		_FogHeightEnd("Fog Height End", Float) = 700
		_SunFogColor("Sun Fog Color", Color) = (0,0,0,0)
		_SunFogRange("Sun Fog Range", Float) = 0
		_SunFogIntensity("Sun Fog Intensity", Float) = 0
		_NoisIntensity("Nois Intensity", Float) = 0.51
		_NoiseTiling("Noise Tiling", Float) = 0
		_Speed("Speed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float3 viewDir;
			float3 worldPos;
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

		uniform float _Smoothness;
		uniform float4 _BaseColor;
		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		uniform float _SunFogRange;
		uniform float _SunFogIntensity;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _FogHeightEnd;
		uniform float _NoiseTiling;
		uniform float _Speed;
		uniform float _NoisIntensity;
		uniform float _FogHeightStart;
		uniform float _FogIntensity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float3 ACESTonemap37( float3 LinearColor )
		{
			float a = 2.51f;
			float b = 0.03f;
			float c = 2.43f;
			float d = 0.59f;
			float e = 0.14f;
			return
			saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = i.worldNormal;
			Unity_GlossyEnvironmentData g2 = UnityGlossyEnvironmentSetup( _Smoothness, data.worldViewDir, ase_worldNormal, float3(0,0,0));
			float3 indirectSpecular2 = UnityGI_IndirectSpecular( data, 1.0, ase_worldNormal, g2 );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult41 = dot( -i.viewDir , ase_worldlightDir );
			float clampResult47 = clamp( pow( (dotResult41*0.5 + 0.5) , _SunFogRange ) , 0.0 , 1.0 );
			float SunFog52 = ( clampResult47 * _SunFogIntensity );
			float4 lerpResult55 = lerp( _FogColor , _SunFogColor , SunFog52);
			float temp_output_11_0_g6 = _FogDistanceEnd;
			float clampResult7_g6 = clamp( ( ( temp_output_11_0_g6 - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( temp_output_11_0_g6 - _FogDistanceStart ) ) , 0.0 , 1.0 );
			float FogDistance66 = ( 1.0 - clampResult7_g6 );
			float temp_output_11_0_g3 = _FogHeightEnd;
			float2 temp_cast_1 = (_NoiseTiling).xx;
			float mulTime72 = _Time.y * -_Speed;
			float2 temp_cast_2 = (mulTime72).xx;
			float2 uv_TexCoord71 = i.uv_texcoord * temp_cast_1 + temp_cast_2;
			float simplePerlin2D70 = snoise( uv_TexCoord71 );
			simplePerlin2D70 = simplePerlin2D70*0.5 + 0.5;
			float2 temp_cast_3 = (_NoiseTiling).xx;
			float mulTime76 = _Time.y * _Speed;
			float2 temp_cast_4 = (mulTime76).xx;
			float2 uv_TexCoord75 = i.uv_texcoord * temp_cast_3 + temp_cast_4;
			float simplePerlin2D77 = snoise( uv_TexCoord75 );
			simplePerlin2D77 = simplePerlin2D77*0.5 + 0.5;
			float clampResult82 = clamp( ( ( simplePerlin2D70 * simplePerlin2D77 ) * _NoisIntensity ) , 0.0 , 1.0 );
			float clampResult7_g3 = clamp( ( ( temp_output_11_0_g3 - ( clampResult82 * ase_worldPos.y ) ) / ( temp_output_11_0_g3 - _FogHeightStart ) ) , 0.0 , 1.0 );
			float FogHight31 = ( 1.0 - ( 1.0 - clampResult7_g3 ) );
			float clampResult35 = clamp( ( ( FogDistance66 * FogHight31 ) * _FogIntensity ) , 0.0 , 1.0 );
			float4 lerpResult16 = lerp( ( float4( indirectSpecular2 , 0.0 ) * _BaseColor ) , lerpResult55 , clampResult35);
			float3 LinearColor37 = ( lerpResult16 * lerpResult16 ).rgb;
			float3 localACESTonemap37 = ACESTonemap37( LinearColor37 );
			c.rgb = sqrt( localACESTonemap37 );
			c.a = 1;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-817;302;922;654;7780.643;729.3699;6.565422;False;False
Node;AmplifyShaderEditor.RangedFloatNode;87;-4818.011,770.7002;Inherit;False;Property;_Speed;Speed;13;0;Create;True;0;0;False;0;False;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;89;-4605.686,701.7407;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;76;-4411.731,874.2324;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;72;-4432.966,628.6055;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-4401.807,753.6641;Inherit;False;Property;_NoiseTiling;Noise Tiling;12;0;Create;True;0;0;False;0;False;0;0.003;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-4114.062,576.6503;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;75;-4127.953,818.4605;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;70;-3876.043,552.7574;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;77;-3888.588,794.5677;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-3540.935,810.1718;Inherit;False;Property;_NoisIntensity;Nois Intensity;11;0;Create;True;0;0;False;0;False;0.51;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-3578.143,586.6307;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;51;-2866.092,1607.134;Inherit;False;1649.897;563.2485;Sun Fog;11;52;44;40;50;41;45;43;49;47;48;42;Sun Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;40;-2816.092,1672.495;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;24;-2969.747,799.1667;Inherit;False;1346.057;508.7882;Fog Hight;7;31;30;29;28;26;33;85;Fog Hight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-3301.209,679.5347;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2795.912,-29.08578;Inherit;False;1346.057;508.7882;Fog Distance;7;66;65;64;63;62;61;60;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;42;-2783.815,1902.237;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;50;-2640.732,1657.134;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;82;-3093.37,671.7544;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;26;-2939.137,872.8477;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;41;-2472.815,1775.237;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-2646.481,893.3003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2658.905,1153.39;Inherit;False;Property;_FogHeightEnd;Fog Height End;7;0;Create;True;0;0;False;0;False;700;500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;61;-2745.912,226.8658;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;60;-2627.702,20.91434;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-2658.637,1050.347;Inherit;False;Property;_FogHeightStart;Fog Height Start;6;0;Create;True;0;0;False;0;False;0;-50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2258.204,239.6599;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;63;-2402.24,145.9402;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2258.472,342.7025;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;5;0;Create;True;0;0;False;0;False;700;700;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;43;-2306.815,1778.237;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2322.815,1937.237;Inherit;False;Property;_SunFogRange;Sun Fog Range;9;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;30;-2380.455,956.5667;Inherit;False;Fog Linear;-1;;3;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;65;-1980.022,145.8804;Inherit;False;Fog Linear;-1;;6;4c9a774ba65ded846812a5c17586cdf5;0;3;13;FLOAT;500;False;12;FLOAT;0;False;11;FLOAT;700;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-2099.181,957.8027;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-2066.815,1863.237;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-1673.854,219.9126;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1931.498,2043.59;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;10;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;47;-1888.815,1888.237;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1853.69,989.1646;Inherit;False;FogHight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-1073.047,39.22899;Inherit;False;922.4023;873.5225;Fog Combine;10;32;54;53;17;35;55;16;57;58;68;Fog Combine;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1015.469,695.2589;Inherit;False;31;FogHight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1633.598,1965.991;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-1022.051,586.5389;Inherit;False;66;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1057.519,-357.6527;Inherit;False;Property;_Smoothness;Smoothness;1;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-723.0508,657.5389;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1418.25,2016.493;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-796.1034,833.5921;Inherit;False;Property;_FogIntensity;Fog Intensity;3;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-749.8917,-203.4985;Inherit;False;Property;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;False;0,0,0,0;0.1677858,0.3207547,0.1558384,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;53;-1023.047,282.3969;Inherit;False;Property;_SunFogColor;Sun Fog Color;8;0;Create;True;0;0;False;0;False;0,0,0,0;0.6588235,0.572549,0.8627452,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-1008.872,89.22899;Inherit;False;Property;_FogColor;FogColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.1921569,0.4666667,0.8745099,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;2;-707.5184,-358.6527;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-507.0154,728.9041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-931.7707,468.3118;Inherit;False;52;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-341.3781,705.7985;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-465.5186,-241.6528;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;55;-680.7711,359.912;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;16;-332.6447,244.0863;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-82.00183,263.0327;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;37;67.40079,274.9528;Inherit;False;float a = 2.51f@$float b = 0.03f@$float c = 2.43f@$float d = 0.59f@$float e = 0.14f@$return$saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e))@;3;False;1;True;LinearColor;FLOAT3;0,0,0;In;;Inherit;False;ACESTonemap;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;39;288.718,280.2031;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;713.8127,-20.39465;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Fog/Terrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;87;0
WireConnection;76;0;87;0
WireConnection;72;0;89;0
WireConnection;71;0;84;0
WireConnection;71;1;72;0
WireConnection;75;0;84;0
WireConnection;75;1;76;0
WireConnection;70;0;71;0
WireConnection;77;0;75;0
WireConnection;73;0;70;0
WireConnection;73;1;77;0
WireConnection;78;0;73;0
WireConnection;78;1;79;0
WireConnection;50;0;40;0
WireConnection;82;0;78;0
WireConnection;41;0;50;0
WireConnection;41;1;42;0
WireConnection;85;0;82;0
WireConnection;85;1;26;2
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;43;0;41;0
WireConnection;30;13;85;0
WireConnection;30;12;28;0
WireConnection;30;11;29;0
WireConnection;65;13;63;0
WireConnection;65;12;64;0
WireConnection;65;11;62;0
WireConnection;33;0;30;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;66;0;65;0
WireConnection;47;0;44;0
WireConnection;31;0;33;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;68;0;67;0
WireConnection;68;1;32;0
WireConnection;52;0;48;0
WireConnection;2;1;5;0
WireConnection;58;0;68;0
WireConnection;58;1;57;0
WireConnection;35;0;58;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;55;0;17;0
WireConnection;55;1;53;0
WireConnection;55;2;54;0
WireConnection;16;0;3;0
WireConnection;16;1;55;0
WireConnection;16;2;35;0
WireConnection;38;0;16;0
WireConnection;38;1;16;0
WireConnection;37;0;38;0
WireConnection;39;0;37;0
WireConnection;0;13;39;0
ASEEND*/
//CHKSM=31737F0D155A2973E178FBCDEDD34AC41E782FEF