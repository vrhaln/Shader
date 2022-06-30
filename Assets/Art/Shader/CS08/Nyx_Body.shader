// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Nyx_Body"
{
	Properties
	{
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Rimpower("Rimpower", Float) = 5
		_RimScale("RimScale", Float) = 1
		_RimBias("RimBias", Float) = 0
		_RimColor("RimColor", Color) = (1,1,1,0)
		_EmissMap("EmissMap", 2D) = "white" {}
		_FlowTillingSpeed("FlowTillingSpeed", Vector) = (1,1,0,0)
		_FlowLightColor("FlowLightColor", Color) = (1,1,1,0)
		_FlowRimBias("FlowRimBias", Float) = 0
		_FlowRimScale("FlowRimScale", Float) = 1
		_FlowRimpower("FlowRimpower", Float) = 5
		_BodyinsideTilling("BodyinsideTilling", Float) = 1
		_BodyinsideMap("BodyinsideMap", 2D) = "white" {}
		_BodyinsideDistort("BodyinsideDistort", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _RimColor;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Rimpower;
		uniform float _RimScale;
		uniform float _RimBias;
		uniform float4 _FlowLightColor;
		uniform sampler2D _EmissMap;
		uniform float4 _FlowTillingSpeed;
		uniform float _FlowRimpower;
		uniform float _FlowRimScale;
		uniform float _FlowRimBias;
		uniform sampler2D _BodyinsideMap;
		uniform float _BodyinsideDistort;
		uniform float _BodyinsideTilling;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 Normal_World6 = normalize( (WorldNormalVector( i , UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) )) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult3 = dot( Normal_World6 , ase_worldViewDir );
			float NdotV4 = dotResult3;
			float clampResult11 = clamp( NdotV4 , 0.0 , 1.0 );
			float4 RimColor23 = ( _RimColor * ( ( pow( ( 1.0 - clampResult11 ) , _Rimpower ) * _RimScale ) + _RimBias ) );
			float3 objToWorld28 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 panner34 = ( 1.0 * _Time.y * (_FlowTillingSpeed).zw + ( ( (NdotV4*0.5 + 0.5) + (( ase_worldPos - objToWorld28 )).xy ) * (_FlowTillingSpeed).xy ));
			float FlowLight37 = tex2D( _EmissMap, panner34 ).r;
			float clampResult51 = clamp( NdotV4 , 0.0 , 1.0 );
			float4 FlowLightColor46 = ( _FlowLightColor * ( FlowLight37 * ( ( pow( ( 1.0 - clampResult51 ) , _FlowRimpower ) * _FlowRimScale ) + _FlowRimBias ) ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToView63 = mul( UNITY_MATRIX_MV, float4( ase_vertex3Pos, 1 ) ).xyz;
			float3 objToView65 = mul( UNITY_MATRIX_MV, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 worldToViewDir74 = normalize( mul( UNITY_MATRIX_V, float4( Normal_World6, 0 ) ).xyz );
			float4 BodyinsideColor70 = tex2D( _BodyinsideMap, ( ( (( objToView63 - objToView65 )).xy + ( (worldToViewDir74).xy * _BodyinsideDistort ) ) * _BodyinsideTilling ) );
			o.Emission = ( RimColor23 + FlowLightColor46 + ( FlowLight37 * BodyinsideColor70 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
264;174;1214;762;2768.679;-1348.875;3.26136;True;True
Node;AmplifyShaderEditor.CommentaryNode;7;-2054.241,-433.3211;Inherit;False;806.7594;280;WorldNormal;3;1;5;6;WorldNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;5;-2004.241,-383.3212;Inherit;True;Property;_NormalMap;NormalMap;0;0;Create;True;0;0;False;0;False;-1;None;f2cddebc6ca16fa479e931409341506d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;1;-1686.486,-379.0012;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;9;-2044.825,-61.06788;Inherit;False;674.5427;345.7012;NdotV;4;4;2;3;8;NdotV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-1467.482,-382.6356;Inherit;False;Normal_World;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2;-1963.087,96.63341;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;8;-1994.825,-11.0679;Inherit;False;6;Normal_World;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-1722.292,8.996515;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-2022.993,966.1521;Inherit;False;1729.4;1106.895;FlowLight;14;37;36;34;30;35;29;33;27;32;26;28;40;41;42;FlowLight;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;26;-1913.493,1545.972;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-1594.282,11.73605;Inherit;False;NdotV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;28;-1956.852,1708.909;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1856.866,1355.829;Inherit;False;4;NdotV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1697.493,1604.972;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;79;-2009.017,2875.957;Inherit;False;2015.652;766.1787;BodyinsideColor;15;73;62;74;63;65;77;75;64;76;66;68;78;67;69;70;BodyinsideColor;1,0.0518868,0.7453598,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;29;-1553.493,1616.972;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;42;-1625.945,1396.395;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;32;-1755.961,1813.722;Inherit;False;Property;_FlowTillingSpeed;FlowTillingSpeed;6;0;Create;True;0;0;False;0;False;1,1,0,0;1,1,0,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;60;-2009.75,2181.465;Inherit;False;1768.991;615.2007;FlowLightColor;14;43;54;55;58;57;56;53;52;51;50;45;59;44;46;FlowLightColor;1,0.8382073,0.3443396,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;62;-1959.017,2926.277;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1380.708,1533.52;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-1948.937,3384.681;Inherit;False;6;Normal_World;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;33;-1517.961,1800.722;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-1959.75,2357.767;Inherit;False;4;NdotV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2035.402,367.8017;Inherit;False;1641.156;488.8992;RimColor;12;11;12;13;14;15;16;17;18;21;22;23;10;RimColor;1,0.4669811,0.4669811,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;-1985.402,417.8017;Inherit;False;4;NdotV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;51;-1746.7,2382.121;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;63;-1756.835,2925.957;Inherit;False;Object;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;35;-1526.961,1911.722;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1221.127,1634.149;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;65;-1760.835,3138.957;Inherit;False;Object;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformDirectionNode;74;-1693.975,3357.814;Inherit;False;World;View;True;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;34;-1052.127,1640.149;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;-1483.835,3053.957;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1524.645,3526.136;Inherit;False;Property;_BodyinsideDistort;BodyinsideDistort;13;0;Create;True;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;11;-1772.352,442.1559;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-1567.739,2389.203;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;75;-1452.384,3376.852;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1579.122,2526.409;Inherit;False;Property;_FlowRimpower;FlowRimpower;10;0;Create;True;0;0;False;0;False;5;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1412.081,2622.166;Inherit;False;Property;_FlowRimScale;FlowRimScale;9;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;66;-1309.835,3068.957;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;36;-840.5163,1617.581;Inherit;True;Property;_EmissMap;EmissMap;5;0;Create;True;0;0;False;0;False;-1;None;10d5a170eb7969a4380b300d1d9ea62c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1285.427,3404.644;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;53;-1380.959,2435.73;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1604.774,586.4443;Inherit;False;Property;_Rimpower;Rimpower;1;0;Create;True;0;0;False;0;False;5;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-1593.391,449.2384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-1049.947,3120.156;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1191.081,2540.266;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;-1406.611,495.7649;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1437.733,682.2012;Inherit;False;Property;_RimScale;RimScale;2;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1213.181,2680.666;Inherit;False;Property;_FlowRimBias;FlowRimBias;8;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-976.6001,3258.983;Inherit;False;Property;_BodyinsideTilling;BodyinsideTilling;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-505.5163,1635.581;Inherit;False;FlowLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1063.231,2410.398;Inherit;False;37;FlowLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1011.681,2593.566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1238.833,740.7011;Inherit;False;Property;_RimBias;RimBias;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-775.5842,3110.616;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1216.733,600.3008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1037.333,653.6013;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-815.6186,2495.805;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;-907.2278,2231.465;Inherit;False;Property;_FlowLightColor;FlowLightColor;7;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-1090.445,431.6371;Inherit;False;Property;_RimColor;RimColor;4;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;-563.9787,3069.46;Inherit;True;Property;_BodyinsideMap;BodyinsideMap;12;0;Create;True;0;0;False;0;False;-1;None;04436ccdea7f25440b63a8c05d5cbb99;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-230.0625,3070.297;Inherit;False;BodyinsideColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-624.5878,2370.045;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-847.1004,555.4078;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-809.968,155.8717;Inherit;False;37;FlowLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-618.2463,595.928;Inherit;False;RimColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-465.759,2395.089;Inherit;False;FlowLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-820.6111,257.5579;Inherit;False;70;BodyinsideColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-747.331,86.25858;Inherit;False;46;FlowLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-616.0206,2.217655;Inherit;False;23;RimColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-538.968,169.8717;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-351.2152,48.23505;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Nyx_Body;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;5;0
WireConnection;6;0;1;0
WireConnection;3;0;8;0
WireConnection;3;1;2;0
WireConnection;4;0;3;0
WireConnection;27;0;26;0
WireConnection;27;1;28;0
WireConnection;29;0;27;0
WireConnection;42;0;40;0
WireConnection;41;0;42;0
WireConnection;41;1;29;0
WireConnection;33;0;32;0
WireConnection;51;0;50;0
WireConnection;63;0;62;0
WireConnection;35;0;32;0
WireConnection;30;0;41;0
WireConnection;30;1;33;0
WireConnection;74;0;73;0
WireConnection;34;0;30;0
WireConnection;34;2;35;0
WireConnection;64;0;63;0
WireConnection;64;1;65;0
WireConnection;11;0;10;0
WireConnection;52;0;51;0
WireConnection;75;0;74;0
WireConnection;66;0;64;0
WireConnection;36;1;34;0
WireConnection;76;0;75;0
WireConnection;76;1;77;0
WireConnection;53;0;52;0
WireConnection;53;1;58;0
WireConnection;12;0;11;0
WireConnection;78;0;66;0
WireConnection;78;1;76;0
WireConnection;54;0;53;0
WireConnection;54;1;57;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;37;0;36;1
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;67;0;78;0
WireConnection;67;1;68;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;17;0;15;0
WireConnection;17;1;18;0
WireConnection;45;0;43;0
WireConnection;45;1;55;0
WireConnection;69;1;67;0
WireConnection;70;0;69;0
WireConnection;59;0;44;0
WireConnection;59;1;45;0
WireConnection;22;0;21;0
WireConnection;22;1;17;0
WireConnection;23;0;22;0
WireConnection;46;0;59;0
WireConnection;80;0;81;0
WireConnection;80;1;71;0
WireConnection;61;0;25;0
WireConnection;61;1;47;0
WireConnection;61;2;80;0
WireConnection;0;2;61;0
ASEEND*/
//CHKSM=957F9F26802990D4AC1B962FFCDD88B8F4EA49F1