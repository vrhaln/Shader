Shader "C1401/GBVS_SSRim"
{
    Properties
    {
        [Header(Texture)]
        [NoScaleOffset]_BaseTex ("Base Texture", 2D) = "white" {}
        [NoScaleOffset]_ILMTex ("ILM Texture", 2D) = "gray" {}
        [NoScaleOffset]_SSSTex ("SSS Texture", 2D) = "white" {}
        [NoScaleOffset]_DetailTex ("Detail Texture", 2D) = "white" {}

        [Header(Ceil)]
        _ShadowStep ("Shadow Step", Range(0, 1)) = 0.5
        _ShadowHardness ("Shadow Hardness", Float) = 20.0
        
        [Header(Specular)]
        _SpecRange ("Specular Range", Range(0, 1)) = 0.1
        _SpecColor ("Specular Color", Color) = (1, 1, 1)
        _SpecHardness ("Specular Hardness", Float) = 500

        [Header(Rim)]
        _RimColor ("Rim Color", Color) = (1, 1, 1)
        _RimIntensity ("Rim Intensity", Float) = 1.0
        _RimWidth ("Rim Width", Range(0, 0.1)) = 0.012
        _RimThreshold ("Rim Threshold", Range(0, 1)) = 0.09
        _FresnelMask ("Fresnel Mask", Range(0, 1)) = 0.5

        [Header(Outline)]
        _OutlineWidth ("Outline Width", Float) = 1.2
        _OutlineColor ("Outline Color", Color) = (0.4, 0.4, 0.4)
        _OutlineZOffset ("Outline Z Offset", Float) = -10.0
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        Pass
        {
            Name "ToonLit"

            Tags
            {
                "LightMode" = "UniversalForward"
            }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct a2v
            {
                float4 positionOS       : POSITION;
                float2 uv1              : TEXCOORD0;
                float2 uv2              : TEXCOORD1;
                float3 normalOS         : NORMAL;
                float4 tangentOS        : TANGENT;
                half4 color             : COLOR;
            };

            struct v2f
            {
                float4 positionCS       : SV_POSITION;
                float4 uv               : TEXCOORD0;
                float3 normalWS         : TEXCOORD1;
                float3 positionVS       : TEXCOORD2;
                float3 positionWS       : TEXCOORD3;
                float4 positionNDC      : TEXCOORD4;
                half4 vertexColor       : TEXCOORD5;
            #if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
                float4 shadowCoords     : TEXCOORD6;
            #endif
            };

            CBUFFER_START(UnityPerMaterial)
                float _ShadowStep;
                float _ShadowHardness;
                float _SpecRange;
                half3 _SpecColor;
                float _SpecHardness;
                half3 _RimColor;
                float _RimIntensity;
                float _RimWidth;
                float _RimThreshold;
                float _FresnelMask;
            CBUFFER_END

            TEXTURE2D(_BaseTex);            SAMPLER(sampler_BaseTex);
            TEXTURE2D(_ILMTex);             SAMPLER(sampler_ILMTex);
            TEXTURE2D(_SSSTex);             SAMPLER(sampler_SSSTex);
            TEXTURE2D(_DetailTex);          SAMPLER(sampler_DetailTex);
            TEXTURE2D(_CameraDepthTexture); SAMPLER(sampler_CameraDepthTexture);

            float4 TransformHClipToViewPortPos(float4 positionCS)
            {
                float4 o = positionCS * 0.5f;
                o.xy = float2(o.x, o.y * _ProjectionParams.x) + o.w;
                o.zw = positionCS.zw;
                return o / o.w;
            }

            v2f vert(a2v v)
            {
                v2f o;

                VertexPositionInputs vertexPositionInput = GetVertexPositionInputs(v.positionOS.xyz);
                o.positionCS = vertexPositionInput.positionCS;
                o.positionWS = vertexPositionInput.positionWS;
                o.positionVS = vertexPositionInput.positionVS;
                o.positionNDC = vertexPositionInput.positionNDC;
                
                VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(v.normalOS, v.tangentOS);
                o.normalWS = vertexNormalInput.normalWS;

                o.vertexColor = v.color;
                o.uv = float4(v.uv1, v.uv2);

            #if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
                o.shadowCoords = GetShadowCoord(vertexPositionInput);
            #endif

                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                float3 normalWS = normalize(i.normalWS);
                float3 normalVS = TransformWorldToViewDir(normalWS);
                float3 positionWS = i.positionWS;
                float3 positionVS = i.positionVS;
                float4 positionNDC = i.positionNDC;
                float3 viewDirectionWS = normalize(GetCameraPositionWS() - positionWS);
                float2 uv1 = i.uv.xy;
                float2 uv2 = i.uv.zw;

            #if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
                Light mainLight = GetMainLight(i.shadowCoords);
            #else
                Light mainLight = GetMainLight();
            #endif
                float3 mainLightDir = mainLight.direction;
                float mainLightAttenuation = mainLight.distanceAttenuation * mainLight.shadowAttenuation;

                // Sample
                half4 baseColor = SAMPLE_TEXTURE2D(_BaseTex, sampler_BaseTex, uv1);
                float skinMask = baseColor.a;
                // R 高光强度 G 阴影阈值 B 高光范围 A 内描线
                half4 ilm = SAMPLE_TEXTURE2D(_ILMTex, sampler_ILMTex, uv1);
                float specIntensity = ilm.r;
                float shadowThreshold = ilm.g * 2.0 - 1.0;
                float specMask = ilm.b;
                float innerLine = ilm.a;
                half4 sssColor = SAMPLE_TEXTURE2D(_SSSTex, sampler_SSSTex, uv1);
                float rimMask = sssColor.a;
                half3 detailColor = SAMPLE_TEXTURE2D(_DetailTex, sampler_DetailTex, uv2);
                half ao = i.vertexColor.r;

                // Diffuse
                float NdotL = dot(normalWS, mainLightDir);
                float halfLambert = NdotL * 0.5 + 0.5;
                float diffuseTerm = halfLambert * ao + shadowThreshold;
                float shadowStep = saturate((diffuseTerm - _ShadowStep) * _ShadowHardness);
                half3 diffuseColor = lerp(sssColor.rgb, baseColor.rgb, shadowStep);

                // Specular
                float NdotV = dot(normalWS, viewDirectionWS);
                float halfNdotV = NdotV * 0.5 + 0.5;
                float specTerm = halfNdotV * ao + shadowThreshold;
                specTerm = halfLambert * 0.9 + specTerm * 0.1;
                float specRange = 1.0 - specMask * _SpecRange;
                float specStep = saturate((specTerm - specRange) * _SpecHardness);
                half3 specColor = (baseColor + _SpecColor) * 0.5;
                specColor *= specStep * specIntensity;

                // Rim
                // 屏幕空间深度边缘光
                float3 samplePositionVS = float3(positionVS.xy + normalVS.xy * _RimWidth, positionVS.z);
                float4 samplePositionCS = TransformWViewToHClip(samplePositionVS);
                float4 samplePositionVP = TransformHClipToViewPortPos(samplePositionCS);
                float depth = positionNDC.z / positionNDC.w;
                float linearEyeDepth = LinearEyeDepth(depth, _ZBufferParams);
                float offsetDepth = SAMPLE_TEXTURE2D_X(_CameraDepthTexture, sampler_CameraDepthTexture, samplePositionVP).r;
                float linearEyeOffsetDepth = LinearEyeDepth(offsetDepth, _ZBufferParams);
                float depthDiff = linearEyeOffsetDepth - linearEyeDepth;
                float rimStep = step(_RimThreshold, depthDiff);
                float rimRatio = 1 - saturate(dot(viewDirectionWS, normalWS));
                rimRatio = pow(rimRatio, exp2(lerp(4.0, 0.0, _FresnelMask)));
                rimStep = lerp(0, rimStep, rimRatio);
                half3 rimColor = rimStep * (_RimColor.rgb + baseColor) * 0.5 * rimMask * _RimIntensity;
                // 去除阴面的边缘光，只留下阳面
                rimColor *= shadowStep;

                half3 color = (diffuseColor + specColor + rimColor) * innerLine * detailColor * mainLightAttenuation;
                // Tonemapping
                color = sqrt(max(exp2(log2(max(color, 0.0)) * 2.2), 0.0));
                
                return half4(color, 1.0);
            }

            ENDHLSL
        }

        Pass
        {
            Name "Outline"

            Tags
            {
                "LightMode" = "LightweightForward"
            }

            Cull Front

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct a2v
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float2 uv           : TEXCOORD0;
                half4 color         : COLOR;
            };

            struct v2f
            {
                float4 positionCS   : SV_POSITION;
                float2 uv           : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
                float _OutlineWidth;
                half3 _OutlineColor;
                float _OutlineZOffset;
            CBUFFER_END

            TEXTURE2D(_BaseTex);        SAMPLER(sampler_BaseTex);

            v2f vert(a2v v)
            {
                v2f o;

                VertexPositionInputs vertexPositionInput = GetVertexPositionInputs(v.positionOS.xyz);
                float3 positionVS = vertexPositionInput.positionVS;
                float3 normalVS = TransformWorldToViewDir(TransformObjectToWorldNormal(v.normalOS));
                float3 outlineDir = float3(normalVS.xy, _OutlineZOffset * (1.0 - v.color.b));
                positionVS += outlineDir * _OutlineWidth * 0.001 * v.color.a;

                o.positionCS = mul(GetViewToHClipMatrix(), float4(positionVS, 1.0));
                o.uv = v.uv;
                
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                // 采样固有色，让描边颜色与固有色做混合
                float3 baseColor = SAMPLE_TEXTURE2D(_BaseTex, sampler_BaseTex, i.uv).rgb;
                half maxComponent = max(max(baseColor.r, baseColor.g), baseColor.b) - 0.004;
                half3 saturatedColor = step(maxComponent.rrr, baseColor) * baseColor;
                saturatedColor = lerp(baseColor, saturatedColor, 0.6);
                half3 outlineColor = 0.8 * saturatedColor * baseColor * _OutlineColor.rgb;

                return half4(outlineColor, 1.0);
            }

            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }
    }
}
