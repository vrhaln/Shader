// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Screen/SpeedLine"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_RGBAMask("RGBA Mask", Vector) = (0,0,0,0)
		_TlingOffset("TlingOffset", Vector) = (0,0,0,0)
		_SpeedTime("SpeedTime", Vector) = (1,1,0,0)
		_Color("Color", Color) = (1,1,1,1)
		_Scale("Scale", Float) = 1
		_Alpha("Alpha", Float) = 1
		_Mask("Mask", 2D) = "white" {}
		_MaskTlingOffset("MaskTlingOffset", Vector) = (0,0,0,0)
		_MaskScale("MaskScale", Float) = 0
		[Toggle(_MULMAINTEXCHANNEL_ON)] _MulMainTexChannel("MulMainTexChannel", Float) = 0
		[Enum(OFF,0,ON,1)]_Int0("主贴图UV是否极坐标", Int) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature_local _MULMAINTEXCHANNEL_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
			};

			uniform sampler2D _MainTex;
			uniform half4 _SpeedTime;
			uniform int _Int0;
			uniform half4 _TlingOffset;
			uniform half4 _Color;
			uniform half _Scale;
			uniform half4 _RGBAMask;
			uniform sampler2D _Mask;
			uniform half4 _MaskTlingOffset;
			uniform half _MaskScale;
			uniform float _Alpha;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
				o.ase_color = v.color;
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
				half mulTime16 = _Time.y * _SpeedTime.z;
				half2 appendResult15 = (half2(_SpeedTime.x , _SpeedTime.y));
				float4 screenPos = i.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				half2 appendResult8 = (half2(ase_screenPosNorm.x , ase_screenPosNorm.y));
				half2 appendResult34 = (half2(ase_screenPosNorm.x , ase_screenPosNorm.y));
				half2 temp_output_35_0 = (appendResult34*2.0 + -1.0);
				half2 break37 = temp_output_35_0;
				half2 appendResult40 = (half2(length( temp_output_35_0 ) , (0.0 + (atan2( break37.y , break37.x ) - 0.0) * (1.0 - 0.0) / (3.141593 - 0.0))));
				half2 lerpResult43 = lerp( appendResult8 , appendResult40 , (float)_Int0);
				half2 appendResult12 = (half2(_TlingOffset.x , _TlingOffset.y));
				half2 appendResult13 = (half2(_TlingOffset.z , _TlingOffset.w));
				half2 panner9 = ( ( mulTime16 + _SpeedTime.w ) * appendResult15 + (lerpResult43*appendResult12 + appendResult13));
				half4 tex2DNode1 = tex2D( _MainTex, panner9 );
				#ifdef _MULMAINTEXCHANNEL_ON
				half staticSwitch41 = ( ( _RGBAMask.x * tex2DNode1.r ) + ( _RGBAMask.y * tex2DNode1.g ) + ( _RGBAMask.z * tex2DNode1.b ) + ( _RGBAMask.w * tex2DNode1.a ) );
				#else
				half staticSwitch41 = 1.0;
				#endif
				half2 appendResult26 = (half2(_MaskTlingOffset.x , _MaskTlingOffset.y));
				half2 appendResult29 = (half2(_MaskTlingOffset.z , _MaskTlingOffset.w));
				half4 appendResult5 = (half4(( tex2DNode1 * _Color * _Scale ).rgb , ( staticSwitch41 * ( tex2D( _Mask, (appendResult8*appendResult26 + appendResult29) ).r * _MaskScale ) * _Alpha * i.ase_color.a )));
				
				
				finalColor = appendResult5;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
