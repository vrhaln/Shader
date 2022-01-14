// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Particle/MeshField"
{
	Properties
	{
		_Position("Position", Vector) = (0,0,0,0)
		_Range("Range", Float) = 1
		_MaxOffsetDistance("MaxOffsetDistance", Float) = 1
		_ColorTex("ColorTex", 2D) = "white" {}
		_VertexOffset("VertexOffset", Vector) = (0.5,0.5,0.5,0)
		_VertexOffsetMul("VertexOffsetMul", Vector) = (0,0,0,0)
		_RotationMul("RotationMul", Float) = 1
		_Vector1("Vector 1", Vector) = (1,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
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

		uniform float2 _Vector1;
		uniform float3 _VertexOffset;
		uniform float _RotationMul;
		uniform float3 _Position;
		uniform float _Range;
		uniform float _MaxOffsetDistance;
		uniform float3 _VertexOffsetMul;
		uniform sampler2D _ColorTex;
		uniform float4 _ColorTex_ST;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float dotResult4_g1 = dot( _Vector1 , float2( 12.9898,78.233 ) );
			float lerpResult10_g1 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g1 ) * 43758.55 ) ));
			float3 appendResult66 = (float3(( 1.0 - v.color.r ) , v.color.g , v.color.b));
			float3 temp_output_65_0 = ( appendResult66 - _VertexOffset );
			float3 APivot90 = temp_output_65_0;
			float3 worldToObj71 = mul( unity_WorldToObject, float4( _Position, 1 ) ).xyz;
			float temp_output_8_0 = ( distance( temp_output_65_0 , worldToObj71 ) - _Range );
			float FieldDistance88 = temp_output_8_0;
			float clampResult77 = clamp( FieldDistance88 , 0.0 , 1.0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 rotatedValue73 = RotateAroundAxis( APivot90, ase_vertex3Pos, normalize( ( lerpResult10_g1 * APivot90 ) ), ( ( _RotationMul * clampResult77 ) * UNITY_PI ) );
			float3 VertexRotation93 = ( rotatedValue73 - ase_vertex3Pos );
			float clampResult17 = clamp( temp_output_8_0 , 0.0 , _MaxOffsetDistance );
			float3 normalizeResult13 = normalize( ( temp_output_65_0 - worldToObj71 ) );
			float3 VertexFieldOffset85 = ( clampResult17 * ( normalizeResult13 * _VertexOffsetMul ) );
			v.vertex.xyz += ( VertexRotation93 + VertexFieldOffset85 );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s49 = (SurfaceOutputStandard ) 0;
			float2 uv_ColorTex = i.uv_texcoord * _ColorTex_ST.xy + _ColorTex_ST.zw;
			s49.Albedo = tex2D( _ColorTex, uv_ColorTex ).rgb;
			float3 ase_worldNormal = i.worldNormal;
			s49.Normal = ase_worldNormal;
			s49.Emission = float3( 0,0,0 );
			s49.Metallic = 0.0;
			s49.Smoothness = 0.0;
			s49.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi49 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g49 = UnityGlossyEnvironmentSetup( s49.Smoothness, data.worldViewDir, s49.Normal, float3(0,0,0));
			gi49 = UnityGlobalIllumination( data, s49.Occlusion, s49.Normal, g49 );
			#endif

			float3 surfResult49 = LightingStandard ( s49, viewDir, gi49 ).rgb;
			surfResult49 += s49.Emission;

			#ifdef UNITY_PASS_FORWARDADD//49
			surfResult49 -= s49.Emission;
			#endif//49
			c.rgb = surfResult49;
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
				vertexDataFunc( v, customInputData );
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
68;270;1367;809;5019.729;1932.084;6.371452;True;False
Node;AmplifyShaderEditor.CommentaryNode;86;-2010.659,457.683;Inherit;False;2265.497;828.006;VertexFieldOffset;11;10;11;28;27;70;71;14;72;85;88;90;VertexFieldOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-1960.659,507.683;Inherit;False;688.3106;295.4241;A;4;65;66;67;46;A;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;46;-1928.314,588.386;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;11;-1603.832,910.2526;Inherit;False;234;238;B;1;6;B;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;67;-1758.369,612.5775;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;70;-1621.233,735.4996;Inherit;False;Property;_VertexOffset;VertexOffset;9;0;Create;True;0;0;False;0;False;0.5,0.5,0.5;0.5,0.5,0.55;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;66;-1587.536,612.7827;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;6;-1553.3,963.4218;Inherit;False;Property;_Position;Position;0;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;71;-1306.642,974.5626;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;28;-975.4062,612.3953;Inherit;False;723.1444;295.3353;强度;5;7;9;8;18;17;强度;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;-1411.353,610.2052;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-925.4062,662.3953;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-916.4703,779.0296;Inherit;False;Property;_Range;Range;1;0;Create;True;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-729.1703,666.3297;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;92;-1971.307,-560.6602;Inherit;False;1610.273;498.9903;VertexRotation;12;93;78;73;75;91;81;82;76;77;89;95;97;VertexRotation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-510.8594,590.3369;Inherit;False;FieldDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-1912.061,-277.9785;Inherit;False;88;FieldDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;-974.2872,966.632;Inherit;False;713.9861;269.7508;向量;4;13;12;69;68;向量;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-1247.328,534.1372;Inherit;False;APivot;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1677.205,-406.2603;Inherit;False;Property;_RotationMul;RotationMul;11;0;Create;True;0;0;False;0;False;1;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;77;-1668.176,-298.7578;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;96;-1623.812,-679.5376;Inherit;False;Property;_Vector1;Vector 1;12;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1515.919,-456.6602;Inherit;False;90;APivot;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1470.7,-389.5492;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;95;-1460.765,-601.2068;Inherit;False;Random Range;-1;;1;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-915.2873,1015.993;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;69;-739.4496,1097.689;Inherit;False;Property;_VertexOffsetMul;VertexOffsetMul;10;0;Create;True;0;0;False;0;False;0,0,0;1,1,24.99;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;13;-758.3713,1019.762;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1267.668,-509.0819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PiNode;75;-1325.344,-387.647;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;81;-1329.83,-262.5891;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-735.0161,790.5777;Inherit;False;Property;_MaxOffsetDistance;MaxOffsetDistance;2;0;Create;True;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-532.6877,1036.125;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;73;-1092.505,-465.7731;Inherit;False;True;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;17;-493.5849,679.7462;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;78;-861.5267,-366.6073;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-169.2192,966.7349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-687.6167,-363.7423;Inherit;False;VertexRotation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;14.83804,968.7612;Inherit;False;VertexFieldOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;50;730.0883,373.6119;Inherit;True;Property;_ColorTex;ColorTex;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;87;900.1483,771.8807;Inherit;False;85;VertexFieldOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;913.277,684.0713;Inherit;False;93;VertexRotation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;1214.186,704.4559;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;39;-201.5285,2827.14;Inherit;True;Property;_DissolveTex;DissolveTex;6;0;Create;True;0;0;False;0;False;-1;None;24eaa96ae3a64a041bacf182844cb6b4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;36;-73.52855,2587.14;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;24;-409.5647,1885.76;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;19;-770.0186,2100.093;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;False;0;False;-1;None;4e79806daeba8214385c96c574622d61;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-122.5391,2364.475;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;502.6788,2476.235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-57.52867,2715.14;Inherit;False;Property;_Float0;Float 0;7;0;Create;True;0;0;False;0;False;0;6.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-384.6035,2142.687;Inherit;False;Property;_EmissionMul;EmissionMul;4;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;31;-665.5288,2635.14;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;22;-691.8436,1880.841;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;327.0417,2466.121;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-617.5286,2795.14;Inherit;False;Property;_SoftParticle;SoftParticle;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-87.94516,2040.381;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;30;-345.5287,2651.14;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;166.4714,2587.14;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;72;-1845.634,946.22;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-457.5287,2875.14;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomStandardSurface;49;1066.088,373.6119;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;42;645.9274,2484.991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1524.269,362.7556;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Particle/MeshField;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;67;0;46;1
WireConnection;66;0;67;0
WireConnection;66;1;46;2
WireConnection;66;2;46;3
WireConnection;71;0;6;0
WireConnection;65;0;66;0
WireConnection;65;1;70;0
WireConnection;7;0;65;0
WireConnection;7;1;71;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;88;0;8;0
WireConnection;90;0;65;0
WireConnection;77;0;89;0
WireConnection;82;0;76;0
WireConnection;82;1;77;0
WireConnection;95;1;96;0
WireConnection;12;0;65;0
WireConnection;12;1;71;0
WireConnection;13;0;12;0
WireConnection;97;0;95;0
WireConnection;97;1;91;0
WireConnection;75;0;82;0
WireConnection;68;0;13;0
WireConnection;68;1;69;0
WireConnection;73;0;97;0
WireConnection;73;1;75;0
WireConnection;73;2;91;0
WireConnection;73;3;81;0
WireConnection;17;0;8;0
WireConnection;17;2;18;0
WireConnection;78;0;73;0
WireConnection;78;1;81;0
WireConnection;14;0;17;0
WireConnection;14;1;68;0
WireConnection;93;0;78;0
WireConnection;85;0;14;0
WireConnection;79;0;94;0
WireConnection;79;1;87;0
WireConnection;39;1;44;0
WireConnection;36;0;30;0
WireConnection;24;0;22;0
WireConnection;21;0;19;1
WireConnection;21;1;22;4
WireConnection;41;0;37;0
WireConnection;41;1;38;0
WireConnection;37;0;21;0
WireConnection;37;1;36;0
WireConnection;20;0;19;0
WireConnection;20;1;24;0
WireConnection;20;2;26;0
WireConnection;30;1;31;0
WireConnection;30;0;33;0
WireConnection;38;0;43;0
WireConnection;38;1;39;1
WireConnection;49;0;50;0
WireConnection;42;0;41;0
WireConnection;0;13;49;0
WireConnection;0;11;79;0
ASEEND*/
//CHKSM=F69AB30F8417A30E86B0BB7F683FA753D000AF53