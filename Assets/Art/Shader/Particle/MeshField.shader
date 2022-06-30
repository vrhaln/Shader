// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Particle/MeshField"
{
	Properties
	{
		_EmissionTex("EmissionTex", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_EmissionIntensity("EmissionIntensity", Range( 0 , 1)) = 0
		_Position("Position", Vector) = (0,0,0,0)
		_Range("Range", Float) = 1
		_MaxOffsetDistance("MaxOffsetDistance", Float) = 1
		_ColorTex("ColorTex", 2D) = "white" {}
		_VertexOffset("VertexOffset", Vector) = (0.5,0.5,0.5,0)
		_VertexOffsetMul("VertexOffsetMul", Vector) = (0,0,0,0)
		_RotationMul("RotationMul", Float) = 1
		_Vector1("Vector 1", Vector) = (1,1,0,0)
		[Toggle(_REVERSE_ON)] _reverse("反转", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _REVERSE_ON
		struct Input
		{
			float2 uv_texcoord;
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

		uniform float2 _Vector1;
		uniform float3 _VertexOffset;
		uniform float _RotationMul;
		uniform float3 _Position;
		uniform float _Range;
		uniform float _MaxOffsetDistance;
		uniform float3 _VertexOffsetMul;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform float4 _EmissionColor;
		uniform float _EmissionIntensity;
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
			#ifdef _REVERSE_ON
				float staticSwitch99 = ( 1.0 - temp_output_8_0 );
			#else
				float staticSwitch99 = temp_output_8_0;
			#endif
			float FieldDistance88 = staticSwitch99;
			float clampResult77 = clamp( FieldDistance88 , 0.0 , 1.0 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 rotatedValue73 = RotateAroundAxis( APivot90, ase_vertex3Pos, normalize( ( lerpResult10_g1 * APivot90 ) ), ( ( _RotationMul * clampResult77 ) * UNITY_PI ) );
			float3 VertexRotation93 = ( rotatedValue73 - ase_vertex3Pos );
			float clampResult17 = clamp( staticSwitch99 , 0.0 , _MaxOffsetDistance );
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
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			o.Emission = ( tex2D( _EmissionTex, uv_EmissionTex ) * _EmissionColor * _EmissionIntensity ).rgb;
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
27;202;1095;743;2240.643;671.7537;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;86;-1955.82,289.5092;Inherit;False;2600.555;893.8516;VertexFieldOffset;9;85;14;90;88;71;27;28;11;10;VertexFieldOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-1865.604,412.6281;Inherit;False;685.7106;377.3241;A;5;65;66;70;67;46;A;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;46;-1833.259,493.3311;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;67;-1663.314,517.5226;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;11;-1858.441,827.1962;Inherit;False;234;238;B;1;6;B;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;66;-1492.481,517.7278;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;70;-1526.178,640.4447;Inherit;False;Property;_VertexOffset;VertexOffset;12;0;Create;True;0;0;False;0;False;0.5,0.5,0.5;0.5,0.5,0.55;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;6;-1807.909,880.3652;Inherit;False;Property;_Position;Position;3;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;-1316.298,515.1503;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;71;-1449.03,884.0818;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;28;-738.7249,437.1372;Inherit;False;930.2241;330.5529;强度;7;17;18;8;9;7;98;99;强度;1,1,1,1;0;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-688.7249,487.1374;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-679.789,603.7717;Inherit;False;Property;_Range;Range;4;0;Create;True;0;0;False;0;False;1;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-492.4891,491.0717;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;98;-357.0183,586.1531;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;99;-206.0185,488.1531;Inherit;False;Property;_reverse;反转;16;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-4.316687,490.8794;Inherit;False;FieldDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;92;-1964.698,-622.3414;Inherit;False;1606.606;664.0001;VertexRotation;13;95;93;78;73;81;75;97;82;91;96;77;76;89;VertexRotation;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-1872.555,-249.809;Inherit;False;88;FieldDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-1069.273,428.0822;Inherit;False;APivot;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1672.799,-353.3904;Inherit;False;Property;_RotationMul;RotationMul;14;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;77;-1663.77,-245.8882;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;-729.1541,836.4523;Inherit;False;713.9861;269.7508;向量;4;13;12;69;68;向量;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;96;-1626.015,-564.9868;Inherit;False;Property;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;91;-1475.666,-414.6407;Inherit;False;90;APivot;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;95;-1394.747,-543.1926;Inherit;False;Random Range;-1;;1;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1454.392,-306.8233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-670.1542,885.8134;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PiNode;75;-1265.935,-338.4442;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-519.4653,687.1633;Inherit;False;Property;_MaxOffsetDistance;MaxOffsetDistance;5;0;Create;True;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1208.259,-459.879;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;69;-494.3165,967.5103;Inherit;False;Property;_VertexOffsetMul;VertexOffsetMul;13;0;Create;True;0;0;False;0;False;0,0,0;0,0,24.99;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;81;-1270.421,-213.3864;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;13;-513.2382,889.5824;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;17;7.270904,577.1057;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-287.5551,905.9456;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;73;-1033.096,-416.5703;Inherit;False;True;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;201.4817,886.4384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;78;-802.1176,-317.4045;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;385.539,888.4646;Inherit;False;VertexFieldOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-628.2076,-314.5395;Inherit;False;VertexRotation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;102;1007.813,25.26173;Inherit;False;Property;_EmissionColor;EmissionColor;1;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;730.0883,373.6119;Inherit;True;Property;_ColorTex;ColorTex;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;87;900.1483,771.8807;Inherit;False;85;VertexFieldOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;100;949.2136,-185.9009;Inherit;True;Property;_EmissionTex;EmissionTex;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;103;910.2906,217.6329;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;2;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;913.277,684.0713;Inherit;False;93;VertexRotation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;24;-409.5647,1885.76;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;39;-201.5285,2827.14;Inherit;True;Property;_DissolveTex;DissolveTex;9;0;Create;True;0;0;False;0;False;-1;None;24eaa96ae3a64a041bacf182844cb6b4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;327.0417,2466.121;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;166.4714,2587.14;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;49;1066.088,373.6119;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;19;-770.0186,2100.093;Inherit;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;False;0;False;-1;None;4e79806daeba8214385c96c574622d61;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;502.6788,2476.235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;30;-345.5287,2651.14;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-57.52867,2715.14;Inherit;False;Property;_Float0;Float 0;10;0;Create;True;0;0;False;0;False;0;6.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;1214.186,704.4559;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-617.5286,2795.14;Inherit;False;Property;_SoftParticle;SoftParticle;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;645.9274,2484.991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;31;-665.5288,2635.14;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;1337.812,-50.13826;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;36;-73.52855,2587.14;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-384.6035,2142.687;Inherit;False;Property;_EmissionMul;EmissionMul;7;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;22;-691.8436,1880.841;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-457.5287,2875.14;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-122.5391,2364.475;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-87.94516,2040.381;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1598.097,135.1226;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Particle/MeshField;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;67;0;46;1
WireConnection;66;0;67;0
WireConnection;66;1;46;2
WireConnection;66;2;46;3
WireConnection;65;0;66;0
WireConnection;65;1;70;0
WireConnection;71;0;6;0
WireConnection;7;0;65;0
WireConnection;7;1;71;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;98;0;8;0
WireConnection;99;1;8;0
WireConnection;99;0;98;0
WireConnection;88;0;99;0
WireConnection;90;0;65;0
WireConnection;77;0;89;0
WireConnection;95;1;96;0
WireConnection;82;0;76;0
WireConnection;82;1;77;0
WireConnection;12;0;65;0
WireConnection;12;1;71;0
WireConnection;75;0;82;0
WireConnection;97;0;95;0
WireConnection;97;1;91;0
WireConnection;13;0;12;0
WireConnection;17;0;99;0
WireConnection;17;2;18;0
WireConnection;68;0;13;0
WireConnection;68;1;69;0
WireConnection;73;0;97;0
WireConnection;73;1;75;0
WireConnection;73;2;91;0
WireConnection;73;3;81;0
WireConnection;14;0;17;0
WireConnection;14;1;68;0
WireConnection;78;0;73;0
WireConnection;78;1;81;0
WireConnection;85;0;14;0
WireConnection;93;0;78;0
WireConnection;24;0;22;0
WireConnection;39;1;44;0
WireConnection;37;0;21;0
WireConnection;37;1;36;0
WireConnection;38;0;43;0
WireConnection;38;1;39;1
WireConnection;49;0;50;0
WireConnection;41;0;37;0
WireConnection;41;1;38;0
WireConnection;30;1;31;0
WireConnection;30;0;33;0
WireConnection;79;0;94;0
WireConnection;79;1;87;0
WireConnection;42;0;41;0
WireConnection;101;0;100;0
WireConnection;101;1;102;0
WireConnection;101;2;103;0
WireConnection;36;0;30;0
WireConnection;21;0;19;1
WireConnection;21;1;22;4
WireConnection;20;0;19;0
WireConnection;20;1;24;0
WireConnection;20;2;26;0
WireConnection;0;2;101;0
WireConnection;0;13;49;0
WireConnection;0;11;79;0
ASEEND*/
//CHKSM=ECE950870E7AC139D6482FF814B5A694733AADBF