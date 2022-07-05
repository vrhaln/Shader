// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Test/CardReflection"
{
	Properties
	{
		_NormalTex("NormalTex", 2D) = "bump" {}
		_MainTex("MainTex", 2D) = "black" {}
		_RotateAngel("RotateAngel", Range( 0 , 360)) = 0
		_NormalScale("NormalScale", Range( 0 , 2)) = 2
		_RampTex("RampTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
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
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _RampTex;
		uniform float _RotateAngel;
		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _NormalScale;


		inline float3 ASESafeNormalize(float3 inVec)
		{
			float dp3 = max( 0.001f , dot( inVec , inVec ) );
			return inVec* rsqrt( dp3);
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 worldToObjDir6 = ASESafeNormalize( mul( unity_WorldToObject, float4( ase_worldViewDir, 0 ) ).xyz );
			float3 break22 = worldToObjDir6;
			float2 appendResult23 = (float2(break22.x , break22.y));
			float cos7 = cos( ( ( _RotateAngel / 180.0 ) * UNITY_PI ) );
			float sin7 = sin( ( ( _RotateAngel / 180.0 ) * UNITY_PI ) );
			float2 rotator7 = mul( appendResult23 - float2( 0,0 ) , float2x2( cos7 , -sin7 , sin7 , cos7 )) + float2( 0,0 );
			float ViewDir18 = abs( (frac( rotator7.x )*2.0 + -1.0) );
			float3 temp_cast_0 = (ViewDir18).xxx;
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float fresnelNdotV1 = dot( normalize( (WorldNormalVector( i , UnpackScaleNormal( tex2D( _NormalTex, uv_NormalTex ), _NormalScale ) )) ), temp_cast_0 );
			float fresnelNode1 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV1, 3.0 ) );
			float CustomFre30 = ( fresnelNode1 * 0.5 );
			float2 appendResult42 = (float2(( pow( ViewDir18 , 3.0 ) + CustomFre30 ) , 0.5));
			float4 RampColor44 = tex2D( _RampTex, appendResult42 );
			c.rgb = ( tex2D( _MainTex, uv_MainTex ) + RampColor44 ).rgb;
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
			o.Normal = float3(0,0,1);
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
Version=18935
48;201;1462;739;3888.237;-157.6437;3.208183;True;True
Node;AmplifyShaderEditor.CommentaryNode;28;-2738.86,527.9979;Inherit;False;2358.55;747.0537;Comment;16;4;10;6;8;22;9;13;11;25;23;14;15;16;17;18;7;CustomViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;4;-2522.672,578.1896;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformDirectionNode;6;-2345.83,577.9979;Inherit;False;World;Object;True;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-2561.461,1072.789;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;180;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2688.86,981.7884;Inherit;False;Property;_RotateAngel;RotateAngel;2;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-2350.86,1012.989;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;22;-2086.181,623.0172;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PiNode;13;-2399.869,1163.021;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1930.182,638.0172;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2169.963,1074.052;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;7;-1725.469,765.7101;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;14;-1465.848,770.5807;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FractNode;15;-1325.833,755.0087;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;16;-1138.035,756.4105;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-2740.6,-279.777;Inherit;False;1630.808;466.4021;Comment;8;2;29;20;1;34;33;30;21;CustomFre;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;17;-868.6102,755.1428;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2690.6,-182.6417;Inherit;False;Property;_NormalScale;NormalScale;3;0;Create;True;0;0;0;False;0;False;2;0.78;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2393.263,-229.777;Inherit;True;Property;_NormalTex;NormalTex;0;0;Create;True;0;0;0;False;0;False;-1;None;9745205e9a7d62a4fb625a93dabb32ce;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-651.3104,754.5428;Inherit;True;ViewDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;20;-2039.088,-225.0487;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;29;-2085.469,-33.17873;Inherit;False;18;ViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1653.683,31.51585;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0.5;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-1784.563,-150.8891;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1495.683,-67.48416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2745.657,1691.47;Inherit;False;1448.852;379.329;RampColor;9;36;38;37;40;43;39;42;41;44;RampColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1333.792,-72.37488;Inherit;True;CustomFre;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-2695.657,1741.47;Inherit;False;18;ViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2673.657,1841.47;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2524.552,1929.405;Inherit;False;30;CustomFre;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;37;-2482.657,1765.47;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-2237.278,1799.283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2224.49,1954.799;Inherit;False;Constant;_Float3;Float 3;7;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-2043.49,1870.799;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;41;-1850.49,1839.799;Inherit;True;Property;_RampTex;RampTex;5;0;Create;True;0;0;0;False;0;False;-1;None;267dab7642eda8746922b441aff48406;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1520.805,1840.031;Inherit;False;RampColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-536.608,-33.59764;Inherit;False;44;RampColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-642.8778,-308.7739;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;d1165499b20c66b4190e8121b159d97f;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;25;-2422.128,772.6379;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;19;211.6604,376.7444;Inherit;False;44;RampColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-44.29919,-139.0698;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;226.6006,-373.4196;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Test/CardReflection;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;22;0;6;0
WireConnection;23;0;22;0
WireConnection;23;1;22;1
WireConnection;11;0;9;0
WireConnection;11;1;13;0
WireConnection;7;0;23;0
WireConnection;7;2;11;0
WireConnection;14;0;7;0
WireConnection;15;0;14;0
WireConnection;16;0;15;0
WireConnection;17;0;16;0
WireConnection;2;5;21;0
WireConnection;18;0;17;0
WireConnection;20;0;2;0
WireConnection;1;0;20;0
WireConnection;1;4;29;0
WireConnection;33;0;1;0
WireConnection;33;1;34;0
WireConnection;30;0;33;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;39;0;37;0
WireConnection;39;1;40;0
WireConnection;42;0;39;0
WireConnection;42;1;43;0
WireConnection;41;1;42;0
WireConnection;44;0;41;0
WireConnection;46;0;3;0
WireConnection;46;1;47;0
WireConnection;0;13;46;0
ASEEND*/
//CHKSM=072E53534D3F6665301CDB84A273C0EB33E67126