-1298;91;1298;928;5972.788;3044.4;7.425797;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;7;-3563.668,-95.4793;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;34;-3239.374,63.69155;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;35;-3009.359,65.90997;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;37;-2684.367,299.8083;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ATan2OpNode;38;-2431.541,297.9258;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;-2161.33,300.1744;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3.141593;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;36;-2056.557,156.3581;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1905.466,-16.07685;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1847.341,-156.6212;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;45;-1698.679,-212.9645;Inherit;False;Property;_Int0;主贴图UV是否极坐标;11;1;[Enum];Create;False;2;OFF;0;ON;1;0;True;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.Vector4Node;11;-1611.663,49.92395;Inherit;False;Property;_TlingOffset;TlingOffset;2;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;14;-1176.629,116.9056;Inherit;False;Property;_SpeedTime;SpeedTime;3;0;Create;True;0;0;False;0;False;1,1,0,0;0,0,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;16;-963.5093,194.3958;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;-1449.524,-163.6856;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1408.238,8.210131;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1385.663,125.9239;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-954.4011,86.44792;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;10;-1217.238,-92.78987;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-792.5082,196.3816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;9;-697.5952,-62.11224;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;30;-727.8485,882.2355;Inherit;False;Property;_MaskTlingOffset;MaskTlingOffset;8;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-501.8485,958.2354;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-502.332,853.0064;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;19;-283.6089,433.7822;Inherit;False;Property;_RGBAMask;RGBA Mask;1;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-459.0866,-84.21609;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;54.23743,388.9388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;28;-312.0982,772.6945;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;55.73224,481.6151;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;55.73224,578.7759;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;51.24786,290.2833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;11.119,744.0894;Inherit;True;Property;_Mask;Mask;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;319.9381,391.5798;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;168.0702,965.8698;Inherit;False;Property;_MaskScale;MaskScale;9;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;380.29,288.0253;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;395.4909,792.0864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;41;624.29,368.0253;Inherit;False;Property;_MulMainTexChannel;MulMainTexChannel;10;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;728.001,673.8826;Float;False;Property;_Alpha;Alpha;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-338.1867,296.684;Inherit;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-377.1866,118.5839;Inherit;False;Property;_Color;Color;4;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;46;694.6226,804.9386;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-84.68675,10.68389;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;925.6873,457.1391;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;1132.861,80.83583;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1319.733,79.49974;Half;False;True;-1;2;ASEMaterialInspector;100;1;ASE/Screen/SpeedLine;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;34;0;7;1
WireConnection;34;1;7;2
WireConnection;35;0;34;0
WireConnection;37;0;35;0
WireConnection;38;0;37;1
WireConnection;38;1;37;0
WireConnection;39;0;38;0
WireConnection;36;0;35;0
WireConnection;40;0;36;0
WireConnection;40;1;39;0
WireConnection;8;0;7;1
WireConnection;8;1;7;2
WireConnection;16;0;14;3
WireConnection;43;0;8;0
WireConnection;43;1;40;0
WireConnection;43;2;45;0
WireConnection;12;0;11;1
WireConnection;12;1;11;2
WireConnection;13;0;11;3
WireConnection;13;1;11;4
WireConnection;15;0;14;1
WireConnection;15;1;14;2
WireConnection;10;0;43;0
WireConnection;10;1;12;0
WireConnection;10;2;13;0
WireConnection;17;0;16;0
WireConnection;17;1;14;4
WireConnection;9;0;10;0
WireConnection;9;2;15;0
WireConnection;9;1;17;0
WireConnection;29;0;30;3
WireConnection;29;1;30;4
WireConnection;26;0;30;1
WireConnection;26;1;30;2
WireConnection;1;1;9;0
WireConnection;21;0;19;2
WireConnection;21;1;1;2
WireConnection;28;0;8;0
WireConnection;28;1;26;0
WireConnection;28;2;29;0
WireConnection;22;0;19;3
WireConnection;22;1;1;3
WireConnection;23;0;19;4
WireConnection;23;1;1;4
WireConnection;20;0;19;1
WireConnection;20;1;1;1
WireConnection;25;1;28;0
WireConnection;24;0;20;0
WireConnection;24;1;21;0
WireConnection;24;2;22;0
WireConnection;24;3;23;0
WireConnection;32;0;25;1
WireConnection;32;1;33;0
WireConnection;41;1;42;0
WireConnection;41;0;24;0
WireConnection;4;0;1;0
WireConnection;4;1;2;0
WireConnection;4;2;3;0
WireConnection;18;0;41;0
WireConnection;18;1;32;0
WireConnection;18;2;6;0
WireConnection;18;3;46;4
WireConnection;5;0;4;0
WireConnection;5;3;18;0
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=5F330C56E10FF0DFE398076384F27C1CBD85D24F