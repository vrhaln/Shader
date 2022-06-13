// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Ground"
{
	Properties
	{
		_Tilling("Tilling", Float) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalIntensity("NormalIntensity", Float) = 0
		_RoughnessMap("RoughnessMap", 2D) = "white" {}
		_RoughnessMin("RoughnessMin", Range( 0 , 1)) = 1
		_RoughnessMax("RoughnessMax", Range( 0 , 1)) = 1
		_WaterRoughness("WaterRoughness", Range( 0 , 0.1)) = 0
		_AOMap("AOMap", 2D) = "white" {}
		_Height("Height", 2D) = "white" {}
		_POMScale("POMScale", Range( -0.5 , 0.5)) = 0
		_POMPlane("POMPlane", Float) = 0
		_BlendContrast("BlendContrast", Range( 0 , 1)) = 0
		_PudlleColor("PudlleColor", Color) = (0,0,0,0)
		_PuddleDepth("PuddleDepth", Range( 0 , 1)) = 0
		_WaterNormal("WaterNormal", 2D) = "bump" {}
		_WaveTilling("WaveTilling", Float) = 0
		_WaveSpeed("WaveSpeed", Vector) = (1,1,0,0)
		_WaveIntensity("WaveIntensity", Range( 0 , 1)) = 0.2
		_RainDrop("RainDrop", 2D) = "bump" {}
		_RainIntensity("RainIntensity", Float) = 0
		_RainDropTilling("RainDropTilling", Float) = 0
		_Columns("Columns", Float) = 8
		_RainDropSpeed("RainDropSpeed", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
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
			float3 worldPos;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
			float4 vertexColor : COLOR;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _NormalMap;
		uniform float _Tilling;
		uniform sampler2D _Height;
		uniform float _POMScale;
		uniform float _POMPlane;
		uniform float4 _Height_ST;
		uniform sampler2D _WaterNormal;
		uniform float _WaveTilling;
		uniform float2 _WaveSpeed;
		uniform float _WaveIntensity;
		uniform float _RainIntensity;
		uniform sampler2D _RainDrop;
		uniform float _RainDropTilling;
		uniform float _Columns;
		uniform float _RainDropSpeed;
		uniform float _BlendContrast;
		uniform sampler2D _Albedo;
		uniform float4 _PudlleColor;
		uniform float _PuddleDepth;
		uniform float _RoughnessMin;
		uniform float _RoughnessMax;
		uniform sampler2D _RoughnessMap;
		uniform float _WaterRoughness;
		uniform sampler2D _AOMap;


		inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
		{
			float3 result = 0;
			int stepIndex = 0;
			int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
			float layerHeight = 1.0 / numSteps;
			float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
			uvs += refPlane * plane;
			float2 deltaTex = -plane * layerHeight;
			float2 prevTexOffset = 0;
			float prevRayZ = 1.0f;
			float prevHeight = 0.0f;
			float2 currTexOffset = deltaTex;
			float currRayZ = 1.0f - layerHeight;
			float currHeight = 0.0f;
			float intersection = 0;
			float2 finalTexOffset = 0;
			while ( stepIndex < numSteps + 1 )
			{
				currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r;
				if ( currHeight > currRayZ )
				{
					stepIndex = numSteps + 1;
				}
				else
				{
					stepIndex++;
					prevTexOffset = currTexOffset;
					prevRayZ = currRayZ;
					prevHeight = currHeight;
					currTexOffset += deltaTex;
					currRayZ -= layerHeight;
				}
			}
			int sectionSteps = 6;
			int sectionIndex = 0;
			float newZ = 0;
			float newHeight = 0;
			while ( sectionIndex < sectionSteps )
			{
				intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				finalTexOffset = prevTexOffset + intersection * deltaTex;
				newZ = prevRayZ - intersection * layerHeight;
				newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
				if ( newHeight > newZ )
				{
					currTexOffset = finalTexOffset;
					currHeight = newHeight;
					currRayZ = newZ;
					deltaTex = intersection * deltaTex;
					layerHeight = intersection * layerHeight;
				}
				else
				{
					prevTexOffset = finalTexOffset;
					prevHeight = newHeight;
					prevRayZ = newZ;
					deltaTex = ( 1 - intersection ) * deltaTex;
					layerHeight = ( 1 - intersection ) * layerHeight;
				}
				sectionIndex++;
			}
			return uvs + finalTexOffset;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 OffsetPOM30 = POM( _Height, ( (ase_worldPos).xz * _Tilling ), ddx(( (ase_worldPos).xz * _Tilling )), ddy(( (ase_worldPos).xz * _Tilling )), ase_worldNormal, ase_worldViewDir, i.viewDir, 8, 8, ( _POMScale * 0.1 ), ( _POMPlane + ( i.vertexColor.b - 0.0 ) ), _Height_ST.xy, float2(0,0), 0 );
			float2 WorldUV15 = OffsetPOM30;
			float2 temp_output_72_0 = ( (ase_worldPos).xz * _WaveTilling );
			float2 temp_output_76_0 = ( _WaveSpeed * _Time.y * 0.1 );
			float3 lerpResult88 = lerp( float3(0,0,1) , BlendNormals( UnpackNormal( tex2D( _WaterNormal, ( temp_output_72_0 + temp_output_76_0 ) ) ) , UnpackNormal( tex2D( _WaterNormal, ( ( temp_output_72_0 * 2.0 ) + ( temp_output_76_0 * -0.5 ) ) ) ) ) , _WaveIntensity);
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles95 = _Columns * _Columns;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset95 = 1.0f / _Columns;
			float fbrowsoffset95 = 1.0f / _Columns;
			// Speed of animation
			float fbspeed95 = _Time[ 1 ] * _RainDropSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling95 = float2(fbcolsoffset95, fbrowsoffset95);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex95 = round( fmod( fbspeed95 + 0.0, fbtotaltiles95) );
			fbcurrenttileindex95 += ( fbcurrenttileindex95 < 0) ? fbtotaltiles95 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox95 = round ( fmod ( fbcurrenttileindex95, _Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx95 = fblinearindextox95 * fbcolsoffset95;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy95 = round( fmod( ( fbcurrenttileindex95 - fblinearindextox95 ) / _Columns, _Columns ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy95 = (int)(_Columns-1) - fblinearindextoy95;
			// Multiply Offset Y by rowoffset
			float fboffsety95 = fblinearindextoy95 * fbrowsoffset95;
			// UV Offset
			float2 fboffset95 = float2(fboffsetx95, fboffsety95);
			// Flipbook UV
			half2 fbuv95 = frac( ( (ase_worldPos).xz * _RainDropTilling ) ) * fbtiling95 + fboffset95;
			// *** END Flipbook UV Animation vars ***
			float3 PuddleNormal86 = BlendNormals( lerpResult88 , UnpackScaleNormal( tex2D( _RainDrop, fbuv95 ), _RainIntensity ) );
			float temp_output_7_0_g8 = _BlendContrast;
			float4 tex2DNode43 = tex2D( _Height, WorldUV15 );
			float clampResult6_g8 = clamp( ( ( tex2DNode43.r - 1.0 ) + ( i.vertexColor.b * 2.0 ) ) , 0.0 , 1.0 );
			float lerpResult11_g8 = lerp( ( 0.0 - temp_output_7_0_g8 ) , ( temp_output_7_0_g8 + 1.0 ) , clampResult6_g8);
			float clampResult12_g8 = clamp( lerpResult11_g8 , 0.0 , 1.0 );
			float BChannelLerp49 = clampResult12_g8;
			float3 lerpResult63 = lerp( UnpackScaleNormal( tex2D( _NormalMap, WorldUV15 ), _NormalIntensity ) , PuddleNormal86 , ( 1.0 - BChannelLerp49 ));
			float3 Normal19 = lerpResult63;
			o.Normal = Normal19;
			float4 tex2DNode1 = tex2D( _Albedo, WorldUV15 );
			float4 lerpResult50 = lerp( tex2DNode1 , _PudlleColor , _PuddleDepth);
			float temp_output_7_0_g10 = _BlendContrast;
			float clampResult6_g10 = clamp( ( ( tex2DNode43.r - 1.0 ) + ( i.vertexColor.r * 2.0 ) ) , 0.0 , 1.0 );
			float lerpResult11_g10 = lerp( ( 0.0 - temp_output_7_0_g10 ) , ( temp_output_7_0_g10 + 1.0 ) , clampResult6_g10);
			float clampResult12_g10 = clamp( lerpResult11_g10 , 0.0 , 1.0 );
			float RChannelLerp47 = clampResult12_g10;
			float4 lerpResult53 = lerp( tex2DNode1 , lerpResult50 , ( 1.0 - RChannelLerp47 ));
			float4 BaseColor18 = lerpResult53;
			o.Albedo = BaseColor18.rgb;
			o.Metallic = 0.0;
			float lerpResult11 = lerp( _RoughnessMin , _RoughnessMax , tex2D( _RoughnessMap, WorldUV15 ).r);
			float lerpResult67 = lerp( _WaterRoughness , 0.1 , BChannelLerp49);
			float temp_output_7_0_g9 = _BlendContrast;
			float clampResult6_g9 = clamp( ( ( tex2DNode43.r - 1.0 ) + ( i.vertexColor.g * 2.0 ) ) , 0.0 , 1.0 );
			float lerpResult11_g9 = lerp( ( 0.0 - temp_output_7_0_g9 ) , ( temp_output_7_0_g9 + 1.0 ) , clampResult6_g9);
			float clampResult12_g9 = clamp( lerpResult11_g9 , 0.0 , 1.0 );
			float GChannelLerp48 = clampResult12_g9;
			float lerpResult58 = lerp( lerpResult11 , lerpResult67 , ( 1.0 - GChannelLerp48 ));
			float Roughness21 = lerpResult58;
			o.Smoothness = ( 1.0 - Roughness21 );
			float AO20 = tex2D( _AOMap, WorldUV15 ).r;
			o.Occlusion = AO20;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				half4 color : COLOR0;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
50;824;1364;731;8022.6;2759.133;5.772489;True;True
Node;AmplifyShaderEditor.CommentaryNode;16;-4599.871,-1566.01;Inherit;False;1607.078;835.4497;WorldUV;15;33;37;36;35;34;32;9;8;10;7;30;15;106;107;105;WorldUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-4535.891,-1505.021;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;105;-4063.107,-915.345;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;92;-3091.719,1249.314;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;87;-2926.156,1212.586;Inherit;False;2269.695;1343.549;PuddleNormal;31;96;94;95;86;88;90;89;85;69;70;84;74;82;79;76;72;83;81;75;78;93;73;77;97;98;99;100;101;102;103;104;PuddleNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4338.519,-1375.217;Inherit;False;Property;_Tilling;Tilling;0;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;8;-4304.519,-1506.217;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-4366.262,-1179.483;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-4522.694,-1280.18;Inherit;False;Property;_POMScale;POMScale;10;0;Create;True;0;0;False;0;False;0;-0.2;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-3979.825,-991.5964;Inherit;False;Property;_POMPlane;POMPlane;11;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;-3836.108,-924.345;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;36;-3825.027,-1114.262;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-3658.108,-986.345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;32;-4567.275,-1067.438;Inherit;True;Property;_Height;Height;9;0;Create;True;0;0;False;0;False;None;de1bdfa4bde2d46429cdfdd983cf7282;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-4122.519,-1478.217;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-4153.14,-1253.161;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;75;-2866.509,1468.193;Inherit;False;Property;_WaveSpeed;WaveSpeed;17;0;Create;True;0;0;False;0;False;1,1;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;73;-2864.049,1356.09;Inherit;False;Property;_WaveTilling;WaveTilling;16;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2860.156,1688.719;Inherit;False;Constant;_Float2;Float 2;17;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;77;-2876.156,1610.719;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;93;-2889.719,1266.314;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-2670.031,1536.512;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;98;-2541.462,1838.432;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;83;-2593.688,1741.637;Inherit;False;Constant;_Float4;Float 4;17;0;Create;True;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;30;-3513.816,-1260.493;Inherit;False;0;8;False;-1;16;False;-1;6;0.02;0;False;1,1;False;0,0;Texture2D;7;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-2633.579,1427.753;Inherit;False;Constant;_Float3;Float 3;17;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-2625.532,1291.32;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-2373.167,1680.732;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;46;-4592.108,-659.5457;Inherit;False;1266.415;708.759;Comment;10;49;48;47;45;42;41;40;43;44;38;BlendFactor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-2373.262,1514.386;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-3219.063,-1278.606;Inherit;False;WorldUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-2486.312,1990.685;Inherit;False;Property;_RainDropTilling;RainDropTilling;21;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;99;-2339.463,1855.432;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-2186.937,1857.688;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-2206.512,1576.927;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-2403.662,1320.089;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-4475.925,-587.6423;Inherit;False;15;WorldUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-4378.783,-151.9073;Inherit;False;Property;_BlendContrast;BlendContrast;12;0;Create;True;0;0;False;0;False;0;0.262;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;69;-2089.524,1295.676;Inherit;True;Property;_WaterNormal;WaterNormal;15;0;Create;True;0;0;False;0;False;-1;None;07dc77e508f417a479281b45df844175;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;102;-2068.532,1937.34;Inherit;False;Property;_Columns;Columns;22;0;Create;True;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-2146.205,2013.731;Inherit;False;Property;_RainDropSpeed;RainDropSpeed;23;0;Create;True;0;0;False;0;False;0;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-4273.992,-609.5457;Inherit;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;103;-2024.437,1859.471;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;70;-2084.786,1549.673;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;69;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;38;-4366.873,-387.4209;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;89;-1650.741,1275.723;Inherit;False;Constant;_Vector1;Vector 1;17;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;61;-2889.141,-824.9108;Inherit;False;1397.829;724.8408;Roughness;12;59;57;21;58;11;60;3;13;12;27;67;68;Roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;42;-3865.236,-144.8691;Inherit;False;HeightLerp;-1;;8;176374bc478a52e498af414a1d11514f;0;3;1;FLOAT;0;False;4;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;95;-1839.705,1867.814;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;2;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;41;-3866.534,-319.0691;Inherit;False;HeightLerp;-1;;9;176374bc478a52e498af414a1d11514f;0;3;1;FLOAT;0;False;4;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;85;-1685.595,1442.509;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1743.741,1604.723;Inherit;False;Property;_WaveIntensity;WaveIntensity;18;0;Create;True;0;0;False;0;False;0.2;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1812.534,2108.142;Inherit;False;Property;_RainIntensity;RainIntensity;20;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;40;-3872.492,-481.8019;Inherit;False;HeightLerp;-1;;10;176374bc478a52e498af414a1d11514f;0;3;1;FLOAT;0;False;4;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-3566.181,-136.9257;Inherit;False;BChannelLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;88;-1378.741,1438.723;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-3574.181,-318.9257;Inherit;False;GChannelLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2839.141,-569.4229;Inherit;False;15;WorldUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;56;-2870.922,-1572.585;Inherit;False;1451.719;590.0042;BaseColor;9;17;1;50;52;51;54;18;53;55;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;94;-1488.324,1872.978;Inherit;True;Property;_RainDrop;RainDrop;19;0;Create;True;0;0;False;0;False;-1;None;3f15c5b716a75d240b55d70bfd2de9bb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-3580.181,-479.9257;Inherit;False;RChannelLerp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-2820.922,-1478.006;Inherit;False;15;WorldUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2336.16,-526.5753;Inherit;False;Property;_WaterRoughness;WaterRoughness;7;0;Create;True;0;0;False;0;False;0;0.01;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2327.569,-420.2354;Inherit;False;49;BChannelLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2633.702,-693.0605;Inherit;False;Property;_RoughnessMax;RoughnessMax;6;0;Create;True;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2631.806,-774.9108;Inherit;False;Property;_RoughnessMin;RoughnessMin;5;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-2323.959,-285.0797;Inherit;False;48;GChannelLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;97;-1148.82,1779.934;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;3;-2639.129,-590.3386;Inherit;True;Property;_RoughnessMap;RoughnessMap;4;0;Create;True;0;0;False;0;False;-1;None;2d0c738b6f39b0c48a4c9044231d6e8b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;66;-2906.042,150.1681;Inherit;False;1321.971;436.5518;Normal;8;26;14;2;62;65;19;63;91;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2838.085,200.168;Inherit;False;15;WorldUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2856.042,285.7722;Inherit;False;Property;_NormalIntensity;NormalIntensity;3;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-901.1768,1774.076;Inherit;False;PuddleNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2549.885,-1098.581;Inherit;False;Property;_PuddleDepth;PuddleDepth;14;0;Create;True;0;0;False;0;False;0;0.72;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-2027.91,-515.3264;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2587.175,-1522.585;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;False;-1;None;58b6821040fd99a48b5c545e30950322;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-2283.833,-709.4764;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;51;-2554.885,-1302.581;Inherit;False;Property;_PudlleColor;PudlleColor;13;0;Create;True;0;0;False;0;False;0,0,0,0;0.3098039,0.3098039,0.3098039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2521.977,415.9337;Inherit;False;49;BChannelLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-2242.087,-1206.291;Inherit;False;47;RChannelLerp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-2133.67,-295.8224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;-2267.615,420.685;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-2790.831,831.5844;Inherit;False;15;WorldUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-2292.997,295.9606;Inherit;False;86;PuddleNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;55;-2007.747,-1316.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;-2211.171,-1393.125;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-2604.062,205.2783;Inherit;True;Property;_NormalMap;NormalMap;2;0;Create;True;0;0;False;0;False;-1;None;d11c20650a97fc248957a5f62dbedd30;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;58;-1855.202,-562.762;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;63;-2008.411,220.0414;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;5;-2594.874,796.7623;Inherit;True;Property;_AOMap;AOMap;8;0;Create;True;0;0;False;0;False;-1;None;c861c7297a578654789cda564d34847e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1680.66,-710.4082;Inherit;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;-1824.992,-1504.141;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-2273.57,813.1934;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-1808.072,221.6754;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-459.6465,150.1409;Inherit;False;21;Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1643.204,-1499.111;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-256.7891,73.29046;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-242.96,240.7993;Inherit;False;20;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;4;-247.746,154.3162;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-304.7703,-116.5049;Inherit;False;18;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-301.7703,-33.50484;Inherit;False;19;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASE/Ground;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;106;0;105;3
WireConnection;107;0;37;0
WireConnection;107;1;106;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;93;0;92;0
WireConnection;76;0;75;0
WireConnection;76;1;77;0
WireConnection;76;2;78;0
WireConnection;30;0;9;0
WireConnection;30;1;32;0
WireConnection;30;2;34;0
WireConnection;30;3;36;0
WireConnection;30;4;107;0
WireConnection;72;0;93;0
WireConnection;72;1;73;0
WireConnection;82;0;76;0
WireConnection;82;1;83;0
WireConnection;79;0;72;0
WireConnection;79;1;81;0
WireConnection;15;0;30;0
WireConnection;99;0;98;0
WireConnection;100;0;99;0
WireConnection;100;1;101;0
WireConnection;84;0;79;0
WireConnection;84;1;82;0
WireConnection;74;0;72;0
WireConnection;74;1;76;0
WireConnection;69;1;74;0
WireConnection;43;0;32;0
WireConnection;43;1;44;0
WireConnection;103;0;100;0
WireConnection;70;1;84;0
WireConnection;42;1;43;1
WireConnection;42;4;38;3
WireConnection;42;7;45;0
WireConnection;95;0;103;0
WireConnection;95;1;102;0
WireConnection;95;2;102;0
WireConnection;95;3;104;0
WireConnection;41;1;43;1
WireConnection;41;4;38;2
WireConnection;41;7;45;0
WireConnection;85;0;69;0
WireConnection;85;1;70;0
WireConnection;40;1;43;1
WireConnection;40;4;38;1
WireConnection;40;7;45;0
WireConnection;49;0;42;0
WireConnection;88;0;89;0
WireConnection;88;1;85;0
WireConnection;88;2;90;0
WireConnection;48;0;41;0
WireConnection;94;1;95;0
WireConnection;94;5;96;0
WireConnection;47;0;40;0
WireConnection;97;0;88;0
WireConnection;97;1;94;0
WireConnection;3;1;27;0
WireConnection;86;0;97;0
WireConnection;67;0;60;0
WireConnection;67;2;68;0
WireConnection;1;1;17;0
WireConnection;11;0;12;0
WireConnection;11;1;13;0
WireConnection;11;2;3;1
WireConnection;59;0;57;0
WireConnection;65;0;62;0
WireConnection;55;0;54;0
WireConnection;50;0;1;0
WireConnection;50;1;51;0
WireConnection;50;2;52;0
WireConnection;2;1;26;0
WireConnection;2;5;14;0
WireConnection;58;0;11;0
WireConnection;58;1;67;0
WireConnection;58;2;59;0
WireConnection;63;0;2;0
WireConnection;63;1;91;0
WireConnection;63;2;65;0
WireConnection;5;1;28;0
WireConnection;21;0;58;0
WireConnection;53;0;1;0
WireConnection;53;1;50;0
WireConnection;53;2;55;0
WireConnection;20;0;5;1
WireConnection;19;0;63;0
WireConnection;18;0;53;0
WireConnection;4;0;24;0
WireConnection;0;0;22;0
WireConnection;0;1;23;0
WireConnection;0;3;29;0
WireConnection;0;4;4;0
WireConnection;0;5;25;0
ASEEND*/
//CHKSM=09179997570AC89972FE5CED7441F3649F050F07