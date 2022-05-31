// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Bend"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_Smoothness("Smoothness", Float) = 0
		_Spin("Spin", Float) = 0
		_MeshZLength("MeshZLength", Float) = 0
		_RollPositionZ("RollPositionZ", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
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

		uniform float _RollPositionZ;
		uniform float _Spin;
		uniform float _MeshZLength;
		uniform float4 _BaseColor;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float PositionZ32 = _RollPositionZ;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_6_0 = radians( ( abs( ( ase_vertex3Pos.z - PositionZ32 ) ) * _Spin ) );
			float3 appendResult13 = (float3(cos( temp_output_6_0 ) , 0.0 , sin( ( temp_output_6_0 + ( 1.0 * UNITY_PI ) ) )));
			float3 Roll68 = appendResult13;
			float MeshZLength59 = _MeshZLength;
			float2 _Vector1 = float2(1,3);
			float Radiusincrease70 = ( ase_vertex3Pos.x + (_Vector1.x + (ase_vertex3Pos.z - 0.0) * (_Vector1.y - _Vector1.x) / (MeshZLength59 - 0.0)) );
			float3 appendResult28 = (float3(0.0 , 0.0 , PositionZ32));
			float3 break55 = ( ( Roll68 * Radiusincrease70 ) + appendResult28 );
			float2 _Vector0 = float2(1,3);
			float3 appendResult58 = (float3(( break55.x - (_Vector0.x + (PositionZ32 - 0.0) * (_Vector0.y - _Vector0.x) / (MeshZLength59 - 0.0)) ) , ase_vertex3Pos.y , break55.z));
			float3 Fanjuan29 = appendResult58;
			float3 ifLocalVar24 = 0;
			if( PositionZ32 >= ase_vertex3Pos.z )
				ifLocalVar24 = Fanjuan29;
			else
				ifLocalVar24 = ase_vertex3Pos;
			v.vertex.xyz = ifLocalVar24;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			s1.Albedo = _BaseColor.rgb;
			float3 ase_worldNormal = i.worldNormal;
			s1.Normal = ase_worldNormal;
			s1.Emission = float3( 0,0,0 );
			s1.Metallic = 0.0;
			s1.Smoothness = _Smoothness;
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
			c.rgb = surfResult1;
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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				o.worldNormal = worldNormal;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
Version=18935
-748;315;1477;759;7064.996;1661.938;6.808422;True;True
Node;AmplifyShaderEditor.CommentaryNode;25;-1751.219,-5.928601;Inherit;False;988.3322;520.5787;判断是否翻卷;6;24;30;33;20;32;23;判断是否翻卷;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1726.126,42.65503;Inherit;False;Property;_RollPositionZ;RollPositionZ;4;0;Create;True;0;0;0;False;0;False;0;-3.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;-4557.467,521.7227;Inherit;False;1992.897;517.2059;翻卷;15;68;13;9;10;38;42;6;43;8;37;18;35;36;7;19;翻卷;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;19;-4507.467,576.8545;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1527.355,50.69384;Inherit;False;PositionZ;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;7;-4312.045,571.7227;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;36;-4312.885,785.6208;Inherit;False;32;PositionZ;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-4093.888,736.6208;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;52;-4545.014,1344.255;Inherit;False;1086.254;739.2656;半径逐渐增加;9;70;54;47;50;60;45;53;59;73;半径逐渐增加;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-3949.067,865.0338;Inherit;False;Property;_Spin;Spin;2;0;Create;True;0;0;0;False;0;False;0;60;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;37;-3917.888,760.6208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-3741.701,914.3793;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-3726.093,773.0986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-4501.607,1437.248;Inherit;False;Property;_MeshZLength;MeshZLength;3;0;Create;True;0;0;0;False;0;False;0;60;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;6;-3547.451,773.8417;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;42;-3604.701,914.3793;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-4294.493,1436.59;Inherit;False;MeshZLength;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-4504.544,1834.385;Inherit;False;59;MeshZLength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-4470.782,1747.58;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;45;-4506.02,1546.417;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;50;-4462.228,1915.052;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;1,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-3376.202,809.5793;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-3218.094,798.4852;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;9;-3205.699,585.2811;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-4147.855,1751.365;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-3932.805,1571.536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-3028.125,614.2585;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-3782.36,1570.062;Inherit;False;Radiusincrease;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-3176.346,1329.337;Inherit;False;2336.56;1132.45;Comment;11;55;34;28;71;69;51;29;58;26;67;72;跟随Z位移;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-2797.605,616.8776;Inherit;False;Roll;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-3084.629,1679.562;Inherit;False;68;Roll;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-3086.626,1779.893;Inherit;False;70;Radiusincrease;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-3076.323,1913.674;Inherit;False;32;PositionZ;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-2904.347,1870.559;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;67;-2407.681,1906.767;Inherit;False;752.6719;423.8346;Comment;5;62;56;64;61;63; 修正位置;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2858.646,1698.986;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2670.53,1707.372;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2345.803,1955.531;Inherit;False;32;PositionZ;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2367.239,2056.292;Inherit;False;59;MeshZLength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;61;-2329.477,2143.878;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;1,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BreakToComponentsNode;55;-2510.621,1710.87;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TFHCRemapNode;62;-2085.611,2007.206;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-1856.683,1977.68;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;72;-1900.825,1634.429;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;58;-1494.923,1695.904;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1303.823,1693.705;Inherit;False;Fanjuan;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-1302.956,150.3413;Inherit;False;32;PositionZ;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-568.5359,151.3729;Inherit;False;Property;_Smoothness;Smoothness;1;0;Create;True;0;0;0;False;0;False;0;3.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-566.5359,69.3729;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;20;-1727.213,211.2983;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-589.4213,-159.0413;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6603774,0.6603774,0.6603774,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1303.783,241.6769;Inherit;False;29;Fanjuan;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomStandardSurface;1;-302.4213,20.9587;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;24;-998.0598,284.1595;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;49;-4742.227,1709.052;Inherit;False;Constant;_YMeshZLength;Y=MeshZLength;3;0;Create;True;0;0;0;False;0;False;0,30;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Bend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;23;0
WireConnection;7;0;19;0
WireConnection;35;0;7;2
WireConnection;35;1;36;0
WireConnection;37;0;35;0
WireConnection;8;0;37;0
WireConnection;8;1;18;0
WireConnection;6;0;8;0
WireConnection;42;0;43;0
WireConnection;59;0;53;0
WireConnection;38;0;6;0
WireConnection;38;1;42;0
WireConnection;10;0;38;0
WireConnection;9;0;6;0
WireConnection;47;0;45;3
WireConnection;47;1;73;0
WireConnection;47;2;60;0
WireConnection;47;3;50;1
WireConnection;47;4;50;2
WireConnection;54;0;45;1
WireConnection;54;1;47;0
WireConnection;13;0;9;0
WireConnection;13;2;10;0
WireConnection;70;0;54;0
WireConnection;68;0;13;0
WireConnection;28;2;34;0
WireConnection;51;0;69;0
WireConnection;51;1;71;0
WireConnection;26;0;51;0
WireConnection;26;1;28;0
WireConnection;55;0;26;0
WireConnection;62;0;64;0
WireConnection;62;2;63;0
WireConnection;62;3;61;1
WireConnection;62;4;61;2
WireConnection;56;0;55;0
WireConnection;56;1;62;0
WireConnection;58;0;56;0
WireConnection;58;1;72;2
WireConnection;58;2;55;2
WireConnection;29;0;58;0
WireConnection;1;0;2;0
WireConnection;1;3;65;0
WireConnection;1;4;66;0
WireConnection;24;0;33;0
WireConnection;24;1;20;3
WireConnection;24;2;30;0
WireConnection;24;3;30;0
WireConnection;24;4;20;0
WireConnection;0;13;1;0
WireConnection;0;11;24;0
ASEEND*/
//CHKSM=45D1BBCC195E448FBDFB27D743F45E3391DD2CA7