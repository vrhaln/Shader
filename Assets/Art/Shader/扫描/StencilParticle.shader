// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Stencil/StencilParticle"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[HDR]_EmissionColor("EmissionColor", Color) = (1,1,1,1)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_FreScale("FreScale", Float) = 1
		_FrePower("FrePower", Float) = 5
		[Toggle(_RISALPHA_ON)] _RisAlpha("RisAlpha", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_PARTICLECONTROLUVOFFSET_ON)] _ParticleControlUVOffset("ParticleControlUVOffset", Float) = 0
		_RChannelPanner("RChannelPanner", Vector) = (0,0,1,0)
		_GChannelTiling("GChannelTiling", Vector) = (1,1,0,0)
		_GChannelPanner("GChannelPanner", Vector) = (0,0,1,0)
		_ScanOpacity("ScanOpacity", Range( 0 , 1)) = 0.5
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZtestMode("ZtestMode", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		ZWrite Off
		ZTest [_ZtestMode]
		Stencil
		{
			Ref 1
			CompFront Equal
			PassFront Replace
			CompBack Equal
			PassBack Replace
		}
		Blend [_Src] [_Dst]
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _PARTICLECONTROLUVOFFSET_ON
		#pragma shader_feature_local _RISALPHA_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv_tex4coord;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			half ASEVFace : VFACE;
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

		uniform float _Dst;
		uniform float _ZtestMode;
		uniform float _Src;
		uniform float _CullMode;
		uniform float4 _EmissionColor;
		uniform sampler2D _MainTex;
		uniform float3 _RChannelPanner;
		uniform float4 _MainTex_ST;
		uniform float _ScanOpacity;
		uniform float3 _GChannelPanner;
		uniform float2 _GChannelTiling;
		uniform float _Opacity;
		uniform float _FreScale;
		uniform float _FrePower;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime15 = _Time.y * _RChannelPanner.z;
			float2 appendResult14 = (float2(_RChannelPanner.x , _RChannelPanner.y));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner10 = ( mulTime15 * appendResult14 + uv0_MainTex);
			float2 appendResult37 = (float2(i.uv_tex4coord.z , i.uv_tex4coord.w));
			#ifdef _PARTICLECONTROLUVOFFSET_ON
				float2 staticSwitch36 = ( uv0_MainTex + appendResult37 );
			#else
				float2 staticSwitch36 = panner10;
			#endif
			float4 tex2DNode9 = tex2D( _MainTex, staticSwitch36 );
			#ifdef _RISALPHA_ON
				float staticSwitch24 = tex2DNode9.r;
			#else
				float staticSwitch24 = tex2DNode9.a;
			#endif
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 break31 = ase_worldNormal;
			float3 appendResult32 = (float3(break31.x , break31.y , -break31.z));
			float3 switchResult28 = (((i.ASEVFace>0)?(ase_worldNormal):(appendResult32)));
			float fresnelNdotV19 = dot( switchResult28, ase_worldViewDir );
			float fresnelNode19 = ( 0.0 + _FreScale * pow( 1.0 - fresnelNdotV19, _FrePower ) );
			c.rgb = 0;
			c.a = ( i.vertexColor.a * _Opacity * staticSwitch24 * saturate( ( 1.0 - fresnelNode19 ) ) );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float mulTime15 = _Time.y * _RChannelPanner.z;
			float2 appendResult14 = (float2(_RChannelPanner.x , _RChannelPanner.y));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner10 = ( mulTime15 * appendResult14 + uv0_MainTex);
			float2 appendResult37 = (float2(i.uv_tex4coord.z , i.uv_tex4coord.w));
			#ifdef _PARTICLECONTROLUVOFFSET_ON
				float2 staticSwitch36 = ( uv0_MainTex + appendResult37 );
			#else
				float2 staticSwitch36 = panner10;
			#endif
			float4 tex2DNode9 = tex2D( _MainTex, staticSwitch36 );
			float mulTime48 = _Time.y * _GChannelPanner.z;
			float2 appendResult47 = (float2(_GChannelPanner.x , _GChannelPanner.y));
			float2 uv_TexCoord44 = i.uv_texcoord * _GChannelTiling;
			float2 panner45 = ( mulTime48 * appendResult47 + uv_TexCoord44);
			float lerpResult50 = lerp( _ScanOpacity , 1.0 , tex2D( _MainTex, panner45 ).g);
			o.Emission = ( _EmissionColor * tex2DNode9.r * i.vertexColor * lerpResult50 ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1562;108;1562;911;1803.824;-15.5011;1;True;False
Node;AmplifyShaderEditor.WorldNormalVector;29;-2173.155,1097.098;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;31;-1991.156,1097.921;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NegateNode;33;-1752.628,1181.353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;13;-2159.193,-51.10683;Inherit;False;Property;_RChannelPanner;RChannelPanner;9;0;Create;True;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-2102.554,288.0404;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1971.192,40.8932;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-2105.513,152.6676;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1957.192,-57.10683;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;46;-2062.094,633.95;Inherit;False;Property;_GChannelPanner;GChannelPanner;11;0;Create;True;0;0;False;0;False;0,0,1;0,5,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1603.45,1097.508;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2110.766,-200.1068;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;37;-1881.77,360.5661;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;26;-1656.403,898.818;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;49;-2233.666,499.8279;Inherit;False;Property;_GChannelTiling;GChannelTiling;10;0;Create;True;0;0;False;0;False;1,1;1,15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;48;-1870.98,725.95;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1336.358,1120.6;Inherit;False;Property;_FrePower;FrePower;5;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;28;-1412.522,897.6591;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-2001.461,487.9155;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;10;-1761.192,-81.10682;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-1856.98,627.95;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1334.168,1037.359;Inherit;False;Property;_FreScale;FreScale;4;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1720.833,158.9174;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;19;-1086.124,897.8297;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;45;-1611.778,487.7281;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;36;-1518.856,94.22372;Inherit;False;Property;_ParticleControlUVOffset;ParticleControlUVOffset;8;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;20;-748.0261,882.6603;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1296.824,344.5011;Inherit;False;Property;_ScanOpacity;ScanOpacity;12;0;Create;True;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-1180.939,69.71751;Inherit;True;Property;_MainTex;MainTex;7;0;Create;True;0;0;False;0;False;-1;None;fd67039a540e4ae43878e96bc497d2d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-1358.599,461.6972;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;False;-1;None;fd67039a540e4ae43878e96bc497d2d5;True;0;False;white;Auto;False;Instance;9;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;50;-970.1823,381.8943;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;16;-812.1569,315.1668;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;21;-523.9504,864.4922;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-817.2758,764.3665;Inherit;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-1315.487,-597.345;Inherit;False;480.9432;261.6791;Blend&Depth Control;4;41;40;6;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;3;-820.64,-98.89453;Inherit;False;Property;_EmissionColor;EmissionColor;2;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;5.992157,5.992157,5.992157,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;24;-373.7573,263.5922;Inherit;False;Property;_RisAlpha;RisAlpha;6;0;Create;True;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1012.13,-547.345;Inherit;False;Property;_CullMode;CullMode;1;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-109.8361,444.756;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-387.3871,-1.195477;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1264.487,-456.9672;Inherit;False;Property;_Dst;Dst;14;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1015.544,-451.6659;Inherit;False;Property;_ZtestMode;ZtestMode;15;1;[Enum];Create;True;1;Option1;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1265.487,-542.9672;Inherit;False;Property;_Src;Src;13;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;148.7978,7.565989;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Stencil/StencilParticle;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;True;6;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;True;1;False;-1;255;False;-1;255;False;-1;5;False;-1;3;False;-1;0;False;-1;0;False;-1;5;False;-1;3;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;True;40;1;True;41;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;True;25;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;29;0
WireConnection;33;0;31;2
WireConnection;15;0;13;3
WireConnection;14;0;13;1
WireConnection;14;1;13;2
WireConnection;32;0;31;0
WireConnection;32;1;31;1
WireConnection;32;2;33;0
WireConnection;37;0;34;3
WireConnection;37;1;34;4
WireConnection;48;0;46;3
WireConnection;28;0;26;0
WireConnection;28;1;32;0
WireConnection;44;0;49;0
WireConnection;10;0;11;0
WireConnection;10;2;14;0
WireConnection;10;1;15;0
WireConnection;47;0;46;1
WireConnection;47;1;46;2
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;19;0;28;0
WireConnection;19;2;18;0
WireConnection;19;3;17;0
WireConnection;45;0;44;0
WireConnection;45;2;47;0
WireConnection;45;1;48;0
WireConnection;36;1;10;0
WireConnection;36;0;39;0
WireConnection;20;0;19;0
WireConnection;9;1;36;0
WireConnection;43;1;45;0
WireConnection;50;0;51;0
WireConnection;50;2;43;2
WireConnection;21;0;20;0
WireConnection;24;1;9;4
WireConnection;24;0;9;1
WireConnection;7;0;16;4
WireConnection;7;1;5;0
WireConnection;7;2;24;0
WireConnection;7;3;21;0
WireConnection;8;0;3;0
WireConnection;8;1;9;1
WireConnection;8;2;16;0
WireConnection;8;3;50;0
WireConnection;0;2;8;0
WireConnection;0;9;7;0
ASEEND*/
//CHKSM=D066C96DFC8153FD88F41F6AE69D678E022F9398