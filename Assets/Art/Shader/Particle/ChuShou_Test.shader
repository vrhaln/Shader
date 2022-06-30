// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HL/Particle/ChuShou_2"
{
	Properties
	{
		[Enum()]_Swi("粒子控制VO随机偏移（UV2_UVW）", Float) = 0
		[Enum()]_Swi4("粒子控制VO强度（UV2_T）", Float) = 0
		[Enum()]_Swi3("粒子控制XYZ强度（UV3_VWT）", Float) = 0
		[Enum()]_Swi2("粒子控制VO强度（+UV3_U）", Float) = 0
		_AlbedoColor("AlbedoColor", Color) = (0,0,0,0)
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Matallic("Matallic", Float) = 0
		_Smoothness("Smoothness", Float) = 0
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseTexScale("NoiseTexScale", Float) = 0
		_NoisePanner("NoisePanner", Vector) = (0,0,0,0)
		_GlowTex("GlowTex", 2D) = "white" {}
		_GlowColor("GlowColor", Color) = (0,0,0,0)
		_GlowColor1("GlowColor1", Color) = (0,0,0,0)
		_GlowScale("GlowScale", Float) = 0
		_GlowPanner("GlowPanner", Vector) = (0,0,0,0)
		_LerpSmo("LerpSmo", Vector) = (0,0,0,0)
		_LerpColorOffset("LerpColorOffset", Float) = 0
		_GlowMaskPower("GlowMaskPower", Float) = 0
		_GlowMaskScale("GlowMaskScale", Float) = 0
		_FreColor("FreColor", Color) = (0,0,0,0)
		_FrePower("FrePower", Float) = 0
		_FreScale("FreScale", Float) = 0
		_VONoiseTex("VONoiseTex", 2D) = "white" {}
		_VONoisePower("VONoisePower", Float) = 0
		_VONoiseScale("VONoiseScale", Float) = 0
		_VONOisePanner("VONOisePanner", Vector) = (0,0,0,0)
		_VOTex1("VOTex1", 2D) = "white" {}
		_VOTex2("VOTex2", 2D) = "white" {}
		_VOTex0("VOTex0", 2D) = "white" {}
		_VO_XTiling("VO_XTiling", Vector) = (0,0,0,0)
		_VO_XPanner("VO_XPanner", Vector) = (0,0,0,0)
		_VO_YTiling("VO_YTiling", Vector) = (0,0,0,0)
		_VO_YPanner("VO_YPanner", Vector) = (0,0,0,0)
		_VO_ZTiling("VO_ZTiling", Vector) = (0,0,0,0)
		_VO_ZPanner("VO_ZPanner", Vector) = (0,0,0,0)
		_VO_XYZScale("VO_XYZScale", Vector) = (0,0,0,0)
		_VOMaskTex("VOMaskTex", 2D) = "white" {}
		_VOMaskScale("VOMaskScale", Float) = 0
		_VOAddTex("VOAddTex", 2D) = "white" {}
		_VoAddTex("VoAddTex", Float) = 0
		_FogMask("FogMask", 2D) = "white" {}
		_FogColor("FogColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest LEqual
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _VONoiseTex;
		SamplerState sampler_VONoiseTex;
		uniform float4 _VONOisePanner;
		uniform float4 _VONoiseTex_ST;
		uniform float _VONoisePower;
		uniform float _VONoiseScale;
		uniform sampler2D _VOTex0;
		SamplerState sampler_VOTex0;
		uniform float4 _VO_XPanner;
		uniform float _Swi;
		uniform float4 _VO_XTiling;
		uniform float4 _VO_XYZScale;
		uniform float _Swi3;
		uniform sampler2D _VOTex1;
		SamplerState sampler_VOTex1;
		uniform float4 _VO_YPanner;
		uniform float4 _VO_YTiling;
		uniform sampler2D _VOTex2;
		SamplerState sampler_VOTex2;
		uniform float4 _VO_ZPanner;
		uniform float4 _VO_ZTiling;
		uniform sampler2D _VOMaskTex;
		SamplerState sampler_VOMaskTex;
		uniform float4 _VOMaskTex_ST;
		uniform float _VOMaskScale;
		uniform float _Swi2;
		uniform float _Swi4;
		uniform sampler2D _VOAddTex;
		SamplerState sampler_VOAddTex;
		uniform float4 _VOAddTex_ST;
		uniform float _VoAddTex;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoisePanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseTexScale;
		uniform float4 _AlbedoColor;
		uniform float4 _FogColor;
		uniform sampler2D _GlowTex;
		uniform float4 _GlowPanner;
		uniform float4 _GlowTex_ST;
		uniform float4 _GlowColor;
		uniform float4 _GlowColor1;
		uniform float2 _LerpSmo;
		uniform float _LerpColorOffset;
		uniform float _GlowScale;
		uniform float _GlowMaskPower;
		uniform float _GlowMaskScale;
		uniform float _FrePower;
		uniform float4 _FreColor;
		uniform float _FreScale;
		uniform sampler2D _FogMask;
		SamplerState sampler_FogMask;
		uniform float4 _FogMask_ST;
		uniform float _Matallic;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float mulTime111 = _Time.y * _VONOisePanner.z;
			float2 appendResult109 = (float2(_VONOisePanner.x , _VONOisePanner.y));
			float2 uv_VONoiseTex = v.texcoord.xy * _VONoiseTex_ST.xy + _VONoiseTex_ST.zw;
			float2 panner105 = ( ( mulTime111 + _VONOisePanner.w ) * appendResult109 + uv_VONoiseTex);
			float mulTime92 = _Time.y * _VO_XPanner.z;
			float lerpResult119 = lerp( 0.0 , v.texcoord1.x , _Swi);
			float2 appendResult89 = (float2(_VO_XPanner.x , _VO_XPanner.y));
			float2 appendResult192 = (float2(_VO_XTiling.x , _VO_XTiling.y));
			float2 appendResult193 = (float2(_VO_XTiling.z , _VO_XTiling.w));
			float2 panner79 = ( ( mulTime92 + _VO_XPanner.w + lerpResult119 ) * appendResult89 + (v.texcoord.xy*appendResult192 + appendResult193));
			float3 appendResult160 = (float3(_VO_XYZScale.x , _VO_XYZScale.y , _VO_XYZScale.z));
			float3 appendResult161 = (float3(v.texcoord2.y , v.texcoord2.z , v.texcoord2.w));
			float3 lerpResult158 = lerp( appendResult160 , appendResult161 , _Swi3);
			float3 break162 = lerpResult158;
			float mulTime93 = _Time.y * _VO_YPanner.z;
			float lerpResult120 = lerp( 0.0 , v.texcoord1.y , _Swi);
			float2 appendResult90 = (float2(_VO_YPanner.x , _VO_YPanner.y));
			float2 appendResult194 = (float2(_VO_YTiling.x , _VO_YTiling.y));
			float2 appendResult195 = (float2(_VO_YTiling.z , _VO_YTiling.w));
			float2 panner80 = ( ( mulTime93 + _VO_YPanner.w + lerpResult120 ) * appendResult90 + (v.texcoord.xy*appendResult194 + appendResult195));
			float mulTime94 = _Time.y * _VO_ZPanner.z;
			float lerpResult121 = lerp( 0.0 , v.texcoord1.z , _Swi);
			float2 appendResult91 = (float2(_VO_ZPanner.x , _VO_ZPanner.y));
			float2 appendResult196 = (float2(_VO_ZTiling.x , _VO_ZTiling.y));
			float2 appendResult197 = (float2(_VO_ZTiling.z , _VO_ZTiling.w));
			float2 panner81 = ( ( mulTime94 + _VO_ZPanner.w + lerpResult121 ) * appendResult91 + (v.texcoord.xy*appendResult196 + appendResult197));
			float3 appendResult98 = (float3(( (-0.5 + (tex2Dlod( _VOTex0, float4( panner79, 0, 0.0) ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * break162.x ) , ( (-0.5 + (tex2Dlod( _VOTex1, float4( panner80, 0, 0.0) ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * break162.y ) , ( (-0.5 + (tex2Dlod( _VOTex2, float4( panner81, 0, 0.0) ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * break162.z )));
			float2 uv_VOMaskTex = v.texcoord * _VOMaskTex_ST.xy + _VOMaskTex_ST.zw;
			float lerpResult155 = lerp( 0.0 , v.texcoord2.x , _Swi2);
			float lerpResult218 = lerp( 0.0 , v.texcoord1.w , _Swi4);
			float2 uv_VOAddTex = v.texcoord * _VOAddTex_ST.xy + _VOAddTex_ST.zw;
			v.vertex.xyz += ( ( ase_vertexNormal * ( pow( tex2Dlod( _VONoiseTex, float4( panner105, 0, 0.0) ).r , _VONoisePower ) * _VONoiseScale ) * 0.0 ) + ( appendResult98 * ( ( tex2Dlod( _VOMaskTex, float4( uv_VOMaskTex, 0, 0.0) ).r * _VOMaskScale ) * lerpResult155 * lerpResult218 ) ) + ( tex2Dlod( _VOAddTex, float4( uv_VOAddTex, 0, 0.0) ).r * _VoAddTex * ase_vertexNormal ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float mulTime50 = _Time.y * _NoisePanner.z;
			float2 appendResult49 = (float2(_NoisePanner.x , _NoisePanner.y));
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner47 = ( ( mulTime50 + _NoisePanner.w ) * appendResult49 + uv_NoiseTex);
			float4 temp_output_44_0 = ( tex2D( _NoiseTex, panner47 ) * _NoiseTexScale );
			float3 tex2DNode225 = UnpackNormal( tex2D( _NormalMap, ( float4( uv_NormalMap, 0.0 , 0.0 ) + temp_output_44_0 ).rg ) );
			o.Normal = tex2DNode225;
			o.Albedo = _AlbedoColor.rgb;
			float mulTime132 = _Time.y * _GlowPanner.z;
			float2 appendResult131 = (float2(_GlowPanner.x , _GlowPanner.y));
			float2 uv_GlowTex = i.uv_texcoord * _GlowTex_ST.xy + _GlowTex_ST.zw;
			float2 panner128 = ( ( mulTime132 + _GlowPanner.w ) * appendResult131 + uv_GlowTex);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult151 = smoothstep( _LerpSmo.x , _LerpSmo.y , ( ase_vertex3Pos.y + _LerpColorOffset ));
			float4 lerpResult148 = lerp( _GlowColor , _GlowColor1 , smoothstepResult151);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult28 = dot( normalize( (WorldNormalVector( i , tex2DNode225 )) ) , ase_worldViewDir );
			float2 uv_FogMask = i.uv_texcoord * _FogMask_ST.xy + _FogMask_ST.zw;
			float4 lerpResult175 = lerp( _FogColor , ( ( tex2D( _GlowTex, ( float4( panner128, 0.0 , 0.0 ) + temp_output_44_0 ).rg ) * lerpResult148 * _GlowScale * ( saturate( pow( saturate( dotResult28 ) , _GlowMaskPower ) ) * _GlowMaskScale ) ) + ( saturate( pow( ( 1.0 - dotResult28 ) , _FrePower ) ) * _FreColor * _FreScale ) ) , tex2D( _FogMask, uv_FogMask ).r);
			o.Emission = lerpResult175.rgb;
			o.Metallic = _Matallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-1618;27;1616;949;1335.039;3863.613;2.262793;True;True
Node;AmplifyShaderEditor.CommentaryNode;232;-1709.961,-3641.494;Inherit;False;5085.71;1720.582;;8;181;230;177;180;179;178;134;207;颜色;1,0.3254717,0.3254717,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;181;-1659.961,-3563.634;Inherit;False;1246;446.0002;扰动流光;9;48;50;46;49;51;47;43;45;44;扰动流光;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;48;-1609.961,-3329.634;Inherit;False;Property;_NoisePanner;NoisePanner;12;0;Create;True;0;0;False;0;False;0,0,0,0;0.5,-1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;50;-1432.961,-3251.633;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1266.961,-3253.633;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-1530.961,-3512.634;Inherit;False;0;43;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1436.961,-3340.634;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;47;-1181.961,-3491.634;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;230;2528.25,-2655.504;Inherit;False;797.5;658.286;;7;220;226;227;225;221;223;224;固有色 法线 金属度 光滑度;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;43;-954.9608,-3511.634;Inherit;True;Property;_NoiseTex;NoiseTex;10;0;Create;True;0;0;False;0;False;-1;None;9bb9e3d400ae31d47943bc7c4fc13356;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-784.9609,-3310.634;Inherit;False;Property;_NoiseTexScale;NoiseTexScale;11;0;Create;True;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-575.961,-3469.634;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;226;2578.25,-2448.818;Inherit;False;0;225;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;233;-1870.127,-693.3461;Inherit;False;5689.057;2797.003;;12;205;206;204;212;215;209;210;219;203;116;114;208;顶点偏移;0.6728769,1,0.5801887,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;205;-807.793,-12.14053;Inherit;False;1737.244;1263.337;;31;87;86;88;190;189;191;93;94;197;194;184;195;193;192;196;92;91;95;96;97;90;185;186;187;89;81;80;79;69;68;67;XYZ3个方向的偏移强度和流动;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;206;-1820.127,403.9157;Inherit;False;672.0005;726.0004;;6;118;122;123;120;121;119;粒子控制VO3个方向的偏移（叠加，给予随机值或固定数值的增量）;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;227;2821.954,-2500.951;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;86;-451.8488,602.597;Inherit;False;Property;_VO_YPanner;VO_YPanner;35;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.8,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;190;-458.6082,413.5596;Inherit;False;Property;_VO_YTiling;VO_YTiling;34;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;191;-461.2084,795.7595;Inherit;False;Property;_VO_ZTiling;VO_ZTiling;36;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;177;-369.5758,-3591.494;Inherit;False;1344.164;411.3861;流光;8;130;132;131;129;127;143;128;133;流光;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;180;-1247.356,-2566.681;Inherit;False;1445.012;563.8705;菲涅尔颜色;11;26;25;28;60;62;61;63;65;64;66;229;菲涅尔颜色;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1763.77,819.9159;Inherit;False;Property;_Swi;粒子控制VO随机偏移（UV2_UVW）;1;1;[Enum];Create;False;0;2;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;118;-1768.734,656.0618;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;204;-358.0097,-643.3461;Inherit;False;1806.785;439.7019;;14;112;104;101;103;2;102;108;111;109;106;110;105;100;113;触手表面噪波涌动;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;87;-451.9489,983.1969;Inherit;False;Property;_VO_ZPanner;VO_ZPanner;37;0;Create;True;0;0;False;0;False;0,0,0,0;0,-1,1.4,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;122;-1693.127,569.9154;Inherit;False;Constant;_Float2;Float 2;27;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;189;-456.0119,27.44483;Inherit;False;Property;_VO_XTiling;VO_XTiling;32;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;225;3000.15,-2403.718;Inherit;True;Property;_NormalMap;NormalMap;6;0;Create;True;0;0;False;0;False;-1;None;88ec5bd158d44bb46a1af39842919788;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;88;-316.1512,230.1153;Inherit;False;Property;_VO_XPanner;VO_XPanner;33;0;Create;True;0;0;False;0;False;0,0,0,0;0,-1,1.1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;197;-235.008,859.4595;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;26;-1197.356,-2363.299;Inherit;True;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;196;-242.808,771.0596;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;120;-1318.127,621.9155;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;184;-757.793,309.9126;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;93;21.1512,826.1971;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;193;-249.3102,113.2393;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;92;19.32888,285.6758;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-1307.77,820.9156;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;212;1295.266,295.4731;Inherit;False;1282.001;694.2503;;11;162;71;72;70;98;78;160;158;157;161;156;XYZ3个方向 强度控制;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;130;-315.5562,-3395.108;Inherit;False;Property;_GlowPanner;GlowPanner;17;0;Create;True;0;0;False;0;False;0,0,0,0;0.65,-1,0.55,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;94;34.1512,1140.197;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;119;-1330.127,453.9156;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;108;-308.0097,-429.6442;Inherit;False;Property;_VONOisePanner;VONOisePanner;28;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.4,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;195;-235.0084,576.0596;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;194;-242.8083,487.6596;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;192;-257.1101,19.63206;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;25;-1165.242,-2538.345;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;90;20.1512,736.1971;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;272.1511,983.1971;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;185;63.99709,68.91669;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;228.6688,288.5667;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;242.1511,642.1971;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;178;-354.6831,-3076.559;Inherit;False;1404.085;429.781;按顶点位置作为mask来线性插值两个颜色;9;144;146;145;151;149;136;148;137;228;流光颜色;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;28;-923.4795,-2431.482;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;187;-14.00837,889.3598;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;33.1512,1052.197;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;78;1358.359,353.9896;Inherit;False;Property;_VO_XYZScale;VO_XYZScale;38;0;Create;True;0;0;False;0;False;0,0,0,0;0.5,-0.01,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;132;-137.5568,-3291.108;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;186;4.191699,544.8599;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;111;-104.0097,-314.6441;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;179;232.6363,-2576.918;Inherit;False;833.2725;327.1996;流光菲涅尔mask;5;140;139;142;138;141;流光菲涅尔mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;156;1355.753,785.7234;Inherit;False;2;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;89;-105.0042,236.1383;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;144;-304.6831,-3020.497;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-215.0097,-562.6445;Inherit;False;0;100;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;110;93.99039,-411.6442;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;161;1578.478,513.187;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-293.5296,-2867.574;Inherit;False;Property;_LerpColorOffset;LerpColorOffset;19;0;Create;True;0;0;False;0;False;0;-0.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;81;390.1511,797.1971;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;160;1597.731,382.1978;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-319.5758,-3516.731;Inherit;False;0;127;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;131;-141.5564,-3382.108;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;229;-402.638,-2486.898;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;1461.266,636.7751;Inherit;False;Property;_Swi3;粒子控制XYZ强度（UV3_VWT）;3;1;[Enum];Create;False;0;2;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;54.32726,-3347.358;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;-102.0097,-409.6442;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;140;282.6363,-2385.575;Inherit;False;Property;_GlowMaskPower;GlowMaskPower;20;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;79;368.8676,142.6754;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;80;364.1511,477.1971;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;68;593.2513,470.697;Inherit;True;Property;_VOTex1;VOTex1;29;0;Create;True;0;0;False;0;False;-1;None;30950b4466df7134dbf0ef7e8350fac6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;158;1832.675,427.8938;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;139;539.9155,-2473.617;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;128;230.0583,-3530.494;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;-112.4276,-2991.01;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;219;1738.287,1843.976;Inherit;False;602.4216;259.6801;;3;216;217;218;遮罩强度 添加UV2 T 的额外控制(添加区间值 错开触手强度);1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-540.8425,-2239.644;Inherit;False;Property;_FrePower;FrePower;23;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;215;1706.474,1479.536;Inherit;False;809.6796;244.0211;;4;154;199;155;200;遮罩强度 添加UV3 U 的额外控制;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;105;140.9903,-550.6445;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;60;-644.5463,-2390.512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;67;607.6803,109.99;Inherit;True;Property;_VOTex0;VOTex0;31;0;Create;True;0;0;False;0;False;-1;None;30950b4466df7134dbf0ef7e8350fac6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;210;1793.712,1048.138;Inherit;False;520.2919;350.0822;;3;115;117;198;3个方向偏移的 遮罩;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;69;609.4512,689.1971;Inherit;True;Property;_VOTex2;VOTex2;30;0;Create;True;0;0;False;0;False;-1;None;30950b4466df7134dbf0ef7e8350fac6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;209;978.0038,239.7252;Inherit;False;260.8999;669.1;;3;166;165;164;偏移强度映射到有正有负;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;228;68.24035,-2774.935;Inherit;False;Property;_LerpSmo;LerpSmo;18;0;Create;True;0;0;False;0;False;0,0;0,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BreakToComponentsNode;162;2009.161,393.3691;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;62;-445.1224,-2374.684;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;151;215.8832,-2990.565;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;340.4132,-576.3261;Inherit;True;Property;_VONoiseTex;VONoiseTex;25;0;Create;True;0;0;False;0;False;-1;None;7ef0b291b72c96840bf16bf25fef0302;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;166;1028.003,701.825;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;200;2002.03,1510.624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;115;1843.711,1098.138;Inherit;True;Property;_VOMaskTex;VOMaskTex;39;0;Create;True;0;0;False;0;False;-1;None;288c4bb3302af1843802cbb2aebb9c2e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;142;590.4095,-2365.718;Inherit;False;Property;_GlowMaskScale;GlowMaskScale;21;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;138;694.1466,-2514.066;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;164;1029.302,289.7253;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;165;1031.903,491.2252;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;1760.829,1607.558;Inherit;False;Property;_Swi2;粒子控制VO强度（+UV3_U）;4;1;[Enum];Create;False;0;2;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;481.5963,-3467.004;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;459.0901,-392.2442;Inherit;False;Property;_VONoisePower;VONoisePower;26;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;136;559.0016,-3026.559;Inherit;False;Property;_GlowColor;GlowColor;14;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.692609,0.07843137,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;217;1788.287,1987.657;Inherit;False;Property;_Swi4;粒子控制VO强度（UV2_T）;2;1;[Enum];Create;False;0;2;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;149;562.5605,-2858.778;Inherit;False;Property;_GlowColor1;GlowColor1;15;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.6686354,0.2028302,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;216;1917.188,1893.976;Inherit;False;Constant;_Float1;Float 1;29;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;1756.474,1529.536;Inherit;False;Constant;_Float3;Float 3;29;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;1968.838,1282.22;Inherit;False;Property;_VOMaskScale;VOMaskScale;40;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;2240.211,345.4731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;112;680.9451,-437.7316;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-249.8612,-2118.81;Inherit;False;Property;_FreScale;FreScale;24;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;2152.002,1109.602;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;148;795.7965,-3005.562;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;64;-317.8612,-2284.811;Inherit;False;Property;_FreColor;FreColor;22;0;Create;True;0;0;False;0;False;0,0,0,0;0.2877358,1,0.6830916,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;137;848.4016,-2727.659;Inherit;False;Property;_GlowScale;GlowScale;16;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;203;1522.56,-277.9879;Inherit;False;578.7706;352.3369;;3;168;170;169;触手加粗;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;104;687.8681,-346.3131;Inherit;False;Property;_VONoiseScale;VONoiseScale;27;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;830.9086,-2526.918;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;155;2334.155,1540.944;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;218;2158.708,1919.756;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;127;654.5885,-3505.795;Inherit;True;Property;_GlowTex;GlowTex;13;0;Create;True;0;0;False;0;False;-1;None;435fff8c8126cf34997a07f8dd5e4adf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;2242.211,577.4735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;61;-265.4646,-2384.125;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;2239.211,459.4732;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;894.4633,-379.832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;207;1419.926,-2584.277;Inherit;False;583.0815;572.1801;;4;175;172;58;176;插值颜色，模拟雾效颜色;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;168;1572.56,-227.9879;Inherit;True;Property;_VOAddTex;VOAddTex;41;0;Create;True;0;0;False;0;False;-1;None;288c4bb3302af1843802cbb2aebb9c2e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-38.34364,-2383.885;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;2562.891,1066.717;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;1709.331,-41.65104;Inherit;False;Property;_VoAddTex;VoAddTex;42;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;2416.267,349.618;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;1257.551,-2902.147;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;103;910.7075,-593.3461;Inherit;False;Constant;_Float0;Float 0;26;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;2;893.9685,-520.9642;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;1939.331,-214.651;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;1286.774,-510.1111;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;172;1469.926,-2242.097;Inherit;True;Property;_FogMask;FogMask;43;0;Create;True;0;0;False;0;False;-1;None;288c4bb3302af1843802cbb2aebb9c2e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;208;3422.371,150.18;Inherit;False;203;209;;1;99;所有偏移结果相加;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;1582.443,-2534.277;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;176;1567.926,-2409.097;Inherit;False;Property;_FogColor;FogColor;44;0;Create;True;0;0;False;0;False;0,0,0,0;0,0.04043129,0.05660379,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;2760.683,350.4088;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;221;3025.751,-2196.218;Inherit;False;Property;_Matallic;Matallic;8;0;Create;True;0;0;False;0;False;0;0.374;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;220;3057.463,-2605.504;Inherit;False;Property;_AlbedoColor;AlbedoColor;5;0;Create;True;0;0;False;0;False;0,0,0,0;0.3679245,0.03991635,0.2267071,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;175;1812.926,-2407.097;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;223;3016.75,-2113.218;Inherit;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;False;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;2705.751,-2323.018;Inherit;False;Property;_NormalScale;NormalScale;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;3472.371,200.18;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4583.346,-633.6983;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HL/Particle/ChuShou_2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;50;0;48;3
WireConnection;51;0;50;0
WireConnection;51;1;48;4
WireConnection;49;0;48;1
WireConnection;49;1;48;2
WireConnection;47;0;46;0
WireConnection;47;2;49;0
WireConnection;47;1;51;0
WireConnection;43;1;47;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;227;0;226;0
WireConnection;227;1;44;0
WireConnection;225;1;227;0
WireConnection;197;0;191;3
WireConnection;197;1;191;4
WireConnection;196;0;191;1
WireConnection;196;1;191;2
WireConnection;120;0;122;0
WireConnection;120;1;118;2
WireConnection;120;2;123;0
WireConnection;93;0;86;3
WireConnection;193;0;189;3
WireConnection;193;1;189;4
WireConnection;92;0;88;3
WireConnection;121;0;122;0
WireConnection;121;1;118;3
WireConnection;121;2;123;0
WireConnection;94;0;87;3
WireConnection;119;0;122;0
WireConnection;119;1;118;1
WireConnection;119;2;123;0
WireConnection;195;0;190;3
WireConnection;195;1;190;4
WireConnection;194;0;190;1
WireConnection;194;1;190;2
WireConnection;192;0;189;1
WireConnection;192;1;189;2
WireConnection;25;0;225;0
WireConnection;90;0;86;1
WireConnection;90;1;86;2
WireConnection;95;0;94;0
WireConnection;95;1;87;4
WireConnection;95;2;121;0
WireConnection;185;0;184;0
WireConnection;185;1;192;0
WireConnection;185;2;193;0
WireConnection;97;0;92;0
WireConnection;97;1;88;4
WireConnection;97;2;119;0
WireConnection;96;0;93;0
WireConnection;96;1;86;4
WireConnection;96;2;120;0
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;187;0;184;0
WireConnection;187;1;196;0
WireConnection;187;2;197;0
WireConnection;91;0;87;1
WireConnection;91;1;87;2
WireConnection;132;0;130;3
WireConnection;186;0;184;0
WireConnection;186;1;194;0
WireConnection;186;2;195;0
WireConnection;111;0;108;3
WireConnection;89;0;88;1
WireConnection;89;1;88;2
WireConnection;110;0;111;0
WireConnection;110;1;108;4
WireConnection;161;0;156;2
WireConnection;161;1;156;3
WireConnection;161;2;156;4
WireConnection;81;0;187;0
WireConnection;81;2;91;0
WireConnection;81;1;95;0
WireConnection;160;0;78;1
WireConnection;160;1;78;2
WireConnection;160;2;78;3
WireConnection;131;0;130;1
WireConnection;131;1;130;2
WireConnection;229;0;28;0
WireConnection;133;0;132;0
WireConnection;133;1;130;4
WireConnection;109;0;108;1
WireConnection;109;1;108;2
WireConnection;79;0;185;0
WireConnection;79;2;89;0
WireConnection;79;1;97;0
WireConnection;80;0;186;0
WireConnection;80;2;90;0
WireConnection;80;1;96;0
WireConnection;68;1;80;0
WireConnection;158;0;160;0
WireConnection;158;1;161;0
WireConnection;158;2;157;0
WireConnection;139;0;229;0
WireConnection;139;1;140;0
WireConnection;128;0;129;0
WireConnection;128;2;131;0
WireConnection;128;1;133;0
WireConnection;145;0;144;2
WireConnection;145;1;146;0
WireConnection;105;0;106;0
WireConnection;105;2;109;0
WireConnection;105;1;110;0
WireConnection;60;0;28;0
WireConnection;67;1;79;0
WireConnection;69;1;81;0
WireConnection;162;0;158;0
WireConnection;62;0;60;0
WireConnection;62;1;66;0
WireConnection;151;0;145;0
WireConnection;151;1;228;1
WireConnection;151;2;228;2
WireConnection;100;1;105;0
WireConnection;166;0;69;1
WireConnection;200;0;156;1
WireConnection;138;0;139;0
WireConnection;164;0;67;1
WireConnection;165;0;68;1
WireConnection;143;0;128;0
WireConnection;143;1;44;0
WireConnection;70;0;164;0
WireConnection;70;1;162;0
WireConnection;112;0;100;1
WireConnection;112;1;113;0
WireConnection;198;0;115;1
WireConnection;198;1;117;0
WireConnection;148;0;136;0
WireConnection;148;1;149;0
WireConnection;148;2;151;0
WireConnection;141;0;138;0
WireConnection;141;1;142;0
WireConnection;155;0;199;0
WireConnection;155;1;200;0
WireConnection;155;2;154;0
WireConnection;218;0;216;0
WireConnection;218;1;118;4
WireConnection;218;2;217;0
WireConnection;127;1;143;0
WireConnection;72;0;166;0
WireConnection;72;1;162;2
WireConnection;61;0;62;0
WireConnection;71;0;165;0
WireConnection;71;1;162;1
WireConnection;102;0;112;0
WireConnection;102;1;104;0
WireConnection;63;0;61;0
WireConnection;63;1;64;0
WireConnection;63;2;65;0
WireConnection;116;0;198;0
WireConnection;116;1;155;0
WireConnection;116;2;218;0
WireConnection;98;0;70;0
WireConnection;98;1;71;0
WireConnection;98;2;72;0
WireConnection;134;0;127;0
WireConnection;134;1;148;0
WireConnection;134;2;137;0
WireConnection;134;3;141;0
WireConnection;169;0;168;1
WireConnection;169;1;170;0
WireConnection;169;2;2;0
WireConnection;101;0;2;0
WireConnection;101;1;102;0
WireConnection;101;2;103;0
WireConnection;58;0;134;0
WireConnection;58;1;63;0
WireConnection;114;0;98;0
WireConnection;114;1;116;0
WireConnection;175;0;176;0
WireConnection;175;1;58;0
WireConnection;175;2;172;1
WireConnection;99;0;101;0
WireConnection;99;1;114;0
WireConnection;99;2;169;0
WireConnection;0;0;220;0
WireConnection;0;1;225;0
WireConnection;0;2;175;0
WireConnection;0;3;221;0
WireConnection;0;4;223;0
WireConnection;0;11;99;0
ASEEND*/
//CHKSM=E951EC6631F1445299910E792DD4C3D5684EB2FC