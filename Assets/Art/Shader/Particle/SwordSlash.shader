// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Particle/SwordSlash"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTexture("MainTexture", 2D) = "white" {}
		_EmissionTex("EmissionTex", 2D) = "white" {}
		_Float1("Float 1", Float) = 20
		_Dissolve("Dissolve", 2D) = "white" {}
		[Toggle(_REVERSE_ON)] _Reverse("Reverse", Float) = 0
		_SpeedMainTexUVNoiseZW("Speed MainTex U/V + Noise Z/W", Vector) = (0,0,0,0)
		_Emission("Emission", Float) = 5
		_Remap("Remap", Vector) = (-2,1,0,0)
		_AddColor("Add Color", Color) = (0,0,0,0)
		_Desaturation("Desaturation", Float) = 0
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseTexScale("NoiseTexScale", Float) = 0
		_NoisePanner("NoisePanner", Vector) = (0,0,0,0)
		_InnerEmission("InnerEmission", Float) = 1
		[Toggle(_UV2INFLUENCEDISSOLVEPANNER_ON)] _UV2InfluenceDissolvePanner("UV2InfluenceDissolvePanner", Float) = 0
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.5
		#pragma shader_feature_local _UV2INFLUENCEDISSOLVEPANNER_ON
		#pragma shader_feature_local _REVERSE_ON
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 uv_tex4coord;
		};

		uniform float4 _AddColor;
		uniform float _Emission;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoisePanner;
		uniform float _NoiseTexScale;
		uniform float _Desaturation;
		uniform float2 _Remap;
		uniform sampler2D _Dissolve;
		SamplerState sampler_Dissolve;
		uniform float4 _SpeedMainTexUVNoiseZW;
		uniform float _InnerEmission;
		uniform sampler2D _MainTexture;
		SamplerState sampler_MainTexture;
		uniform float _Float1;
		uniform float _Cutoff = 0.5;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float mulTime60 = _Time.y * _NoisePanner.z;
			float2 appendResult61 = (float2(_NoisePanner.x , _NoisePanner.y));
			float2 panner64 = ( ( mulTime60 + _NoisePanner.w + i.uv2_tex4coord2.w ) * appendResult61 + i.uv_texcoord);
			float3 hsvTorgb8 = RGBToHSV( tex2D( _EmissionTex, ( float4( uv_EmissionTex, 0.0 , 0.0 ) + ( tex2D( _NoiseTex, panner64 ) * _NoiseTexScale ) ).rg ).rgb );
			float3 hsvTorgb11 = HSVToRGB( float3(( hsvTorgb8.x + i.uv2_tex4coord2.z ),hsvTorgb8.y,hsvTorgb8.z) );
			float3 desaturateInitialColor18 = hsvTorgb11;
			float desaturateDot18 = dot( desaturateInitialColor18, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar18 = lerp( desaturateInitialColor18, desaturateDot18.xxx, _Desaturation );
			float2 _Vector0 = float2(0,1);
			float3 temp_cast_3 = (_Vector0.x).xxx;
			float3 temp_cast_4 = (_Vector0.y).xxx;
			float3 temp_cast_5 = (_Remap.x).xxx;
			float3 temp_cast_6 = (_Remap.y).xxx;
			float3 clampResult33 = clamp( (temp_cast_5 + (desaturateVar18 - temp_cast_3) * (temp_cast_6 - temp_cast_5) / (temp_cast_4 - temp_cast_3)) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float2 appendResult3 = (float2(_SpeedMainTexUVNoiseZW.z , _SpeedMainTexUVNoiseZW.w));
			float2 panner6 = ( 1.0 * _Time.y * appendResult3 + i.uv_tex4coord.xy);
			float2 break10 = panner6;
			#ifdef _UV2INFLUENCEDISSOLVEPANNER_ON
				float staticSwitch74 = ( break10.y + i.uv2_tex4coord2.w );
			#else
				float staticSwitch74 = break10.y;
			#endif
			float2 appendResult20 = (float2(break10.x , staticSwitch74));
			float4 tex2DNode23 = tex2D( _Dissolve, appendResult20 );
			float T17 = i.uv_tex4coord.w;
			o.Emission = ( ( _AddColor * i.vertexColor ) + ( _Emission * float4( clampResult33 , 0.0 ) * i.vertexColor ) + ( tex2DNode23.r * T17 * _InnerEmission ) ).rgb;
			o.Alpha = 1;
			float2 appendResult13 = (float2(_SpeedMainTexUVNoiseZW.x , _SpeedMainTexUVNoiseZW.y));
			float2 panner19 = ( 1.0 * _Time.y * appendResult13 + i.uv2_tex4coord2.xy);
			float clampResult36 = clamp( ( tex2D( _MainTexture, panner19 ).r * _Float1 ) , 0.0 , 1.0 );
			#ifdef _REVERSE_ON
				float staticSwitch44 = tex2DNode23.r;
			#else
				float staticSwitch44 = ( 1.0 - tex2DNode23.r );
			#endif
			float W26 = i.uv_tex4coord.z;
			float3 _Vector1 = float3(0.3,0,1);
			float ifLocalVar42 = 0;
			if( ( staticSwitch44 * T17 ) >= W26 )
				ifLocalVar42 = _Vector1.y;
			else
				ifLocalVar42 = _Vector1.z;
			clip( ( i.vertexColor.a * clampResult36 * ifLocalVar42 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-1618;27;1616;949;3217.62;727.3389;1;True;True
Node;AmplifyShaderEditor.Vector4Node;59;-3853.526,-184.8252;Inherit;False;Property;_NoisePanner;NoisePanner;14;0;Create;True;0;0;False;0;False;0,0,0,0;1,-2,0.2,0.2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-4006.572,70.08884;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;60;-3528.367,-101.0141;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-3532.367,-190.015;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-3362.367,-103.0141;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-3626.367,-362.015;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;64;-3316.14,-384.8457;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;2;-3202.467,773.0629;Float;False;Property;_SpeedMainTexUVNoiseZW;Speed MainTex U/V + Noise Z/W;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,-0.8,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-3005.399,-186.7745;Inherit;False;Property;_NoiseTexScale;NoiseTexScale;13;0;Create;True;0;0;False;0;False;0;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-3082.397,-418.3321;Inherit;True;Property;_NoiseTex;NoiseTex;11;0;Create;True;0;0;False;0;False;-1;None;9bb9e3d400ae31d47943bc7c4fc13356;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;3;-2660.385,975.5968;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2705.608,812.6962;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;6;-2371.353,947.9631;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-2980.948,-640.2958;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2791.74,-387.9893;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2655.365,-496.6923;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;10;-2186.563,962.759;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;5;-2354.221,-580.088;Inherit;True;Property;_EmissionTex;EmissionTex;2;0;Create;True;0;0;False;0;False;-1;None;41a9643aee5fa1649987d5fffc5c4200;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-2035.075,1101.055;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;74;-1902.479,1063.451;Inherit;False;Property;_UV2InfluenceDissolvePanner;UV2InfluenceDissolvePanner;16;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;8;-2040.395,-573.8558;Float;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1792.861,911.9639;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1757.03,-439.6013;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;11;-1614.481,-536.5823;Float;True;3;0;FLOAT;1.13;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;14;-1557.446,-265.9482;Float;False;Property;_Desaturation;Desaturation;10;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-2629.7,721.2854;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;23;-1648.448,891.8624;Inherit;True;Property;_Dissolve;Dissolve;4;0;Create;True;0;0;False;0;False;-1;None;9bb9e3d400ae31d47943bc7c4fc13356;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;43;-1354.538,869.5448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;15;-1326.176,-128.7864;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;16;-1328.203,-14.08758;Float;False;Property;_Remap;Remap;8;0;Create;True;0;0;False;0;False;-2,1;-0.18,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DesaturateOpNode;18;-1335.607,-279.3528;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-2342.068,865.9326;Float;False;T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;19;-1648.441,323.8343;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;44;-1270.91,961.3063;Inherit;False;Property;_Reverse;Reverse;5;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-1343.682,287.7777;Inherit;True;Property;_MainTexture;MainTexture;1;0;Create;True;0;0;False;0;False;-1;None;e671b35a4d1ba054c966b99b9cf333dc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;22;-1348.57,1099.174;Inherit;False;17;T;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;21;-1078.022,-80.64885;Inherit;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1094.643,493.2006;Float;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-2345.313,790.9468;Float;False;W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1107.002,1068.753;Inherit;False;26;W;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-882.0898,-151.7259;Float;False;Property;_Emission;Emission;7;0;Create;True;0;0;False;0;False;5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-942.4039,-315.636;Float;False;Property;_AddColor;Add Color;9;0;Create;True;0;0;False;0;False;0,0,0,0;0.4849234,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1079.387,941.9492;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;28;-901.2701,41.5906;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;31;-1121.763,1161.4;Float;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;False;0.3,0,1;0.1,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;33;-881.3234,-79.91225;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1095.599,787.3299;Inherit;False;Property;_InnerEmission;InnerEmission;15;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-917.4089,400.2083;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-698.1216,-106.7828;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;42;-821.3704,941.3384;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;36;-766.4625,400.7876;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-695.9545,-242.6229;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-963.6168,629.5542;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2079.135,-318.2885;Float;False;Property;_HUE;HUE;12;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-408.4557,-118.6865;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-397.0485,166.4688;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;0,0;Float;False;True;-1;3;ASEMaterialInspector;0;0;Unlit;ASE/Particle/SwordSlash;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;0;59;3
WireConnection;61;0;59;1
WireConnection;61;1;59;2
WireConnection;63;0;60;0
WireConnection;63;1;59;4
WireConnection;63;2;7;4
WireConnection;64;0;62;0
WireConnection;64;2;61;0
WireConnection;64;1;63;0
WireConnection;65;1;64;0
WireConnection;3;0;2;3
WireConnection;3;1;2;4
WireConnection;6;0;4;0
WireConnection;6;2;3;0
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;56;0;55;0
WireConnection;56;1;67;0
WireConnection;10;0;6;0
WireConnection;5;1;56;0
WireConnection;73;0;10;1
WireConnection;73;1;7;4
WireConnection;74;1;10;1
WireConnection;74;0;73;0
WireConnection;8;0;5;0
WireConnection;20;0;10;0
WireConnection;20;1;74;0
WireConnection;9;0;8;1
WireConnection;9;1;7;3
WireConnection;11;0;9;0
WireConnection;11;1;8;2
WireConnection;11;2;8;3
WireConnection;13;0;2;1
WireConnection;13;1;2;2
WireConnection;23;1;20;0
WireConnection;43;0;23;1
WireConnection;18;0;11;0
WireConnection;18;1;14;0
WireConnection;17;0;4;4
WireConnection;19;0;7;0
WireConnection;19;2;13;0
WireConnection;44;1;43;0
WireConnection;44;0;23;1
WireConnection;24;1;19;0
WireConnection;21;0;18;0
WireConnection;21;1;15;1
WireConnection;21;2;15;2
WireConnection;21;3;16;1
WireConnection;21;4;16;2
WireConnection;26;0;4;3
WireConnection;30;0;44;0
WireConnection;30;1;22;0
WireConnection;33;0;21;0
WireConnection;34;0;24;1
WireConnection;34;1;25;0
WireConnection;35;0;32;0
WireConnection;35;1;33;0
WireConnection;35;2;28;0
WireConnection;42;0;30;0
WireConnection;42;1;29;0
WireConnection;42;2;31;2
WireConnection;42;3;31;2
WireConnection;42;4;31;3
WireConnection;36;0;34;0
WireConnection;37;0;27;0
WireConnection;37;1;28;0
WireConnection;68;0;23;1
WireConnection;68;1;22;0
WireConnection;68;2;72;0
WireConnection;39;0;37;0
WireConnection;39;1;35;0
WireConnection;39;2;68;0
WireConnection;38;0;28;4
WireConnection;38;1;36;0
WireConnection;38;2;42;0
WireConnection;1;2;39;0
WireConnection;1;10;38;0
ASEEND*/
//CHKSM=5330C1564915D4423EB8995900DFDFD2A64F2ADF