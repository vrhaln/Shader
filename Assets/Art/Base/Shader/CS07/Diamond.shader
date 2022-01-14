// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Diamond"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_RefractTex("RefractTex", CUBE) = "white" {}
		_ReflectTex("ReflectTex", CUBE) = "white" {}
		_RefractIntensity("RefractIntensity", Float) = 0
		_ReflectIntensity("ReflectIntensity", Float) = 0
		_RimBias("RimBias", Float) = 0
		_RimPower("RimPower", Float) = 2
		_RimScale("RimScale", Float) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }
	LOD 100
		
		
		Pass
		{
			Name "Unlit"
			Blend One Zero
			ZWrite On
			ZTest LEqual
			Cull Front
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color;
			uniform samplerCUBE _RefractTex;
			uniform samplerCUBE _ReflectTex;
			uniform float _RefractIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float3 ase_worldReflection = reflect(-ase_worldViewDir, ase_worldNormal);
				float4 texCUBENode7 = texCUBE( _ReflectTex, ase_worldReflection );
				float4 temp_output_12_0 = ( _Color * texCUBE( _RefractTex, reflect( -ase_worldViewDir , ase_worldNormal ) ) * texCUBENode7 * _RefractIntensity );
				
				
				finalColor = temp_output_12_0;
				return finalColor;
			}
			ENDCG
		}
		
		Pass
		{
				Name "Second"
				Blend One One
				ZWrite On
				ZTest LEqual
				Cull Back
				CGPROGRAM
				
				
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				//only defining to not throw compilation error over Unity 5.5
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"
				#define ASE_NEEDS_FRAG_WORLD_POSITION


				struct appdata
				{
					float4 vertex : POSITION;
					float4 color : COLOR;
					float3 ase_normal : NORMAL;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
					float3 worldPos : TEXCOORD0;
					#endif
					float4 ase_texcoord1 : TEXCOORD1;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				uniform float4 _Color;
				uniform samplerCUBE _RefractTex;
				uniform samplerCUBE _ReflectTex;
				uniform float _RefractIntensity;
				uniform float _ReflectIntensity;
				uniform float _RimPower;
				uniform float _RimScale;
				uniform float _RimBias;


				v2f vert(appdata v )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);

					float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
					o.ase_texcoord1.xyz = ase_worldNormal;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord1.w = 0;
					float3 vertexValue = float3(0, 0, 0);
					#if ASE_ABSOLUTE_VERTEX_POS
					vertexValue = v.vertex.xyz;
					#endif
					vertexValue = vertexValue;
					#if ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
					#else
					v.vertex.xyz += vertexValue;
					#endif
					o.vertex = UnityObjectToClipPos(v.vertex);

					#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
					o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					#endif
					return o;
				}

				fixed4 frag(v2f i ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(i);
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
					fixed4 finalColor;
					#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
					float3 WorldPosition = i.worldPos;
					#endif
					float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
					ase_worldViewDir = normalize(ase_worldViewDir);
					float3 ase_worldNormal = i.ase_texcoord1.xyz;
					float3 ase_worldReflection = reflect(-ase_worldViewDir, ase_worldNormal);
					float4 texCUBENode7 = texCUBE( _ReflectTex, ase_worldReflection );
					float4 temp_output_12_0 = ( _Color * texCUBE( _RefractTex, reflect( -ase_worldViewDir , ase_worldNormal ) ) * texCUBENode7 * _RefractIntensity );
					float3 normalizedWorldNormal = normalize( ase_worldNormal );
					float dotResult17 = dot( normalizedWorldNormal , ase_worldViewDir );
					float clampResult20 = clamp( dotResult17 , 0.0 , 1.0 );
					float temp_output_21_0 = ( 1.0 - clampResult20 );
					float4 temp_output_16_0 = ( temp_output_12_0 + ( texCUBENode7 * _ReflectIntensity * temp_output_21_0 ) );
					float saferPower22 = max( temp_output_21_0 , 0.0001 );
					

					finalColor = ( temp_output_16_0 + ( temp_output_16_0 * ( ( pow( saferPower22 , _RimPower ) * _RimScale ) + _RimBias ) ) );
					return finalColor;
				}
				ENDCG
			}
		
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18500
21;474;1339;812;1174.281;487.4184;1.784312;True;True
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;19;-1540.297,807.5149;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;18;-1555.202,621.6164;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;9;-1689.227,59.30678;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;17;-1282.748,721.0229;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;10;-1512.227,93.30679;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;11;-1665.509,221.575;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;20;-1047.687,719.543;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-865.332,726.4256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-711.0101,845.1633;Inherit;False;Property;_RimPower;RimPower;6;0;Create;True;0;0;False;0;False;2;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ReflectOpNode;8;-1351.086,141.1378;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldReflectionVector;31;-1290.423,347.3241;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;7;-1050.25,336.3381;Inherit;True;Property;_ReflectTex;ReflectTex;2;0;Create;True;0;0;False;0;False;-1;None;0641faea04029a244b9b496a1bba401e;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-495.5117,250.0954;Inherit;False;Property;_RefractIntensity;RefractIntensity;3;0;Create;True;0;0;False;0;False;0;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-736.666,520.6147;Inherit;False;Property;_ReflectIntensity;ReflectIntensity;4;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-1006.165,-85.75954;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;False;0,0,0,0;0.6981132,0.6981132,0.6981132,0.572549;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1049.256,105.8689;Inherit;True;Property;_RefractTex;RefractTex;1;0;Create;True;0;0;False;0;False;-1;None;ce57a93305ff61c458be1272e42650b5;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;22;-530.7751,753.6492;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-495.0107,862.1633;Inherit;False;Property;_RimScale;RimScale;7;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-211.4023,-34.38252;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-299.1075,866.7985;Inherit;False;Property;_RimBias;RimBias;5;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-434.6839,472.7148;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-309.8717,751.8834;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-143.817,774.0018;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;33.43412,445.5946;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;174.5168,555.6069;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;332.066,433.443;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;646.7158,421.7569;Float;False;False;-1;2;ASEMaterialInspector;100;9;New Amplify Shader;10215824774e6ba4184cedc0fe585d91;True;Second;0;1;Second;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;0;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;322.011,-37.84589;Float;False;True;-1;2;ASEMaterialInspector;100;9;Diamond;10215824774e6ba4184cedc0fe585d91;True;Unlit;0;0;Unlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;1;False;-1;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;2;True;True;False;;False;0
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;10;0;9;0
WireConnection;20;0;17;0
WireConnection;21;0;20;0
WireConnection;8;0;10;0
WireConnection;8;1;11;0
WireConnection;7;1;31;0
WireConnection;6;1;8;0
WireConnection;22;0;21;0
WireConnection;22;1;25;0
WireConnection;12;0;4;0
WireConnection;12;1;6;0
WireConnection;12;2;7;0
WireConnection;12;3;13;0
WireConnection;14;0;7;0
WireConnection;14;1;15;0
WireConnection;14;2;21;0
WireConnection;24;0;22;0
WireConnection;24;1;26;0
WireConnection;27;0;24;0
WireConnection;27;1;28;0
WireConnection;16;0;12;0
WireConnection;16;1;14;0
WireConnection;29;0;16;0
WireConnection;29;1;27;0
WireConnection;30;0;16;0
WireConnection;30;1;29;0
WireConnection;3;0;30;0
WireConnection;2;0;12;0
ASEEND*/
//CHKSM=4F6CF1B11DC1CBD55CA7D743A6DD715B5B956F64