// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Particle/SwordSlash2"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_MainTexture("MainTexture", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		_Emission("Emission", Float) = 0
		[Toggle(_USEBLACK_ON)] _UseBlack("UseBlack", Float) = 0
		_Dissolve("Dissolve", 2D) = "white" {}
		_SpeedNoiseZW("Speed Noise Z/W", Vector) = (0,0,0,0)

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_FRAG_COLOR
				#pragma shader_feature_local _USEBLACK_ON


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					float4 ase_texcoord1 : TEXCOORD1;
					float4 ase_texcoord2 : TEXCOORD2;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					float4 ase_texcoord3 : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				uniform float4 _Color;
				uniform sampler2D _MainTexture;
				uniform float _Emission;
				uniform sampler2D _Dissolve;
				SamplerState sampler_Dissolve;
				uniform float2 _SpeedNoiseZW;


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.ase_texcoord3 = v.ase_texcoord1;
					o.ase_texcoord4 = v.ase_texcoord2;

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float4 temp_cast_0 = (1.0).xxxx;
					float4 texCoord58 = i.ase_texcoord3;
					texCoord58.xy = i.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
					float4 temp_cast_1 = (texCoord58.z).xxxx;
					float4 temp_cast_2 = (( texCoord58.z + texCoord58.w )).xxxx;
					float4 texCoord62 = i.texcoord;
					texCoord62.xy = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float U63 = texCoord62.x;
					float temp_output_65_0 = (1.0 + (saturate( texCoord58.y ) - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
					float V64 = texCoord62.y;
					float2 appendResult75 = (float2(( saturate( ( ( pow( (2.5 + (( 1.0 + texCoord58.x ) - 0.0) * (1.0 - 2.5) / (1.0 - 0.0)) , 5.0 ) * U63 ) - temp_output_65_0 ) ) * ( 1.0 / (1.0 + (temp_output_65_0 - 0.0) * (0.001 - 1.0) / (1.0 - 0.0)) ) ) , V64));
					float4 smoothstepResult77 = smoothstep( temp_cast_1 , temp_cast_2 , tex2D( _MainTexture, saturate( appendResult75 ) ));
					float4 temp_output_80_0 = saturate( smoothstepResult77 );
					#ifdef _USEBLACK_ON
					float4 staticSwitch89 = temp_output_80_0;
					#else
					float4 staticSwitch89 = temp_cast_0;
					#endif
					float2 appendResult92 = (float2(_SpeedNoiseZW.x , _SpeedNoiseZW.y));
					float4 texCoord105 = i.ase_texcoord4;
					texCoord105.xy = i.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
					float2 panner93 = ( 1.0 * _Time.y * appendResult92 + texCoord105.xy);
					float2 break94 = panner93;
					float2 appendResult98 = (float2(break94.x , ( 0.0 + break94.y )));
					float T95 = texCoord105.w;
					float W96 = texCoord105.z;
					float3 _Vector1 = float3(0.3,0,1);
					float ifLocalVar104 = 0;
					if( ( tex2D( _Dissolve, appendResult98 ).r * T95 ) >= W96 )
					ifLocalVar104 = _Vector1.y;
					else
					ifLocalVar104 = _Vector1.z;
					float4 appendResult87 = (float4((( _Color * staticSwitch89 * _Emission * i.color )).rgb , ( _Color.a * (temp_output_80_0).r * i.color.a * ifLocalVar104 )));
					

					fixed4 col = appendResult87;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18500
-1653;136;1565;883;3736.104;1524.617;4.7478;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-1815.592,358.1487;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1497.391,-152.6242;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-1364.938,180.8076;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;67;-1331.346,-166.9792;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-1076.819,145.3694;Inherit;False;U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;69;-1108.574,-311.0414;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;61;-1467.093,88.85907;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;65;-821.9592,17.12683;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-811.5059,-224.5456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;66;-577.5091,17.85241;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-630.5059,-227.5456;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;106;-1706.492,885.394;Inherit;False;Property;_SpeedNoiseZW;Speed Noise Z/W;5;0;Create;True;0;0;False;0;False;0,0;-0.8,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;73;-359.3517,-15.02595;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;72;-385.3268,-226.4501;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1074.819,220.3694;Inherit;False;V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;105;-1420.695,716.0763;Inherit;False;2;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;92;-1298.067,927.4235;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-174.2206,-169.7752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;75;-7.194432,197.1061;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;93;-1051.498,903.8339;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;94;-784.004,900.4352;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;76;180.5887,218.2763;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;443.1359,470.3285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-471.6231,830.7761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;365.9716,204.4988;Inherit;True;Property;_MainTexture;MainTexture;0;0;Create;True;0;0;False;0;False;-1;None;54f681889f3180b4a9dbd61d5b13c3b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;77;733.1589,355.5635;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-1022.213,821.8033;Float;False;T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-285.1762,894.1429;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;90;934.0796,241.1864;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-28.71514,1055.044;Inherit;False;95;T;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-1025.458,746.8176;Float;False;W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;80;953.374,382.3364;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;100;-141.7631,868.0414;Inherit;True;Property;_Dissolve;Dissolve;4;0;Create;True;0;0;False;0;False;-1;None;1a7f074f01ec95d45a96f2f6196edd36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;103;185.0922,1067.271;Float;False;Constant;_Vector1;Vector 1;4;0;Create;True;0;0;False;0;False;0.3,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;89;1136.897,262.3779;Inherit;False;Property;_UseBlack;UseBlack;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;1068.719,147.585;Inherit;False;Property;_Emission;Emission;2;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;956.7121,-64.3502;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;85;1146.612,582.8497;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;101;187.8525,991.6236;Inherit;False;96;W;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;195.4684,896.82;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1469.312,167.6498;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;104;864.1924,911.1982;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;84;1122.612,443.8498;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;86;1648.939,165.2239;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1430.612,530.8497;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;87;1948.239,347.6239;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;57;2196.713,342.7679;Float;False;True;-1;2;ASEMaterialInspector;0;7;ASE/Particle/SwordSlash2;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;2;False;-1;True;True;True;True;False;0;False;-1;False;False;False;False;True;2;False;-1;True;3;False;-1;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;59;1;58;1
WireConnection;67;0;59;0
WireConnection;63;0;62;1
WireConnection;69;0;67;0
WireConnection;61;0;58;2
WireConnection;65;0;61;0
WireConnection;70;0;69;0
WireConnection;70;1;63;0
WireConnection;66;0;65;0
WireConnection;71;0;70;0
WireConnection;71;1;65;0
WireConnection;73;1;66;0
WireConnection;72;0;71;0
WireConnection;64;0;62;2
WireConnection;92;0;106;1
WireConnection;92;1;106;2
WireConnection;74;0;72;0
WireConnection;74;1;73;0
WireConnection;75;0;74;0
WireConnection;75;1;64;0
WireConnection;93;0;105;0
WireConnection;93;2;92;0
WireConnection;94;0;93;0
WireConnection;76;0;75;0
WireConnection;79;0;58;3
WireConnection;79;1;58;4
WireConnection;97;1;94;1
WireConnection;2;1;76;0
WireConnection;77;0;2;0
WireConnection;77;1;58;3
WireConnection;77;2;79;0
WireConnection;95;0;105;4
WireConnection;98;0;94;0
WireConnection;98;1;97;0
WireConnection;96;0;105;3
WireConnection;80;0;77;0
WireConnection;100;1;98;0
WireConnection;89;1;90;0
WireConnection;89;0;80;0
WireConnection;102;0;100;1
WireConnection;102;1;99;0
WireConnection;81;0;82;0
WireConnection;81;1;89;0
WireConnection;81;2;88;0
WireConnection;81;3;85;0
WireConnection;104;0;102;0
WireConnection;104;1;101;0
WireConnection;104;2;103;2
WireConnection;104;3;103;2
WireConnection;104;4;103;3
WireConnection;84;0;80;0
WireConnection;86;0;81;0
WireConnection;83;0;82;4
WireConnection;83;1;84;0
WireConnection;83;2;85;4
WireConnection;83;3;104;0
WireConnection;87;0;86;0
WireConnection;87;3;83;0
WireConnection;57;0;87;0
ASEEND*/
//CHKSM=D56E127183A2BD12AFD9DDF327A20C233EA87B70