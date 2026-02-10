Shader "PostEffect/ToneCorrection"
{
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            //"Queue" = "Overlay"
        }

        Pass
        {
            Name "PE_Green"

            ZTest Always
            ZWrite Off
            Cull Off
            Blend Off

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma editor_sync_compilation

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            half4 Frag(Varyings i) : SV_Target
            {
                half4 output = SAMPLE_TEXTURE2D(_BlitTexture, sampler_LinearRepeat, i.texcoord);

                half grayscale = 
                0.2126 * output.r + 0.7152 * output.g + 0.0722 * output.b;

                half4 monoChromeColor = half4(grayscale, grayscale, grayscale, 1);
                return monoChromeColor;
            }
            ENDHLSL
        }
    }
}