// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Teleport"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_BaseMap("BaseMap", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_CompMask("CompMask", 2D) = "white" {}
		_MetallicAdjust("MetallicAdjust", Range( -1 , 1)) = 0
		_SmoothnessAdjust("SmoothnessAdjust", Range( -1 , 1)) = 0
		_DissolveAmount("DissolveAmount", Float) = 0
		_DissolveOffset("DissolveOffset", Float) = 0
		_DissolveSpread("DissolveSpread", Float) = 0
		_NoiseScale("NoiseScale", Vector) = (1,1,1,0)
		_Edgeoffset("Edgeoffset", Float) = 0
		_EdgeWidth("EdgeWidth", Float) = 2.12
		[HDR]_EdgeEmissColor("EdgeEmissColor", Color) = (0,0.7579308,1,0)
		_VertexOffsetIntensity("VertexOffsetIntensity", Float) = 0
		_VertexEffectOffset("VertexEffectOffset", Float) = 0
		_VertexEffectSpread("VertexEffectSpread", Float) = 0
		_VertexEffectDirection("VertexEffectDirection", Vector) = (0,1,0,0)
		_VertexOffsetNoise("VertexOffsetNoise", Vector) = (10,10,0,0)
		_RimScale("RimScale", Float) = 0
		_RimPower("RimPower", Float) = 0
		[HDR]_RimColor("RimColor", Color) = (0,0,0,0)
		_RimControl("RimControl", Range( 0 , 1)) = 0
		_EmissTex("EmissTex", 2D) = "white" {}
		_RimIntensity("RimIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform float _DissolveAmount;
		uniform float _VertexEffectOffset;
		uniform float _VertexEffectSpread;
		uniform float3 _VertexEffectDirection;
		uniform float _VertexOffsetIntensity;
		uniform float3 _VertexOffsetNoise;
		uniform float _DissolveOffset;
		uniform float _DissolveSpread;
		uniform float3 _NoiseScale;
		uniform sampler2D _BaseMap;
		uniform float4 _BaseMap_ST;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _MetallicAdjust;
		uniform sampler2D _CompMask;
		uniform float4 _CompMask_ST;
		uniform float _SmoothnessAdjust;
		uniform float _RimControl;
		uniform float _Edgeoffset;
		uniform float _EdgeWidth;
		uniform float4 _EdgeEmissColor;
		uniform float _RimIntensity;
		uniform float _RimScale;
		uniform float _RimPower;
		uniform sampler2D _EmissTex;
		uniform float4 _EmissTex_ST;
		uniform float4 _RimColor;
		uniform float _Cutoff = 0.5;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 objToWorld20 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float temp_output_21_0 = ( ase_worldPos.y - objToWorld20.y );
			float simplePerlin3D120 = snoise( ( ase_worldPos * _VertexOffsetNoise ) );
			simplePerlin3D120 = simplePerlin3D120*0.5 + 0.5;
			float3 worldToObj116 = mul( unity_WorldToObject, float4( ( ( max( ( ( ( temp_output_21_0 + _DissolveAmount ) - _VertexEffectOffset ) / _VertexEffectSpread ) , 0.0 ) * _VertexEffectDirection * _VertexOffsetIntensity * simplePerlin3D120 ) + ase_worldPos ), 1 ) ).xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 FinalVertexOffset115 = ( worldToObj116 - ase_vertex3Pos );
			v.vertex.xyz += FinalVertexOffset115;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float3 objToWorld20 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float temp_output_21_0 = ( ase_worldPos.y - objToWorld20.y );
			float temp_output_26_0 = ( ( ( ( 1.0 - temp_output_21_0 ) - _DissolveAmount ) - _DissolveOffset ) / _DissolveSpread );
			float smoothstepResult59 = smoothstep( 0.9 , 1.0 , temp_output_26_0);
			float simplePerlin3D30 = snoise( ( ase_worldPos * _NoiseScale ) );
			simplePerlin3D30 = simplePerlin3D30*0.5 + 0.5;
			float temp_output_33_0 = ( temp_output_26_0 / simplePerlin3D30 );
			float clampResult28 = clamp( ( smoothstepResult59 + temp_output_33_0 ) , 0.0 , 1.0 );
			float Dissolve49 = clampResult28;
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float2 uv_BaseMap = i.uv_texcoord * _BaseMap_ST.xy + _BaseMap_ST.zw;
			float3 gammaToLinear13 = GammaToLinearSpace( tex2D( _BaseMap, uv_BaseMap ).rgb );
			s1.Albedo = gammaToLinear13;
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			s1.Normal = WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) );
			s1.Emission = float3( 0,0,0 );
			float2 uv_CompMask = i.uv_texcoord * _CompMask_ST.xy + _CompMask_ST.zw;
			float4 tex2DNode5 = tex2D( _CompMask, uv_CompMask );
			float clampResult8 = clamp( ( _MetallicAdjust + tex2DNode5.r ) , 0.0 , 1.0 );
			s1.Metallic = clampResult8;
			float clampResult12 = clamp( ( ( 1.0 - tex2DNode5.g ) + _SmoothnessAdjust ) , 0.0 , 1.0 );
			s1.Smoothness = clampResult12;
			s1.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi1 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g1 = UnityGlossyEnvironmentSetup( s1.Smoothness, data.worldViewDir, s1.Normal, float3(0,0,0));
			gi1 = UnityGlobalIllumination( data, s1.Occlusion, s1.Normal, g1 );
			#endif

			float3 surfResult1 = LightingStandard ( s1, viewDir, gi1 ).rgb;
			surfResult1 += s1.Emission;

			#ifdef UNITY_PASS_FORWARDADD//1
			surfResult1 -= s1.Emission;
			#endif//1
			float3 linearToGamma14 = LinearToGammaSpace( surfResult1 );
			float RimControl144 = _RimControl;
			float3 PBRLighting16 = ( linearToGamma14 * RimControl144 );
			float smoothstepResult65 = smoothstep( 0.9 , 1.0 , ( 1.0 - ( temp_output_26_0 - _Edgeoffset ) ));
			float4 DissolveEdgeColor45 = max( ( ( ( ( 1.0 - distance( temp_output_33_0 , _Edgeoffset ) ) + _EdgeWidth ) - ( 1.0 - smoothstepResult65 ) ) * _EdgeEmissColor ) , float4( 0,0,0,0 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float fresnelNdotV125 = dot( ase_normWorldNormal, ase_worldViewDir );
			float fresnelNode125 = ( 0.0 + _RimScale * pow( 1.0 - fresnelNdotV125, _RimPower ) );
			float clampResult139 = clamp( ( fresnelNode125 - (_RimControl*2.0 + -1.0) ) , 0.0 , 1.0 );
			float2 uv_EmissTex = i.uv_texcoord * _EmissTex_ST.xy + _EmissTex_ST.zw;
			float4 RimEmiss133 = ( _RimIntensity * ( clampResult139 + ( clampResult139 * tex2D( _EmissTex, uv_EmissTex ).r ) ) * _RimColor );
			c.rgb = ( float4( PBRLighting16 , 0.0 ) + DissolveEdgeColor45 + RimEmiss133 ).rgb;
			c.a = 1;
			clip( Dissolve49 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
-343;545;1298;773;4442.895;-2480.047;1.701074;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-4153.522,736.1615;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;20;-4169.402,899.3796;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;100;-3642.007,604.3676;Inherit;False;3365.051;985.161;Dissolve;29;49;28;45;60;83;59;43;44;72;55;66;57;65;40;64;38;33;73;30;39;26;24;37;27;25;36;22;34;29;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-3889.169,818.8953;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-3557.958,825.4205;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-4090.232,1273.341;Inherit;False;Property;_DissolveAmount;DissolveAmount;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-3285.661,826.67;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2844.802,946.4219;Inherit;False;Property;_DissolveOffset;DissolveOffset;7;0;Create;True;0;0;False;0;False;0;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;34;-3304.807,1232.712;Inherit;False;Property;_NoiseScale;NoiseScale;9;0;Create;True;0;0;False;0;False;1,1,1;100,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;36;-3308.084,1061.674;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-2995.525,1104.415;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2638.604,947.2861;Inherit;False;Property;_DissolveSpread;DissolveSpread;8;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-2643.29,821.266;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2372.378,1118.295;Inherit;False;Property;_Edgeoffset;Edgeoffset;10;0;Create;True;0;0;False;0;False;0;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;30;-2707.733,1096.353;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;124;-3604.469,1742.686;Inherit;False;2101.425;790.6016;VertexOffset;19;102;108;104;123;105;121;122;106;112;107;120;111;109;114;113;118;116;117;115;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-3618.304,-542.8015;Inherit;False;1495.521;968.7773;PBRLighting;16;5;7;9;11;6;10;3;4;8;12;13;1;14;16;145;146;PBRLighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;134;-3591.226,2613.779;Inherit;False;1769.283;861.4584;RimColor;17;137;126;135;132;130;139;138;125;133;127;128;129;140;141;142;143;144;RimColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;26;-2446.408,822.5023;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-3471.582,1797.049;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-3564.775,69.84241;Inherit;True;Property;_CompMask;CompMask;3;0;Create;True;0;0;False;0;False;-1;None;a7f745220fb33f946a159d308f6c7308;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;129;-3525.925,3074.027;Inherit;False;Property;_RimPower;RimPower;19;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-3526.925,2989.027;Inherit;False;Property;_RimScale;RimScale;18;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-2234.627,820.7987;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;126;-3541.226,2663.779;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;102;-3538.992,1911.968;Inherit;False;Property;_VertexEffectOffset;VertexEffectOffset;14;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;127;-3529.925,2821.027;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;-2124.622,1158.12;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-3535.909,3194.2;Inherit;False;Property;_RimControl;RimControl;21;0;Create;True;0;0;False;0;False;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-3281.13,1925.069;Inherit;False;Property;_VertexEffectSpread;VertexEffectSpread;15;0;Create;True;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;121;-3269.064,2201.716;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;9;-3235.02,103.4427;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3562.24,309.976;Inherit;False;Property;_SmoothnessAdjust;SmoothnessAdjust;5;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;104;-3240.948,1804.487;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;38;-1999.334,895.6625;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3564.289,-48.9614;Inherit;False;Property;_MetallicAdjust;MetallicAdjust;4;0;Create;True;0;0;False;0;False;0;0.5;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;-1949.355,1182.755;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;125;-3288.808,2798.241;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;137;-3235.955,3151.871;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;123;-3338.879,2345.286;Inherit;False;Property;_VertexOffsetNoise;VertexOffsetNoise;17;0;Create;True;0;0;False;0;False;10,10,0;5,5,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;3;-3568.304,-492.8015;Inherit;True;Property;_BaseMap;BaseMap;1;0;Create;True;0;0;False;0;False;-1;None;f7549f6cf82871c439168b7599da3968;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-3228.663,-23.95199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1903.171,1012.372;Inherit;False;Property;_EdgeWidth;EdgeWidth;11;0;Create;True;0;0;False;0;False;2.12;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-1827.786,917.0841;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-3058.112,2242.439;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-3071.241,106.0759;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;65;-1741.345,1164.092;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;138;-2954.08,2805.452;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;106;-3044.066,1805.724;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;12;-2929.541,-70.72428;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;139;-2788.5,2804.519;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;66;-1475.646,1160.624;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1607.857,936.8043;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2949.291,2109.528;Inherit;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;13;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GammaToLinearNode;13;-3189.684,-461.8536;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;111;-2907.248,1926.007;Inherit;False;Property;_VertexEffectDirection;VertexEffectDirection;16;0;Create;True;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;107;-2875.763,1800.117;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;120;-2897.982,2236.526;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-3560.128,-276.6266;Inherit;True;Property;_NormalMap;NormalMap;2;0;Create;True;0;0;False;0;False;-1;None;77b91526e481d164aa4fee6e8b5fc94c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;8;-3097.984,-177.1105;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;140;-2963.636,3069.067;Inherit;True;Property;_EmissTex;EmissTex;22;0;Create;True;0;0;False;0;False;-1;None;668fcaed21c1ad143a5b2782b04ad025;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;44;-1223.678,1310.82;Inherit;False;Property;_EdgeEmissColor;EdgeEmissColor;12;1;[HDR];Create;True;0;0;False;0;False;0,0.7579308,1,0;0,1.232806,5.340313,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;72;-1254.649,1068.157;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-2655.364,1911.092;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;114;-2577.685,2072.427;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CustomStandardSurface;1;-2903.765,-414.8384;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-3239.942,3282.077;Inherit;False;RimControl;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-2637.812,2971.793;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;113;-2349.685,1977.427;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;59;-2263.676,654.3676;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-2480.525,2712.101;Inherit;False;Property;_RimIntensity;RimIntensity;23;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-2626.031,-267.4821;Inherit;False;144;RimControl;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearToGammaNode;14;-2636.158,-416.734;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;135;-2465.918,3044.229;Inherit;False;Property;_RimColor;RimColor;20;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,1.232806,5.340313,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;142;-2472.172,2831.85;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-967.542,1081.839;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;118;-2160.773,2189.133;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;83;-769.1843,1081.991;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2053.41,694.0056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;116;-2188.114,1977.607;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-2230.285,2811.286;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2444.071,-344.9648;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;117;-1921.902,2069.7;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2309.783,-411.9125;Inherit;False;PBRLighting;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-2057.78,2817.715;Inherit;False;RimEmiss;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;28;-1896.295,681.5566;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-532.5424,1082.839;Inherit;False;DissolveEdgeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-444.1488,391.8528;Inherit;False;133;RimEmiss;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-443.993,222.5445;Inherit;False;16;PBRLighting;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-447.4962,306.1073;Inherit;False;45;DissolveEdgeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-1702.883,667.7808;Inherit;True;Dissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-1742.043,2068.959;Inherit;False;FinalVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-189.9296,398.7442;Inherit;False;115;FinalVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-182.9991,156.7122;Inherit;False;49;Dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-149.9272,244.1073;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;130,13;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/Teleport;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;19;2
WireConnection;21;1;20;2
WireConnection;29;0;21;0
WireConnection;22;0;29;0
WireConnection;22;1;23;0
WireConnection;37;0;36;0
WireConnection;37;1;34;0
WireConnection;24;0;22;0
WireConnection;24;1;25;0
WireConnection;30;0;37;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;108;0;21;0
WireConnection;108;1;23;0
WireConnection;33;0;26;0
WireConnection;33;1;30;0
WireConnection;73;0;26;0
WireConnection;73;1;39;0
WireConnection;9;0;5;2
WireConnection;104;0;108;0
WireConnection;104;1;102;0
WireConnection;38;0;33;0
WireConnection;38;1;39;0
WireConnection;64;0;73;0
WireConnection;125;0;126;0
WireConnection;125;4;127;0
WireConnection;125;2;128;0
WireConnection;125;3;129;0
WireConnection;137;0;132;0
WireConnection;6;0;7;0
WireConnection;6;1;5;1
WireConnection;40;0;38;0
WireConnection;122;0;121;0
WireConnection;122;1;123;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;65;0;64;0
WireConnection;138;0;125;0
WireConnection;138;1;137;0
WireConnection;106;0;104;0
WireConnection;106;1;105;0
WireConnection;12;0;10;0
WireConnection;139;0;138;0
WireConnection;66;0;65;0
WireConnection;55;0;40;0
WireConnection;55;1;57;0
WireConnection;13;0;3;0
WireConnection;107;0;106;0
WireConnection;120;0;122;0
WireConnection;8;0;6;0
WireConnection;72;0;55;0
WireConnection;72;1;66;0
WireConnection;109;0;107;0
WireConnection;109;1;111;0
WireConnection;109;2;112;0
WireConnection;109;3;120;0
WireConnection;1;0;13;0
WireConnection;1;1;4;0
WireConnection;1;3;8;0
WireConnection;1;4;12;0
WireConnection;144;0;132;0
WireConnection;141;0;139;0
WireConnection;141;1;140;1
WireConnection;113;0;109;0
WireConnection;113;1;114;0
WireConnection;59;0;26;0
WireConnection;14;0;1;0
WireConnection;142;0;139;0
WireConnection;142;1;141;0
WireConnection;43;0;72;0
WireConnection;43;1;44;0
WireConnection;83;0;43;0
WireConnection;60;0;59;0
WireConnection;60;1;33;0
WireConnection;116;0;113;0
WireConnection;130;0;143;0
WireConnection;130;1;142;0
WireConnection;130;2;135;0
WireConnection;146;0;14;0
WireConnection;146;1;145;0
WireConnection;117;0;116;0
WireConnection;117;1;118;0
WireConnection;16;0;146;0
WireConnection;133;0;130;0
WireConnection;28;0;60;0
WireConnection;45;0;83;0
WireConnection;49;0;28;0
WireConnection;115;0;117;0
WireConnection;46;0;17;0
WireConnection;46;1;47;0
WireConnection;46;2;136;0
WireConnection;0;10;50;0
WireConnection;0;13;46;0
WireConnection;0;11;119;0
ASEEND*/
//CHKSM=884114407BE38A6762C213DF73505D7237A991CD