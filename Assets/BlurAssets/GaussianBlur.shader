Shader "Custom/GaussianBlur"
{
    Properties
    {
        _StepWidth("ブラー密度", Range(0, 0.1)) = 0.01
        _StepNums("ブラー強度", Range(1, 7)) = 3
        _Sigma("ガウシアン幅", Range(0.1, 5)) = 1.0
    }

    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float _StepWidth;
                float _StepNums;
                float _Sigma;
            CBUFFER_END

            // ガウシアン重み
            float Gaussian(float x, float y, float sigma)
            {
                float s2 = sigma * sigma;
                return exp(-(x * x + y * y) / (2.0 * s2));
            }

            half4 Frag(Varyings IN) : SV_Target
            {
                half4 output = half4(0, 0, 0, 0);
                float weightSum = 0;

                float stepNums = floor(_StepNums);
                float2 margin = _BlitTexture_TexelSize.xy * 0.5;

                for (float y = -stepNums * 0.5; y <= stepNums * 0.5; y += 1.0)
                {
                    for (float x = -stepNums * 0.5; x <= stepNums * 0.5; x += 1.0)
                    {
                        float2 offset = float2(x, y);
                        float w = Gaussian(offset.x, offset.y, _Sigma);

                        float2 pickUV = IN.texcoord + offset * _StepWidth;
                        pickUV = clamp(pickUV, margin, 1.0 - margin);

                        output += SAMPLE_TEXTURE2D(
                            _BlitTexture,
                            sampler_LinearClamp,
                            pickUV
                        ) * w;

                        weightSum += w;
                    }
                }

                output /= weightSum;
                output.a = 1;
                return output;
            }
            ENDHLSL
        }
    }
}