// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Stencil/StencilObject"
{
	Properties
	{
		_EmissionColor("EmissionColor", Color) = (1,1,1,1)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_FreScale1("FreScale", Float) = 1
		_FrePower1("FrePower", Float) = 5
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZtestMode("ZtestMode", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest [_ZtestMode]
		Stencil
		{
			Ref 1
			Comp Equal
			Pass Replace
		}
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
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

		uniform float _ZtestMode;
		uniform float4 _EmissionColor;
		uniform float _FreScale1;
		uniform float _FrePower1;
		uniform float _Opacity;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV6 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode6 = ( 0.0 + _FreScale1 * pow( 1.0 - fresnelNdotV6, _FrePower1 ) );
			c.rgb = 0;
			c.a = ( fresnelNode6 * _Opacity );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV6 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode6 = ( 0.0 + _FreScale1 * pow( 1.0 - fresnelNdotV6, _FrePower1 ) );
			o.Emission = ( _EmissionColor * fresnelNode6 ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
89;496;1213;650;1384.875;199.2092;1.6;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-770.3563,205.5494;Inherit;False;Property;_FreScale1;FreScale;3;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-779.3823,291.0693;Inherit;False;Property;_FrePower1;FrePower;4;0;Create;True;0;0;False;0;False;5;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-505.0432,-32.40484;Inherit;False;Property;_EmissionColor;EmissionColor;1;0;Create;True;0;0;False;0;False;1,1,1,1;0,1,0.01689792,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;6;-613.3331,157.0642;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-589.1394,396.7946;Inherit;False;Property;_Opacity;Opacity;2;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-352.1972,-137.7271;Inherit;False;Property;_ZtestMode;ZtestMode;5;1;[Enum];Create;True;1;Option1;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-208.339,297.4641;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-249.5904,16.89428;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;17.32409,-20.57326;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Stencil/StencilObject;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;2;False;-1;4;True;3;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;5;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;2;4;0
WireConnection;6;3;5;0
WireConnection;8;0;6;0
WireConnection;8;1;2;0
WireConnection;7;0;1;0
WireConnection;7;1;6;0
WireConnection;0;2;7;0
WireConnection;0;9;8;0
ASEEND*/
//CHKSM=FF438700BFC705BE581510A2978A20D940C36FB5