// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/OutlineDoublePass"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_FreScale("FreScale", Float) = 1
		_FrePower("FrePower", Float) = 5
		[HDR]_OutlineColor("OutlineColor", Color) = (1,1,1,1)
		_OutlineWith("OutlineWith", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZtestMode("ZtestMode", Float) = 0

	}
	
	SubShader
	{
		LOD 0

		Tags { "RenderType"="Transparent" }
		
		Pass
		{
			
			Name "First"
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			ColorMask RGBA
			ZWrite Off
			ZTest [_ZtestMode]
			Stencil
			{
				Ref 1
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			uniform float _ZtestMode;
			uniform float _OutlineWith;
			uniform float4 _OutlineColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				
				
				v.vertex.xyz += ( v.ase_normal * _OutlineWith );
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				
				
				finalColor = _OutlineColor;
				return finalColor;
			}
			ENDCG
		}

		
		Pass
		{
			Name "Second"
			
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Back
			ColorMask RGBA
			ZWrite Off
			ZTest [_ZtestMode]
			Stencil
			{
				Ref 1
				Comp Equal
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform float _ZtestMode;
			uniform float4 _MainColor;
			uniform float _FreScale;
			uniform float _FrePower;
			uniform float _Opacity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float fresnelNdotV17 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode17 = ( 0.0 + _FreScale * pow( 1.0 - fresnelNdotV17, _FrePower ) );
				float4 appendResult15 = (float4((( (_MainColor).rgb * fresnelNode17 )).xyz , _Opacity));
				
				
				finalColor = appendResult15;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
-1234;17;1213;733;1556.92;848.0219;1.710309;True;False
Node;AmplifyShaderEditor.ColorNode;8;-1273.068,-17.6379;Inherit;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0,1,0.01568628,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1399.143,216.5178;Inherit;False;Property;_FreScale;FreScale;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1391.895,311.0912;Inherit;False;Property;_FrePower;FrePower;3;0;Create;True;0;0;False;0;False;5;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;17;-1162.414,178.6947;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;-1009.916,47.5195;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-754.0179,106.3857;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-852.7802,353.4945;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;28;-759.0766,-815.5342;Inherit;False;231;166;Comment;1;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;14;-581.749,118.3042;Inherit;False;True;True;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;10;-735.7757,-336.339;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-344.7814,137.9339;Inherit;True;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;9;-743.978,-553.6196;Inherit;False;Property;_OutlineColor;OutlineColor;4;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-709.0766,-765.5342;Inherit;False;Property;_ZtestMode;ZtestMode;6;1;[Enum];Create;True;1;Option1;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-424.5225,-268.286;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-722.2457,-172.9452;Inherit;False;Property;_OutlineWith;OutlineWith;5;0;Create;True;0;0;False;0;False;0;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;7;-2.690107,135.1348;Float;False;False;-1;2;ASEMaterialInspector;0;9;New Amplify Shader;003dfa9c16768d048b74f75c088119d8;True;Second;0;1;Second;2;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;0;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;True;1;False;-1;255;False;-1;255;False;-1;5;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;7;True;13;True;False;0;False;-1;0;False;-1;True;0;True;2;0;;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;-31.81056,-428.0174;Float;False;True;-1;2;ASEMaterialInspector;0;9;Whl/OutlineDoublePass;003dfa9c16768d048b74f75c088119d8;True;First;0;0;First;2;False;False;False;False;False;False;False;False;False;True;1;RenderType=Transparent=RenderType;False;0;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;1;False;-1;True;True;True;True;True;0;False;-1;True;True;1;False;-1;255;False;-1;255;False;-1;5;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;True;13;True;False;0;False;-1;0;False;-1;True;0;True;2;0;;0;0;Standard;0;0;2;True;True;False;;0
WireConnection;17;2;18;0
WireConnection;17;3;19;0
WireConnection;33;0;8;0
WireConnection;20;0;33;0
WireConnection;20;1;17;0
WireConnection;14;0;20;0
WireConnection;15;0;14;0
WireConnection;15;3;24;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;7;0;15;0
WireConnection;6;0;9;0
WireConnection;6;1;11;0
ASEEND*/
//CHKSM=984F5750C423A512B3F24F6F9764BA137DD5BC50