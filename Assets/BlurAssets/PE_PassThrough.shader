Shader "Custom/PE_PassThrough"
{
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

            half4 Frag(Varyings IN) : SV_Target
            {
                return SAMPLE_TEXTURE2D(
                    _BlitTexture,
                    sampler_LinearClamp,
                    IN.texcoord
                );
            }
            ENDHLSL
        }
    }
}